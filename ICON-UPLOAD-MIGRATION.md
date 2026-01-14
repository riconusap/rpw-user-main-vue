# Icon Upload Feature - Migration Guide

## Database Changes Required

Run these SQL scripts in your Supabase SQL Editor:

### 1. Features Table
```sql
ALTER TABLE features ADD COLUMN IF NOT EXISTS icon_image_url TEXT;
COMMENT ON COLUMN features.icon_image_url IS 'URL for custom uploaded icon image (alternative to Font Awesome icon class)';
```

### 2. Practice Areas Table
```sql
ALTER TABLE practice_areas ADD COLUMN IF NOT EXISTS icon_image_url TEXT;
COMMENT ON COLUMN practice_areas.icon_image_url IS 'URL for custom uploaded icon image (alternative to Font Awesome icon class)';
```

### 3. Create Icons Storage Bucket

In Supabase Dashboard > Storage:
1. Create new bucket named `icons`
2. Enable public access
3. Set max file size to 2MB
4. Allowed MIME types: `image/png, image/jpeg, image/svg+xml, image/webp`

Or run this SQL:
```sql
INSERT INTO storage.buckets (id, name, public)
VALUES ('icons', 'icons', true)
ON CONFLICT (id) DO NOTHING;

-- Set storage policies (adjust for your security needs)
CREATE POLICY "Icons are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'icons');

CREATE POLICY "Authenticated users can upload icons"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'icons' AND auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can update icons"
ON storage.objects FOR UPDATE
USING (bucket_id = 'icons' AND auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can delete icons"
ON storage.objects FOR DELETE
USING (bucket_id = 'icons' AND auth.role() = 'authenticated');
```

## Features Added

### Icon Type Selection
Users can now choose between:
- **Font Awesome Icon**: Select from 70+ pre-defined icons using IconPicker modal
- **Upload Image**: Upload custom icon image (PNG, JPG, SVG, WebP)

### Implementation Details

1. **Radio Button Toggle**: User selects icon type at top of form
2. **Conditional Fields**: 
   - Font Awesome: Shows icon picker with browse button
   - Upload Image: Shows ImageUpload component
3. **Data Storage**:
   - Font Awesome: Stores class name in `icon` column (e.g., "fas fa-gavel")
   - Upload Image: Stores Supabase storage URL in `icon_image_url` column
4. **Display Logic**: 
   - If `icon_image_url` exists, show `<img>` tag
   - Otherwise, show `<i>` tag with Font Awesome class

### Files Modified
- `/src/views/admin/Features.vue` - Added icon type toggle and image upload
- `/src/views/admin/PracticeAreas.vue` - Added icon type toggle and image upload
- TypeScript interfaces updated with `icon_image_url` and `icon_type` fields

### Recommended Icon Specs
- **Format**: PNG with transparent background (preferred)
- **Size**: 64x64px to 256x256px
- **Aspect Ratio**: Square (1:1)
- **File Size**: < 500KB
- **Other formats**: JPG, SVG, WebP also supported

## Usage Instructions

1. Open Features or Practice Areas admin page
2. Click "Add New" or "Edit" existing item
3. Select icon type:
   - Choose "Font Awesome Icon" to browse and select from icon library
   - Choose "Upload Image" to upload custom icon file
4. Complete other fields and save

## Testing Checklist

- [ ] Database migrations executed successfully
- [ ] Icons storage bucket created with proper permissions
- [ ] Can select Font Awesome icons using IconPicker
- [ ] Can upload custom icon images
- [ ] Icons display correctly in card view (both FA and images)
- [ ] Editing existing items preserves icon type
- [ ] Image icons have proper sizing and styling
- [ ] Radio buttons work correctly to switch icon types

