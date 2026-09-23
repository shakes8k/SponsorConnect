import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { buildEmailHtml } from "./email-template";
import { isSkin, renderSkin } from "./email-skin";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { classifyFailure, type EmailFailureStatus } from "./bounce-classifier";
import { OUTREACH_TEMPLATE_KEY, primaryRole } from "./roles";

export type { MailAttachment } from "./email-transport.server";

const recipientSchema = z.object({
  email: z.string().email(),
  name: z.string().optional(),
  domain: z.string().max(120).optional(),
});

const inputSchema = z.object({
  templateType: z.string().min(1).max(64),
  subject: z.string().min(1),
  markdownBody: z.string(),
  recipients: z.array(recipientSchema).min(1),
  headerTagline: z.string().optional(),
  eventDates: z.string().optional(),
  signOff: z.string().optional(),
  secondaryCtaLabel: z.string().optional(),
  secondaryCtaUrl: z.string().url().optional().or(z.literal("")),
  ctaButtons: z.array(z.object({ label: z.string(), url: z.string(), style: z.enum(['filled', 'outline']).optional() })).optional(),
  socialLinks: z.array(z.object({ platform: z.string(), url: z.string() })).optional(),
  logoUrls: z.array(z.string().url()).max(6).optional(),
  headerBg: z.string().max(200).optional(),
  headerImageUrl: z.string().url().optional().or(z.literal("")),
  footerImageUrl: z.string().url().optional().or(z.literal("")),
  showAicssycLogo: z.boolean().optional(),
  /** Uploaded email design (see email-skin.ts); the fields are rendered into it instead of the standard layout. */
  layoutHtml: z.string().max(1_000_000).refine(isSkin, "Invalid email design").optional(),
});



export type SendEmailInput = z.infer<typeof inputSchema>;
export type SendEmailResult = {
  sent: number;
  total: number;
  transport: "smtp_gmail";
  senderEmail: string;
  results: Array<{ to: string; ok: boolean; status: string; error?: string; messageId?: string }>;
};

/**
 * What an outreach member sends: the saved AICSSYC invitation, exactly as stored — only the
 * recipients come from the request, so the content can't be changed from the browser.
 */
async function savedInvitation(supabase: any, recipients: SendEmailInput["recipients"]): Promise<SendEmailInput> {
  const { data: t, error } = await supabase
    .from("email_templates")
    .select("*")
    .eq("key", OUTREACH_TEMPLATE_KEY)
    .maybeSingle();
  if (error) throw new Error(error.message);
  if (!t) throw new Error("The AICSSYC invitation template is missing. Ask an admin to restore it.");
  return inputSchema.parse({
    templateType: OUTREACH_TEMPLATE_KEY,
    recipients,
    subject: t.subject,
    markdownBody: t.body_md,
    headerTagline: t.header_tagline ?? undefined,
    eventDates: t.event_dates ?? undefined,
    signOff: t.sign_off ?? undefined,
    ctaButtons: t.cta_buttons ?? undefined,
    socialLinks: t.social_links ?? undefined,
    logoUrls: t.logo_urls ?? [],
    headerBg: t.header_bg ?? undefined,
    headerImageUrl: t.header_image_url ?? undefined,
    footerImageUrl: t.footer_image_url ?? undefined,
    layoutHtml: t.layout_html ?? undefined,
  });
}

