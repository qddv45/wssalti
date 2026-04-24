-- Create custom types
CREATE TYPE user_role AS ENUM ('admin', 'restaurant_owner', 'manager', 'waiter', 'driver', 'customer');
CREATE TYPE user_account_type AS ENUM ('basic', 'premium', 'business');
CREATE TYPE user_subscription_status AS ENUM ('active', 'inactive', 'suspended');
CREATE TYPE address_label AS ENUM ('home', 'work', 'other');
CREATE TYPE payment_method_type AS ENUM ('card', 'paypal', 'wallet');

-- Create trigger function for updated_at
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 1. Create users table
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  phone TEXT UNIQUE,
  full_name TEXT,
  full_name_ar TEXT,
  avatar_url TEXT,
  role user_role DEFAULT 'customer'::user_role,
  account_type user_account_type DEFAULT 'basic'::user_account_type,
  subscription_status user_subscription_status DEFAULT 'active'::user_subscription_status,
  is_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Trigger for users.updated_at
CREATE TRIGGER set_users_updated_at
BEFORE UPDATE ON public.users
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- 2. Create user_addresses table
CREATE TABLE IF NOT EXISTS public.user_addresses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  label address_label DEFAULT 'other'::address_label,
  address_line TEXT NOT NULL,
  address_line_ar TEXT,
  city TEXT NOT NULL,
  city_ar TEXT,
  postal_code TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  is_default BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Create user_payment_methods table
CREATE TABLE IF NOT EXISTS public.user_payment_methods (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  type payment_method_type NOT NULL,
  card_last_four TEXT,
  card_brand TEXT,
  is_default BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_payment_methods ENABLE ROW LEVEL SECURITY;

-- Create Policies for users table
CREATE POLICY "Users can view their own profile"
ON public.users FOR SELECT
USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
ON public.users FOR UPDATE
USING (auth.uid() = id);

CREATE POLICY "Admins can view all users"
ON public.users FOR SELECT
USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'::user_role));

CREATE POLICY "Admins can insert users"
ON public.users FOR INSERT
WITH CHECK (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'::user_role));

CREATE POLICY "Admins can update all users"
ON public.users FOR UPDATE
USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'::user_role));

CREATE POLICY "Admins can delete users"
ON public.users FOR DELETE
USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'::user_role));

-- Create Policies for user_addresses table
CREATE POLICY "Users can view their own addresses"
ON public.user_addresses FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own addresses"
ON public.user_addresses FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own addresses"
ON public.user_addresses FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own addresses"
ON public.user_addresses FOR DELETE
USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all addresses"
ON public.user_addresses FOR SELECT
USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'::user_role));

CREATE POLICY "Admins can insert all addresses"
ON public.user_addresses FOR INSERT
WITH CHECK (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'::user_role));

CREATE POLICY "Admins can update all addresses"
ON public.user_addresses FOR UPDATE
USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'::user_role));

CREATE POLICY "Admins can delete all addresses"
ON public.user_addresses FOR DELETE
USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'::user_role));


-- Create Policies for user_payment_methods table
CREATE POLICY "Users can view their own payment methods"
ON public.user_payment_methods FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own payment methods"
ON public.user_payment_methods FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own payment methods"
ON public.user_payment_methods FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own payment methods"
ON public.user_payment_methods FOR DELETE
USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all payment methods"
ON public.user_payment_methods FOR SELECT
USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'::user_role));

CREATE POLICY "Admins can insert all payment methods"
ON public.user_payment_methods FOR INSERT
WITH CHECK (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'::user_role));

CREATE POLICY "Admins can update all payment methods"
ON public.user_payment_methods FOR UPDATE
USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'::user_role));

CREATE POLICY "Admins can delete all payment methods"
ON public.user_payment_methods FOR DELETE
USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'::user_role));
