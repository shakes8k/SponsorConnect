-- Uploaded HTML is now imported into the regular template fields instead of being stored raw.
ALTER TABLE public.email_templates DROP COLUMN IF EXISTS body_html;
