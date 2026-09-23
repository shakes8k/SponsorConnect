-- Site admins for this deployment: as1798@srmist.edu.in and ug9320@srmist.edu.in.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  email_lower text := lower(NEW.email);
BEGIN
  IF email_lower NOT LIKE '%@srmist.edu.in' THEN
    RAISE EXCEPTION 'Only @srmist.edu.in email addresses are allowed';
  END IF;

  INSERT INTO public.profiles (id, name, email, avatar_url, last_login)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1)),
    NEW.email,
    NEW.raw_user_meta_data->>'avatar_url',
    now()
  )
  ON CONFLICT (id) DO NOTHING;

  IF email_lower IN ('as1798@srmist.edu.in', 'ug9320@srmist.edu.in') THEN
    INSERT INTO public.user_roles (user_id, role)
    VALUES (NEW.id, 'admin')
    ON CONFLICT (user_id, role) DO NOTHING;
  ELSE
    INSERT INTO public.user_roles (user_id, role)
    VALUES (NEW.id, 'volunteer')
    ON CONFLICT (user_id, role) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$;

-- Promote Ushnish if he has already signed up (one role per user, as setUserRole expects).
DELETE FROM public.user_roles
WHERE user_id IN (SELECT id FROM auth.users WHERE lower(email) = 'ug9320@srmist.edu.in');
INSERT INTO public.user_roles (user_id, role)
SELECT id, 'admin'::app_role FROM auth.users WHERE lower(email) = 'ug9320@srmist.edu.in'
ON CONFLICT (user_id, role) DO NOTHING;
