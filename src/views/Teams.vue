<template>
  <div class="teams-page">
    <!-- Page Header Start -->
    <div class="container-fluid page-header d-flex flex-column align-items-center justify-content-center pt-0 pt-lg-5 mb-5">
      <h1 class="display-4 text-white mb-3 mt-0 mt-lg-5">Our Attorney</h1>
      <div class="d-inline-flex text-white">
        <p class="m-0">
          <router-link class="text-white" to="/">Home</router-link>
        </p>
        <p class="m-0 px-2">/</p>
        <p class="m-0">Our People's</p>
      </div>
    </div>
    <!-- Page Header End -->

    <!-- Teams Content Start -->
    <div class="container py-5">
      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-primary" role="status">
          <span class="sr-only">Loading...</span>
        </div>
      </div>
      <div v-else>
        <!-- Founder Section -->
        <div v-if="founder" class="row d-flex align-items-center justify-content-center">
          <div class="col-lg-4">
            <img :src="getImageUrl(founder.photo)" class="w-100 rounded shadow" :alt="founder.name" @error="(e) => (e.target as HTMLImageElement).src = '/img/founder.png'">
          </div>
          <div class="col-lg-8 d-flex flex-column justify-content-around">
            <div class="people-name d-flex flex-column text-center justify-content-center align-items-center">
              <h4>FOUNDER</h4>
              <h4>{{ founder.name }}</h4>
            </div>
            <p>{{ founder.bio }}</p>
          </div>
        </div>

        <!-- Associates Section -->
        <div v-if="associates.length > 0" class="row mt-4">
          <div class="container">
            <div class="row">
              <div class="col-lg-12 mb-5">
                <div ref="teamCarousel" class="owl-carousel team-carousel" data-aos="fade-right" data-aos-duration="2000">
                  <div 
                    v-for="associate in associates" 
                    :key="associate.id" 
                    class="team-item"
                  >
                    <div class="position-relative">
                      <img class="img-fluid w-100" :src="getImageUrl(associate.photo)" :alt="associate.name" @error="(e) => (e.target as HTMLImageElement).src = '/img/user.jpg'">
                      <div class="team-overlay position-absolute d-flex align-items-center justify-content-center m-3">
                        <div class="d-flex align-items-center justify-content-start">
                          <a 
                            class="btn btn-outline-secondary rounded-circle text-center mr-2 px-0" 
                            style="width: 38px; height: 38px;" 
                            href="#"
                            data-toggle="tooltip" 
                            data-placement="top" 
                            title="Detail"
                          >
                            <i class="fas fa-eye"></i>
                          </a>
                        </div>
                      </div>
                    </div>
                    <div class="border border-top-0 text-center" style="padding: 30px;">
                      <h5 class="font-weight-bold">{{ associate.name }}</h5>
                      <span>{{ associate.position }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div v-if="!founder && associates.length === 0" class="alert alert-info">
          No attorneys available. Please add attorneys in the admin panel.
        </div>
      </div>
    </div>
    <!-- Teams Content End -->
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, ref } from 'vue';
import { useSEO, seoConfigs } from '@/composables/useSEO';
import { supabase, getImageUrl } from '@/lib/supabase';

interface Attorney {
  id: string;
  name: string;
  position: string;
  photo: string;
  bio: string;
  is_founder: boolean;
  is_featured: boolean;
}

export default defineComponent({
  name: 'Teams',
  setup() {
    // SEO Meta Tags
    useSEO(seoConfigs.teams);

    const teamCarousel = ref<HTMLElement | null>(null);
    const loading = ref(true);
    const founder = ref<Attorney | null>(null);
    const associates = ref<Attorney[]>([]);

    const loadAttorneys = async () => {
      try {
        const { data, error } = await supabase
          .from('attorneys')
          .select('*')
          .eq('is_active', true)
          .order('order_position', { ascending: true });

        if (error) throw error;

        // Separate founder and associates
        const attorneys = data || [];
        founder.value = attorneys.find(a => a.is_founder) || null;
        associates.value = attorneys.filter(a => !a.is_founder);
      } catch (error) {
        console.error('Error loading attorneys:', error);
      } finally {
        loading.value = false;
      }
    };

    onMounted(async () => {
      await loadAttorneys();

      // Initialize Owl Carousel after data is loaded
      setTimeout(() => {
        if (teamCarousel.value && associates.value.length > 0 && (window as any).$) {
          (window as any).$(teamCarousel.value).owlCarousel({
            autoplay: true,
            smartSpeed: 1000,
            margin: 30,
            dots: false,
            loop: true,
            nav: true,
            navText: [
              '<i class="fa fa-angle-left" aria-hidden="true"></i>',
              '<i class="fa fa-angle-right" aria-hidden="true"></i>',
            ],
            responsive: {
              0: {
                items: 1,
              },
              576: {
                items: 1,
              },
              768: {
                items: 2,
              },
              992: {
                items: 3,
              },
            },
          });
        }

        // Initialize tooltips
        if ((window as any).$ && (window as any).$('[data-toggle="tooltip"]').tooltip) {
          (window as any).$('[data-toggle="tooltip"]').tooltip();
        }
      }, 100);
    });

    return {
      loading,
      founder,
      associates,
      teamCarousel,
      getImageUrl,
    };
  },
});
</script>

<style scoped>
.teams-page {
  min-height: 100vh;
}

.page-header {
  background: linear-gradient(rgba(33, 40, 50, 0.8), rgba(33, 40, 50, 0.8)), url('/img/about.png');
  background-position: center center;
  background-repeat: no-repeat;
  background-size: cover;
}

.people-name h4 {
  margin: 10px 0;
}
</style>
