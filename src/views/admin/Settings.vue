<template>
  <div class="settings-page">
    <div class="page-header-admin">
      <div>
        <h1>Settings</h1>
        <p class="subtitle">Configure your website settings</p>
      </div>
      <button @click="saveAllSettings" class="btn btn-primary" :disabled="saving">
        <i class="fas fa-save"></i>
        {{ saving ? 'Saving...' : 'Save All Changes' }}
      </button>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="loading">
      <i class="fas fa-spinner fa-spin"></i> Loading settings...
    </div>

    <div v-else class="settings-sections">
      <!-- Site Configuration -->
      <div class="settings-section">
        <div class="section-header">
          <div class="section-icon">
            <i class="fas fa-cog"></i>
          </div>
          <div>
            <h2>Site Configuration</h2>
            <p>Manage site name, tagline, and branding</p>
          </div>
        </div>

        <div class="section-content">
          <div class="form-row">
            <div class="form-group">
              <label for="site_name">Site Name *</label>
              <input
                id="site_name"
                v-model="settings.site_name"
                type="text"
                class="form-control"
                placeholder="R. Prama Wijaya Law Firm"
              />
            </div>

            <div class="form-group">
              <label for="site_tagline">Tagline</label>
              <input
                id="site_tagline"
                v-model="settings.site_tagline"
                type="text"
                class="form-control"
                placeholder="Committed to Excellence"
              />
            </div>
          </div>

          <div class="form-group">
            <label for="site_description">Site Description</label>
            <textarea
              id="site_description"
              v-model="settings.site_description"
              class="form-control"
              rows="3"
              placeholder="Brief description of your law firm..."
            ></textarea>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Logo</label>
              <ImageUpload
                v-model="settings.site_logo"
                :bucket="'images'"
                :folder="'settings'"
                :placeholder="'Upload site logo'"
              />
            </div>

            <div class="form-group">
              <label>Favicon</label>
              <ImageUpload
                v-model="settings.site_favicon"
                :bucket="'images'"
                :folder="'settings'"
                :placeholder="'Upload favicon (32x32px)'"
              />
            </div>
          </div>
        </div>
      </div>

      <!-- Contact Information -->
      <div class="settings-section">
        <div class="section-header">
          <div class="section-icon">
            <i class="fas fa-envelope"></i>
          </div>
          <div>
            <h2>Contact Information</h2>
            <p>Update office address, phone, and email</p>
          </div>
        </div>

        <div class="section-content">
          <div class="form-group">
            <label for="contact_address">Office Address</label>
            <textarea
              id="contact_address"
              v-model="settings.contact_address"
              class="form-control"
              rows="3"
              placeholder="123 Main Street, Jakarta, Indonesia"
            ></textarea>
          </div>
          <div class="form-group">
            <label for="contact_address_secondary">Office Address (Secondary)</label>
            <textarea
              id="contact_address_secondary"
              v-model="settings.contact_address_secondary"
              class="form-control"
              rows="3"
              placeholder="Secondary address, e.g. branch office..."
            ></textarea>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="contact_phone">Phone Number</label>
              <input
                id="contact_phone"
                v-model="settings.contact_phone"
                type="text"
                class="form-control"
                placeholder="+62 21 1234 5678"
              />
            </div>

            <div class="form-group">
              <label for="contact_whatsapp">WhatsApp Number</label>
              <input
                id="contact_whatsapp"
                v-model="settings.contact_whatsapp"
                type="text"
                class="form-control"
                placeholder="+62 812 3456 7890"
              />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="contact_email">Email Address</label>
              <input
                id="contact_email"
                v-model="settings.contact_email"
                type="email"
                class="form-control"
                placeholder="info@rpramawijaya.com"
              />
            </div>

            <div class="form-group">
              <label for="contact_email_secondary">Secondary Email</label>
              <input
                id="contact_email_secondary"
                v-model="settings.contact_email_secondary"
                type="email"
                class="form-control"
                placeholder="support@rpramawijaya.com"
              />
            </div>
          </div>

          <div class="form-group">
            <label for="business_hours">Business Hours</label>
            <textarea
              id="business_hours"
              v-model="settings.business_hours"
              class="form-control"
              rows="3"
              placeholder="Monday - Friday: 9:00 AM - 5:00 PM&#10;Saturday: 9:00 AM - 1:00 PM&#10;Sunday: Closed"
            ></textarea>
          </div>

          <div class="form-group">
            <label for="google_maps_url">Google Maps Embed URL</label>
            <input
              id="google_maps_url"
              v-model="settings.google_maps_url"
              type="url"
              class="form-control"
              placeholder="https://www.google.com/maps/embed?pb=..."
            />
            <small class="form-help">Get embed URL from Google Maps</small>
          </div>
        </div>
      </div>

      <!-- Social Media -->
      <div class="settings-section">
        <div class="section-header">
          <div class="section-icon">
            <i class="fas fa-share-alt"></i>
          </div>
          <div>
            <h2>Social Media Links</h2>
            <p>Add your social media profiles</p>
          </div>
        </div>

        <div class="section-content">
          <div class="form-row">
            <div class="form-group">
              <label for="social_facebook">
                <i class="fab fa-facebook"></i> Facebook
              </label>
              <input
                id="social_facebook"
                v-model="settings.social_facebook"
                type="url"
                class="form-control"
                placeholder="https://facebook.com/yourpage"
              />
            </div>

            <div class="form-group">
              <label for="social_twitter">
                <i class="fab fa-twitter"></i> Twitter
              </label>
              <input
                id="social_twitter"
                v-model="settings.social_twitter"
                type="url"
                class="form-control"
                placeholder="https://twitter.com/yourhandle"
              />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="social_instagram">
                <i class="fab fa-instagram"></i> Instagram
              </label>
              <input
                id="social_instagram"
                v-model="settings.social_instagram"
                type="url"
                class="form-control"
                placeholder="https://instagram.com/yourhandle"
              />
            </div>

            <div class="form-group">
              <label for="social_linkedin">
                <i class="fab fa-linkedin"></i> LinkedIn
              </label>
              <input
                id="social_linkedin"
                v-model="settings.social_linkedin"
                type="url"
                class="form-control"
                placeholder="https://linkedin.com/company/yourcompany"
              />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="social_youtube">
                <i class="fab fa-youtube"></i> YouTube
              </label>
              <input
                id="social_youtube"
                v-model="settings.social_youtube"
                type="url"
                class="form-control"
                placeholder="https://youtube.com/@yourchannel"
              />
            </div>

            <div class="form-group">
              <label for="social_tiktok">
                <i class="fab fa-tiktok"></i> TikTok
              </label>
              <input
                id="social_tiktok"
                v-model="settings.social_tiktok"
                type="url"
                class="form-control"
                placeholder="https://tiktok.com/@yourhandle"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted } from 'vue';
