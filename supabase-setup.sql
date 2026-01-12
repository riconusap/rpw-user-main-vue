-- ============================================
-- Supabase Database Setup for RPW Law Firm
-- ============================================
-- Run this SQL in your Supabase SQL Editor
-- Project: https://homngxqmbbxodvjpfdxc.supabase.co
-- ============================================

-- Enable UUID extension (if not already enabled)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

-- Function to auto-update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate article reading time
CREATE OR REPLACE FUNCTION calculate_reading_time(content TEXT)
RETURNS INTEGER AS $$
BEGIN
  -- Average reading speed: 200 words per minute
  RETURN CEIL(array_length(regexp_split_to_array(content, E'\\s+'), 1) / 200.0);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ============================================
-- TABLE 1: HERO SLIDES
-- ============================================

CREATE TABLE hero_slides (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  subtitle TEXT,
  description TEXT NOT NULL,
  background_image TEXT NOT NULL, -- Storage bucket path
  cta_text TEXT,
  cta_link TEXT,
  order_position INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_hero_slides_order ON hero_slides(order_position, is_active);

CREATE TRIGGER update_hero_slides_updated_at
  BEFORE UPDATE ON hero_slides
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Sample data
INSERT INTO hero_slides (title, subtitle, description, background_image, cta_text, cta_link, order_position) VALUES
('We Provide Legal Solutions', 'For Your Business', 'Leading law firm in Jakarta providing comprehensive legal services for businesses and individuals across Indonesia', 'hero/carousel-1.jpg', 'Get A Quote', '/contact', 1),
('Trusted Legal Advisors', 'Since 1998', 'Over 25 years of experience in Indonesian law with a proven track record of success', 'hero/carousel-2.jpg', 'Learn More', '/about', 2),
('Expert Legal Team', 'At Your Service', 'Our team of experienced attorneys is ready to help you with any legal challenges', 'hero/carousel-3.jpg', 'Contact Us', '/contact', 3);

-- ============================================
-- TABLE 2: FEATURES
-- ============================================

CREATE TABLE features (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  icon TEXT NOT NULL, -- FontAwesome icon class
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  order_position INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_features_order ON features(order_position, is_active);

CREATE TRIGGER update_features_updated_at
  BEFORE UPDATE ON features
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Sample data
INSERT INTO features (icon, title, description, order_position) VALUES
('fas fa-balance-scale', 'Best Law Practices', 'Our firm follows the highest standards of legal practice with proven methodologies', 1),
('fas fa-user-shield', 'Efficiency & Trust', 'We deliver efficient legal solutions while maintaining the highest level of trust', 2),
('fas fa-trophy', 'Results You Deserve', 'Our track record speaks for itself with countless successful outcomes', 3),
('fas fa-users', 'Expert Team', 'Team of highly qualified attorneys with diverse specializations', 4);

-- ============================================
-- TABLE 3: PRACTICE AREAS
-- ============================================

CREATE TABLE practice_areas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  icon TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  order_position INTEGER DEFAULT 0,
  is_featured BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_practice_areas_slug ON practice_areas(slug);
CREATE INDEX idx_practice_areas_featured ON practice_areas(is_featured, is_active);

CREATE TRIGGER update_practice_areas_updated_at
  BEFORE UPDATE ON practice_areas
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Sample data
INSERT INTO practice_areas (icon, title, description, slug, order_position, is_featured) VALUES
('fas fa-gavel', 'Civil Law', 'Comprehensive civil litigation services including contract disputes, property disputes, and personal injury cases', 'civil-law', 1, true),
('fas fa-balance-scale', 'Criminal Law', 'Expert criminal defense representation for individuals and corporations facing criminal charges', 'criminal-law', 2, true),
('fas fa-home', 'Property Law', 'Full-service property law assistance including transactions, disputes, and land registration', 'property-law', 3, true),
('fas fa-briefcase', 'Business Law', 'Strategic business law services covering corporate formation, contracts, and mergers', 'business-law', 4, true),
('fas fa-graduation-cap', 'Education Law', 'Legal guidance for educational institutions and students on academic and regulatory matters', 'education-law', 5, false),
('fas fa-file-contract', 'Contract Law', 'Expert contract drafting, review, and dispute resolution services', 'contract-law', 6, false);

-- ============================================
-- TABLE 4: ATTORNEYS
-- ============================================

CREATE TABLE attorneys (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name TEXT NOT NULL,
  position TEXT NOT NULL,
  photo TEXT, -- Storage path
  bio TEXT,
  specializations JSONB, -- Array of specializations
  education JSONB, -- Array of education objects
  experience_years INTEGER,
  languages TEXT,
  bar_admission TEXT,
  email TEXT,
  phone TEXT,
  linkedin_url TEXT,
  order_position INTEGER DEFAULT 0,
  is_founder BOOLEAN DEFAULT false,
  is_featured BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_attorneys_order ON attorneys(order_position, is_active);
CREATE INDEX idx_attorneys_featured ON attorneys(is_featured, is_active);
CREATE INDEX idx_attorneys_founder ON attorneys(is_founder);

CREATE TRIGGER update_attorneys_updated_at
  BEFORE UPDATE ON attorneys
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Sample data (Founder)
INSERT INTO attorneys (
  full_name, position, photo, bio, specializations, education, 
  experience_years, languages, bar_admission, email, phone, 
  order_position, is_founder, is_featured
) VALUES (
  'Ramon Prama Wijaya, S.H.',
  'Founder & Managing Partner',
  'attorneys/founder.jpg',
  'Ramon Prama Wijaya is the founder and managing partner of R. Prama Wijaya & Partners. With over 25 years of experience in Indonesian law, he has successfully handled numerous high-profile cases.',
  '["Corporate Law", "Commercial Litigation", "Mergers & Acquisitions", "Banking & Finance"]'::jsonb,
  '[{"degree": "S.H. (Bachelor of Law)", "institution": "University of Indonesia", "year": "1998"}]'::jsonb,
  25,
  'Indonesian, English',
  'Indonesian Bar Association',
  'ramon@rpwadvocates.com',
  '+62-21-29557422',
  0,
  true,
  true
);

-- Sample data (Associates)
INSERT INTO attorneys (full_name, position, photo, specializations, experience_years, languages, order_position, is_featured) VALUES
('Maria Santoso, S.H., M.H.', 'Senior Associate', 'attorneys/team-1.jpg', '["Criminal Law", "Civil Law"]'::jsonb, 10, 'Indonesian, English', 1, true),
('Budi Hartono, S.H.', 'Associate', 'attorneys/team-2.jpg', '["Corporate Law", "Tax Law"]'::jsonb, 8, 'Indonesian, English', 2, true),
('Siti Nurhaliza, S.H.', 'Associate', 'attorneys/team-3.jpg', '["Family Law", "Property Law"]'::jsonb, 7, 'Indonesian, English', 3, true),
('Ahmad Yani, S.H., M.H.', 'Senior Associate', 'attorneys/team-4.jpg', '["Employment Law", "Labor Law"]'::jsonb, 12, 'Indonesian, English, Mandarin', 4, true);

-- ============================================
-- TABLE 5: ARTICLE CATEGORIES
-- ============================================

CREATE TABLE article_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  icon TEXT,
  order_position INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_categories_slug ON article_categories(slug);

CREATE TRIGGER update_article_categories_updated_at
  BEFORE UPDATE ON article_categories
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Sample data
INSERT INTO article_categories (name, slug, description, icon, order_position) VALUES
('Corporate Law', 'corporate-law', 'Articles about corporate and business law', 'fas fa-building', 1),
('Criminal Law', 'criminal-law', 'Criminal law updates and case studies', 'fas fa-gavel', 2),
('Civil Law', 'civil-law', 'Civil litigation and procedures', 'fas fa-balance-scale', 3),
('Family Law', 'family-law', 'Family and domestic relations law', 'fas fa-home', 4),
('Employment Law', 'employment-law', 'Labor and employment regulations', 'fas fa-briefcase', 5),
('Intellectual Property', 'intellectual-property', 'IP rights and protection', 'fas fa-lightbulb', 6);

-- ============================================
-- TABLE 6: ARTICLES
-- ============================================

CREATE TABLE articles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  excerpt TEXT NOT NULL,
  featured_image TEXT, -- Storage path
  content TEXT NOT NULL,
  author_id UUID REFERENCES attorneys(id) ON DELETE SET NULL,
  category_id UUID REFERENCES article_categories(id) ON DELETE SET NULL,
  tags JSONB, -- Array of tags
  published_date TIMESTAMPTZ,
  is_published BOOLEAN DEFAULT false,
  is_featured BOOLEAN DEFAULT false,
  views_count INTEGER DEFAULT 0,
  reading_time INTEGER, -- Minutes (auto-calculated)
  meta_title TEXT,
  meta_description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_articles_slug ON articles(slug);
CREATE INDEX idx_articles_published ON articles(is_published, published_date DESC);
CREATE INDEX idx_articles_featured ON articles(is_featured, is_published);
CREATE INDEX idx_articles_author ON articles(author_id);
CREATE INDEX idx_articles_category ON articles(category_id);
CREATE INDEX idx_articles_tags ON articles USING gin(tags);

CREATE TRIGGER update_articles_updated_at
  BEFORE UPDATE ON articles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trigger to auto-calculate reading time
CREATE OR REPLACE FUNCTION update_article_reading_time()
RETURNS TRIGGER AS $$
BEGIN
  NEW.reading_time := calculate_reading_time(NEW.content);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_article_reading_time
  BEFORE INSERT OR UPDATE OF content ON articles
  FOR EACH ROW
  EXECUTE FUNCTION update_article_reading_time();

-- Sample article
INSERT INTO articles (
  title, slug, excerpt, featured_image, content, 
  author_id, category_id, tags, published_date, 
  is_published, is_featured, meta_title, meta_description
) VALUES (
  'Understanding Indonesian Labor Law 2026',
  'understanding-indonesian-labor-law-2026',
  'Comprehensive guide to the latest updates in Indonesian labor regulations and their impact on businesses.',
  'articles/blog-1.jpg',
  '<h2>Introduction</h2><p>Indonesian labor law has seen significant changes in 2026. This comprehensive guide covers all the essential aspects that employers and employees need to know.</p><h2>Key Changes</h2><p>The latest amendments to the labor law include provisions for flexible work arrangements, updated minimum wage calculations, and enhanced worker protections.</p><h2>Impact on Businesses</h2><p>Businesses operating in Indonesia need to be aware of these changes to ensure compliance and maintain good employee relations.</p>',
  (SELECT id FROM attorneys WHERE is_founder = true LIMIT 1),
  (SELECT id FROM article_categories WHERE slug = 'employment-law' LIMIT 1),
  '["Labor Law", "Employment", "Regulations", "2026"]'::jsonb,
  NOW(),
  true,
  true,
  'Understanding Indonesian Labor Law 2026 - RPW Law Firm',
  'Learn about the latest updates and key provisions in Indonesian labor law for 2026 and how they affect your business.'
);

-- ============================================
-- TABLE 7: CONTACT SUBMISSIONS
-- ============================================

CREATE TABLE contact_submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  subject TEXT,
  message TEXT NOT NULL,
  status TEXT DEFAULT 'new' CHECK (status IN ('new', 'read', 'replied', 'archived')),
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_contact_submissions_status ON contact_submissions(status, created_at DESC);
CREATE INDEX idx_contact_submissions_email ON contact_submissions(email);

CREATE TRIGGER update_contact_submissions_updated_at
  BEFORE UPDATE ON contact_submissions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- TABLE 8: CONTACT INFO (Single Row)
-- ============================================

CREATE TABLE contact_info (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  office_address TEXT NOT NULL,
  office_address_full TEXT,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  phone_secondary TEXT,
  fax TEXT,
  office_hours TEXT,
  google_maps_embed TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_contact_info_singleton ON contact_info((id IS NOT NULL));

CREATE TRIGGER update_contact_info_updated_at
  BEFORE UPDATE ON contact_info
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Sample data
INSERT INTO contact_info (
  office_address, 
  office_address_full, 
  email, 
  phone, 
  office_hours
) VALUES (
  'Jakarta, Indonesia',
  'Jl. Sudirman No. 123, Jakarta Pusat 10220, Indonesia',
  'proxy@rpwadvocates.com',
  '(021) - 29557422',
  'Monday - Friday: 09:00 - 18:00'
);

-- ============================================
-- TABLE 9: SITE CONFIGURATION (Single Row)
-- ============================================

CREATE TABLE site_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  site_name TEXT NOT NULL,
  site_name_short TEXT,
  site_tagline TEXT,
  site_description TEXT,
  site_logo TEXT, -- Storage path
  site_logo_white TEXT,
  site_favicon TEXT,
  copyright_text TEXT,
  footer_text TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_site_config_singleton ON site_config((id IS NOT NULL));

CREATE TRIGGER update_site_config_updated_at
  BEFORE UPDATE ON site_config
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Sample data
INSERT INTO site_config (
  site_name,
  site_name_short,
  site_tagline,
  site_description,
  copyright_text,
  footer_text
) VALUES (
  'R. Prama Wijaya & Partners Law Firm',
  'RPW Law Firm',
  'Leading Legal Solutions in Indonesia',
  'R. Prama Wijaya & Partners is a leading law firm in Jakarta providing comprehensive legal services for businesses and individuals across Indonesia since 1998.',
  '© 2026 R. Prama Wijaya & Partners. All Rights Reserved.',
  'R. Prama Wijaya & Partners is committed to providing excellent legal services with integrity and professionalism.'
);

-- ============================================
-- TABLE 10: SOCIAL MEDIA (Single Row)
-- ============================================

CREATE TABLE social_media (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  facebook_url TEXT,
  twitter_url TEXT,
  linkedin_url TEXT,
  instagram_url TEXT,
  youtube_url TEXT,
  show_social_links BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_social_media_singleton ON social_media((id IS NOT NULL));

CREATE TRIGGER update_social_media_updated_at
  BEFORE UPDATE ON social_media
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Sample data
INSERT INTO social_media (
  facebook_url,
  twitter_url,
  linkedin_url,
  instagram_url,
  show_social_links
) VALUES (
  'https://facebook.com/rpwlawfirm',
  'https://twitter.com/rpwlawfirm',
  'https://linkedin.com/company/rpw-law-firm',
  'https://instagram.com/rpwlawfirm',
  true
);

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Enable RLS on all tables
ALTER TABLE hero_slides ENABLE ROW LEVEL SECURITY;
ALTER TABLE features ENABLE ROW LEVEL SECURITY;
ALTER TABLE practice_areas ENABLE ROW LEVEL SECURITY;
ALTER TABLE attorneys ENABLE ROW LEVEL SECURITY;
ALTER TABLE article_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_info ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE social_media ENABLE ROW LEVEL SECURITY;

-- Public READ policies (for frontend website)
CREATE POLICY "Public can view active hero slides" ON hero_slides FOR SELECT USING (is_active = true);
CREATE POLICY "Public can view active features" ON features FOR SELECT USING (is_active = true);
CREATE POLICY "Public can view active practice areas" ON practice_areas FOR SELECT USING (is_active = true);
CREATE POLICY "Public can view active attorneys" ON attorneys FOR SELECT USING (is_active = true);
CREATE POLICY "Public can view active categories" ON article_categories FOR SELECT USING (is_active = true);
CREATE POLICY "Public can view published articles" ON articles FOR SELECT USING (is_published = true);
CREATE POLICY "Public can view contact info" ON contact_info FOR SELECT USING (true);
CREATE POLICY "Public can view site config" ON site_config FOR SELECT USING (true);
CREATE POLICY "Public can view social media" ON social_media FOR SELECT USING (true);

-- Public INSERT policy for contact form
CREATE POLICY "Anyone can submit contact form" ON contact_submissions FOR INSERT WITH CHECK (true);

-- Admin FULL ACCESS policies (authenticated users only)
-- Note: You'll need to set up user authentication first
CREATE POLICY "Authenticated users full access hero_slides" ON hero_slides FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users full access features" ON features FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users full access practice_areas" ON practice_areas FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users full access attorneys" ON attorneys FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users full access article_categories" ON article_categories FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users full access articles" ON articles FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users full access contact_submissions" ON contact_submissions FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users full access contact_info" ON contact_info FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users full access site_config" ON site_config FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users full access social_media" ON social_media FOR ALL USING (auth.role() = 'authenticated');

-- ============================================
-- SETUP COMPLETE!
-- ============================================
-- Next steps:
-- 1. Create Storage buckets in Supabase Storage:
--    - 'images' bucket for general images
--    - Set bucket to PUBLIC for frontend access
--    - Create folders: hero/, attorneys/, articles/, etc.
--
-- 2. Create admin user in Supabase Authentication:
--    - Go to Authentication > Users
--    - Add new user with email/password
--    - This user can login to /admin panel
--
-- 3. Test the setup:
--    - npm run dev
--    - Visit http://localhost:5173/admin
--    - Login with admin credentials
--    - Test CRUD operations
-- ============================================
