<template>
  <div class="about-page">
    <!-- Page Header Start -->
    <div class="container-fluid page-header d-flex flex-column align-items-center justify-content-center pt-0 pt-lg-5 mb-5">
      <h1 class="display-4 text-white mb-3 mt-0 mt-lg-5">About Us</h1>
      <div class="d-inline-flex text-white">
        <p class="m-0">
          <router-link class="text-white" to="/">Home</router-link>
        </p>
        <p class="m-0 px-2">/</p>
        <p class="m-0">About Us</p>
      </div>
    </div>
    <!-- Page Header End -->

    <!-- About Content Start -->
    <div class="container py-5">
      <section data-aos="fade-right" data-aos-duration="1000" data-aos-easing="ease-in-sine" id="about">
        <div class="container-fluid py-5">
          <div class="container">
            <div class="row align-items-center pb-1">
              <div data-aos="fade-left" data-aos-duration="1000" class="col-lg-7 mt-5 mt-lg-0">
                <h1 class="mt-2 mb-3">About Our Firm</h1>
                <h4>{{ content.firmName }}</h4>
                <p class="mb-4">
                  {{ content.description.paragraph1 }}
                  <br><br>
                  {{ content.description.paragraph2 }}
                </p>
              </div>
              <div data-aos="fade-right" data-aos-duration="1000" class="col-lg-5 border-0">
                <img class="img-thumbnail border-0 h-100" src="/img/about.png" alt="About">
              </div>
            </div>
            <div data-aos="fade-right" class="row mt-4">
              <div v-for="(contact, index) in content.contacts" :key="index" class="col-md-4">
                <div class="card border-0">
                  <div class="card-header bg-transparent border-0">
                    <h5 class="font-weight-bold">{{ contact.title }}</h5>
                  </div>
                  <div class="card-body d-flex align-items-center">
                    <i :class="contact.icon"></i>
                    <div class="d-flex flex-column">
                      <p class="m-0">{{ contact.value }}</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
    <!-- About Content End -->
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, computed } from 'vue';
import { useSEO, seoConfigs } from '@/composables/useSEO';
import { useSettings } from '@/composables/useSettings';

interface ContactCard {
  title: string;
  icon: string;
  value: string;
}

export default defineComponent({
  name: 'About',
  setup() {
    // SEO Meta Tags
    useSEO(seoConfigs.about);

    // Load settings
    const { settings, loadSettings } = useSettings();

    onMounted(() => {
      loadSettings();
    });

    // Page Content - dynamically use settings data
    const content = computed(() => {
      const contacts: ContactCard[] = [];
      
      if (settings.value?.contact_email) {
        contacts.push({
          title: 'Email',
          icon: 'fa fa-2x fa-envelope-open text-primary mr-3',
          value: settings.value.contact_email
        });
      }
      
      if (settings.value?.contact_phone) {
        contacts.push({
          title: 'Phone',
          icon: 'fa fa-2x fa-phone-alt text-primary mr-3',
          value: settings.value.contact_phone
        });
      }
      
      if (settings.value?.contact_address) {
        contacts.push({
          title: 'Office',
          icon: 'fas fa-2x fa-building text-primary mr-3',
          value: settings.value.contact_address
        });
      }

      return {
        firmName: settings.value?.site_name || 'R. PRAMA WIJAYA & PARTNERS',
        description: {
          paragraph1: settings.value?.site_description || `Our firm is focused on the results. With exceptional experiences and depth of knowledge, we delivers a practical and objective solutions to solving your legal problems. Our mindset is understanding what your needs and deliver a top notch legal services.`,
          paragraph2: settings.value?.site_tagline || `The firm is committed to provide excellent service to develop a long-term relationship with clients. We believe that our dedication in understanding client's objectives are finding the right approach to achieve those objectives will be a strength point in developing a long-term mutual relationship between the firm and its clients.`
        },
        contacts
      };
    });

    return {
      content
    };
  },
});
</script>

<style scoped>
.about-page {
  min-height: 100vh;
}

.page-header {
  background: linear-gradient(rgba(33, 40, 50, 0.8), rgba(33, 40, 50, 0.8)), url('/img/carousel-1.jpg');
  background-position: center center;
  background-repeat: no-repeat;
  background-size: cover;
}
</style>
