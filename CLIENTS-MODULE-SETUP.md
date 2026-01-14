# Clients Module Setup Guide

## Overview
The Clients module allows you to manage and display client logos on your website. This is useful for showcasing the companies or organizations you work with.

## Features
- Add, edit, and delete clients
- Upload client logos
- Set display order
- Toggle active/inactive status
- Responsive design

## Database Setup

### 1. Create the Clients Table

Run the migration SQL script in your Supabase SQL Editor:

```bash
# The SQL file is located at:
supabase-clients-migration.sql
```

Or run the SQL directly in Supabase Dashboard:
1. Go to your Supabase project
2. Navigate to SQL Editor
3. Copy and paste the contents of `supabase-clients-migration.sql`
4. Click "Run"

### 2. Create Storage Bucket for Client Logos

1. Go to Supabase Dashboard → Storage
2. Create a new bucket named `clients`
3. Set the bucket to **Public** (so logos can be displayed on the website)
4. Configure the following policies:

**Storage Policies:**

```sql
-- Allow public to view client logos
CREATE POLICY "Allow public to view client logos"
ON storage.objects FOR SELECT
USING (bucket_id = 'clients');

-- Allow authenticated users to upload client logos
CREATE POLICY "Allow authenticated users to upload client logos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'clients');

-- Allow authenticated users to update client logos
CREATE POLICY "Allow authenticated users to update client logos"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'clients');

-- Allow authenticated users to delete client logos
CREATE POLICY "Allow authenticated users to delete client logos"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'clients');
```

## Admin Panel Usage

### Accessing the Clients Module

1. Log in to the admin panel
2. Navigate to `/admin/clients`
3. You should see the Clients Management page

### Adding a New Client

1. Click the "Add Client" button
2. Fill in the form:
   - **Client Name**: Enter the name of the client/company
   - **Logo**: Upload the client's logo (recommended: PNG with transparent background, max 500KB)
   - **Order Position**: Set the display order (lower numbers appear first)
   - **Active**: Check to make the client visible on the website
3. Click "Save Client"

### Editing a Client

1. Click the edit icon (pencil) on a client card
2. Update the information
3. Click "Save Client"

### Managing Client Status

- Click the eye icon to toggle between active/inactive
- Inactive clients won't be displayed on the public website

### Deleting a Client

1. Click the trash icon on a client card
2. Confirm the deletion
3. The client and its data will be permanently removed

## Logo Guidelines

- **Format**: PNG (preferably with transparent background) or JPG
- **Size**: Maximum 500KB per file
- **Dimensions**: Square images work best (e.g., 200x200px, 400x400px)
- **Quality**: Use high-resolution logos for better display

## Displaying Clients on Website

To display clients on your website, create a new component or section:

```vue
<template>
  <div class="clients-section">
    <div class="container">
      <h2>Our Clients</h2>
      <div class="clients-grid">
        <div
          v-for="client in clients"
          :key="client.id"
          class="client-logo"
        >
          <img
            :src="getImageUrl(client.logo_url, 'clients')"
            :alt="client.name"
            :title="client.name"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabase, getImageUrl } from '@/lib/supabase'

interface Client {
  id: string
  name: string
  logo_url: string
  order_position: number
}

const clients = ref<Client[]>([])

const loadClients = async () => {
  const { data, error } = await supabase
    .from('clients')
    .select('*')
    .eq('is_active', true)
    .order('order_position', { ascending: true })

  if (!error && data) {
    clients.value = data
  }
}

onMounted(() => {
  loadClients()
})
</script>

<style scoped>
.clients-section {
  padding: 60px 0;
  background: #f8f9fa;
}

.clients-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 2rem;
  margin-top: 2rem;
}

.client-logo {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  background: white;
  border-radius: 8px;
  transition: transform 0.3s;
}

.client-logo:hover {
  transform: translateY(-5px);
}

.client-logo img {
  max-width: 100%;
  max-height: 80px;
  object-fit: contain;
  filter: grayscale(100%);
  transition: filter 0.3s;
}

.client-logo:hover img {
  filter: grayscale(0%);
}
</style>
```

## Database Schema

```sql
clients (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  logo_url TEXT NOT NULL,
  order_position INTEGER NOT NULL DEFAULT 1,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE,
  updated_at TIMESTAMP WITH TIME ZONE
)
```

## API Endpoints

The module uses Supabase automatically. No additional API configuration needed.

### Read Clients (Public)
```typescript
const { data } = await supabase
  .from('clients')
  .select('*')
  .eq('is_active', true)
  .order('order_position', { ascending: true })
```

### Create Client (Admin)
```typescript
const { data, error } = await supabase
  .from('clients')
  .insert([{
    name: 'Client Name',
    logo_url: 'path/to/logo.png',
    order_position: 1,
    is_active: true
  }])
```

### Update Client (Admin)
```typescript
const { error } = await supabase
  .from('clients')
  .update({
    name: 'Updated Name',
    logo_url: 'new/path/to/logo.png'
  })
  .eq('id', clientId)
```

### Delete Client (Admin)
```typescript
const { error } = await supabase
  .from('clients')
  .delete()
  .eq('id', clientId)
```

## Troubleshooting

### Logos not displaying
- Check if the `clients` storage bucket is set to Public
- Verify the storage policies are correctly set
- Ensure the logo file was uploaded successfully

### Can't add new clients
- Verify you're logged in as an authenticated user
- Check if the Row Level Security policies are correctly set
- Ensure the `clients` table exists in your database

### Permission errors
- Make sure RLS policies are properly configured
- Verify you have authenticated access to Supabase
- Check if the admin user has the correct permissions

## Next Steps

1. Run the database migration
2. Create the storage bucket
3. Configure storage policies
4. Access the admin panel at `/admin/clients`
5. Add your first client
6. Display clients on your website using the example component

## Support

If you encounter any issues, check the browser console for error messages and verify all database tables and policies are correctly set up.
