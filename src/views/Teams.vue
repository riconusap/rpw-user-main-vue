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
          <div class="col-lg-4 position-relative founder-image-wrapper">
            <img :src="getImageUrl(founder.photo)" class="w-100 rounded shadow" :alt="founder.full_name" @error="handleImageError">
            <RouterLink 
              :to="`/attorneys/${founder.id}`" 
              class="founder-overlay d-flex align-items-center justify-content-center"
            >
              <span class="view-profile-text">
                <i class="fas fa-user"></i> View Full Profile
              </span>
            </RouterLink>
          </div>
          <div class="col-lg-8 d-flex flex-column justify-content-around">
            <div class="people-name d-flex flex-column text-center justify-content-center align-items-center">
              <h4>FOUNDER</h4>
              <h4>{{ founder.full_name }}</h4>
            </div>
            <div class="" v-html="founder.bio"></div>
            <div class="text-center mt-3">
              <RouterLink 
                :to="`/attorneys/${founder.id}`" 
                class="btn btn-primary"
              >
                <i class="fas fa-eye"></i> View Full Profile
              </RouterLink>
            </div>
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
                      <img class="img-fluid w-100" :src="getImageUrl(associate.photo)" :alt="associate.full_name" @error="handleImageError">
                      <div class="team-overlay position-absolute d-flex align-items-center justify-content-center m-3">
                        <div class="d-flex align-items-center justify-content-start">
                          <RouterLink
                            :to="`/attorneys/${associate.id}`"
                            class="btn btn-outline-secondary rounded-circle text-center mr-2 px-0" 
                            style="width: 38px; height: 38px;" 
                            data-toggle="tooltip" 
                            data-placement="top" 
                            title="View Profile"
                          >
                            <i class="fas fa-eye"></i>
                          </RouterLink>
                        </div>
                      </div>
                    </div>
                    <div class="border border-top-0 text-center" style="padding: 30px;">
                      <h5 class="font-weight-bold">{{ associate.full_name }}</h5>
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
  full_name: string;
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

    const handleImageError = (event: Event) => {
      const target = event.target as HTMLImageElement;
      target.src = '/img/user.jpg';
    };

    return {
      loading,
      founder,
      associates,
      teamCarousel,
      getImageUrl,
      handleImageError,
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

.team-overlay {
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  opacity: 0;
  transition: all 0.3s;
}

.team-item:hover .team-overlay {
  opacity: 1;
}

/* Founder Section */
.founder-image-wrapper {
  position: relative;
  overflow: hidden;
  border-radius: 8px;
}

.founder-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(180deg, rgba(26, 26, 46, 0.7) 0%, rgba(26, 26, 46, 0.9) 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
  text-decoration: none;
  border-radius: 8px;
}

.founder-image-wrapper:hover .founder-overlay {
  opacity: 1;
}

.view-profile-text {
  color: white;
  font-size: 1.125rem;
  font-weight: 600;
  padding: 1rem 2rem;
  background: linear-gradient(135deg, #d4a948 0%, #c69840 100%);
  border-radius: 50px;
  box-shadow: 0 4px 12px rgba(212, 169, 72, 0.3);
  transition: all 0.3s ease;
}

.founder-overlay:hover .view-profile-text {
  transform: translateY(-4px);
  box-shadow: 0 6px 16px rgba(212, 169, 72, 0.4);
}

.btn-primary {
  background: linear-gradient(135deg, #d4a948 0%, #c69840 100%);
  border: none;
  border-radius: 50px;
  padding: 0.75rem 2rem;
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(212, 169, 72, 0.3);
}

.btn-primary:hover {
  background: linear-gradient(135deg, #c69840 0%, #b88738 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(212, 169, 72, 0.4);
}
</style>

