-- Function to get the current user's role safely (SECURITY DEFINER bypasses RLS)
CREATE OR REPLACE FUNCTION public.get_user_role(user_id uuid)
RETURNS public.user_role
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_role public.user_role;
BEGIN
  SELECT role INTO v_role FROM public.users WHERE id = user_id;
  RETURN v_role;
END;
$$;

-- Drop all admin policies that cause infinite recursion
DROP POLICY IF EXISTS "Admins can view all users" ON public.users;
DROP POLICY IF EXISTS "Admins can insert users" ON public.users;
DROP POLICY IF EXISTS "Admins can update all users" ON public.users;
DROP POLICY IF EXISTS "Admins can delete users" ON public.users;

DROP POLICY IF EXISTS "Admins can view all addresses" ON public.user_addresses;
DROP POLICY IF EXISTS "Admins can insert all addresses" ON public.user_addresses;
DROP POLICY IF EXISTS "Admins can update all addresses" ON public.user_addresses;
DROP POLICY IF EXISTS "Admins can delete all addresses" ON public.user_addresses;

DROP POLICY IF EXISTS "Admins can view all payment methods" ON public.user_payment_methods;
DROP POLICY IF EXISTS "Admins can insert all payment methods" ON public.user_payment_methods;
DROP POLICY IF EXISTS "Admins can update all payment methods" ON public.user_payment_methods;
DROP POLICY IF EXISTS "Admins can delete all payment methods" ON public.user_payment_methods;

-- Re-create admin policies using the security definer function

-- users table admin policies
CREATE POLICY "Admins can view all users"
ON public.users FOR SELECT
USING (public.get_user_role(auth.uid()) = 'admin'::user_role);

CREATE POLICY "Admins can insert users"
ON public.users FOR INSERT
WITH CHECK (public.get_user_role(auth.uid()) = 'admin'::user_role);

CREATE POLICY "Admins can update all users"
ON public.users FOR UPDATE
USING (public.get_user_role(auth.uid()) = 'admin'::user_role);

CREATE POLICY "Admins can delete users"
ON public.users FOR DELETE
USING (public.get_user_role(auth.uid()) = 'admin'::user_role);

-- user_addresses table admin policies
CREATE POLICY "Admins can view all addresses"
ON public.user_addresses FOR SELECT
USING (public.get_user_role(auth.uid()) = 'admin'::user_role);

CREATE POLICY "Admins can insert all addresses"
ON public.user_addresses FOR INSERT
WITH CHECK (public.get_user_role(auth.uid()) = 'admin'::user_role);

CREATE POLICY "Admins can update all addresses"
ON public.user_addresses FOR UPDATE
USING (public.get_user_role(auth.uid()) = 'admin'::user_role);

CREATE POLICY "Admins can delete all addresses"
ON public.user_addresses FOR DELETE
USING (public.get_user_role(auth.uid()) = 'admin'::user_role);

-- user_payment_methods table admin policies
CREATE POLICY "Admins can view all payment methods"
ON public.user_payment_methods FOR SELECT
USING (public.get_user_role(auth.uid()) = 'admin'::user_role);

CREATE POLICY "Admins can insert all payment methods"
ON public.user_payment_methods FOR INSERT
WITH CHECK (public.get_user_role(auth.uid()) = 'admin'::user_role);

CREATE POLICY "Admins can update all payment methods"
ON public.user_payment_methods FOR UPDATE
USING (public.get_user_role(auth.uid()) = 'admin'::user_role);

CREATE POLICY "Admins can delete all payment methods"
ON public.user_payment_methods FOR DELETE
USING (public.get_user_role(auth.uid()) = 'admin'::user_role);
