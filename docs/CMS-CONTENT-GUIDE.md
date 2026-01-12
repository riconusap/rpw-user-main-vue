# CMS Content Guide

Panduan lengkap untuk menyiapkan konten di CMS untuk website R. Prama Wijaya & Partners Law Firm.

## 📋 Daftar Isi

1. [Home Page](#home-page)
2. [Teams Page](#teams-page)
3. [Articles Page](#articles-page)
4. [Contact Page](#contact-page)
5. [About Page](#about-page)
6. [Global Settings](#global-settings)
7. [SEO Settings](#seo-settings)
8. [Media Requirements](#media-requirements)

---

## 🏠 Home Page

### Hero Section / Carousel
**Collection: `hero_slides`** (Multiple items)

| Field | Type | Required | Example |
|-------|------|----------|---------|
| title | Text | Yes | "We Provide Legal Solutions" |
| subtitle | Rich Text | Yes | "For Your Business" |
| description | Long Text | Yes | "Leading law firm in Jakarta providing..." |
| background_image | Image | Yes | carousel-1.jpg (1920x1080px) |
| cta_text | Text | No | "Get A Quote" |
| cta_link | URL | No | "/contact" |
| order | Number | Yes | 1, 2, 3... |
| is_active | Boolean | Yes | true/false |

**Recommended:** 3-5 slides

---

### Features Section
**Collection: `features`** (Multiple items)

| Field | Type | Required | Example |
|-------|------|----------|---------|
| icon | Text | Yes | "fa-flask" (FontAwesome icon) |
| title | Text | Yes | "Best Law Practices" |
| description | Long Text | Yes | "Dolor lorem ipsum dolor sit amet..." |
| order | Number | Yes | 1, 2, 3, 4 |
| is_active | Boolean | Yes | true/false |

**Recommended:** 4 items (tampil dalam grid 4 kolom)

---

### About Preview Section
**Single Item: `about_preview`**

| Field | Type | Required | Example |
|-------|------|----------|---------|
| badge_text | Text | Yes | "About Us" |
| title | Text | Yes | "Welcome To The Best Law Firm" |
| description | Rich Text | Yes | "Our firm is focused on results..." |
| image | Image | Yes | about.png (800x600px) |
| points | JSON Array | Yes | ["Civil Law Cases", "Criminal Law Cases", etc.] |
| experience_years | Number | Yes | 25 |

**Points Array Example:**
```json
[
  "Civil Law Cases",
  "Criminal Law Cases",
  "Family Law Cases",
  "Business Law Cases"
]
```

---

### Practice Areas Section
**Collection: `practice_areas`** (Multiple items)

| Field | Type | Required | Example |
|-------|------|----------|---------|
| icon | Text | Yes | "fa-gavel" |
| title | Text | Yes | "Civil Law" |
| description | Long Text | Yes | "Lorem ipsum dolor sit amet..." |
| slug | Text | Yes | "civil-law" |
| order | Number | Yes | 1, 2, 3... |
| is_featured | Boolean | Yes | true/false |
| is_active | Boolean | Yes | true/false |

**Recommended:** 6-8 items (tampil dalam grid 3 kolom)

---

### Team Preview Section
**Uses same data as Teams Page** - Show 4 featured attorneys

Settings:
- `show_on_homepage`: true/false
- `featured_count`: 4 (jumlah yang ditampilkan)

---

### Testimonials Section
**Collection: `testimonials`** (Multiple items)

| Field | Type | Required | Example |
|-------|------|----------|---------|
| client_name | Text | Yes | "John Doe" |
| client_position | Text | No | "CEO, Company Name" |
| client_image | Image | No | testimonial-1.jpg (150x150px) |
| content | Long Text | Yes | "Excellent service, very professional..." |
| rating | Number | Yes | 5 (1-5) |
| order | Number | Yes | 1, 2, 3... |
| is_active | Boolean | Yes | true/false |

**Recommended:** 4-6 testimonials (carousel)

---

### Statistics Section
**Single Item: `statistics`**

| Field | Type | Required | Example |
|-------|------|----------|---------|
| clients_count | Number | Yes | 225 |
| cases_count | Number | Yes | 1050 |
| attorneys_count | Number | Yes | 50 |
| awards_count | Number | Yes | 25 |

---

## 👥 Teams Page

### Founder Section
**Single Item: `founder`**

| Field | Type | Required | Example |
|-------|------|----------|---------|
| full_name | Text | Yes | "Ramon Prama Wijaya, S.H." |
| position | Text | Yes | "Founder & Managing Partner" |
| photo | Image | Yes | founder.jpg (400x500px) |
| bio | Rich Text | Yes | "Ramon Prama Wijaya adalah pendiri..." |
| education | JSON Array | Yes | List of education |
| specializations | JSON Array | Yes | List of practice areas |
| languages | Text | Yes | "Indonesian, English" |
| bar_admission | Text | Yes | "Indonesian Bar Association" |
| email | Email | No | "ramon@rpwadvocates.com" |
| phone | Text | No | "+62-21-xxx" |
| linkedin | URL | No | "https://linkedin.com/in/..." |

**Education Array Example:**
```json
[
  {
    "degree": "S.H. (Bachelor of Law)",
    "institution": "University of Indonesia",
    "year": "2005"
  }
]
```

**Specializations Array Example:**
```json
[
  "Corporate Law",
  "Commercial Litigation",
  "Mergers & Acquisitions",
  "Banking & Finance"
]
```

---

### Associates Section
**Collection: `attorneys`** (Multiple items)

| Field | Type | Required | Example |
|-------|------|----------|---------|
| full_name | Text | Yes | "Maria Santoso, S.H., M.H." |
| position | Text | Yes | "Senior Associate" |
| photo | Image | Yes | attorney-1.jpg (300x400px) |
| bio | Long Text | Yes | "Maria has extensive experience..." |
| specializations | JSON Array | Yes | ["Criminal Law", "Civil Law"] |
| education | JSON Array | No | List of education |
| experience_years | Number | Yes | 10 |
| languages | Text | Yes | "Indonesian, English" |
| email | Email | No | "maria@rpwadvocates.com" |
| phone | Text | No | "+62-21-xxx" |
| linkedin | URL | No | URL |
| order | Number | Yes | 1, 2, 3... |
| is_featured | Boolean | Yes | true/false (for homepage) |
| is_active | Boolean | Yes | true/false |

**Recommended:** 6-12 attorneys

---

## 📝 Articles Page

### Blog Posts
**Collection: `articles`** (Multiple items)

| Field | Type | Required | Example |
|-------|------|----------|---------|
| title | Text | Yes | "Understanding Indonesian Labor Law" |
| slug | Text | Yes | "understanding-indonesian-labor-law" |
| excerpt | Long Text | Yes | "Short description of the article..." |
| featured_image | Image | Yes | blog-1.jpg (800x450px) |
| content | Rich Text | Yes | Full article content (HTML) |
| author_id | Relation | Yes | Link to attorney/author |
| category_id | Relation | Yes | Link to category |
| tags | JSON Array | No | ["Labor Law", "Employment", "HR"] |
| published_date | DateTime | Yes | 2026-01-12T10:00:00 |
| is_published | Boolean | Yes | true/false |
| is_featured | Boolean | No | true/false |
| views_count | Number | Auto | 0 (auto-increment) |
| reading_time | Number | Auto | 5 (calculated from content) |
| meta_title | Text | SEO | "Understanding Indonesian Labor Law - Blog" |
| meta_description | Text | SEO | "Learn about the key aspects..." |

**Recommended:** Start with 10-20 articles

---

### Blog Categories
**Collection: `article_categories`** (Multiple items)

| Field | Type | Required | Example |
|-------|------|----------|---------|
| name | Text | Yes | "Corporate Law" |
| slug | Text | Yes | "corporate-law" |
| description | Long Text | No | "Articles about corporate law..." |
| icon | Text | No | "fa-building" |
| order | Number | Yes | 1, 2, 3... |
| is_active | Boolean | Yes | true/false |
| articles_count | Number | Auto | 15 (calculated) |

**Recommended Categories:**
- Corporate Law
- Criminal Law
- Civil Law
- Family Law
- Tax Law
- Intellectual Property
- Employment Law
- Real Estate Law

---

### Blog Authors
**Uses `attorneys` collection** - Same data as Teams

Additional fields for blog:
- `author_bio`: Short bio for article byline
- `author_photo`: Smaller photo (100x100px)

---

### Sidebar Content
**Collection: `blog_sidebar`** (Single item)

| Field | Type | Required | Example |
|-------|------|----------|---------|
| search_placeholder | Text | Yes | "Search articles..." |
| recent_posts_title | Text | Yes | "Recent Post" |
| recent_posts_count | Number | Yes | 5 |
| categories_title | Text | Yes | "Categories" |
| show_categories | Boolean | Yes | true/false |
| show_tags | Boolean | Yes | true/false |

---

## 📞 Contact Page

### Contact Information
**Single Item: `contact_info`**

| Field | Type | Required | Example |
|-------|------|----------|---------|
| office_address | Text | Yes | "Jakarta, Indonesia" |
| office_address_full | Long Text | No | "Jl. Example No. 123, Jakarta 12345" |
| email | Email | Yes | "proxy@rpwadvocates.com" |
| phone | Text | Yes | "(021) - 29557422" |
| phone_secondary | Text | No | "+62-xxx-xxx" |
| fax | Text | No | "(021) - xxx" |
| office_hours | Text | Yes | "Mon - Fri: 09:00 - 18:00" |
| google_maps_embed | URL | No | Google Maps embed URL |

---

### Contact Form Settings
**Single Item: `contact_form_settings`**

| Field | Type | Required | Example |
|-------|------|----------|---------|
| form_title | Text | Yes | "Contact For Any Queries" |
| form_subtitle | Text | Yes | "Get In Touch" |
| recipient_email | Email | Yes | "proxy@rpwadvocates.com" |
| cc_emails | JSON Array | No | ["admin@rpw.com", "info@rpw.com"] |
| success_message | Text | Yes | "Your message has been sent successfully!" |
| error_message | Text | Yes | "Failed to send message. Please try again." |
| enable_notifications | Boolean | Yes | true/false |
| auto_reply | Boolean | Yes | true/false |
| auto_reply_template | Rich Text | No | Email template for auto-reply |

---

## ℹ️ About Page

### Firm Information
**Single Item: `firm_info`**

| Field | Type | Required | Example |
|-------|------|----------|---------|
| firm_name | Text | Yes | "R. PRAMA WIJAYA & PARTNERS" |
| firm_name_display | Text | Yes | "R. Prama Wijaya & Partners" |
| tagline | Text | Yes | "Leading Legal Solutions" |
| about_title | Text | Yes | "About Our Firm" |
| description_paragraph_1 | Rich Text | Yes | "Our firm is focused on the results..." |
| description_paragraph_2 | Rich Text | Yes | "The firm is committed to provide..." |
| founding_year | Number | Yes | 1998 |
| about_image | Image | Yes | about.png (800x600px) |

---

### Contact Cards (About Page)
**Uses `contact_info`** - Same data as Contact Page

Display format:
1. Email card
2. Phone card
3. Office card

---

## 🌐 Global Settings

### Site Configuration
**Single Item: `site_config`**

| Field | Type | Required | Example |
|-------|------|----------|---------|
| site_name | Text | Yes | "R. Prama Wijaya & Partners Law Firm" |
| site_name_short | Text | Yes | "RPW Law Firm" |
| site_tagline | Text | Yes | "Leading Legal Solutions in Indonesia" |
| site_description | Long Text | Yes | "R. Prama Wijaya & Partners is a..." |
| site_logo | Image | Yes | logo.png (300x100px) |
| site_logo_white | Image | Yes | logo-white.png |
| site_favicon | Image | Yes | favicon.ico (32x32px) |
| copyright_text | Text | Yes | "© 2026 R. Prama Wijaya & Partners. All Rights Reserved." |
| footer_text | Rich Text | No | Additional footer content |

---

### Social Media
**Single Item: `social_media`**

| Field | Type | Required | Example |
|-------|------|----------|---------|
| facebook_url | URL | No | "https://facebook.com/rpwadvocates" |
| twitter_url | URL | No | "https://twitter.com/rpwadvocates" |
| linkedin_url | URL | No | "https://linkedin.com/company/rpwadvocates" |
| instagram_url | URL | No | "https://instagram.com/rpwadvocates" |
| youtube_url | URL | No | "https://youtube.com/@rpwadvocates" |
| show_social_links | Boolean | Yes | true/false |

---

### Navigation Menu
**Collection: `menu_items`** (Multiple items)

| Field | Type | Required | Example |
|-------|------|----------|---------|
| label | Text | Yes | "Our Attorney" |
| url | Text | Yes | "/teams" |
| parent_id | Relation | No | Link to parent menu (for dropdown) |
| order | Number | Yes | 1, 2, 3... |
| is_active | Boolean | Yes | true/false |
| target | Select | Yes | "_self" or "_blank" |

**Current Menu Structure:**
1. Our Attorney (/teams)
2. Articles (/articles)
3. About Us (/about)
4. Contact Us (/contact)

---

## 🔍 SEO Settings

### Global SEO
**Single Item: `seo_settings`**

| Field | Type | Required | Example |
|-------|------|----------|---------|
| default_meta_title | Text | Yes | "R. Prama Wijaya & Partners Law Firm" |
| default_meta_description | Text | Yes | "Leading law firm in Jakarta..." |
| default_meta_keywords | Text | Yes | "law firm Jakarta, Indonesian attorney..." |
| og_default_image | Image | Yes | og-image.jpg (1200x630px) |
| twitter_card_type | Select | Yes | "summary_large_image" |
| twitter_handle | Text | No | "@rpwadvocates" |
| google_analytics_id | Text | No | "G-XXXXXXXXXX" |
| google_site_verification | Text | No | "verification code" |
| robots_txt_custom | Long Text | No | Custom robots.txt rules |

---

### Page-Specific SEO
**Each page collection should have:**

| Field | Type | Required | Example |
|-------|------|----------|---------|
| meta_title | Text | SEO | "Page Title | Site Name" |
| meta_description | Text | SEO | "150-160 characters description" |
| meta_keywords | Text | SEO | "keyword1, keyword2, keyword3" |
| og_title | Text | SEO | Same as meta_title or custom |
| og_description | Text | SEO | Same as meta_description or custom |
| og_image | Image | SEO | Custom OG image (1200x630px) |
| canonical_url | URL | SEO | Full canonical URL |
| no_index | Boolean | SEO | false (don't index this page) |
| no_follow | Boolean | SEO | false (don't follow links) |

---

## 📸 Media Requirements

### Image Specifications

#### Hero/Carousel Images
- **Size:** 1920x1080px (16:9 ratio)
- **Format:** JPG or WebP
- **Max File Size:** 500KB
- **Quantity:** 3-5 images

#### Featured/Blog Images
- **Size:** 800x450px (16:9 ratio)
- **Format:** JPG or WebP
- **Max File Size:** 300KB
- **Alt Text:** Required for SEO

#### Team Photos
- **Size:** 400x500px (portrait)
- **Format:** JPG or PNG
- **Max File Size:** 200KB
- **Background:** Professional, preferably solid color

#### Thumbnails
- **Size:** 300x300px (square)
- **Format:** JPG or PNG
- **Max File Size:** 100KB

#### Logo & Favicon
- **Logo:** 300x100px, PNG with transparent background
- **Favicon:** 32x32px, ICO or PNG format

#### Open Graph Images
- **Size:** 1200x630px (1.91:1 ratio)
- **Format:** JPG or PNG
- **Max File Size:** 300KB

---

### Video Requirements (Optional)

| Type | Spec | Example |
|------|------|---------|
| Format | MP4 (H.264) | promotional-video.mp4 |
| Resolution | 1920x1080 (1080p) | HD quality |
| Max File Size | 50MB | Compressed |
| Duration | 1-3 minutes | Keep it short |
| Thumbnail | 1280x720px | Custom thumbnail |

---

## 📝 Content Writing Guidelines

### General Rules

1. **Tone of Voice:** Professional, trustworthy, clear
2. **Language:** Indonesian & English
3. **Sentence Length:** 15-20 words per sentence (average)
4. **Paragraph Length:** 3-5 sentences
5. **Reading Level:** Professional but accessible

---

### SEO Best Practices

#### Title Tags
- **Length:** 50-60 characters
- **Format:** "Primary Keyword | Brand Name"
- **Include:** Main keyword near the beginning
- **Unique:** Every page must have unique title

#### Meta Descriptions
- **Length:** 150-160 characters
- **Include:** Call-to-action
- **Contains:** Primary keyword
- **Compelling:** Encourage click-through

#### Keywords
- **Primary Keyword:** 1 per page
- **Secondary Keywords:** 2-3 per page
- **Density:** 1-2% (natural placement)
- **Placement:** Title, H1, first paragraph, URL

#### Content Structure
- **H1:** 1 per page (main title)
- **H2:** Section headings (3-5 per page)
- **H3:** Sub-sections
- **Bold:** Important terms and key points
- **Lists:** Use for easy scanning

---

### Blog Article Guidelines

#### Article Structure
1. **Title:** Catchy, includes primary keyword (60 chars max)
2. **Introduction:** 100-150 words, hook + overview
3. **Body:** 800-1500 words, broken into sections
4. **Conclusion:** 50-100 words, summary + CTA
5. **Images:** 1 featured + 2-3 inline images
6. **Internal Links:** 2-3 links to other articles/pages
7. **External Links:** 1-2 authoritative sources

#### Content Types
- **How-to Guides:** Step-by-step instructions
- **Case Studies:** Real-world examples
- **Legal Updates:** Latest law changes
- **FAQs:** Common questions answered
- **Opinion Pieces:** Expert perspectives

---

## 🔄 Content Update Schedule

### Daily
- Monitor contact form submissions
- Check for urgent blog comments

### Weekly
- Publish 1-2 new blog articles
- Update recent news/updates
- Review and respond to inquiries

### Monthly
- Update team members if changes
- Review practice areas descriptions
- Update statistics/numbers
- Check for broken links
- Review SEO performance

### Quarterly
- Full content audit
- Update outdated articles
- Refresh testimonials
- Review and update images
- SEO optimization review

### Yearly
- Major content refresh
- Update copyright year
- Review all legal disclaimers
- Update firm achievements/awards
- Professional photoshoot

---

## ✅ Content Checklist

### Before Publishing

#### General Content
- [ ] Spelling and grammar checked
- [ ] Legal accuracy verified
- [ ] Brand voice consistent
- [ ] Contact information verified
- [ ] Links tested (internal & external)
- [ ] Images optimized (size & quality)
- [ ] Alt text added to all images
- [ ] Mobile responsive checked

#### SEO Checklist
- [ ] Meta title set (50-60 chars)
- [ ] Meta description set (150-160 chars)
- [ ] Keywords naturally placed
- [ ] H1 tag present and unique
- [ ] H2-H3 structure logical
- [ ] URL is SEO-friendly
- [ ] Canonical URL set
- [ ] Open Graph tags set
- [ ] Image alt texts descriptive
- [ ] Internal links added
- [ ] External links open in new tab

#### Blog Articles
- [ ] Featured image set (800x450px)
- [ ] Category assigned
- [ ] Tags added (3-5 tags)
- [ ] Author assigned
- [ ] Published date set
- [ ] Reading time calculated
- [ ] Related articles linked
- [ ] Social share buttons work
- [ ] Comments enabled (if applicable)

---

## 🛠️ CMS Tools Recommendations

### Headless CMS Options

1. **Strapi** (Recommended)
   - Open-source
   - Highly customizable
   - Good documentation
   - REST & GraphQL API

2. **Contentful**
   - Enterprise-grade
   - Great UI/UX
   - Strong media management
   - Good free tier

3. **Sanity**
   - Real-time collaboration
   - Flexible schema
   - Excellent for developers
   - Customizable studio

4. **Directus**
   - Open-source
   - Database agnostic
   - Self-hosted option
   - User-friendly

---

## 📊 Analytics & Tracking

### Essential Metrics to Track

#### Website Performance
- Page load time
- Bounce rate
- Time on page
- Pages per session
- Mobile vs desktop traffic

#### Content Performance
- Most viewed articles
- Most shared content
- Average reading time
- Search queries leading to site
- Top landing pages

#### User Engagement
- Contact form submissions
- Newsletter signups
- Social media clicks
- Download/PDF views
- Video plays

#### SEO Metrics
- Organic search traffic
- Keyword rankings
- Backlinks count
- Domain authority
- Page authority

---

## 🔐 Content Security

### Best Practices

1. **User Permissions**
   - Admin: Full access
   - Editor: Content creation/editing
   - Reviewer: Review only
   - Contributor: Draft creation only

2. **Backup Strategy**
   - Daily automatic backups
   - Weekly manual backups
   - Store in multiple locations
   - Test restore process monthly

3. **Version Control**
   - Enable content versioning
   - Track all changes
   - Allow rollback
   - Audit trail for compliance

4. **Content Review**
   - Legal review before publishing
   - Fact-checking process
   - Multiple approval stages
   - Scheduled reviews

---

## 📞 Support & Maintenance

### Content Management Contact

**For content-related questions:**
- Content Manager: [email]
- Technical Support: [email]
- Emergency Contact: [phone]

**Documentation:**
- CMS User Manual: [link]
- Video Tutorials: [link]
- FAQ: [link]
- Support Ticket System: [link]

---

**Last Updated:** January 12, 2026  
**Version:** 1.0  
**Status:** ✅ Ready for Implementation
