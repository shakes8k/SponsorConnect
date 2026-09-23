-- Outreach members can send only the AICSSYC invitation; volunteers can no longer send.
-- (Enforced in sendOutreachEmail, src/lib/email.functions.ts.)
ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'outreach';
