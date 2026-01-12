# SEO Implementation Guide

Complete SEO implementation for R. Prama Wijaya & Partners Law Firm website.

## 📊 Overview

SEO optimization telah diimplementasikan menggunakan **@unhead/vue** dengan fitur lengkap:

- ✅ Meta tags (Title, Description, Keywords)
- ✅ Open Graph tags (Facebook)
- ✅ Twitter Card tags
- ✅ Canonical URLs
- ✅ Structured Data (Schema.org JSON-LD)
- ✅ Sitemap.xml
- ✅ Robots.txt
- ✅ Favicon configuration

---

## 🛠️ Implementation

### 1. Package Installation

```bash
npm install @unhead/vue
```

### 2. Main Setup

File: `src/main.ts`

```typescript
import { createUnhead } from '@unhead/vue';

const app = createApp(App);
const head = createUnhead();

app.provide('head', head);
```

### 3. SEO Composable

File: `src/composables/useSEO.ts`

Composable yang digunakan untuk manage meta tags di setiap halaman:

```typescript
import { useHead } from '@unhead/vue';

export function useSEO(options: SEOOptions) {
  useHead({
    title: options.title,
    meta: [...],
    link: [...],
    script: [...], // JSON-LD
  });
}
```

---

## 📄 Per-Page SEO

### Home Page

```typescript
useSEO({
  title: 'Home',
  description: 'R. Prama Wijaya & Partners is a leading law firm...',
  keywords: 'law firm Jakarta, Indonesian attorney...',
});
```

### Teams Page

```typescript
useSEO({
  title: 'Our Attorney Team',
  description: 'Meet our experienced legal team led by Ramon Prama Wijaya...',
  keywords: 'attorneys Indonesia, legal team...',
});
```

### Articles Page

```typescript
useSEO({
  title: 'Legal Articles & News',
  description: 'Stay updated with the latest legal news...',
  keywords: 'legal articles, Indonesian law news...',
});
```

### Contact Page

```typescript
useSEO({
  title: 'Contact Us',
  description: 'Contact R. Prama Wijaya & Partners for professional legal consultation...',
  keywords: 'contact lawyer, legal consultation Jakarta...',
});
```

### About Page

```typescript
useSEO({
  title: 'About Our Firm',
  description: 'Learn about R. Prama Wijaya & Partners, our history, mission...',
  keywords: 'about law firm, legal services Jakarta...',
});
```

---

## 🏷️ Meta Tags Generated

### Basic Meta Tags

```html
<title>Page Title | R. Prama Wijaya & Partners Law Firm</title>
<meta name="description" content="...">
<meta name="keywords" content="...">
<meta name="author" content="R. Prama Wijaya & Partners">
<meta name="robots" content="index, follow">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

### Open Graph (Facebook)

```html
<meta property="og:type" content="website">
<meta property="og:site_name" content="R. Prama Wijaya & Partners Law Firm">
<meta property="og:title" content="Page Title">
<meta property="og:description" content="...">
<meta property="og:image" content="https://rpwadvocates.com/img/logo.png">
<meta property="og:url" content="https://rpwadvocates.com">
<meta property="og:locale" content="id_ID">
```

### Twitter Card

```html
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:site" content="@rpwadvocates">
<meta name="twitter:title" content="Page Title">
<meta name="twitter:description" content="...">
<meta name="twitter:image" content="https://rpwadvocates.com/img/logo.png">
```

### Canonical URL

```html
<link rel="canonical" href="https://rpwadvocates.com/page-url">
```

---

## 📊 Structured Data (Schema.org)

### JSON-LD Implementation

Setiap halaman memiliki structured data untuk membantu search engines memahami content:

```json
{
  "@context": "https://schema.org",
  "@type": "LegalService",
  "name": "R. Prama Wijaya & Partners Law Firm",
  "description": "...",
  "url": "https://rpwadvocates.com",
  "logo": "https://rpwadvocates.com/img/logo.png",
  "address": {
    "@type": "PostalAddress",
    "addressLocality": "Jakarta",
    "addressCountry": "ID"
  },
  "contactPoint": {
    "@type": "ContactPoint",
    "telephone": "+62-21-29557422",
    "contactType": "customer service",
    "email": "proxy@rpwadvocates.com"
  },
  "sameAs": [
    "https://twitter.com/rpwadvocates",
    "https://facebook.com/rpwadvocates",
    "https://linkedin.com/company/rpwadvocates",
    "https://instagram.com/rpwadvocates"
  ]
}
```

---

## 🗺️ Sitemap.xml

File: `public/sitemap.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://rpwadvocates.com/</loc>
    <lastmod>2026-01-12</lastmod>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>https://rpwadvocates.com/teams</loc>
    <lastmod>2026-01-12</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
  <!-- More URLs... -->
</urlset>
```

### Submit Sitemap

Submit ke search engines:
- Google: https://search.google.com/search-console
- Bing: https://www.bing.com/webmasters

---

## 🤖 Robots.txt

File: `public/robots.txt`

```txt
User-agent: *
Allow: /

Sitemap: https://rpwadvocates.com/sitemap.xml

# Popular search engines
User-agent: Googlebot
Allow: /

User-agent: Bingbot
Allow: /

# Block AI scrapers (optional)
User-agent: GPTBot
Disallow: /

User-agent: ChatGPT-User
Disallow: /
```

---

## ⚙️ Configuration

### Environment Variables

File: `.env.example`

```env
# Base URL for SEO
VITE_BASE_URL=https://rpwadvocates.com

