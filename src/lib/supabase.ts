import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables. Please check your .env file.')
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Auth helpers
export const signIn = async (email: string, password: string) => {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })
  return { data, error }
}

export const signOut = async () => {
  const { error } = await supabase.auth.signOut()
  return { error }
}

export const getCurrentUser = async () => {
  const { data: { user }, error } = await supabase.auth.getUser()
  return { user, error }
}

export const checkSession = async () => {
  const { data: { session }, error } = await supabase.auth.getSession()
  return { session, error }
}

// Storage helpers
export const getImageUrl = (path: string, bucket = 'images') => {
  const { data } = supabase.storage.from(bucket).getPublicUrl(path)
  return data.publicUrl
}

export const uploadImage = async (file: File, path: string, bucket = 'images') => {
  const { data, error } = await supabase.storage
    .from(bucket)
    .upload(path, file, {
      cacheControl: '3600',
      upsert: false,
    })
  
  if (error) throw error
  return { data, url: getImageUrl(data.path, bucket) }
}

export const deleteImage = async (path: string, bucket = 'images') => {
  const { error } = await supabase.storage.from(bucket).remove([path])
  return { error }
}

// TypeScript types
export type Database = {
  public: {
    Tables: {
      hero_slides: {
        Row: {
          id: string
          title: string
          subtitle: string | null
          description: string
          background_image: string
          cta_text: string | null
          cta_link: string | null
          order_position: number
          is_active: boolean
          created_at: string
          updated_at: string
        }
      }
      features: {
        Row: {
          id: string
          icon: string
          title: string
          description: string
          order_position: number
          is_active: boolean
          created_at: string
          updated_at: string
        }
      }
      // Add other table types as needed
    }
  }
}
