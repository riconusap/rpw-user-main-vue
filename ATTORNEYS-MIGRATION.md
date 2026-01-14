# Attorneys Table Migration Instructions

## Langkah-langkah Update Database

### 1. Jalankan Migration SQL

Buka Supabase SQL Editor dan jalankan file `supabase-attorneys-migration.sql`:

```sql
-- Hapus kolom yang tidak diperlukan
ALTER TABLE attorneys DROP COLUMN IF EXISTS experience_years;
ALTER TABLE attorneys DROP COLUMN IF EXISTS languages;
ALTER TABLE attorneys DROP COLUMN IF EXISTS bar_admission;
ALTER TABLE attorneys DROP COLUMN IF EXISTS linkedin_url;
ALTER TABLE attorneys DROP COLUMN IF EXISTS email;
ALTER TABLE attorneys DROP COLUMN IF EXISTS phone;

-- Tambah kolom baru untuk certificates
ALTER TABLE attorneys ADD COLUMN IF NOT EXISTS certificates JSONB DEFAULT '[]'::jsonb;
```

### 2. Struktur Data Certificates

Kolom `certificates` menggunakan format JSONB array dengan struktur:

```json
[
  {
    "name": "Advocate License",
    "issuer": "Indonesian Bar Association",
    "year": "2010"
  },
  {
    "name": "Certified Mediator",
    "issuer": "Supreme Court of Indonesia",
    "year": "2015"
  }
]
```

### 3. Contoh Update Data (Optional)

Jika Anda ingin menambahkan sample certificates ke data yang sudah ada:

```sql
UPDATE attorneys 
SET certificates = '[
  {
    "name": "Advocate License",
    "issuer": "Indonesian Bar Association",
    "year": "2010"
  }
]'::jsonb
WHERE is_founder = true;
```

### 4. Verifikasi

Cek apakah struktur table sudah benar:

```sql
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'attorneys';
```

## Perubahan pada Frontend

### Field yang Dihapus:
- ❌ Experience (Years)
- ❌ Languages
- ❌ Bar Admission
- ❌ LinkedIn URL
- ❌ Email
- ❌ Phone

### Field yang Ditambahkan:
- ✅ Certificates (Dynamic list dengan nama, issuer, dan year)

## Cara Menggunakan

1. Jalankan migration SQL di Supabase
2. Refresh aplikasi frontend
3. Buka halaman Admin > Attorneys
4. Edit atau tambah attorney baru
5. Gunakan tombol "+ Add Certificate" untuk menambah sertifikat
6. Isi nama sertifikat, pemberi sertifikat, dan tahun
7. Gunakan tombol trash untuk menghapus sertifikat

## Troubleshooting

**Q: Error saat save attorney?**
A: Pastikan migration SQL sudah dijalankan dengan benar di Supabase.

**Q: Data lama hilang?**
A: Data lama (photo, bio, dll) tetap tersimpan. Hanya field experience_years, languages, bar_admission, linkedin_url, email, dan phone yang dihapus.

**Q: Gambar tidak muncul setelah upload?**
A: Sudah diperbaiki dengan cache-busting mechanism. Image akan otomatis refresh setelah upload.
