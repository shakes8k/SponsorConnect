import { createServerFn } from "@tanstack/react-start";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { primaryRole, type AppRole } from "./roles";

export type { AppRole };

export type MeResponse = {
  id: string;
  name: string | null;
  email: string;
  avatar_url: string | null;
  is_active: boolean;
  role: AppRole;
  gmail_connected: boolean;
  gmail_email: string | null;
  today_sent: number;
  daily_limit: number | null;
};

// Display only — no per-user cap is enforced when sending. (Volunteers can't send at all.)
const LIMITS: Record<AppRole, number | null> = {
  volunteer: null,
  outreach: null,
  admin: null,
};

export const getMe = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<MeResponse> => {
    const { supabase, userId } = context;

    const [profileRes, rolesRes, gmailRes, todayRes] = await Promise.all([
      supabase.from("profiles").select("*").eq("id", userId).maybeSingle(),
      supabase.from("user_roles").select("role").eq("user_id", userId),
      supabase.from("gmail_tokens").select("gmail_email").eq("user_id", userId).maybeSingle(),
      supabase.rpc("today_send_count", { _user_id: userId }),
    ]);

    // Update last_login (best-effort)
    await supabase.from("profiles").update({ last_login: new Date().toISOString() }).eq("id", userId);

    const role = primaryRole((rolesRes.data ?? []).map((r: any) => r.role as string));

    const profile = profileRes.data;
    return {
      id: userId,
      name: profile?.name ?? null,
      email: profile?.email ?? "",
      avatar_url: profile?.avatar_url ?? null,
      is_active: profile?.is_active ?? true,
      role,
      gmail_connected: !!gmailRes.data,
      gmail_email: gmailRes.data?.gmail_email ?? null,
      today_sent: (todayRes.data as number) ?? 0,
      daily_limit: LIMITS[role],
    };
  });
