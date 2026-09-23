// Who may do what:
//   admin     — send anything; create, edit and delete templates; manage users
//   outreach  — send anything except admin-only templates (lead interview mails), incl. their own uploads;
//               create and edit templates (incl. HTML uploads), but not delete them
//   volunteer — nothing
export type AppRole = "admin" | "outreach" | "volunteer";

export const ROLES: AppRole[] = ["admin", "outreach", "volunteer"];

/** Roles that can create/edit templates (also enforced by RLS). Deleting stays admin-only. */
export const TEMPLATE_EDITORS: AppRole[] = ["admin", "outreach"];

/** Templates only admins can send (enforced in sendOutreachEmail; hidden from others in the Composer). */
export const ADMIN_ONLY_TEMPLATE_KEYS = ["lead_interview"];

/** A user's effective role from their user_roles rows (the most privileged wins). */
export function primaryRole(roles: string[]): AppRole {
  if (roles.includes("admin")) return "admin";
  if (roles.includes("outreach")) return "outreach";
  return "volunteer";
}
