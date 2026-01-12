# Image Storage Options Guide

Panduan lengkap untuk memilih solusi penyimpanan gambar yang efisien untuk website R. Prama Wijaya & Partners Law Firm.

## 📋 Daftar Isi

1. [Perbandingan Opsi Storage](#perbandingan-opsi-storage)
2. [Supabase Storage (Default)](#1-supabase-storage-default)
3. [Cloudinary (Recommended)](#2-cloudinary-recommended)
4. [Cloudflare R2](#3-cloudflare-r2)
5. [ImageKit](#4-imagekit)
6. [Bunny CDN Storage](#5-bunny-cdn-storage)
7. [Vercel Blob Storage](#6-vercel-blob-storage)
8. [AWS S3 + CloudFront](#7-aws-s3--cloudfront)
9. [Hybrid Approach](#hybrid-approach)
10. [Rekomendasi](#rekomendasi)

---

## 📊 Perbandingan Opsi Storage

| Provider | Cost/Month | Free Tier | CDN | Optimization | Upload Speed | Best For |
|----------|-----------|-----------|-----|--------------|--------------|----------|
| **Cloudinary** | $0-89 | 25GB storage, 25GB bandwidth | ✅ Global | ✅ Auto | Fast | Images with transformations |
| **Cloudflare R2** | $0.015/GB | 10GB free | ✅ Global | ❌ Manual | Very Fast | Large files, no egress fees |
| **ImageKit** | $0-49 | 20GB bandwidth | ✅ Global | ✅ Auto | Fast | Image-heavy sites |
| **Bunny CDN** | $0.01/GB | Pay as you go | ✅ Global | ✅ Optional | Very Fast | Budget-friendly CDN |
| **Supabase Storage** | Included | 1GB (free tier) | ✅ Via CDN | ❌ Manual | Fast | All-in-one solution |
| **Vercel Blob** | $0.15/GB | 500MB free | ✅ Edge | ❌ Manual | Very Fast | Vercel deployments |
| **AWS S3 + CF** | $5+/month | 5GB (1 year) | ✅ Global | ❌ Manual | Fast | Enterprise, complex needs |

---

## 1. Supabase Storage (Default)

### ✅ Pros
- Included with Supabase (no additional setup)
- Integrated with database (RLS policies)
- Simple API
- Good for small-medium projects
- CDN included

### ❌ Cons
- Limited free tier (1GB)
- No automatic image optimization
- No image transformations
- Basic CDN (not as fast as dedicated CDNs)

### 💰 Pricing
- **Free tier:** 1GB storage + 2GB bandwidth
- **Pro:** $25/month includes 100GB bandwidth
- **Additional storage:** $0.021/GB/month

### 📝 When to Use
- Small project (<1000 images)
- Already using Supabase
- Don't need image transformations
- Budget constraint

### 🔧 Implementation (Current)
Already implemented in SUPABASE-CONTENT-GUIDE.md

---

## 2. Cloudinary (Recommended)

### ✅ Pros
- **Automatic image optimization** (WebP, AVIF, format selection)
- **On-the-fly transformations** (resize, crop, effects)
- **Global CDN** (fast worldwide)
- **Generous free tier** (25GB/month)
- **AI-powered features** (auto-crop, background removal)
- **Video support**
- **Easy integration**

### ❌ Cons
- Can be expensive for high traffic
- Vendor lock-in (URLs tied to Cloudinary)
- Overkill for simple use cases

### 💰 Pricing
- **Free:** 25 credits/month (~25GB bandwidth + storage)
- **Plus:** $89/month (135 credits)
- **Advanced:** $224/month (375 credits)

### 📝 When to Use
- Need image optimization
- Want responsive images
- High-traffic website
- Need image transformations

### 🔧 Implementation

#### Install SDK
```bash
npm install cloudinary
```

#### Setup (.env)
```env
VITE_CLOUDINARY_CLOUD_NAME=your-cloud-name
VITE_CLOUDINARY_API_KEY=your-api-key
VITE_CLOUDINARY_API_SECRET=your-api-secret
```

#### Upload Helper
```typescript
// src/lib/cloudinary.ts
import { v2 as cloudinary } from 'cloudinary'

cloudinary.config({
  cloud_name: import.meta.env.VITE_CLOUDINARY_CLOUD_NAME,
  api_key: import.meta.env.VITE_CLOUDINARY_API_KEY,
  api_secret: import.meta.env.VITE_CLOUDINARY_API_SECRET,
})

export const uploadToCloudinary = async (file: File, folder: string) => {
  const formData = new FormData()
  formData.append('file', file)
  formData.append('folder', folder)
  formData.append('upload_preset', 'rpw_uploads') // Create preset in dashboard

  const response = await fetch(
    `https://api.cloudinary.com/v1_1/${import.meta.env.VITE_CLOUDINARY_CLOUD_NAME}/image/upload`,
    {
      method: 'POST',
      body: formData,
    }
  )

  return response.json()
}

// Get optimized image URL
export const getCloudinaryUrl = (
  publicId: string,
  transformations?: {
    width?: number
    height?: number
    crop?: 'fill' | 'fit' | 'scale' | 'thumb'
    quality?: 'auto' | number
    format?: 'auto' | 'webp' | 'avif'
  }
) => {
  const baseUrl = `https://res.cloudinary.com/${import.meta.env.VITE_CLOUDINARY_CLOUD_NAME}/image/upload`
  
  const transforms = []
  if (transformations?.width) transforms.push(`w_${transformations.width}`)
  if (transformations?.height) transforms.push(`h_${transformations.height}`)
  if (transformations?.crop) transforms.push(`c_${transformations.crop}`)
  if (transformations?.quality) transforms.push(`q_${transformations.quality}`)
  if (transformations?.format) transforms.push(`f_${transformations.format}`)
  
  const transformString = transforms.length > 0 ? transforms.join(',') + '/' : ''
  
  return `${baseUrl}/${transformString}${publicId}`
}
```

#### Usage in Component
```vue
<template>
  <img 
    :src="getCloudinaryUrl('hero/carousel-1', { 
      width: 1920, 
      height: 1080, 
      quality: 'auto',
      format: 'auto'
    })" 
    alt="Hero Image"
  >
</template>

<script setup lang="ts">
import { getCloudinaryUrl } from '@/lib/cloudinary'
</script>
```

#### Supabase Integration
```typescript
// Store only Cloudinary public_id in Supabase
// Instead of full path, save: "hero/carousel-1"

// In your API service
export const getHeroSlides = async () => {
  const { data, error } = await supabase
    .from('hero_slides')
    .select('*')
  
  if (error) throw error
  
  // Transform Cloudinary IDs to full URLs
  return data.map(slide => ({
    ...slide,
    background_image: getCloudinaryUrl(slide.background_image, {
      width: 1920,
      height: 1080,
      quality: 'auto',
      format: 'auto'
    })
  }))
}
```

---

## 3. Cloudflare R2

### ✅ Pros
- **No egress fees** (unlimited bandwidth for free!)
- **S3-compatible API** (easy migration)
- **Very fast** (Cloudflare's global network)
- **Cheap storage** ($0.015/GB)
- **10GB free storage**

### ❌ Cons
- No automatic image optimization
- Requires Cloudflare Workers for transformations
- More complex setup

### 💰 Pricing
- **Free:** 10GB storage
- **Storage:** $0.015/GB/month
- **Operations:** $4.50/million Class A, $0.36/million Class B
- **Egress:** FREE (huge advantage!)

### 📝 When to Use
- High bandwidth usage
- Need S3 compatibility
- Cost-sensitive project
- Already using Cloudflare

### 🔧 Implementation

#### Install SDK
```bash
npm install @aws-sdk/client-s3
```

#### Setup
```typescript
// src/lib/r2.ts
import { S3Client, PutObjectCommand, GetObjectCommand } from '@aws-sdk/client-s3'
import { getSignedUrl } from '@aws-sdk/s3-request-presigner'

const r2 = new S3Client({
  region: 'auto',
  endpoint: import.meta.env.VITE_R2_ENDPOINT, // https://xxx.r2.cloudflarestorage.com
  credentials: {
    accessKeyId: import.meta.env.VITE_R2_ACCESS_KEY_ID,
    secretAccessKey: import.meta.env.VITE_R2_SECRET_ACCESS_KEY,
  },
})

export const uploadToR2 = async (file: File, key: string) => {
  const command = new PutObjectCommand({
    Bucket: import.meta.env.VITE_R2_BUCKET_NAME,
    Key: key,
    Body: file,
    ContentType: file.type,
  })

  await r2.send(command)
  
  // Return public URL (if bucket is public)
  return `https://cdn.rpwadvocates.com/${key}`
}

export const getR2Url = (key: string) => {
  return `https://cdn.rpwadvocates.com/${key}`
}
```

#### Cloudflare Worker for Image Resizing
```javascript
// worker.js
export default {
  async fetch(request, env) {
    const url = new URL(request.url)
    const key = url.pathname.slice(1)
    
    // Get query params for transformations
    const width = url.searchParams.get('w')
    const height = url.searchParams.get('h')
    const quality = url.searchParams.get('q') || '85'
    
    // Fetch from R2
    const object = await env.MY_BUCKET.get(key)
    
    if (!object) {
      return new Response('Not Found', { status: 404 })
    }
    
    // Use Cloudflare Image Resizing
    const resizeUrl = new URL(request.url)
    resizeUrl.pathname = '/cdn-cgi/image/' + 
      `width=${width},height=${height},quality=${quality},format=auto/${key}`
    
    return fetch(resizeUrl)
  }
}
```

---

## 4. ImageKit

### ✅ Pros
- **Real-time image optimization**
- **Global CDN** (6 regions)
- **Generous free tier** (20GB bandwidth)
- **Easy integration**
- **Video optimization**
- **Faster than Cloudinary** (in some cases)

### ❌ Cons
- Smaller company than Cloudinary
- Less features than Cloudinary
- Limited video support on free tier

### 💰 Pricing
- **Free:** 20GB bandwidth/month
- **Starter:** $49/month (100GB bandwidth)
- **Scale:** $149/month (500GB bandwidth)

### 📝 When to Use
- Need image optimization
- Budget-conscious
- Faster alternative to Cloudinary

### 🔧 Implementation

#### Install SDK
```bash
npm install imagekit
```

#### Setup
```typescript
// src/lib/imagekit.ts
import ImageKit from 'imagekit-javascript'

const imagekit = new ImageKit({
  publicKey: import.meta.env.VITE_IMAGEKIT_PUBLIC_KEY,
  urlEndpoint: import.meta.env.VITE_IMAGEKIT_URL_ENDPOINT,
})

export const getImageKitUrl = (
  path: string,
  transformations?: {
    width?: number
    height?: number
    quality?: number
    format?: string
  }
) => {
  return imagekit.url({
    path: path,
    transformation: [
      {
        width: transformations?.width?.toString(),
        height: transformations?.height?.toString(),
        quality: transformations?.quality?.toString(),
        format: transformations?.format,
      }
    ],
  })
}
```

#### Usage
```vue
<img 
  :src="getImageKitUrl('/hero/carousel-1.jpg', { 
    width: 1920, 
    quality: 80,
    format: 'webp'
  })" 
  alt="Hero"
>
```

---

## 5. Bunny CDN Storage

### ✅ Pros
- **Extremely cheap** ($0.01/GB storage + $0.01/GB bandwidth)
- **Very fast CDN** (global network)
- **Simple API**
- **Good for any file type**
- **No minimum commitment**

### ❌ Cons
- No automatic image optimization
- Requires integration work
- Smaller company

### 💰 Pricing
- **Storage:** $0.01/GB/month
- **Bandwidth:** $0.01-0.03/GB (depends on region)
- **No free tier** (but very cheap!)

### 📝 When to Use
- Budget is critical
- High storage/bandwidth needs
- Don't need auto-optimization

### 🔧 Implementation

#### Setup
```typescript
// src/lib/bunny.ts
const BUNNY_STORAGE_ZONE = import.meta.env.VITE_BUNNY_STORAGE_ZONE
const BUNNY_ACCESS_KEY = import.meta.env.VITE_BUNNY_ACCESS_KEY
const BUNNY_CDN_URL = import.meta.env.VITE_BUNNY_CDN_URL

export const uploadToBunny = async (file: File, path: string) => {
  const response = await fetch(
    `https://storage.bunnycdn.com/${BUNNY_STORAGE_ZONE}/${path}`,
    {
      method: 'PUT',
      headers: {
        'AccessKey': BUNNY_ACCESS_KEY,
        'Content-Type': file.type,
      },
      body: file,
    }
  )

  if (!response.ok) throw new Error('Upload failed')

  return `${BUNNY_CDN_URL}/${path}`
}

export const getBunnyUrl = (path: string) => {
  return `${BUNNY_CDN_URL}/${path}`
}
```

---

## 6. Vercel Blob Storage

### ✅ Pros
- **Integrated with Vercel**
- **Edge network** (very fast)
- **Simple API**
- **Good for Vercel deployments**

### ❌ Cons
- Expensive ($0.15/GB)
- Only 500MB free
- Tied to Vercel platform

### 💰 Pricing
- **Free:** 500MB
- **Storage:** $0.15/GB/month
- **Bandwidth:** $0.30/GB

### 📝 When to Use
- Already using Vercel
- Small storage needs
- Want simplicity

### 🔧 Implementation

```bash
npm install @vercel/blob
```

```typescript
import { put, list } from '@vercel/blob'

export const uploadToVercel = async (file: File, pathname: string) => {
  const blob = await put(pathname, file, {
    access: 'public',
  })

  return blob.url
}
```

---

## 7. AWS S3 + CloudFront

### ✅ Pros
- **Industry standard**
- **Extremely reliable** (99.999999999% durability)
- **Flexible**
- **Integrates with everything**

### ❌ Cons
- Complex setup
- Can be expensive
- Requires AWS knowledge
- No auto-optimization (need Lambda@Edge)

### 💰 Pricing
- **S3 Storage:** $0.023/GB/month
- **CloudFront:** $0.085/GB (first 10TB)
- **Requests:** Variable

### 📝 When to Use
- Enterprise project
- Already using AWS
- Need maximum control
- Compliance requirements

---

## 🎯 Hybrid Approach

### Best of Both Worlds

Combine different solutions for different use cases:

```typescript
// src/lib/storage.ts
export enum StorageProvider {
  CLOUDINARY = 'cloudinary',
  R2 = 'r2',
  SUPABASE = 'supabase',
}

const storageConfig = {
  // User-uploaded images → Cloudinary (auto-optimization)
  userUploads: StorageProvider.CLOUDINARY,
  
  // Static assets (logos, icons) → R2 (cheap, fast)
  staticAssets: StorageProvider.R2,
  
  // Large files, documents → Supabase (integrated)
  documents: StorageProvider.SUPABASE,
}

export const uploadFile = async (
  file: File,
  type: keyof typeof storageConfig
) => {
  const provider = storageConfig[type]
  
  switch (provider) {
    case StorageProvider.CLOUDINARY:
      return uploadToCloudinary(file, type)
    case StorageProvider.R2:
      return uploadToR2(file, type)
    case StorageProvider.SUPABASE:
      return uploadToSupabase(file, type)
  }
}
```

### Use Case Mapping

| File Type | Provider | Why |
|-----------|----------|-----|
| Hero images | Cloudinary | Auto-optimization, transformations |
| Blog images | Cloudinary | Auto-optimization, transformations |
| Team photos | Cloudinary | Auto-optimization, transformations |
| Logos/Icons | R2 | Static, rarely change, no egress fees |
| Documents/PDFs | Supabase | Integrated auth, RLS policies |
| Video files | Cloudinary/R2 | Depends on need for transcoding |

---

## 💡 Rekomendasi

### 🥇 Best Overall: **Cloudinary**
**Ideal untuk:** Small to medium law firm website

**Why:**
- ✅ Generous free tier (25GB/month)
- ✅ Automatic optimization (WebP, AVIF)
- ✅ On-the-fly transformations
- ✅ Fast global CDN
- ✅ Easy integration
- ✅ Future-proof (scales easily)

**Implementation:**
```typescript
// Minimal setup needed
const imageUrl = getCloudinaryUrl('hero/carousel-1', {
  width: 1920,
  quality: 'auto',
  format: 'auto' // Serves WebP to modern browsers
})
```

**Cost estimate:**
- 1000 images × 500KB = 500MB storage
- 10,000 views/month × 200KB (optimized) = 2GB bandwidth
- **Total: FREE** (within 25GB limit)

---

### 🥈 Best Budget: **Cloudflare R2 + Workers**
**Ideal untuk:** High-traffic sites with budget constraint

**Why:**
- ✅ No bandwidth fees (huge savings)
- ✅ Very cheap storage ($0.015/GB)
- ✅ S3-compatible
- ✅ Cloudflare's fast network
- ✅ Can add image optimization with Workers

**Cost estimate:**
- 10GB storage = $0.15/month
- Unlimited bandwidth = $0
- Workers: 100,000 requests free/day
- **Total: ~$0.15-5/month**

---

### 🥉 Best Integrated: **Keep Supabase Storage**
**Ideal untuk:** MVP, prototype, low-traffic sites

**Why:**
- ✅ Already set up
- ✅ Integrated with your database
- ✅ RLS policies work
- ✅ Simple API
- ✅ Good enough for most cases

**When to upgrade:**
- Traffic exceeds 1GB/month
- Need image optimization
- Want faster load times
- Budget allows

---

## 🚀 Migration Guide

### From Supabase → Cloudinary

#### Step 1: Setup Cloudinary
```bash
npm install cloudinary
```

#### Step 2: Migrate Existing Images
```typescript
// scripts/migrate-to-cloudinary.ts
import { supabase } from '@/lib/supabase'
import { uploadToCloudinary } from '@/lib/cloudinary'

async function migrateImages() {
  // Get all image references from database
  const { data: slides } = await supabase.from('hero_slides').select('*')
  
  for (const slide of slides) {
    // Download from Supabase
    const { data: file } = await supabase.storage
      .from('images')
      .download(slide.background_image)
    
    // Upload to Cloudinary
    const result = await uploadToCloudinary(
      new File([file], slide.background_image),
      'hero'
    )
    
    // Update database with Cloudinary public_id
    await supabase
      .from('hero_slides')
      .update({ background_image: result.public_id })
      .eq('id', slide.id)
    
    console.log(`Migrated: ${slide.background_image} → ${result.public_id}`)
  }
}
```

#### Step 3: Update Code
```typescript
// Before (Supabase)
const url = supabase.storage.from('images').getPublicUrl(path).data.publicUrl

// After (Cloudinary)
const url = getCloudinaryUrl(publicId, { width: 800, quality: 'auto' })
```

---

## 📊 Cost Comparison (Real Example)

### Scenario: Law Firm Website
- 500 images (avg 800KB each = 400MB)
- 50,000 page views/month
- 3 images per page = 150,000 image requests
- Avg image size after optimization: 150KB
- Total bandwidth: 150,000 × 150KB = ~22GB

### Monthly Costs:

| Provider | Storage | Bandwidth | Total | Notes |
|----------|---------|-----------|-------|-------|
| **Cloudinary** | FREE | FREE | **$0** | Within free tier! |
| **Cloudflare R2** | $0.006 | $0 | **$0.006** | No egress fees |
| **ImageKit** | FREE | FREE | **$0** | Within free tier |
| **Bunny CDN** | $0.004 | $0.22 | **$0.224** | Super cheap |
| **Supabase** | $0.008 | ~$20 | **$20** | Over bandwidth limit |
| **Vercel Blob** | $0.06 | $6.60 | **$6.66** | Expensive |
| **AWS S3+CF** | $0.009 | $1.87 | **$1.88** | + complexity |

### 🏆 Winner: **Cloudinary** (FREE + auto-optimization!)

---

## ✅ Implementation Checklist

### Quick Start (Cloudinary)
- [ ] Sign up at cloudinary.com
- [ ] Get API credentials
- [ ] Install SDK: `npm install cloudinary`
- [ ] Configure environment variables
- [ ] Create upload preset in dashboard
- [ ] Update image URLs in database
- [ ] Test image transformations
- [ ] Monitor usage in dashboard

### Optimization Tips
- [ ] Use `quality: 'auto'` for automatic quality adjustment
- [ ] Use `format: 'auto'` to serve WebP/AVIF
- [ ] Set proper width/height for responsive images
- [ ] Enable lazy loading
- [ ] Use blur placeholders (LQIP)
- [ ] Set up proper caching headers
- [ ] Monitor Core Web Vitals

---

## 🔗 Resources

### Cloudinary
- [Documentation](https://cloudinary.com/documentation)
- [Vue Integration](https://cloudinary.com/documentation/vue_integration)
- [Image Transformations](https://cloudinary.com/documentation/image_transformations)
- [Pricing Calculator](https://cloudinary.com/pricing)

### Cloudflare R2
- [Documentation](https://developers.cloudflare.com/r2/)
- [S3 Compatibility](https://developers.cloudflare.com/r2/api/s3/)
- [Workers Integration](https://developers.cloudflare.com/r2/examples/)

### ImageKit
- [Documentation](https://docs.imagekit.io/)
- [Vue SDK](https://github.com/imagekit-developer/imagekit-vuejs)
- [Pricing](https://imagekit.io/pricing)

---

## 🎯 Final Recommendation

### For Your Law Firm Website:

**Use Cloudinary** because:

1. **Free for your traffic** (25GB free tier)
2. **Automatic optimization** (WebP, AVIF, quality)
3. **Responsive images** (on-the-fly resizing)
4. **Fast CDN** (global delivery)
5. **Easy to implement** (minimal code changes)
6. **Future-proof** (scales as you grow)

### Implementation Priority:

1. **Week 1:** Set up Cloudinary account, get credentials
2. **Week 2:** Migrate hero images (most important)
3. **Week 3:** Migrate blog images
4. **Week 4:** Migrate team photos
5. **Week 5:** Test & optimize

### Budget for Growth:

- **Now (0-10K visitors/month):** FREE (Cloudinary)
- **Later (10-50K visitors/month):** Still FREE or $89/month
- **Scale (50K+ visitors/month):** $89-224/month

**ROI:** Faster load times = better SEO = more clients = $$$ 💰

---

**Last Updated:** January 12, 2026  
**Version:** 1.0  
**Recommended:** Cloudinary for optimal efficiency
