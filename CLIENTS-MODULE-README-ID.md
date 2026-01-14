# Modul Clients - Panduan Lengkap

## 📋 Ringkasan

Modul Clients telah berhasil ditambahkan ke aplikasi. Modul ini memungkinkan Anda untuk mengelola dan menampilkan logo klien di website.

## ✅ File yang Dibuat

1. **Admin Page**: `/src/views/admin/Clients.vue` - Halaman admin untuk mengelola clients
2. **Frontend Component**: `/src/components/ClientsSection.vue` - Komponen untuk menampilkan clients di website
3. **Database Migration**: `supabase-clients-migration.sql` - SQL untuk membuat tabel clients
4. **Storage Policies**: `supabase-clients-storage-policies.sql` - SQL untuk storage bucket policies
5. **Dokumentasi**: `CLIENTS-MODULE-SETUP.md` - Panduan lengkap setup dan penggunaan

## 🔧 Setup Database (Wajib)

### Langkah 1: Buat Tabel Clients

1. Buka **Supabase Dashboard** → **SQL Editor**
2. Copy isi file `supabase-clients-migration.sql`
3. Paste dan klik **Run**

### Langkah 2: Buat Storage Bucket

1. Buka **Supabase Dashboard** → **Storage**
2. Klik **New bucket**
3. Nama bucket: `clients`
4. **Centang "Public bucket"** (agar logo bisa ditampilkan)
5. Klik **Create bucket**

### Langkah 3: Setup Storage Policies

1. Buka **Supabase Dashboard** → **SQL Editor**
2. Copy isi file `supabase-clients-storage-policies.sql`
3. Paste dan klik **Run**

## 🎯 Cara Menggunakan

### Admin Panel

1. Login ke admin panel
2. Klik menu **"Clients"** di sidebar
3. Klik tombol **"Add Client"**
4. Isi form:
   - **Client Name**: Nama perusahaan/klien
   - **Logo**: Upload logo (PNG/JPG, maks 500KB)
   - **Order Position**: Urutan tampil
   - **Active**: Centang untuk aktifkan
5. Klik **"Save Client"**

### Menampilkan di Website

Tambahkan komponen `ClientsSection` di halaman yang diinginkan:

**Contoh di Home.vue:**
```vue
<template>
  <div>
    <!-- Konten lain -->
    <ClientsSection />
    <!-- Konten lain -->
  </div>
</template>

<script setup lang="ts">
import ClientsSection from '@/components/ClientsSection.vue'
</script>
```

## 📊 Struktur Database

```
clients
├── id (UUID, Primary Key)
├── name (TEXT, Required)
├── logo_url (TEXT, Required)
├── order_position (INTEGER, Default: 1)
├── is_active (BOOLEAN, Default: true)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

## 🎨 Fitur

- ✅ CRUD (Create, Read, Update, Delete) clients
- ✅ Upload logo dengan preview
- ✅ Drag & drop image upload
- ✅ Pengaturan urutan tampil
- ✅ Toggle active/inactive
- ✅ Responsive design
- ✅ Loading states
- ✅ Empty states
- ✅ Error handling

## 🔐 Keamanan

- Row Level Security (RLS) aktif
- Public hanya bisa melihat clients yang active
- Authenticated users bisa full CRUD
- Storage bucket terpisah untuk isolasi

## 📝 Catatan Penting

1. **Logo Requirements:**
   - Format: PNG (dengan transparent background) atau JPG
   - Ukuran maks: 500KB
   - Dimensi rekomendasi: 200x200px atau lebih (square/persegi)

2. **Storage Bucket:**
   - Nama bucket HARUS: `clients` (huruf kecil semua)
   - Bucket HARUS public agar logo bisa ditampilkan

3. **RLS Policies:**
   - Pastikan semua policies sudah dibuat dengan benar
   - Public bisa SELECT clients yang is_active = true
   - Authenticated bisa full access

## 🚀 Testing

Setelah setup, test dengan:

1. Buka `/admin/clients`
2. Tambah client baru
3. Upload logo
4. Set active
5. Lihat hasilnya di frontend (jika sudah menambahkan `ClientsSection`)

## 🐛 Troubleshooting

**Logo tidak muncul?**
- Pastikan bucket `clients` sudah dibuat dan public
- Cek storage policies sudah benar
- Lihat console browser untuk error

**Tidak bisa add client?**
- Pastikan sudah login sebagai authenticated user
- Cek RLS policies sudah aktif
- Lihat error message di alert

**Error saat upload logo?**
- Cek ukuran file (maks 500KB)
- Pastikan format PNG atau JPG
- Cek storage policies

## 📦 Next Steps

1. ✅ Setup database (selesai)
2. ✅ Setup storage bucket (selesai)
3. ✅ Test di admin panel
4. ⬜ Tambahkan `ClientsSection` ke halaman website
5. ⬜ Upload logo clients
6. ⬜ Sesuaikan styling sesuai kebutuhan

## 🆘 Support

Jika ada masalah:
1. Cek console browser untuk error
2. Cek Supabase logs
3. Pastikan semua file SQL sudah dijalankan
4. Lihat dokumentasi lengkap di `CLIENTS-MODULE-SETUP.md`

---

**Modul sudah siap digunakan!** 🎉

Silakan jalankan SQL migrations dan buat storage bucket untuk mulai menggunakan modul Clients.