export const sendOutreachEmail = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => inputSchema.parse(d))
  .handler(async ({ data: request, context }): Promise<SendEmailResult> => {
    const { supabase, userId } = context;

    const [profRes, rolesRes] = await Promise.all([
      supabase.from("profiles").select("email,is_active").eq("id", userId).maybeSingle(),
      supabase.from("user_roles").select("role").eq("user_id", userId),
    ]);

    if (!profRes.data?.is_active) throw new Error("Your account is disabled. Contact an admin.");

    const role = primaryRole((rolesRes.data ?? []).map((r: any) => r.role as string));
    if (role === "volunteer") {
      throw new Error("Volunteers can't send emails. Ask an admin to give you outreach access.");
    }
    // No per-user daily limit (Gmail's own sending limit still applies).
    const data = role === "outreach" ? await savedInvitation(supabase, request.recipients) : request;

    const transport = "smtp_gmail" as const;
    const senderEmail = process.env.GMAIL_USER;
    if (!senderEmail) throw new Error("Shared Gmail sender is not configured.");

    const applyMerge = (text: string, name: string, domain: string) =>
      text.replace(/\{\{\s*name\s*\}\}/gi, name).replace(/\{\{\s*domain\s*\}\}/gi, domain);

    const results: SendEmailResult["results"] = [];
    let mailer: Awaited<ReturnType<typeof import("./email-transport.server")["createMailer"]>> | null = null;
    let mailerErr: string | null = null;
    const { createMailer, formatSender } = await import("./email-transport.server");
    const fromHeader = formatSender(senderEmail);
    try {
      mailer = await createMailer();
    } catch (e: any) {
      mailerErr = e?.message || "Email transport unavailable.";
    }

    for (const r of data.recipients) {
      const name = (r.name || "").trim();
      const domain = (r.domain || "").trim();
      const personalizedSubject = applyMerge(data.subject, name, domain);
      const personalizedBody = applyMerge(data.markdownBody, name, domain);
      const personalizedSignOff = data.signOff ? applyMerge(data.signOff, name, domain) : data.signOff;
      const personalizedTagline = data.headerTagline ? applyMerge(data.headerTagline, name, domain) : data.headerTagline;
      const html = data.layoutHtml
        ? renderSkin(data.layoutHtml, {
            tagline: personalizedTagline ?? "",
            dates: data.eventDates ?? "",
            recipientName: name || undefined,
            body: personalizedBody,
            signOff: personalizedSignOff ?? "",
            ctaButtons: data.ctaButtons ?? [],
          })
        : buildEmailHtml({
            templateType: data.templateType,
            markdownBody: personalizedBody,
            recipientName: name || undefined,
            headerTagline: personalizedTagline,
            eventDates: data.eventDates,
            signOff: personalizedSignOff,
            secondaryCtaLabel: data.secondaryCtaLabel,
            secondaryCtaUrl: data.secondaryCtaUrl || undefined,
            ctaButtons: data.ctaButtons,
            socialLinks: data.socialLinks,
            logoUrls: data.logoUrls,
            headerBg: data.headerBg,
            headerImageUrl: data.headerImageUrl || undefined,
            footerImageUrl: data.footerImageUrl || undefined,
            showAicssycLogo: data.showAicssycLogo,
          });


      const appDomain = process.env.VERCEL_URL || process.env.APP_URL?.replace(/^https?:\/\//, '') || "localhost";
      const messageIdBare = `${crypto.randomUUID()}@${appDomain}`;
      const messageIdHeader = `<${messageIdBare}>`;

      // Insert as QUEUED first so we always have a row even on total transport failure
      const { data: row, error: insErr } = await supabase
        .from("email_messages")
        .insert({
          user_id: userId,
          sender_email: senderEmail,
          recipient_name: name || null,
          recipient_email: r.email,
          subject: personalizedSubject,
          // Emails in an uploaded design are logged as sent, so the email log can show that design.
          body: data.layoutHtml ? html : personalizedBody,
          template_type: data.templateType,
          gmail_message_id: messageIdBare,
          status: "QUEUED" as const,
        })
        .select("id")
        .maybeSingle();
      if (insErr) {
        console.error("[email] insert failed:", insErr);
        results.push({ to: r.email, ok: false, status: "FAILED", error: insErr.message });
        continue;
      }
      const rowId = row!.id;

      if (mailerErr || !mailer) {
        await supabase.from("email_messages").update({
          status: "FAILED" as const,
          failure_reason: mailerErr ?? "Mailer unavailable",
        }).eq("id", rowId);
        results.push({ to: r.email, ok: false, status: "FAILED", error: mailerErr ?? "Mailer unavailable" });
        continue;
      }

      await supabase.from("email_messages").update({ status: "SENDING" as const }).eq("id", rowId);

      try {
        const { smtpResponse } = await mailer.send({
          from: fromHeader,
          to: r.email,
          subject: personalizedSubject,
          html,
          messageId: messageIdHeader,
        });
        await supabase.from("email_messages").update({
          status: "SENT" as const,
          smtp_response: smtpResponse,
        }).eq("id", rowId);
        results.push({ to: r.email, ok: true, status: "SENT", messageId: messageIdBare });
      } catch (e: any) {
        const raw = e?.message ?? "Send failed";
        const classified = classifyFailure(raw);
        const status: EmailFailureStatus = classified.status;
        await supabase.from("email_messages").update({
          status,
          failure_reason: classified.reason,
          smtp_response: raw,
        }).eq("id", rowId);
        console.error(`[email] send to ${r.email} failed:`, raw);
        results.push({ to: r.email, ok: false, status, error: classified.reason });
      }
    }

    await mailer?.close().catch(() => {});

    return {
      sent: results.filter((r) => r.ok).length,
      total: results.length,
      transport,
      senderEmail,
      results,
    };
  });