import { supabase } from '@/lib/supabase';
import ImageUpload from '@/components/ImageUpload.vue';

interface Settings {
  // Site Configuration
  site_name: string;
  site_tagline: string;
  site_description: string;
  site_logo: string;
  site_favicon: string;
  
  // Contact Information
  contact_address: string;
  contact_phone: string;
  contact_whatsapp: string;
  contact_email: string;
  contact_email_secondary: string;
  business_hours: string;
  google_maps_url: string;
  
  // Social Media
  social_facebook: string;
  social_twitter: string;
  social_instagram: string;
  social_linkedin: string;
  social_youtube: string;
  social_tiktok: string;
}

export default defineComponent({
  name: 'AdminSettings',
  components: {
    ImageUpload,
  },
  setup() {
    const loading = ref(false);
    const saving = ref(false);

    const settings = reactive<Settings>({
      site_name: '',
      site_tagline: '',
      site_description: '',
      site_logo: '',
      site_favicon: '',
      contact_address: '',
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
    });

    const loadSettings = async () => {
      loading.value = true;
      try {
        const { data, error } = await supabase
          .from('site_settings')
          .select('*')
          .single();

        if (error && error.code !== 'PGRST116') {
          throw error;
        }

        if (data) {
          Object.assign(settings, data);
        }
      } catch (error: any) {
        console.error('Error loading settings:', error.message);
      } finally {
        loading.value = false;
      }
    };

    const saveAllSettings = async () => {
      saving.value = true;
      try {
        // Check if settings exist
        const { data: existing } = await supabase
          .from('site_settings')
          .select('id')
          .single();

        if (existing) {
          // Update existing settings
          const { error } = await supabase
            .from('site_settings')
            .update(settings)
            .eq('id', existing.id);

          if (error) throw error;
        } else {
          // Insert new settings
          const { error } = await supabase
            .from('site_settings')
            .insert([settings]);

          if (error) throw error;
        }

        alert('Settings saved successfully!');
      } catch (error: any) {
        alert('Error saving settings: ' + error.message);
      } finally {
        saving.value = false;
      }
    };

    onMounted(() => {
      loadSettings();
    });

    return {
      loading,
      saving,
      settings,
      saveAllSettings,
    };
  },
});
</script>

