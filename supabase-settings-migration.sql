-- Create site_settings table
CREATE TABLE IF NOT EXISTS public.site_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    
    -- Site Configuration
    site_name TEXT DEFAULT 'R. Prama Wijaya Law Firm',
    site_tagline TEXT DEFAULT 'Committed to Excellence',
    site_description TEXT,
    site_logo TEXT,
    site_favicon TEXT,
    
    -- Contact Information
    contact_address TEXT,
    contact_phone TEXT,
    contact_whatsapp TEXT,
    contact_email TEXT,
    contact_email_secondary TEXT,
    business_hours TEXT,
    google_maps_url TEXT,
    
    -- Social Media
    social_facebook TEXT,
    social_twitter TEXT,
    social_instagram TEXT,
    social_linkedin TEXT,
    social_youtube TEXT,
    social_tiktok TEXT,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE public.site_settings ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access
CREATE POLICY "Allow public read access to site settings"
    ON public.site_settings
    FOR SELECT
    USING (true);

-- Create policy for authenticated users to update settings
CREATE POLICY "Allow authenticated users to update site settings"
    ON public.site_settings
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

-- Create policy for authenticated users to insert settings
CREATE POLICY "Allow authenticated users to insert site settings"
    ON public.site_settings
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_site_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_site_settings_updated_at
    BEFORE UPDATE ON public.site_settings
    FOR EACH ROW
    EXECUTE FUNCTION public.update_site_settings_updated_at();

-- Insert default settings (optional)
INSERT INTO public.site_settings (
    site_name,
    site_tagline,
    site_description,
    contact_email
) VALUES (
    'R. Prama Wijaya Law Firm',
    'Committed to Excellence',
    'Professional legal services with excellence and integrity',
    'info@rpramawijaya.com'
) ON CONFLICT DO NOTHING;

-- Grant permissions
GRANT SELECT ON public.site_settings TO anon;
GRANT ALL ON public.site_settings TO authenticated;
