-- Outreach members can create and edit templates and upload template images, but not delete templates
-- ("Admins delete templates" is unchanged).
DROP POLICY IF EXISTS "Admins insert templates" ON public.email_templates;
DROP POLICY IF EXISTS "Admins update templates" ON public.email_templates;

CREATE POLICY "Admins and outreach insert templates"
  ON public.email_templates FOR INSERT
  TO authenticated
  WITH CHECK (public.has_role(auth.uid(), 'admin'::app_role) OR public.has_role(auth.uid(), 'outreach'::app_role));

CREATE POLICY "Admins and outreach update templates"
  ON public.email_templates FOR UPDATE
  TO authenticated
  USING (public.has_role(auth.uid(), 'admin'::app_role) OR public.has_role(auth.uid(), 'outreach'::app_role))
  WITH CHECK (public.has_role(auth.uid(), 'admin'::app_role) OR public.has_role(auth.uid(), 'outreach'::app_role));

DROP POLICY IF EXISTS "Admins upload assets" ON storage.objects;
CREATE POLICY "Admins and outreach upload assets"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'assets'
    AND (public.has_role(auth.uid(), 'admin'::app_role) OR public.has_role(auth.uid(), 'outreach'::app_role))
  );