<style scoped>
.settings-page {
  max-width: 1200px;
}

.page-header-admin {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 2rem;
  gap: 1rem;
  flex-wrap: wrap;
}

.page-header-admin h1 {
  font-size: 2rem;
  color: #1e293b;
  margin: 0 0 0.5rem 0;
}

.subtitle {
  color: #64748b;
  margin: 0;
}

.btn {
  padding: 0.75rem 1.5rem;
  border-radius: 10px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  border: none;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  white-space: nowrap;
}

.btn-primary {
  background: #d4a948;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background: #c69840;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.loading {
  text-align: center;
  padding: 3rem;
  color: #64748b;
}

.settings-sections {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.settings-section {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  border: 1px solid #f1f5f9;
}

.section-header {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  padding: 2rem;
  background: linear-gradient(135deg, #fafafa 0%, #f5f5f5 100%);
  border-bottom: 1px solid #e5e7eb;
}

.section-icon {
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, #d4a948 0%, #c69840 100%);
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  box-shadow: 0 4px 12px rgba(212, 169, 72, 0.3);
}

.section-icon i {
  font-size: 1.75rem;
  color: white;
}

.section-header h2 {
  font-size: 1.5rem;
  color: #1e293b;
  margin: 0 0 0.25rem 0;
  font-weight: 700;
}

.section-header p {
  color: #64748b;
  margin: 0;
  font-size: 0.875rem;
}

.section-content {
  padding: 2rem;
}

.form-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-bottom: 1.5rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group:last-child {
  margin-bottom: 0;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #1e293b;
  font-size: 0.875rem;
}

.form-group label i {
  margin-right: 0.5rem;
  width: 20px;
  text-align: center;
}

.form-control {
  width: 100%;
  padding: 0.75rem;
  border: 2px solid #e2e8f0;
  border-radius: 10px;
  font-size: 1rem;
  transition: all 0.2s ease;
  background: white;
}

.form-control:hover {
  border-color: #cbd5e1;
}

.form-control:focus {
  outline: none;
  border-color: #d4a948;
  box-shadow: 0 0 0 3px rgba(212, 169, 72, 0.1);
}

.form-control::placeholder {
  color: #94a3b8;
}

.form-help {
  display: block;
  margin-top: 0.5rem;
  color: #64748b;
  font-size: 0.8rem;
}

@media (max-width: 768px) {
  .page-header-admin {
    flex-direction: column;
    align-items: stretch;
  }

  .btn {
    width: 100%;
    justify-content: center;
  }

  .form-row {
    grid-template-columns: 1fr;
  }

  .section-header {
    flex-direction: column;
    text-align: center;
  }
}
.settings-card p {
  color: #64748b;
  font-size: 0.875rem;
  line-height: 1.6;
}
</style>
