<template>
  <div class="contact-page">
    <!-- Page Header Start -->
    <div class="container-fluid page-header d-flex flex-column align-items-center justify-content-center pt-0 pt-lg-5 mb-5">
      <h1 class="display-4 text-white mb-3 mt-0 mt-lg-5">Contact</h1>
      <div class="d-inline-flex text-white">
        <p class="m-0">
          <router-link class="text-white" to="/">Home</router-link>
        </p>
        <p class="m-0 px-2">/</p>
        <p class="m-0">Contact</p>
      </div>
    </div>
    <!-- Page Header End -->

    <!-- Contact Start -->
    <div class="container-fluid py-5">
      <div class="container">
        <div class="text-center">
          <small class="bg-primary text-white text-uppercase font-weight-bold text-center px-1">{{ pageContent.subtitle }}</small>
          <h1 class="mt-2 mb-5">{{ pageContent.title }}</h1>
        </div>
        <div class="row">
          <div class="col-md-5">
            <div 
              v-for="(contact, index) in pageContent.contactInfo" 
              :key="index"
              class="d-flex align-items-center border p-4"
              :class="index < pageContent.contactInfo.length - 1 ? 'mb-3' : 'mb-3 mb-md-0'"
            >
              <i :class="contact.icon"></i>
              <div class="d-flex flex-column">
                <h5 class="font-weight-bold">{{ contact.title }}</h5>
                <p class="m-0">{{ contact.value }}</p>
              </div>
            </div>
          </div>
          <div class="col-md-7">
            <div class="contact-form">
              <div v-if="formStatus" :class="`alert alert-${formStatus.type}`" role="alert">
                {{ formStatus.message }}
              </div>
              <form @submit.prevent="handleSubmit">
                <div class="form-row">
                  <div class="col-md-6">
                    <div class="control-group">
                      <input 
                        v-model="formData.name"
                        type="text" 
                        class="form-control p-4" 
                        placeholder="Your Name" 
                        required
                      />
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="control-group">
                      <input 
                        v-model="formData.email"
                        type="email" 
                        class="form-control p-4" 
                        placeholder="Your Email" 
                        required
                      />
                    </div>
                  </div>
                </div>
                <div class="control-group">
                  <input 
                    v-model="formData.subject"
                    type="text" 
                    class="form-control p-4" 
                    placeholder="Subject" 
                    required
                  />
                </div>
                <div class="control-group">
                  <textarea 
                    v-model="formData.message"
                    class="form-control" 
                    rows="5" 
                    placeholder="Message" 
                    required
                  ></textarea>
                </div>
                <div>
                  <button 
                    class="btn btn-primary font-weight-semi-bold px-4" 
                    style="height: 50px;" 
                    type="submit"
                    :disabled="isSubmitting"
                  >
                    {{ isSubmitting ? 'Sending...' : 'Send Message' }}
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Contact End -->
  </div>
</template>

<script lang="ts">
import { defineComponent, reactive, ref, onMounted, computed } from 'vue';
import { useSEO, seoConfigs } from '@/composables/useSEO';
import { supabase } from '@/lib/supabase';
import { useSettings } from '@/composables/useSettings';

interface FormData {
  name: string;
  email: string;
  subject: string;
  message: string;
}

interface FormStatus {
  type: 'success' | 'danger';
  message: string;
}

interface ContactInfo {
  icon: string;
  title: string;
  value: string;
}

export default defineComponent({
  name: 'Contact',
  setup() {
    // SEO Meta Tags
    useSEO(seoConfigs.contact);

    // Load settings
    const { settings, loadSettings } = useSettings();

    onMounted(() => {
      loadSettings();
    });

    // Page Content - dynamically use settings data
    const pageContent = computed(() => {
      const contactInfo: ContactInfo[] = [];
      
      if (settings.value?.contact_address) {
        contactInfo.push({
          icon: 'fa fa-2x fa-map-marker-alt text-primary mr-3',
          title: 'Our Office',
          value: settings.value.contact_address
        });
      }
      
      if (settings.value?.contact_email) {
        contactInfo.push({
          icon: 'fa fa-2x fa-envelope-open text-primary mr-3',
          title: 'Email Us',
          value: settings.value.contact_email
        });
      }
      
      if (settings.value?.contact_phone) {
        contactInfo.push({
          icon: 'fas fa-2x fa-phone-alt text-primary mr-3',
          title: 'Call Us',
          value: settings.value.contact_phone
        });
      }

      if (settings.value?.contact_whatsapp) {
        contactInfo.push({
          icon: 'fab fa-2x fa-whatsapp text-primary mr-3',
          title: 'WhatsApp',
          value: settings.value.contact_whatsapp
        });
      }
      
      return {
        title: 'Contact For Any Queries',
        subtitle: 'Get In Touch',
        contactInfo
      };
    });
    const formData = reactive<FormData>({
      name: '',
      email: '',
      subject: '',
      message: '',
    });

    const formStatus = ref<FormStatus | null>(null);
    const isSubmitting = ref(false);

    const handleSubmit = async () => {
      isSubmitting.value = true;
      formStatus.value = null;

      try {
        // Submit to Supabase contact_submissions table
        const { error } = await supabase
          .from('contact_submissions')
          .insert([
            {
              name: formData.name,
              email: formData.email,
              subject: formData.subject,
              message: formData.message,
              status: 'new',
            },
          ]);
        
        if (error) throw error;
        
        formStatus.value = {
          type: 'success',
          message: 'Your message has been sent successfully! We will get back to you soon.',
        };
        
        // Reset form
        formData.name = '';
        formData.email = '';
        formData.subject = '';
        formData.message = '';
      } catch (error) {
        console.error('Error submitting contact form:', error);
        formStatus.value = {
          type: 'danger',
          message: 'Failed to send message. Please try again later.',
        };
      } finally {
        isSubmitting.value = false;
      }
    };

    return {
      pageContent,
      formData,
      formStatus,
      isSubmitting,
      handleSubmit,
    };
  },
});
</script>

<style scoped>
.contact-page {
  min-height: 100vh;
}

.page-header {
  background: linear-gradient(rgba(33, 40, 50, 0.8), rgba(33, 40, 50, 0.8)), url('/img/about.png');
  background-position: center center;
  background-repeat: no-repeat;
  background-size: cover;
}

.control-group {
  margin-bottom: 1rem;
}
</style>
