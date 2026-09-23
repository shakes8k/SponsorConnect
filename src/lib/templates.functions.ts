import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { TEMPLATE_EDITORS, primaryRole, type AppRole } from "./roles";

export type EmailTemplate = {
  id: string;
  key: string;
  label: string;
  description: string | null;
  subject: string;
  body_md: string;
  header_tagline: string | null;
  event_dates: string | null;
  sign_off: string | null;
  secondary_cta_label: string | null;
  secondary_cta_url: string | null;
  cta_buttons: Array<{label: string; url: string; style?: 'filled' | 'outline'}> | null;
  social_links: Array<{platform: string; url: string}> | null;
  logo_urls: string[];
  header_bg: string | null;
  header_image_url: string | null;
  footer_image_url: string | null;
  /** Uploaded email design with slot markers (see email-skin.ts); replaces the standard layout when set. */
  layout_html: string | null;

  created_at: string;
  updated_at: string;
};

const upsertSchema = z.object({
  id: z.string().uuid().optional(),
  key: z
    .string()
    .min(1)
    .max(64)
    .regex(/^[a-z0-9][a-z0-9_-]*$/i, "Key must be alphanumeric (dashes/underscores allowed)"),
  label: z.string().min(1).max(120),
  description: z.string().max(500).optional().nullable(),
  subject: z.string().min(1).max(300),
  body_md: z.string().min(1),
  header_tagline: z.string().max(200).optional().nullable(),
  event_dates: z.string().max(120).optional().nullable(),
  sign_off: z.string().max(2000).optional().nullable(),
  secondary_cta_label: z.string().max(60).optional().nullable(),
  secondary_cta_url: z.string().url().optional().nullable().or(z.literal("")),
  cta_buttons: z.array(z.object({ label: z.string(), url: z.string(), style: z.enum(['filled', 'outline']).optional() })).optional().nullable(),
  social_links: z.array(z.object({ platform: z.string(), url: z.string() })).optional().nullable(),
  logo_urls: z.array(z.string().url()).max(6).optional(),
  header_bg: z.string().max(200).optional().nullable(),
  header_image_url: z.string().url().optional().nullable().or(z.literal("")),
  footer_image_url: z.string().url().optional().nullable().or(z.literal("")),
  layout_html: z.string().max(1_000_000).optional().nullable(),
});


export const listEmailTemplates = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<EmailTemplate[]> => {
    const { data, error } = await context.supabase
      .from("email_templates")
      .select("*")
      .order("label", { ascending: true });
    if (error) throw new Error(error.message);
    return (data ?? []) as unknown as EmailTemplate[];
  });

async function requireRole(context: { supabase: any; userId: string }, allowed: AppRole[], message: string) {
  const { data, error } = await context.supabase.from("user_roles").select("role").eq("user_id", context.userId);
  if (error) throw new Error(error.message);
  if (!allowed.includes(primaryRole((data ?? []).map((r: any) => r.role as string)))) throw new Error(message);
}

export const upsertEmailTemplate = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) => upsertSchema.parse(d))
  .handler(async ({ data, context }): Promise<EmailTemplate> => {
    await requireRole(context, TEMPLATE_EDITORS, "Only admins and outreach members can edit templates.");
    const payload = {
      key: data.key.toLowerCase(),
      label: data.label,
      description: data.description ?? null,
      subject: data.subject,
      body_md: data.body_md,
      header_tagline: data.header_tagline ?? null,
      event_dates: data.event_dates ?? null,
      sign_off: data.sign_off ?? null,
      secondary_cta_label: data.secondary_cta_label ?? null,
      secondary_cta_url: data.secondary_cta_url || null,
      logo_urls: data.logo_urls ?? [],
      header_bg: data.header_bg ?? null,
      header_image_url: data.header_image_url || null,
      footer_image_url: data.footer_image_url || null,
      // Only touch buttons, social links and the design when the caller sends them — the template
      // manager doesn't, and saving there must not wipe them.
      ...(data.cta_buttons !== undefined ? { cta_buttons: data.cta_buttons } : {}),
      ...(data.social_links !== undefined ? { social_links: data.social_links } : {}),
      ...(data.layout_html !== undefined ? { layout_html: data.layout_html || null } : {}),
    } as any;

    if (data.id) {
      const { data: row, error } = await context.supabase
        .from("email_templates")
        .update(payload)
        .eq("id", data.id)
        .select("*")
        .single();
      if (error) throw new Error(error.message);
      return row as unknown as EmailTemplate;
    }
    const { data: row, error } = await context.supabase
      .from("email_templates")
      .insert({ ...payload, created_by: context.userId })
      .select("*")
      .single();
    if (error) throw new Error(error.message);
    return row as unknown as EmailTemplate;
  });

export const deleteEmailTemplate = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) => z.object({ id: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }): Promise<{ ok: true }> => {
    await requireRole(context, ["admin"], "Only admins can delete templates.");
    const { error } = await context.supabase.from("email_templates").delete().eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });
