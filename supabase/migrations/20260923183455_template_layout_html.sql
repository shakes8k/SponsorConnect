-- An uploaded email design ("skin"): the uploaded HTML with slot markers such as <!--sc:body-->.
-- When set, emails from this template use this design instead of the standard layout.
ALTER TABLE public.email_templates ADD COLUMN IF NOT EXISTS layout_html text;
