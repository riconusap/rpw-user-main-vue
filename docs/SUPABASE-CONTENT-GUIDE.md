# Supabase CMS Content Guide

Panduan lengkap implementasi CMS menggunakan Supabase untuk website R. Prama Wijaya & Partners Law Firm.

## 📋 Daftar Isi

1. [Database Schema](#database-schema)
2. [Storage Buckets](#storage-buckets)
3. [Row Level Security (RLS)](#row-level-security-rls)
4. [API Integration](#api-integration)
5. [Real-time Features](#real-time-features)
6. [Edge Functions](#edge-functions)
7. [Setup Guide](#setup-guide)

---

## 🗄️ Database Schema

### 1. Hero Slides Table
```sql
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

-- Index for ordering
CREATE INDEX idx_hero_slides_order ON hero_slides(order_position, is_active);

-- Trigger for updated_at
CREATE TRIGGER update_hero_slides_updated_at
  BEFORE UPDATE ON hero_slides
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
```

**Sample Data:**
```sql
INSERT INTO hero_slides (title, subtitle, description, background_image, cta_text, cta_link, order_position) VALUES
('We Provide Legal Solutions', 'For Your Business', 'Leading law firm in Jakarta providing comprehensive legal services...', 'carousel-1.jpg', 'Get A Quote', '/contact', 1),
('Trusted Legal Advisors', 'Since 1998', 'Over 25 years of experience in Indonesian law...', 'carousel-2.jpg', 'Learn More', '/about', 2),
('Expert Legal Team', 'At Your Service', 'Our team of experienced attorneys is ready to help...', 'carousel-3.jpg', 'Contact Us', '/contact', 3);
```

---

### 2. Features Table
```sql
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
```

**Sample Data:**
```sql
INSERT INTO features (icon, title, description, order_position) VALUES
('fa-flask', 'Best Law Practices', 'Dolor lorem ipsum dolor sit amet consectetur adipiscing', 1),
('fa-gavel', 'Efficiency & Trust', 'Dolor lorem ipsum dolor sit amet consectetur adipiscing', 2),
('fa-balance-scale', 'Results You Deserve', 'Dolor lorem ipsum dolor sit amet consectetur adipiscing', 3),
('fa-users', 'Dedicated Team', 'Dolor lorem ipsum dolor sit amet consectetur adipiscing', 4);
```

---

### 3. Firm Info Table (Single Row)
```sql
CREATE TABLE firm_info (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  firm_name TEXT NOT NULL DEFAULT 'R. PRAMA WIJAYA & PARTNERS',
  firm_name_display TEXT NOT NULL,
  tagline TEXT,
  about_badge_text TEXT DEFAULT 'About Us',
  about_title TEXT,
  about_description_1 TEXT,
  about_description_2 TEXT,
  about_image TEXT, -- Storage path
  founding_year INTEGER,
  experience_years INTEGER,
  about_points JSONB, -- Array of points
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Ensure only one row
CREATE UNIQUE INDEX idx_firm_info_singleton ON firm_info((id IS NOT NULL));
```

**Sample Data:**
```sql
INSERT INTO firm_info (
  firm_name_display, 
  tagline, 
  about_title,
  about_description_1,
  about_description_2,
  about_image,
  founding_year,
  experience_years,
  about_points
) VALUES (
  'R. Prama Wijaya & Partners',
  'Leading Legal Solutions in Indonesia',
  'Welcome To The Best Law Firm',
  'Our firm is focused on the results. With exceptional experiences and depth of knowledge...',
  'The firm is committed to provide excellent service to develop a long-term relationship...',
  'about.png',
  1998,
  25,
  '["Civil Law Cases", "Criminal Law Cases", "Family Law Cases", "Business Law Cases"]'::jsonb
);
```

---

### 4. Practice Areas Table
```sql
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
```

**Sample Data:**
```sql
INSERT INTO practice_areas (icon, title, description, slug, order_position, is_featured) VALUES
('fa-gavel', 'Civil Law', 'Lorem ipsum dolor sit amet elit. Ipsum dolor sit amet', 'civil-law', 1, true),
('fa-balance-scale', 'Criminal Law', 'Lorem ipsum dolor sit amet elit. Ipsum dolor sit amet', 'criminal-law', 2, true),
('fa-home', 'Property Law', 'Lorem ipsum dolor sit amet elit. Ipsum dolor sit amet', 'property-law', 3, true),
('fa-briefcase', 'Business Law', 'Lorem ipsum dolor sit amet elit. Ipsum dolor sit amet', 'business-law', 4, true),
('fa-graduation-cap', 'Education Law', 'Lorem ipsum dolor sit amet elit. Ipsum dolor sit amet', 'education-law', 5, false),
('fa-file-contract', 'Contract Law', 'Lorem ipsum dolor sit amet elit. Ipsum dolor sit amet', 'contract-law', 6, false);
```

---

### 5. Attorneys Table
```sql
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
```

**Sample Data:**
```sql
-- Founder
INSERT INTO attorneys (
  full_name, position, photo, bio, specializations, education, 
  experience_years, languages, bar_admission, email, phone, 
  order_position, is_founder, is_featured
) VALUES (
  'Ramon Prama Wijaya, S.H.',
  'Founder & Managing Partner',
  'founder.jpg',
  'Ramon Prama Wijaya adalah pendiri dan managing partner...',
  '["Corporate Law", "Commercial Litigation", "Mergers & Acquisitions", "Banking & Finance"]'::jsonb,
  '[{"degree": "S.H. (Bachelor of Law)", "institution": "University of Indonesia", "year": "2005"}]'::jsonb,
  25,
  'Indonesian, English',
  'Indonesian Bar Association',
  'ramon@rpwadvocates.com',
  '+62-21-29557422',
  0,
  true,
  true
);

-- Associates
INSERT INTO attorneys (full_name, position, photo, specializations, experience_years, languages, order_position, is_featured) VALUES
('Maria Santoso, S.H., M.H.', 'Senior Associate', 'attorney-1.jpg', '["Criminal Law", "Civil Law"]'::jsonb, 10, 'Indonesian, English', 1, true),
('Budi Hartono, S.H.', 'Associate', 'attorney-2.jpg', '["Corporate Law", "Tax Law"]'::jsonb, 8, 'Indonesian, English', 2, true),
('Siti Nurhaliza, S.H.', 'Associate', 'attorney-3.jpg', '["Family Law", "Property Law"]'::jsonb, 7, 'Indonesian, English', 3, true),
('Ahmad Yani, S.H., M.H.', 'Senior Associate', 'attorney-4.jpg', '["Employment Law", "Labor Law"]'::jsonb, 12, 'Indonesian, English, Mandarin', 4, true);
```

---

### 6. Article Categories Table
```sql
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
```

**Sample Data:**
```sql
INSERT INTO article_categories (name, slug, description, icon, order_position) VALUES
('Corporate Law', 'corporate-law', 'Articles about corporate and business law', 'fa-building', 1),
('Criminal Law', 'criminal-law', 'Criminal law updates and case studies', 'fa-gavel', 2),
('Civil Law', 'civil-law', 'Civil litigation and procedures', 'fa-balance-scale', 3),
('Family Law', 'family-law', 'Family and domestic relations law', 'fa-home', 4),
('Employment Law', 'employment-law', 'Labor and employment regulations', 'fa-briefcase', 5),
('Intellectual Property', 'intellectual-property', 'IP rights and protection', 'fa-lightbulb', 6);
```

---

### 7. Articles Table
```sql
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
  reading_time INTEGER, -- Minutes
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

-- Function to calculate reading time
CREATE OR REPLACE FUNCTION calculate_reading_time(content TEXT)
RETURNS INTEGER AS $$
BEGIN
  -- Average reading speed: 200 words per minute
  RETURN CEIL(array_length(regexp_split_to_array(content, E'\\s+'), 1) / 200.0);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

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
```

**Sample Data:**
```sql
INSERT INTO articles (
  title, slug, excerpt, featured_image, content, 
  author_id, category_id, tags, published_date, 
  is_published, meta_title, meta_description
) VALUES (
  'Understanding Indonesian Labor Law 2026',
  'understanding-indonesian-labor-law-2026',
  'Comprehensive guide to the latest updates in Indonesian labor regulations...',
  'blog-1.jpg',
  '<h2>Introduction</h2><p>Indonesian labor law has seen significant changes...</p>',
  (SELECT id FROM attorneys WHERE is_founder = true LIMIT 1),
  (SELECT id FROM article_categories WHERE slug = 'employment-law' LIMIT 1),
  '["Labor Law", "Employment", "Regulations"]'::jsonb,
  NOW(),
  true,
  'Understanding Indonesian Labor Law 2026 - RPW Law Firm',
  'Learn about the latest updates and key provisions in Indonesian labor law for 2026.'
);
```

---

### 8. Testimonials Table
```sql
CREATE TABLE testimonials (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_name TEXT NOT NULL,
  client_position TEXT,
  client_image TEXT, -- Storage path
  content TEXT NOT NULL,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  order_position INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_testimonials_order ON testimonials(order_position, is_active);
```

**Sample Data:**
```sql
INSERT INTO testimonials (client_name, client_position, content, rating, order_position) VALUES
('John Doe', 'CEO, Tech Company', 'Excellent service, very professional and knowledgeable. Highly recommended!', 5, 1),
('Jane Smith', 'Business Owner', 'The team at RPW helped us navigate complex legal issues with ease.', 5, 2),
('Ahmad Ibrahim', 'Director, Finance Corp', 'Outstanding legal expertise and customer service. Very satisfied!', 5, 3),
('Sarah Chen', 'Entrepreneur', 'Professional, responsive, and results-oriented. Thank you!', 5, 4);
```

---

### 9. Statistics Table (Single Row)
```sql
CREATE TABLE statistics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clients_count INTEGER DEFAULT 0,
  cases_count INTEGER DEFAULT 0,
  attorneys_count INTEGER DEFAULT 0,
  awards_count INTEGER DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Ensure only one row
CREATE UNIQUE INDEX idx_statistics_singleton ON statistics((id IS NOT NULL));
```

**Sample Data:**
```sql
INSERT INTO statistics (clients_count, cases_count, attorneys_count, awards_count) 
VALUES (225, 1050, 50, 25);
```

---

### 10. Contact Info Table (Single Row)
```sql
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
```

**Sample Data:**
```sql
INSERT INTO contact_info (
  office_address, 
  office_address_full, 
  email, 
  phone, 
  office_hours
) VALUES (
  'Jakarta, Indonesia',
  'Jl. Sudirman No. 123, Jakarta Pusat 10220',
  'proxy@rpwadvocates.com',
  '(021) - 29557422',
  'Monday - Friday: 09:00 - 18:00'
);
```

---

### 11. Contact Submissions Table
```sql
CREATE TABLE contact_submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  subject TEXT NOT NULL,
  message TEXT NOT NULL,
  status TEXT DEFAULT 'new' CHECK (status IN ('new', 'read', 'replied', 'archived')),
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_contact_submissions_status ON contact_submissions(status, created_at DESC);
CREATE INDEX idx_contact_submissions_email ON contact_submissions(email);
```

---

### 12. Site Configuration Table (Single Row)
```sql
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
```

**Sample Data:**
```sql
INSERT INTO site_config (
  site_name,
  site_name_short,
  site_tagline,
  site_description,
  copyright_text
) VALUES (
  'R. Prama Wijaya & Partners Law Firm',
  'RPW Law Firm',
  'Leading Legal Solutions in Indonesia',
  'R. Prama Wijaya & Partners is a leading law firm in Jakarta...',
  '© 2026 R. Prama Wijaya & Partners. All Rights Reserved.'
);
```

---

### 13. Social Media Table (Single Row)
```sql
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
```

**Sample Data:**
```sql
INSERT INTO social_media (
  facebook_url,
  twitter_url,
  linkedin_url,
  instagram_url
) VALUES (
  'https://facebook.com/rpwadvocates',
  'https://twitter.com/rpwadvocates',
  'https://linkedin.com/company/rpwadvocates',
  'https://instagram.com/rpwadvocates'
);
```

---

### 14. SEO Settings Table (Single Row)
```sql
CREATE TABLE seo_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  default_meta_title TEXT,
  default_meta_description TEXT,
  default_meta_keywords TEXT,
  og_default_image TEXT, -- Storage path
  twitter_card_type TEXT DEFAULT 'summary_large_image',
  twitter_handle TEXT,
  google_analytics_id TEXT,
  google_site_verification TEXT,
  robots_txt_custom TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_seo_settings_singleton ON seo_settings((id IS NOT NULL));
```

---

### 15. Menu Items Table
```sql
CREATE TABLE menu_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  label TEXT NOT NULL,
  url TEXT NOT NULL,
  parent_id UUID REFERENCES menu_items(id) ON DELETE CASCADE,
  order_position INTEGER DEFAULT 0,
  target TEXT DEFAULT '_self' CHECK (target IN ('_self', '_blank')),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_menu_items_order ON menu_items(order_position, is_active);
CREATE INDEX idx_menu_items_parent ON menu_items(parent_id);
```

**Sample Data:**
```sql
INSERT INTO menu_items (label, url, order_position) VALUES
('Our Attorney', '/teams', 1),
('Articles', '/articles', 2),
('About Us', '/about', 3),
('Contact Us', '/contact', 4);
```

---

## 📦 Storage Buckets

### Bucket Configuration

```sql
-- Create storage buckets
INSERT INTO storage.buckets (id, name, public) VALUES
('images', 'images', true),
('documents', 'documents', false),
('avatars', 'avatars', true);
```

### Folder Structure in `images` bucket:
```
images/
├── hero/           # Hero carousel images (1920x1080)
├── about/          # About page images
├── blog/           # Blog featured images (800x450)
├── team/           # Attorney photos (400x500)
├── thumbnails/     # Auto-generated thumbnails
├── logos/          # Site logos and branding
└── og/             # Open Graph images (1200x630)
```

### Storage Policies

```sql
-- Allow public read access to images bucket
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING (bucket_id = 'images');

-- Allow authenticated users to upload images
CREATE POLICY "Authenticated Upload"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'images' 
  AND auth.role() = 'authenticated'
);

-- Allow users to update their own uploads
CREATE POLICY "User Update Own Files"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'images' 
  AND auth.uid()::text = owner
);

-- Allow users to delete their own uploads
CREATE POLICY "User Delete Own Files"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'images' 
  AND auth.uid()::text = owner
);
```

---

## 🔒 Row Level Security (RLS)

### Enable RLS on all tables
```sql
ALTER TABLE hero_slides ENABLE ROW LEVEL SECURITY;
ALTER TABLE features ENABLE ROW LEVEL SECURITY;
ALTER TABLE firm_info ENABLE ROW LEVEL SECURITY;
ALTER TABLE practice_areas ENABLE ROW LEVEL SECURITY;
ALTER TABLE attorneys ENABLE ROW LEVEL SECURITY;
ALTER TABLE article_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE testimonials ENABLE ROW LEVEL SECURITY;
ALTER TABLE statistics ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_info ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE social_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE seo_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
```

---

### Public Read Policies (for website frontend)

```sql
-- Hero Slides - Public can read active slides
CREATE POLICY "Public can view active hero slides"
ON hero_slides FOR SELECT
USING (is_active = true);

-- Features - Public can read active features
CREATE POLICY "Public can view active features"
ON features FOR SELECT
USING (is_active = true);

-- Firm Info - Public can read
CREATE POLICY "Public can view firm info"
ON firm_info FOR SELECT
USING (true);

-- Practice Areas - Public can read active areas
CREATE POLICY "Public can view active practice areas"
ON practice_areas FOR SELECT
USING (is_active = true);

-- Attorneys - Public can read active attorneys
CREATE POLICY "Public can view active attorneys"
ON attorneys FOR SELECT
USING (is_active = true);

-- Article Categories - Public can read active categories
CREATE POLICY "Public can view active categories"
ON article_categories FOR SELECT
USING (is_active = true);

-- Articles - Public can read published articles
CREATE POLICY "Public can view published articles"
ON articles FOR SELECT
USING (is_published = true);

-- Testimonials - Public can read active testimonials
CREATE POLICY "Public can view active testimonials"
ON testimonials FOR SELECT
USING (is_active = true);

-- Statistics - Public can read
CREATE POLICY "Public can view statistics"
ON statistics FOR SELECT
USING (true);

-- Contact Info - Public can read
CREATE POLICY "Public can view contact info"
ON contact_info FOR SELECT
USING (true);

-- Site Config - Public can read
CREATE POLICY "Public can view site config"
ON site_config FOR SELECT
USING (true);

-- Social Media - Public can read
CREATE POLICY "Public can view social media"
ON social_media FOR SELECT
USING (true);

-- SEO Settings - Public can read
CREATE POLICY "Public can view seo settings"
ON seo_settings FOR SELECT
USING (true);

-- Menu Items - Public can read active items
CREATE POLICY "Public can view active menu items"
ON menu_items FOR SELECT
USING (is_active = true);
```

---

### Admin Write Policies

```sql
-- Admins can do everything (authenticated users with admin role)
CREATE POLICY "Admins full access hero_slides"
ON hero_slides FOR ALL
USING (auth.jwt()->>'role' = 'admin')
WITH CHECK (auth.jwt()->>'role' = 'admin');

CREATE POLICY "Admins full access features"
ON features FOR ALL
USING (auth.jwt()->>'role' = 'admin')
WITH CHECK (auth.jwt()->>'role' = 'admin');

-- Repeat for all tables...
```

---

### Contact Form Policy

```sql
-- Anyone can insert contact submissions (public form)
CREATE POLICY "Anyone can submit contact form"
ON contact_submissions FOR INSERT
WITH CHECK (true);

-- Only admins can read submissions
CREATE POLICY "Admins can view submissions"
ON contact_submissions FOR SELECT
USING (auth.jwt()->>'role' = 'admin');

-- Admins can update submission status
CREATE POLICY "Admins can update submissions"
ON contact_submissions FOR UPDATE
USING (auth.jwt()->>'role' = 'admin')
WITH CHECK (auth.jwt()->>'role' = 'admin');
```

---

## 🔌 API Integration

### 1. Environment Variables (.env)

```env
# Supabase Configuration
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

---

### 2. Supabase Client Setup

**File:** `src/lib/supabase.ts`

```typescript
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables')
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// TypeScript types
export type Database = {
  public: {
    Tables: {
      hero_slides: {
        Row: {
          id: string
          title: string
          subtitle: string | null
          description: string
          background_image: string
          cta_text: string | null
          cta_link: string | null
          order_position: number
          is_active: boolean
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['hero_slides']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['hero_slides']['Insert']>
      }
      // Add other table types...
    }
  }
}
```

---

### 3. API Service Examples

**File:** `src/services/api.ts`

```typescript
import { supabase } from '@/lib/supabase'

// Hero Slides
export const getHeroSlides = async () => {
  const { data, error } = await supabase
    .from('hero_slides')
    .select('*')
    .eq('is_active', true)
    .order('order_position', { ascending: true })
  
  if (error) throw error
  return data
}

// Features
export const getFeatures = async () => {
  const { data, error } = await supabase
    .from('features')
    .select('*')
    .eq('is_active', true)
    .order('order_position', { ascending: true })
  
  if (error) throw error
  return data
}

// Firm Info
export const getFirmInfo = async () => {
  const { data, error } = await supabase
    .from('firm_info')
    .select('*')
    .single()
  
  if (error) throw error
  return data
}

// Practice Areas
export const getPracticeAreas = async (featured_only = false) => {
  let query = supabase
    .from('practice_areas')
    .select('*')
    .eq('is_active', true)
  
  if (featured_only) {
    query = query.eq('is_featured', true)
  }
  
  const { data, error } = await query.order('order_position', { ascending: true })
  
  if (error) throw error
  return data
}

// Attorneys
export const getAttorneys = async (featured_only = false) => {
  let query = supabase
    .from('attorneys')
    .select('*')
    .eq('is_active', true)
  
  if (featured_only) {
    query = query.eq('is_featured', true)
  }
  
  const { data, error } = await query.order('order_position', { ascending: true })
  
  if (error) throw error
  return data
}

export const getFounder = async () => {
  const { data, error } = await supabase
    .from('attorneys')
    .select('*')
    .eq('is_founder', true)
    .eq('is_active', true)
    .single()
  
  if (error) throw error
  return data
}

// Articles
export const getArticles = async (page = 1, limit = 10) => {
  const from = (page - 1) * limit
  const to = from + limit - 1
  
  const { data, error, count } = await supabase
    .from('articles')
    .select('*, author:attorneys(*), category:article_categories(*)', { count: 'exact' })
    .eq('is_published', true)
    .order('published_date', { ascending: false })
    .range(from, to)
  
  if (error) throw error
  return { articles: data, total: count }
}

export const getArticleBySlug = async (slug: string) => {
  const { data, error } = await supabase
    .from('articles')
    .select('*, author:attorneys(*), category:article_categories(*)')
    .eq('slug', slug)
    .eq('is_published', true)
    .single()
  
  if (error) throw error
  
  // Increment view count
  await supabase.rpc('increment_article_views', { article_id: data.id })
  
  return data
}

export const getArticleCategories = async () => {
  const { data, error } = await supabase
    .from('article_categories')
    .select('*, articles:articles(count)')
    .eq('is_active', true)
    .order('order_position', { ascending: true })
  
  if (error) throw error
  return data
}

// Testimonials
export const getTestimonials = async () => {
  const { data, error } = await supabase
    .from('testimonials')
    .select('*')
    .eq('is_active', true)
    .order('order_position', { ascending: true })
  
  if (error) throw error
  return data
}

// Statistics
export const getStatistics = async () => {
  const { data, error } = await supabase
    .from('statistics')
    .select('*')
    .single()
  
  if (error) throw error
  return data
}

// Contact
export const getContactInfo = async () => {
  const { data, error } = await supabase
    .from('contact_info')
    .select('*')
    .single()
  
  if (error) throw error
  return data
}

export const submitContactForm = async (formData: {
  name: string
  email: string
  subject: string
  message: string
}) => {
  const { data, error } = await supabase
    .from('contact_submissions')
    .insert([{
      ...formData,
      status: 'new'
    }])
    .select()
    .single()
  
  if (error) throw error
  return data
}

// Site Config
export const getSiteConfig = async () => {
  const { data, error } = await supabase
    .from('site_config')
    .select('*')
    .single()
  
  if (error) throw error
  return data
}

// Social Media
export const getSocialMedia = async () => {
  const { data, error } = await supabase
    .from('social_media')
    .select('*')
    .single()
  
  if (error) throw error
  return data
}

// Menu Items
export const getMenuItems = async () => {
  const { data, error } = await supabase
    .from('menu_items')
    .select('*')
    .eq('is_active', true)
    .is('parent_id', null)
    .order('order_position', { ascending: true })
  
  if (error) throw error
  return data
}

// Storage - Get public URL for image
export const getImageUrl = (path: string, bucket = 'images') => {
  const { data } = supabase.storage.from(bucket).getPublicUrl(path)
  return data.publicUrl
}
```

---

### 4. Database Functions

```sql
-- Function to increment article views
CREATE OR REPLACE FUNCTION increment_article_views(article_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE articles 
  SET views_count = views_count + 1 
  WHERE id = article_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get articles count by category
CREATE OR REPLACE FUNCTION get_category_article_count(category_id UUID)
RETURNS INTEGER AS $$
  SELECT COUNT(*)::INTEGER 
  FROM articles 
  WHERE category_id = $1 AND is_published = true;
$$ LANGUAGE sql STABLE;

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

## ⚡ Real-time Features

### Subscribe to Article Updates

```typescript
import { supabase } from '@/lib/supabase'

// Subscribe to new published articles
const subscription = supabase
  .channel('public:articles')
  .on(
    'postgres_changes',
    {
      event: 'INSERT',
      schema: 'public',
      table: 'articles',
      filter: 'is_published=eq.true'
    },
    (payload) => {
      console.log('New article published:', payload.new)
      // Update UI with new article
    }
  )
  .subscribe()

// Unsubscribe when component unmounts
// subscription.unsubscribe()
```

---

### Real-time Contact Form Notifications

```typescript
// Admin dashboard - listen for new contact submissions
const contactSubscription = supabase
  .channel('contact_submissions')
  .on(
    'postgres_changes',
    {
      event: 'INSERT',
      schema: 'public',
      table: 'contact_submissions'
    },
    (payload) => {
      console.log('New contact submission:', payload.new)
      // Show notification to admin
      showNotification('New contact form submission!')
    }
  )
  .subscribe()
```

---

## 🔧 Edge Functions

### 1. Send Email Notification (Contact Form)

**File:** `supabase/functions/send-contact-email/index.ts`

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { name, email, subject, message } = await req.json()

    // Send email using your preferred service (SendGrid, Resend, etc.)
    const emailResponse = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${Deno.env.get('RESEND_API_KEY')}`,
      },
      body: JSON.stringify({
        from: 'noreply@rpwadvocates.com',
        to: 'proxy@rpwadvocates.com',
        subject: `New Contact Form: ${subject}`,
        html: `
          <h2>New Contact Form Submission</h2>
          <p><strong>Name:</strong> ${name}</p>
          <p><strong>Email:</strong> ${email}</p>
          <p><strong>Subject:</strong> ${subject}</p>
          <p><strong>Message:</strong></p>
          <p>${message}</p>
        `,
      }),
    })

    if (!emailResponse.ok) {
      throw new Error('Failed to send email')
    }

    return new Response(
      JSON.stringify({ success: true }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
```

**Deploy:**
```bash
supabase functions deploy send-contact-email
```

---

### 2. Generate Sitemap

**File:** `supabase/functions/generate-sitemap/index.ts`

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
  )

  // Get all published articles
  const { data: articles } = await supabase
    .from('articles')
    .select('slug, updated_at')
    .eq('is_published', true)

  const baseUrl = 'https://rpwadvocates.com'
  
  const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>${baseUrl}/</loc>
    <lastmod>${new Date().toISOString()}</lastmod>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>${baseUrl}/teams</loc>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>${baseUrl}/articles</loc>
    <changefreq>weekly</changefreq>
    <priority>0.9</priority>
  </url>
  <url>
    <loc>${baseUrl}/about</loc>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>${baseUrl}/contact</loc>
    <changefreq>monthly</changefreq>
    <priority>0.7</priority>
  </url>
  ${articles?.map(article => `
  <url>
    <loc>${baseUrl}/articles/${article.slug}</loc>
    <lastmod>${article.updated_at}</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.6</priority>
  </url>`).join('')}
</urlset>`

  return new Response(sitemap, {
    headers: { 'Content-Type': 'application/xml' },
  })
})
```

---

## 🚀 Setup Guide

### 1. Install Supabase CLI

```bash
npm install -g supabase
```

### 2. Initialize Supabase

```bash
supabase init
supabase login
```

### 3. Link to Project

```bash
supabase link --project-ref your-project-ref
```

### 4. Run Migrations

```bash
# Create migration file
supabase migration new init_cms_schema

# Copy all SQL from above into the migration file
# Then apply migration
supabase db push
```

### 5. Seed Database

```bash
# Create seed file
supabase seed new initial_data

# Copy sample data SQL into seed file
# Then run seed
supabase db seed
```

### 6. Install Supabase Client

```bash
npm install @supabase/supabase-js
```

### 7. Configure Environment

```bash
cp .env.example .env
# Add your Supabase URL and keys
```

### 8. Test Connection

```typescript
// Test in your app
import { supabase } from '@/lib/supabase'

const testConnection = async () => {
  const { data, error } = await supabase
    .from('site_config')
    .select('*')
    .single()
  
  console.log('Connection test:', data, error)
}
```

---

## 📊 Database Diagram

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   hero_slides   │     │    attorneys     │────▶│   articles      │
└─────────────────┘     └──────────────────┘     │  (author_id)    │
                                                  └─────────────────┘
┌─────────────────┐                                      ▲
│    features     │                                      │
└─────────────────┘                              ┌───────┴──────────┐
                                                 │article_categories│
┌─────────────────┐                              │   (category_id)  │
│ practice_areas  │                              └──────────────────┘
└─────────────────┘

┌─────────────────┐     ┌──────────────────┐
│  testimonials   │     │  contact_info    │
└─────────────────┘     └──────────────────┘

┌─────────────────┐     ┌──────────────────┐
│   statistics    │     │contact_submissions│
└─────────────────┘     └──────────────────┘

┌─────────────────┐     ┌──────────────────┐
│   firm_info     │     │   site_config    │
└─────────────────┘     └──────────────────┘

┌─────────────────┐     ┌──────────────────┐
│  social_media   │     │  seo_settings    │
└─────────────────┘     └──────────────────┘

┌─────────────────┐
│   menu_items    │────▶│ menu_items       │
│                 │     │ (parent_id)      │
└─────────────────┘     └──────────────────┘
```

---

## ✅ Migration Checklist

- [ ] Create Supabase project
- [ ] Run all SQL migrations
- [ ] Seed initial data
- [ ] Configure Storage buckets
- [ ] Set up RLS policies
- [ ] Deploy Edge Functions
- [ ] Configure environment variables
- [ ] Test all API endpoints
- [ ] Set up real-time subscriptions
- [ ] Configure backup strategy
- [ ] Set up monitoring/alerts
- [ ] Document admin procedures

---

## 📚 Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [Storage Documentation](https://supabase.com/docs/guides/storage)
- [Edge Functions Guide](https://supabase.com/docs/guides/functions)
- [Real-time Documentation](https://supabase.com/docs/guides/realtime)

---

**Last Updated:** January 12, 2026  
**Version:** 1.0  
**Status:** ✅ Ready for Implementation
