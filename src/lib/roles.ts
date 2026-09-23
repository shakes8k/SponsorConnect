// Who may send what:
//   admin     — anything
//   outreach  — only the AICSSYC invitation, exactly as saved (enforced in sendOutreachEmail)
//   volunteer — nothing
export type AppRole = "admin" | "outreach" | "volunteer";

export const ROLES: AppRole[] = ["admin", "outreach", "volunteer"];

/** The only template outreach members can send. */
export const OUTREACH_TEMPLATE_KEY = "aicssyc_invitation";

/** A user's effective role from their user_roles rows (the most privileged wins). */
export function primaryRole(roles: string[]): AppRole {
  if (roles.includes("admin")) return "admin";
  if (roles.includes("outreach")) return "outreach";
  return "volunteer";
}
