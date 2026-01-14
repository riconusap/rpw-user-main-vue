-- Complete Migration for Icon Upload Feature
-- Run this SQL script in Supabase SQL Editor

-- 1. Add icon_image_url columns to features and practice_areas tables
ALTER TABLE features ADD COLUMN IF NOT EXISTS icon_image_url TEXT;
ALTER TABLE practice_areas ADD COLUMN IF NOT EXISTS icon_image_url TEXT;

COMMENT ON COLUMN features.icon_image_url IS 'URL for custom uploaded icon image (alternative to Font Awesome icon class)';
COMMENT ON COLUMN practice_areas.icon_image_url IS 'URL for custom uploaded icon image (alternative to Font Awesome icon class)';

-- 2. Create icons storage bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('icons', 'icons', true)
ON CONFLICT (id) DO NOTHING;

-- 3. Set storage policies for icons bucket
-- Public read access
CREATE POLICY IF NOT EXISTS "Icons are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'icons');

-- Authenticated users can upload
CREATE POLICY IF NOT EXISTS "Authenticated users can upload icons"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'icons' AND auth.role() = 'authenticated');

-- Authenticated users can update their icons
CREATE POLICY IF NOT EXISTS "Authenticated users can update icons"
ON storage.objects FOR UPDATE
USING (bucket_id = 'icons' AND auth.role() = 'authenticated');

-- Authenticated users can delete icons
CREATE POLICY IF NOT EXISTS "Authenticated users can delete icons"
ON storage.objects FOR DELETE
USING (bucket_id = 'icons' AND auth.role() = 'authenticated');
