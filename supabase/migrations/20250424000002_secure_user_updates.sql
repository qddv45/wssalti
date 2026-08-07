-- Trigger function to prevent privilege escalation
-- This trigger ensures that users cannot change their own role or other sensitive fields
CREATE OR REPLACE FUNCTION public.prevent_user_privilege_escalation()
RETURNS TRIGGER AS $$
BEGIN
  -- Allow service_role to make any changes
  -- In Supabase, auth.uid() is null for the service_role
  IF auth.uid() IS NULL THEN
    RETURN NEW;
  END IF;

  -- Allow admins to make any changes
  -- Use the existing security definer function to avoid infinite recursion
  IF public.get_user_role(auth.uid()) = 'admin'::public.user_role THEN
    RETURN NEW;
  END IF;

  -- For regular users, prevent updating sensitive columns
  IF (
    NEW.role IS DISTINCT FROM OLD.role OR
    NEW.account_type IS DISTINCT FROM OLD.account_type OR
    NEW.subscription_status IS DISTINCT FROM OLD.subscription_status OR
    NEW.is_verified IS DISTINCT FROM OLD.is_verified OR
    NEW.id IS DISTINCT FROM OLD.id OR
    NEW.created_at IS DISTINCT FROM OLD.created_at
  ) THEN
    RAISE EXCEPTION 'You do not have permission to update sensitive profile fields (role, account_type, status, etc.)';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Attach the trigger to the users table
-- It must be a BEFORE UPDATE trigger to intercept and validate changes
DROP TRIGGER IF EXISTS ensure_user_privilege_security ON public.users;
CREATE TRIGGER ensure_user_privilege_security
  BEFORE UPDATE ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION public.prevent_user_privilege_escalation();
