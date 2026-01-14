# Settings Module - Setup Guide

## Overview
The Settings module allows administrators to manage site configuration, contact information, and social media links through a centralized interface.

## Features Implemented

### 1. **Site Configuration**
- Site Name
- Site Tagline
- Site Description
- Logo Upload
- Favicon Upload

### 2. **Contact Information**
- Office Address
- Phone Number
- WhatsApp Number
- Primary Email
- Secondary Email
- Business Hours
- Google Maps Embed URL

### 3. **Social Media Links**
- Facebook
- Twitter
- Instagram
- LinkedIn
- YouTube
- TikTok

## Database Setup

### Step 1: Run Migration SQL

1. Go to **Supabase Dashboard** → **SQL Editor**
2. Copy the contents of `supabase-settings-migration.sql`
3. Paste and click **Run**

This will create:
- `site_settings` table with all required fields
- Row Level Security (RLS) policies
- Auto-update triggers for timestamps
- Default settings data

### Step 2: Verify Storage Bucket

Ensure the `images` bucket exists for logo/favicon uploads:

1. Go to **Supabase Dashboard** → **Storage**
2. Check if `images` bucket exists
3. Create folder `settings` inside the bucket (optional, will auto-create)

## Usage

### Accessing Settings

1. Log in to admin panel
2. Click **Settings** in the sidebar
3. You'll see three main sections

### Updating Settings

1. **Site Configuration**
   - Update site name and tagline
   - Upload logo (recommended: PNG with transparent background)
   - Upload favicon (recommended: 32x32px or 64x64px)

2. **Contact Information**
   - Fill in office address
   - Add phone and WhatsApp numbers
   - Set primary and secondary emails
   - Define business hours
   - Add Google Maps embed URL for location map

3. **Social Media**
   - Add full URLs to social media profiles
   - Leave blank any platforms you don't use

4. Click **"Save All Changes"** button at the top

### Getting Google Maps Embed URL

1. Go to [Google Maps](https://maps.google.com)
2. Search for your office location
3. Click **Share** → **Embed a map**
4. Copy the URL from the iframe src attribute
5. Paste into "Google Maps Embed URL" field

## Using Settings in Frontend

### Example: Display Contact Info

```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const settings = ref<any>({})

const loadSettings = async () => {
  const { data } = await supabase
    .from('site_settings')
    .select('*')
    .single()
  
  if (data) {
    settings.value = data
  }
}

onMounted(() => {
  loadSettings()
})
</script>

<template>
  <div>
    <h1>{{ settings.site_name }}</h1>
    <p>{{ settings.site_tagline }}</p>
    <p>{{ settings.contact_address }}</p>
    <p>{{ settings.contact_phone }}</p>
    <a :href="`mailto:${settings.contact_email}`">
      {{ settings.contact_email }}
    </a>
  </div>
</template>
```

### Example: Display Social Media Icons

```vue
<template>
  <div class="social-links">
    <a v-if="settings.social_facebook" :href="settings.social_facebook" target="_blank">
      <i class="fab fa-facebook"></i>
    </a>
    <a v-if="settings.social_twitter" :href="settings.social_twitter" target="_blank">
      <i class="fab fa-twitter"></i>
    </a>
    <a v-if="settings.social_instagram" :href="settings.social_instagram" target="_blank">
      <i class="fab fa-instagram"></i>
    </a>
    <a v-if="settings.social_linkedin" :href="settings.social_linkedin" target="_blank">
      <i class="fab fa-linkedin"></i>
    </a>
  </div>
</template>
```

### Example: Create a Composable

Create `src/composables/useSettings.ts`:

```typescript
import { ref } from 'vue'
import { supabase } from '@/lib/supabase'

interface SiteSettings {
  site_name: string
  site_tagline: string
  site_description: string
  site_logo: string
  site_favicon: string
  contact_address: string
  contact_phone: string
  contact_whatsapp: string
  contact_email: string
  contact_email_secondary: string
  business_hours: string
  google_maps_url: string
  social_facebook: string
  social_twitter: string
  social_instagram: string
  social_linkedin: string
  social_youtube: string
  social_tiktok: string
}

const settings = ref<SiteSettings | null>(null)
const loading = ref(false)

export const useSettings = () => {
  const loadSettings = async () => {
    if (settings.value) return settings.value // Cache
    
    loading.value = true
    try {
      const { data, error } = await supabase
        .from('site_settings')
        .select('*')
        .single()

      if (error) throw error
      settings.value = data
      return data
    } catch (error) {
      console.error('Error loading settings:', error)
      return null
    } finally {
      loading.value = false
    }
  }

  return {
    settings,
    loading,
    loadSettings,
  }
}
```

Then use in components:

```vue
<script setup lang="ts">
import { onMounted } from 'vue'
import { useSettings } from '@/composables/useSettings'

const { settings, loadSettings } = useSettings()

onMounted(() => {
  loadSettings()
})
</script>
```

## Database Schema

```sql
site_settings (
  id UUID PRIMARY KEY,
  
  -- Site Config
  site_name TEXT,
  site_tagline TEXT,
  site_description TEXT,
  site_logo TEXT,
  site_favicon TEXT,
  
  -- Contact Info
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
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

## API Reference

### Read Settings (Public)
```typescript
const { data } = await supabase
  .from('site_settings')
  .select('*')
  .single()
```

### Update Settings (Admin)
```typescript
const { error } = await supabase
  .from('site_settings')
  .update({
    site_name: 'New Name',
    contact_email: 'new@email.com'
  })
  .eq('id', settingsId)
```

## Security

- **RLS Enabled:** Row Level Security is active
- **Public Read:** Anyone can read settings (for frontend display)
- **Authenticated Update:** Only authenticated users can modify settings
- **Single Row:** Typically only one row in this table

## Best Practices

1. **Update Regularly:** Keep contact info current
2. **Optimize Images:** 
   - Logo: Max 200KB, PNG preferred
   - Favicon: 32x32px or 64x64px
3. **Test Links:** Verify all social media URLs work
4. **Backup:** Export settings before major changes
5. **Use Cache:** Cache settings in frontend to reduce database calls

## Troubleshooting

### Settings not saving
- Check authentication status
- Verify RLS policies are set correctly
- Check browser console for errors

### Images not displaying
- Verify `images` bucket exists and is public
- Check storage policies allow public read
- Ensure image paths are correct

### Can't access settings
- Run the migration SQL first
- Verify table was created successfully
- Check user has authenticated access

## Next Steps

1. ✅ Run database migration
2. ✅ Access Settings page in admin
3. ✅ Fill in your information
4. ✅ Upload logo and favicon
5. ⬜ Create useSettings composable (optional)
6. ⬜ Use settings in frontend components
7. ⬜ Update footer with contact info
8. ⬜ Add social media icons to header/footer

## Support

For issues or questions:
1. Check browser console for errors
2. Verify database table exists
3. Check Supabase logs
4. Ensure RLS policies are correct

---

**Settings module is ready to use!** 🎉
