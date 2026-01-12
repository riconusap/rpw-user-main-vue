# Supabase Database Setup Guide

## 📦 Quick Setup

Ikuti langkah-langkah berikut untuk setup database Supabase:

### 1. Login ke Supabase Dashboard

Buka: https://homngxqmbbxodvjpfdxc.supabase.co

### 2. Run SQL Migration

1. Di dashboard Supabase, buka menu **SQL Editor** (ikon database di sidebar kiri)
2. Klik tombol **"+ New query"**
3. Copy seluruh isi file `supabase-setup.sql` yang ada di root project
4. Paste ke SQL Editor
5. Klik tombol **"Run"** atau tekan `Ctrl/Cmd + Enter`

⏱️ **Estimasi waktu**: ~5-10 detik

### 3. Setup Storage Buckets

1. Di dashboard Supabase, buka menu **Storage** (ikon folder di sidebar)
2. Klik **"Create a new bucket"**
3. Buat bucket dengan nama: `images`
4. **PENTING**: Set bucket ke **Public** agar gambar bisa diakses dari frontend
5. Klik "Create bucket"

#### Struktur Folder (opsional, akan auto-created saat upload):
```
images/
├── hero/          # Hero slide backgrounds
├── attorneys/     # Attorney photos
├── articles/      # Article featured images
└── general/       # Other images
```

### 4. Create Admin User

1. Di dashboard Supabase, buka menu **Authentication** (ikon user di sidebar)
2. Klik tab **"Users"**
3. Klik tombol **"Add user"** → **"Create new user"**
4. Isi form:
   - **Email**: admin@rpwadvocates.com (atau email Anda)
   - **Password**: Buat password yang kuat (min 8 karakter)
   - **Auto Confirm User**: ✅ CENTANG (agar langsung bisa login tanpa verifikasi email)
5. Klik **"Create user"**

### 5. Test Setup

```bash
# Jalankan development server
npm run dev
```

Buka browser:
- Frontend: http://localhost:5173
- Admin Panel: http://localhost:5173/admin

Login dengan credentials yang dibuat di step 4.

---

## 📊 Tables Created

Setup ini akan membuat 10 tables:

| Table | Purpose | Sample Data |
|-------|---------|-------------|
| `hero_slides` | Hero carousel di homepage | ✅ 3 slides |
| `features` | Features section | ✅ 4 features |
| `practice_areas` | Practice areas list | ✅ 6 areas |
| `attorneys` | Team members | ✅ 5 attorneys |
| `article_categories` | Blog categories | ✅ 6 categories |
| `articles` | Blog posts | ✅ 1 sample |
| `contact_submissions` | Contact form data | Empty |
| `contact_info` | Office contact details | ✅ Filled |
| `site_config` | Site configuration | ✅ Filled |
| `social_media` | Social media links | ✅ Filled |

---

## 🔒 Security (RLS Policies)

Row Level Security sudah dikonfigurasi:

### Public Access (Frontend)
- ✅ **Read** active/published content
- ✅ **Insert** contact form submissions

### Admin Access (Authenticated Users)
- ✅ **Full CRUD** access ke semua tables
- ✅ View all data (including inactive/draft)

---

## 🧪 Verify Setup

Jalankan query berikut di SQL Editor untuk verifikasi:

```sql
-- Check tables created
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Check sample data
SELECT 'hero_slides' as table, COUNT(*) as rows FROM hero_slides
UNION ALL
SELECT 'features', COUNT(*) FROM features
UNION ALL
SELECT 'practice_areas', COUNT(*) FROM practice_areas
UNION ALL
SELECT 'attorneys', COUNT(*) FROM attorneys
UNION ALL
SELECT 'article_categories', COUNT(*) FROM article_categories
UNION ALL
SELECT 'articles', COUNT(*) FROM articles;

-- Check RLS policies
SELECT schemaname, tablename, policyname 
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, policyname;
```

Expected output:
```
hero_slides: 3 rows
features: 4 rows
practice_areas: 6 rows
attorneys: 5 rows
article_categories: 6 rows
articles: 1 row
```

---

## 🚨 Troubleshooting

### Error: "relation already exists"
Database sudah pernah di-setup. Untuk reset:
```sql
-- WARNING: Ini akan HAPUS semua data!
DROP TABLE IF EXISTS articles CASCADE;
DROP TABLE IF EXISTS article_categories CASCADE;
DROP TABLE IF EXISTS attorneys CASCADE;
DROP TABLE IF EXISTS practice_areas CASCADE;
DROP TABLE IF EXISTS features CASCADE;
DROP TABLE IF EXISTS hero_slides CASCADE;
DROP TABLE IF EXISTS contact_submissions CASCADE;
DROP TABLE IF EXISTS contact_info CASCADE;
DROP TABLE IF EXISTS site_config CASCADE;
DROP TABLE IF EXISTS social_media CASCADE;

-- Lalu run ulang supabase-setup.sql
```

### Error: "permission denied for schema public"
1. Pastikan Anda login sebagai owner project
2. Check di Project Settings → Database → Connection pooling

### Storage bucket tidak bisa diakses
1. Pastikan bucket `images` di-set ke **Public**
2. Check di Storage → images → Settings → Make public

### Admin tidak bisa login
1. Pastikan user sudah di-create di Authentication
2. Check "Auto Confirm User" sudah dicentang
3. Coba reset password lewat dashboard

---

## 📝 Next Steps

Setelah setup selesai:

1. ✅ Login ke admin panel: http://localhost:5173/admin
2. ✅ Test Hero Slides management
3. ✅ Upload sample images
4. ✅ Test Features management
5. ✅ Test Contact Submissions viewer
6. ✅ Create more content

---

## 🔗 Useful Links

- **Supabase Dashboard**: https://homngxqmbbxodvjpfdxc.supabase.co
- **API Documentation**: https://supabase.com/docs
- **SQL Editor**: Dashboard → SQL Editor
- **Authentication**: Dashboard → Authentication
- **Storage**: Dashboard → Storage

---

## 💡 Tips

- **Auto-save**: Changes in admin panel langsung tersimpan ke database
- **Real-time**: Gunakan real-time subscriptions untuk live updates
- **Backup**: Export data lewat SQL Editor → Query → Export to CSV
- **Images**: Compress gambar sebelum upload (recommended < 1MB)
- **Performance**: Gunakan CDN atau Cloudinary untuk production

---

**✨ Setup Complete!** Database Anda siap digunakan.
