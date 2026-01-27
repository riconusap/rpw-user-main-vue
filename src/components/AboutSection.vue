<template>
  <section data-aos="fade-right" data-aos-duration="1000" data-aos-easing="ease-in-sine" id="about">
    <div class="container-fluid py-5">
      <div class="container">
        <div class="row align-items-center pb-1">
          <div data-aos="fade-right" data-aos-duration="1000" class="col-lg-5 border-0">
            <img class="img-thumbnail border-0 h-100" src="/img/about.png" alt="About Our Firm" />
          </div>
          <div data-aos="fade-left" data-aos-duration="1000" class="col-lg-7 mt-5 mt-lg-0">
            <h1 class="mt-2 mb-3">About Our Firm</h1>
            <h4>{{ settings?.site_name || 'R. PRAMA WIJAWA & PARTNERS' }}</h4>
            
            <p class="mb-4 text-justify" v-if="settings?.site_description" v-html="settings.site_description">
            </p>
            <p class="mb-4 text-justify" v-else>
              Our firm is focused on the results. With exceptional experiences and depth of knowledge, we delivers a
              practical and objective solutions to solving your legal problems. Our mindset is understanding what your
              needs and deliver a top notch legal services.
              <br />
              The firm is committed to provide excellent service to develop a long-term relationship with clients. We
              believe that our dedication in understanding client's objectives are finding the right approach to achieve
              those objectives will be a strength point in developing a long-term mutual relationship between the firm
              and its clients.
            </p>
            <RouterLink to="/about" class="btn btn-primary py-md-2 px-md-4 font-weight-semi-bold">
              Read More
            </RouterLink>
          </div>
        </div>
        <!-- <div data-aos="fade-right" class="row mt-4">
          <div v-if="settings?.contact_email" class="col-md-4">
            <div class="card border-0">
              <div class="card-header bg-transparent border-0">
                <h5 class="font-weight-bold">Email</h5>
              </div>
              <div class="card-body d-flex align-items-center">
                <i class="fa fa-2x fa-envelope-open text-primary mr-3"></i>
                <div class="d-flex flex-column">
                  <p class="m-0">
                    <a :href="`mailto:${settings.contact_email}`" class="text-dark">
                      {{ settings.contact_email }}
                    </a>
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div v-if="settings?.contact_phone" class="col-md-4">
            <div class="card border-0">
              <div class="card-header bg-transparent border-0">
                <h5 class="font-weight-bold">Phone</h5>
              </div>
              <div class="card-body d-flex align-items-center">
                <i class="fa fa-2x fa-phone-alt text-primary mr-3"></i>
                <div class="d-flex flex-column">
                  <p class="m-0">
                    <a :href="`tel:${settings.contact_phone}`" class="text-dark">
                      {{ settings.contact_phone }}
                    </a>
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div v-if="settings?.contact_address" class="col-md-4">
            <div class="card border-0">
              <div class="card-header bg-transparent border-0">
                <h5 class="font-weight-bold">Office</h5>
              </div>
              <div class="card-body d-flex align-items-center">
                <i class="fas fa-2x fa-building text-primary mr-3"></i>
                <div class="d-flex flex-column">
                  <p class="m-0">{{ settings.contact_address }}</p>
                </div>
              </div>
            </div>
          </div>
        </div> -->
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, onMounted } from 'vue';
import { useSettings } from '@/composables/useSettings';

export default defineComponent({
  name: 'AboutSection',
  setup() {
    const { settings, loadSettings } = useSettings();

    onMounted(() => {
      loadSettings();
    });

    return {
      settings,
    };
  },
});
</script>

<style scoped>
/* Component-specific styles if needed */
</style>
