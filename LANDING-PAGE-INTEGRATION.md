# Landing Page Integration with Admin Settings

This document outlines the integration of admin panel settings with the landing page components, making the website fully dynamic.

## Overview

All hardcoded content has been replaced with dynamic data from the `site_settings` table. This allows administrators to update site-wide information through the admin panel without modifying code.

## Updated Components

### 1. Footer Component (`src/components/Footer.vue`)

**Dynamic Fields:**
- Site logo from `settings.site_logo`
- Site description from `settings.site_description`
- Social media links (Twitter, Facebook, LinkedIn, Instagram, YouTube)
- Contact address, phone, WhatsApp
- Contact email with clickable mailto link
- Business hours display
- Site name in copyright

**Features:**
- Conditional rendering - only shows filled fields
- Fallback to default logo if not set
- External links open in new tab
- WhatsApp link with proper formatting
- Hover effects on social icons

### 2. Navbar Component (`src/components/Navbar.vue`)

**Dynamic Fields:**
- Site logo from `settings.site_logo`
- Site name for alt text

**Features:**
- Fallback to default logo if not configured
- Responsive design maintained

### 3. Contact Page (`src/views/Contact.vue`)

**Dynamic Fields:**
- Contact address (displays as "Our Office")
- Contact email (displays as "Email Us")
- Contact phone (displays as "Call Us")
- Contact WhatsApp (displays as "WhatsApp")

**Features:**
- Icons automatically assigned based on field type
- Computed property for dynamic contact info
- Form submission still works with Supabase

### 4. About Section (`src/components/AboutSection.vue`)

**Dynamic Fields:**
- Site name (displays as firm name)
- Site description (replaces hardcoded about text)
- Contact email with mailto link
- Contact phone with tel link
- Contact address (office location)

**Features:**
- Fallback to default content if settings not loaded
- Clickable email and phone links
- Conditional rendering for each contact card

### 5. About Page (`src/views/About.vue`)

**Dynamic Fields:**
- Firm name from `settings.site_name`
- Description from `settings.site_description`
- Tagline from `settings.site_tagline`
- All contact information dynamically rendered

**Features:**
- Computed property for reactive updates
- Fallback text for each field
- Flexible contact cards based on available data

### 6. Home Page (`src/views/Home.vue`)

**Added:**
- ClientsSection component imported and displayed
- Shows active clients from database
- Positioned between Services and Team sections

## Technical Implementation

### useSettings Composable

Location: `src/composables/useSettings.ts`

```typescript
interface SiteSettings {
  // Site Configuration
  site_name: string;
  site_tagline: string;
  site_description: string;
  site_logo: string;
  site_favicon: string;
  
  // Contact Information
  contact_email: string;
  contact_phone: string;
  contact_whatsapp: string;
  contact_address: string;
  business_hours: string;
  
  // Social Media
  social_facebook: string;
  social_twitter: string;
  social_instagram: string;
  social_linkedin: string;
  social_youtube: string;
  social_tiktok: string;
  social_threads: string;
}
```

**Key Features:**
- Caching mechanism to avoid repeated database calls
- Error handling with fallback values
- `loadSettings()` - loads settings with cache check
- `refreshSettings()` - clears cache and reloads
- Single source of truth for all settings

### Usage Pattern

```vue
<script lang="ts">
import { defineComponent, onMounted } from 'vue';
import { useSettings } from '@/composables/useSettings';
import { getImageUrl } from '@/lib/supabase';

export default defineComponent({
  setup() {
    const { settings, loadSettings } = useSettings();

    onMounted(() => {
      loadSettings();
    });

    return {
      settings,
      getImageUrl,
    };
  },
});
</script>
```

## Benefits

1. **No Code Changes Required**: Admins can update content through the admin panel
2. **Single Source of Truth**: All settings stored in one database table
3. **Performance Optimized**: Caching prevents unnecessary database calls
4. **Fallback Values**: Site works even if settings not configured
5. **Type Safe**: TypeScript interfaces ensure data integrity
6. **SEO Friendly**: Dynamic meta tags can be integrated with settings
7. **Consistent Data**: Same contact info across all pages

## Integration with Clients Module

The Clients section now displays on the home page:
- Shows active clients only (`is_active = true`)
- Ordered by `order_position`
- Displays client logo and name
- Responsive grid layout
- Managed through admin panel at `/admin/clients`

## Future Enhancements

Potential improvements:
1. **Dynamic SEO**: Update `useSEO.ts` to use settings data
2. **Multiple Languages**: Add language switcher with settings per locale
3. **Theme Customization**: Add primary color, fonts, etc. to settings
4. **Google Analytics**: Store GA tracking ID in settings
5. **Maintenance Mode**: Add toggle in settings to show maintenance page
6. **Opening Hours**: Structured format for business hours with timezone
7. **Google Maps**: Store coordinates for office location map

## Testing Checklist

- [x] Footer displays dynamic social links
- [x] Contact page shows dynamic info
- [x] About section uses dynamic data
- [x] Navbar shows dynamic logo
- [x] Clients section visible on home page
- [x] All links are clickable and functional
- [x] Settings cache works correctly
- [x] Fallback values work when settings empty
- [x] Mobile responsive layout maintained

## Admin Panel Updates Required

For full integration, ensure these are completed in admin settings:

1. **Site Configuration**
   - Upload site logo
   - Set site name, tagline, description
   - Upload favicon

2. **Contact Information**
   - Add email, phone, WhatsApp
   - Set office address
   - Configure business hours

3. **Social Media**
   - Add all relevant social media URLs
   - Use full URLs (e.g., `https://facebook.com/yourpage`)

4. **Clients**
   - Add client logos
   - Set display order
   - Activate/deactivate as needed

## Database Schema

Settings are stored in the `site_settings` table with a single row (id=1). See `supabase-settings-migration.sql` for the complete schema.

Clients are stored in the `clients` table with the following fields:
- `name`: Client company name
- `logo_url`: Path to logo in Supabase storage
- `order_position`: Display order on landing page
- `is_active`: Toggle visibility

## Related Documentation

- [SETTINGS-MODULE-SETUP.md](./SETTINGS-MODULE-SETUP.md) - Admin settings module
- [CLIENTS-MODULE-SETUP.md](./CLIENTS-MODULE-SETUP.md) - Clients management
- [supabase-settings-migration.sql](./supabase-settings-migration.sql) - Database schema
- [supabase-clients-migration.sql](./supabase-clients-migration.sql) - Clients table

---

Last Updated: 2024
