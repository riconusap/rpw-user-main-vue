-- ============================================
-- ATTORNEYS TABLE MIGRATION
-- Update struktur table attorneys
-- Menghapus: experience_years, languages, bar_admission, linkedin_url, email, phone
-- Menambah: certificates (JSONB array)
-- ============================================

-- Backup data lama (optional)
-- CREATE TABLE attorneys_backup AS SELECT * FROM attorneys;

-- Hapus kolom yang tidak diperlukan
ALTER TABLE attorneys DROP COLUMN IF EXISTS experience_years;
ALTER TABLE attorneys DROP COLUMN IF EXISTS languages;
ALTER TABLE attorneys DROP COLUMN IF EXISTS bar_admission;
ALTER TABLE attorneys DROP COLUMN IF EXISTS linkedin_url;
ALTER TABLE attorneys DROP COLUMN IF EXISTS email;
ALTER TABLE attorneys DROP COLUMN IF EXISTS phone;

-- Tambah kolom baru untuk certificates
ALTER TABLE attorneys ADD COLUMN IF NOT EXISTS certificates JSONB DEFAULT '[]'::jsonb;

-- Update comment untuk dokumentasi
COMMENT ON COLUMN attorneys.certificates IS 'Array of certificate objects: [{"name": "Certificate Name", "issuer": "Issuing Organization", "year": "2023"}]';

-- Contoh update data (jika perlu migrasi dari education ke certificates)
-- UPDATE attorneys SET certificates = education WHERE education IS NOT NULL;

-- ============================================
-- MIGRATION COMPLETE
-- ============================================
-- Struktur certificates (JSONB):
-- [
--   {
--     "name": "Advocate License",
--     "issuer": "Indonesian Bar Association", 
--     "year": "2010"
--   },
--   {
--     "name": "Certified Mediator",
--     "issuer": "Supreme Court of Indonesia",
--     "year": "2015"
--   }
-- ]
-- ============================================