# Social Media Links
VITE_TWITTER_URL=https://twitter.com/rpwadvocates
VITE_FACEBOOK_URL=https://facebook.com/rpwadvocates
VITE_LINKEDIN_URL=https://linkedin.com/company/rpwadvocates
VITE_INSTAGRAM_URL=https://instagram.com/rpwadvocates
```

Buat file `.env` di root project:

```bash
cp .env.example .env
# Edit .env dengan URL production Anda
```

---

## 🧪 Testing SEO

### 1. View Page Source

Buka halaman di browser dan klik "View Page Source" (Ctrl/Cmd + U)

Cari:
- `<title>` tag
- `<meta name="description">` tag
- `<meta property="og:">` tags
- `<script type="application/ld+json">` tag

### 2. Online Tools

#### Meta Tags Checker
- https://metatags.io
- https://www.opengraph.xyz
- https://cards-dev.twitter.com/validator

#### Structured Data Validator
- https://search.google.com/test/rich-results
- https://validator.schema.org

#### SEO Analysis
- https://www.seobility.net/en/seocheck
- https://www.woorank.com

### 3. Browser Extensions

- **SEO Meta in 1 Click** (Chrome/Firefox)
- **MozBar** (Chrome)
- **Ahrefs SEO Toolbar** (Chrome)

---

## 📈 SEO Best Practices

### ✅ Implemented

1. **Unique Titles** - Setiap halaman memiliki title unik
2. **Meta Descriptions** - 150-160 karakter, descriptive
3. **Keywords** - Relevant keywords untuk setiap halaman
4. **Canonical URLs** - Mencegah duplicate content
5. **Open Graph** - Social media preview
6. **Twitter Cards** - Twitter preview
7. **Structured Data** - Help search engines understand content
8. **Sitemap** - All pages indexed
9. **Robots.txt** - Crawl instructions
10. **Mobile-Friendly** - Responsive design

### 📋 Future Improvements

1. **Content Optimization**
   - Add more unique content to each page
   - Include relevant keywords naturally
   - Add alt texts to all images
   - Create blog articles regularly

2. **Performance**
   - Optimize images (WebP format)
   - Implement lazy loading
   - Minimize JavaScript bundles
   - Use CDN for static assets

3. **Technical SEO**
   - Add hreflang tags (if multi-language)
   - Implement breadcrumbs
   - Add FAQ schema (if applicable)
   - Optimize Core Web Vitals

4. **Local SEO**
   - Google My Business profile
   - Local business schema
   - Customer reviews
   - Local directories

5. **Analytics**
   - Google Analytics 4
   - Google Search Console
   - Track conversions
   - Monitor rankings

---

## 🎯 Expected Results

### Google Search Console

Setelah submit sitemap (1-2 minggu):
- Pages indexed: 5/5
- Valid structured data
- No mobile usability issues
- No security issues

### Search Rankings

Target keywords (3-6 bulan):
- "law firm Jakarta"
- "Indonesian attorney"
- "legal services Indonesia"
- "Ramon Prama Wijaya"

### Lighthouse SEO Score

Target: **90+/100**

Current implementation should achieve:
- ✅ Has a `<meta name="viewport">` tag
- ✅ Document has a `<title>` element
- ✅ Document has a meta description
- ✅ Links have descriptive text
- ✅ Page has valid structured data
- ✅ Has a valid robots.txt
- ✅ Has a valid sitemap

---

## 🔍 Monitoring & Maintenance

### Weekly Tasks

- Check Google Search Console for errors
- Monitor organic traffic (Google Analytics)
- Check for broken links
- Review crawl errors

### Monthly Tasks

- Update sitemap (if new pages added)
- Review keyword rankings
- Analyze competitor SEO
- Update content for freshness
- Check backlinks quality

### Quarterly Tasks

- Full SEO audit
- Update meta descriptions if needed
- Review and update structured data
- Analyze Core Web Vitals
- Update keywords strategy

---

## 📚 Resources

### Official Documentation
- [@unhead/vue](https://unhead.unjs.io/)
- [Schema.org](https://schema.org/)
- [Open Graph Protocol](https://ogp.me/)
- [Twitter Cards](https://developer.twitter.com/en/docs/twitter-for-websites/cards/overview/abouts-cards)

### SEO Guides
- [Google Search Central](https://developers.google.com/search/docs)
- [Moz SEO Guide](https://moz.com/beginners-guide-to-seo)
- [Ahrefs SEO Guide](https://ahrefs.com/seo)

### Tools
- [Google Search Console](https://search.google.com/search-console)
- [Google Analytics](https://analytics.google.com/)
- [Google PageSpeed Insights](https://pagespeed.web.dev/)
- [Screaming Frog SEO Spider](https://www.screamingfrog.co.uk/seo-spider/)

---

## ✅ Checklist

- [x] Install @unhead/vue
- [x] Create useSEO composable
- [x] Implement SEO on all pages
- [x] Add structured data (JSON-LD)
- [x] Create sitemap.xml
- [x] Create robots.txt
- [x] Configure environment variables
- [ ] Submit sitemap to Google
- [ ] Submit sitemap to Bing
- [ ] Set up Google Search Console
- [ ] Set up Google Analytics
- [ ] Monitor rankings
- [ ] Optimize images
- [ ] Create content strategy

---

**Last Updated:** January 12, 2026  
**Status:** ✅ Complete & Production Ready
