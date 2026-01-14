# Attorney Detail Page Migration Guide

## Overview
This guide explains how to add additional fields to the attorneys table to support the new attorney detail page with comprehensive information display.

## Database Migration

### Step 1: Run SQL Migration
Execute the SQL migration file `attorney-detail-fields-migration.sql` in your Supabase SQL Editor:

1. Go to Supabase Dashboard
2. Navigate to SQL Editor
3. Copy and paste the contents of `attorney-detail-fields-migration.sql`
4. Click "Run" to execute the migration

### New Fields Added

The migration adds the following optional fields to the `attorneys` table:

1. **email** (TEXT)
   - Attorney's contact email address
   - Optional field for direct contact

2. **phone** (TEXT)
   - Attorney's phone number
   - Optional field for direct contact

3. **specializations** (JSONB)
   - Array of practice area specializations
   - Example: `["Criminal Law", "Corporate Law", "Family Law"]`
   - Displayed as tags on the detail page

4. **education** (JSONB)
   - Array of education history
   - Example: `["S.H., University of Indonesia, 2015", "LL.M., Harvard Law School, 2018"]`
   - Displayed as a bulleted list

5. **experience** (JSONB)
   - Array of professional experience entries
   - Example: `["Senior Associate at ABC Law Firm (2018-2020)", "Partner at XYZ Legal Partners (2020-Present)"]`
   - Displayed as a bulleted list

6. **achievements** (JSONB)
   - Array of awards, recognitions, and achievements
   - Example: `["Best Young Lawyer Award 2020", "Published author in Law Journal"]`
   - Displayed as a bulleted list

### Data Format Examples

#### Adding Specializations
```sql
UPDATE attorneys 
SET specializations = '["Criminal Defense", "Corporate Law", "Intellectual Property"]'::jsonb
WHERE id = 'your-attorney-id';
```

#### Adding Education
```sql
UPDATE attorneys 
SET education = '[
  "S.H., Faculty of Law, University of Indonesia (2012-2016)",
  "LL.M., International Business Law, Harvard Law School (2017-2018)"
]'::jsonb
WHERE id = 'your-attorney-id';
```

#### Adding Experience
```sql
UPDATE attorneys 
SET experience = '[
  "Junior Associate, Hadiputranto, Hadinoto & Partners (2016-2018)",
  "Senior Associate, Assegaf Hamzah & Partners (2018-2021)",
  "Partner, R. Prama Wijaya & Partners (2021-Present)"
]'::jsonb
WHERE id = 'your-attorney-id';
```

#### Adding Achievements
```sql
UPDATE attorneys 
SET achievements = '[
  "Indonesian Young Lawyer of the Year 2020",
  "Published: Corporate Governance Best Practices in Southeast Asia",
  "Speaker at ASEAN Legal Conference 2022"
]'::jsonb
WHERE id = 'your-attorney-id';
```

#### Adding Contact Information
```sql
UPDATE attorneys 
SET 
  email = 'john.doe@rpw-law.com',
  phone = '+62 21 1234 5678'
WHERE id = 'your-attorney-id';
```

## Admin Panel Update (Optional)

To allow editing these fields in the admin panel, you would need to update `/src/views/admin/Attorneys.vue`:

1. Add form fields for email, phone, specializations, education, experience, achievements
2. Update the `AttorneyFormData` interface
3. Update the `saveAttorney()` function to include new fields

## Features

### Attorney Detail Page (`/attorneys/:id`)

The new detail page displays:

1. **Profile Card (Left Column)**
   - Attorney photo with founder badge (if applicable)
   - Full name and position
   - Contact information (email, phone)
   - Specialization tags
   - Sticky positioning on desktop

2. **Biography Section (Right Column)**
   - Full biography
   - Education history
   - Professional experience
   - Achievements and awards
   - Call-to-action buttons

3. **Navigation**
   - Breadcrumb navigation
   - Links to contact page
   - "View All Attorneys" button

### Team Section Redesign

The homepage team section now features:
- Modern card-based layout (no carousel)
- Grid display (4 attorneys per row on desktop)
- Hover overlay with "View Profile" button
- Direct links to attorney detail pages
- Responsive design for mobile/tablet
- "Meet All Our Team" button

### Teams Page Updates

The dedicated teams page (`/teams`) now includes:
- Founder section with profile view overlay
- Associates carousel with detail links
- All links point to attorney detail pages

## Routes

New route added:
- `/attorneys/:id` - Individual attorney profile page

Existing routes:
- `/teams` - All attorneys page
- `/` (home) - Featured attorneys section

## SEO

The attorney detail page includes:
- Dynamic page title: `[Attorney Name] - [Position]`
- Meta description from attorney bio
- Keywords including attorney name and position

## Styling

Modern design features:
- Gradient backgrounds
- Smooth hover effects
- Responsive layout
- Shadow effects
- Professional color scheme (gold accents: #d4a948)
- Consistent with site-wide design language

## Testing Checklist

- [ ] Database migration executed successfully
- [ ] Attorney detail page loads without errors
- [ ] All links from TeamSection work correctly
- [ ] All links from Teams page work correctly
- [ ] Contact information displays when present
- [ ] Specializations display as tags
- [ ] Education, experience, achievements show as lists
- [ ] Empty fields are hidden gracefully
- [ ] Mobile responsive layout works
- [ ] SEO meta tags update correctly
- [ ] Image error handling works (fallback to default)
- [ ] "Not Found" state shows for invalid attorney IDs
