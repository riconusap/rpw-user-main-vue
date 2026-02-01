import { ref } from 'vue'
import { supabase } from '@/lib/supabase'

interface SiteSettings {
  id?: string
  site_name: string
  site_tagline: string
  site_description: string
  site_logo: string
  site_favicon: string
  contact_address: string
  contact_address_secondary?: string
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
const error = ref<string | null>(null)

export const useSettings = () => {
  const loadSettings = async () => {
    // Return cached settings if already loaded
    if (settings.value) return settings.value
    
    loading.value = true
    error.value = null
    
    try {
      const { data, error: fetchError } = await supabase
        .from('site_settings')
        .select('*')
        .single()

      if (fetchError) throw fetchError
      
      settings.value = data
      return data
    } catch (err: any) {
      error.value = err.message
      console.error('Error loading settings:', err)
      
      // Return default settings on error
      return {
        site_name: 'R. Prama Wijaya Law Firm',
        site_tagline: 'Committed to Excellence',
        site_description: '',
        site_logo: '',
        site_favicon: '',
        contact_address: '',
        contact_address_secondary: '',
        contact_phone: '',
        contact_whatsapp: '',
        contact_email: '',
        contact_email_secondary: '',
        business_hours: '',
        google_maps_url: '',
        social_facebook: '',
        social_twitter: '',
        social_instagram: '',
        social_linkedin: '',
        social_youtube: '',
        social_tiktok: '',
      }
    } finally {
      loading.value = false
    }
  }

  const refreshSettings = async () => {
    settings.value = null // Clear cache
    return await loadSettings()
  }

  return {
    settings,
    loading,
    error,
    loadSettings,
    refreshSettings,
  }
}
