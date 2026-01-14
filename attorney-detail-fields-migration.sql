-- Add additional fields for attorney detail page
-- Run this migration in Supabase SQL Editor

-- Add email field
ALTER TABLE attorneys 
ADD COLUMN IF NOT EXISTS email TEXT;

-- Add phone field
ALTER TABLE attorneys 
ADD COLUMN IF NOT EXISTS phone TEXT;

-- Add specializations (JSON array)
ALTER TABLE attorneys 
ADD COLUMN IF NOT EXISTS specializations JSONB DEFAULT '[]'::jsonb;

-- Add education (JSON array)
ALTER TABLE attorneys 
ADD COLUMN IF NOT EXISTS education JSONB DEFAULT '[]'::jsonb;

-- Add experience (JSON array)
ALTER TABLE attorneys 
ADD COLUMN IF NOT EXISTS experience JSONB DEFAULT '[]'::jsonb;

-- Add achievements (JSON array)
ALTER TABLE attorneys 
ADD COLUMN IF NOT EXISTS achievements JSONB DEFAULT '[]'::jsonb;

-- Add comments with field descriptions
COMMENT ON COLUMN attorneys.email IS 'Attorney contact email';
COMMENT ON COLUMN attorneys.phone IS 'Attorney contact phone number';
COMMENT ON COLUMN attorneys.specializations IS 'JSON array of practice area specializations';
COMMENT ON COLUMN attorneys.education IS 'JSON array of education history';
COMMENT ON COLUMN attorneys.experience IS 'JSON array of professional experience';
COMMENT ON COLUMN attorneys.achievements IS 'JSON array of achievements and awards';
