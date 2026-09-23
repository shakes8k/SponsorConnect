-- Columns the template code already reads/writes but no earlier migration created.
ALTER TABLE public.email_templates
  ADD COLUMN IF NOT EXISTS cta_buttons jsonb,
  ADD COLUMN IF NOT EXISTS social_links jsonb,
  -- Uploaded full-HTML templates: when set, the email is sent as this HTML instead of the Markdown layout.
  ADD COLUMN IF NOT EXISTS body_html text;

-- Public bucket for images uploaded in the template manager (only admins can upload).
INSERT INTO storage.buckets (id, name, public)
VALUES ('assets', 'assets', true)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "Admins upload assets" ON storage.objects;
CREATE POLICY "Admins upload assets"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'assets' AND public.has_role(auth.uid(), 'admin'::app_role));
