<template>
  <section data-aos="fade-right" data-aos-duration="1000" id="teams">
    <div class="container-fluid pt-5">
      <div class="container">
        <div class="row">
          <div class="col-lg-4 mb-5" data-aos="fade-right" data-aos-duration="1000">
            <h1 class="mt-2 mb-3">Meet Experts of Behind Work</h1>
            <h4 class="font-weight-normal text-muted mb-4">
              We provide comprehensive and integrated answers, so it will eliminate doubts for individuals, business
              people and even companies to be able to take strategic steps legally
            </h4>
            <RouterLink to="/attorneys" class="btn btn-primary py-md-2 px-md-4 font-weight-semi-bold">
              Meet All Experts
            </RouterLink>
          </div>
          <div class="col-lg-8 mb-5">
            <div v-if="loading" class="text-center py-5">
              <div class="spinner-border text-primary" role="status">
                <span class="sr-only">Loading...</span>
              </div>
            </div>
            <div v-else-if="attorneys.length > 0" class="owl-carousel team-carousel" data-aos="fade-right" data-aos-duration="2000" ref="teamCarousel">
              <div v-for="attorney in attorneys" :key="attorney.id" class="team-item">
                <div class="position-relative">
                  <img class="img-fluid w-100" :src="getImageUrl(attorney.photo)" :alt="attorney.full_name" @error="handleImageError" />
                  <div
                    class="team-overlay position-absolute d-flex align-items-center justify-content-center m-3"
                  >
                    <div class="d-flex align-items-center justify-content-start">
                      <RouterLink
                        :to="`/attorneys/${attorney.id}`"
                        class="btn btn-outline-secondary rounded-circle text-center mr-2 px-0"
                        style="width: 38px; height: 38px"
                      >
                        <i class="fas fa-eye" data-toggle="tooltip" data-placement="top" title="Detail"></i>
                      </RouterLink>
                    </div>
                  </div>
                </div>
                <div class="border border-top-0 text-center" style="padding: 30px">
                  <p class="font-weight-bold" :style="{ fontSize: '1rem' }">{{ attorney.full_name }}</p>
                  <span>{{ attorney.position }}</span>
                </div>
              </div>
            </div>
            <div v-else class="alert alert-info">
              No attorneys available. Please add attorneys in the admin panel.
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { supabase, getImageUrl } from '@/lib/supabase';
import $ from 'jquery';
import 'owl.carousel';

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
  name: 'TeamSection',
  setup() {
    const teamCarousel = ref<HTMLElement | null>(null);
    const loading = ref(true);
    const attorneys = ref<Attorney[]>([]);

    const loadAttorneys = async () => {
      try {
        const { data, error } = await supabase
          .from('attorneys')
          .select('*')
          .eq('is_active', true)
          .eq('is_featured', true)
          .order('order_position', { ascending: true });

        if (error) throw error;
        attorneys.value = data || [];
      } catch (error) {
        console.error('Error loading attorneys:', error);
      } finally {
        loading.value = false;
      }
    };

    onMounted(async () => {
      await loadAttorneys();
      
      // Initialize Owl Carousel after attorneys are loaded
      setTimeout(() => {
        if (attorneys.value.length > 0) {
          ($('.team-carousel') as any).owlCarousel({
            autoplay: true,
            smartSpeed: 1000,
            margin: 30,
            dots: false,
            loop: true,
            autoWidth: true,
            responsive: {
              0: {
                items: 1,
                autoWidth: false,
              },
              576: {
                items: 2,
                autoWidth: false,
              },
              768: {
                autoWidth: true,
              },
            },
          });
        }
      }, 100);
    });

    const handleImageError = (event: Event) => {
      const target = event.target as HTMLImageElement;
      target.src = '/img/user.jpg';
    };

    return {
      teamCarousel,
      loading,
      attorneys,
      getImageUrl,
      handleImageError,
    };
  },
});
</script>

<style scoped>
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

/* Dynamic Width based on content */
.team-item {
  width: auto !important;
  min-width: 300px;
  max-width: 350px;
}

.team-item .position-relative {
  width: 300px;
  height: 300px;
  overflow: hidden;
  margin: 0 auto;
}

.team-item .position-relative img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
}

.team-item .border {
  overflow: visible;
}

.team-item .font-weight-bold {
  white-space: normal;
  word-wrap: break-word;
  line-height: 1.4;
}

/* Responsive adjustments */
@media (max-width: 767px) {
  .team-item {
    width: 100% !important;
    max-width: 100%;
  }
  
  .team-item .border {
    white-space: normal;
  }
  
  .team-item .font-weight-bold {
    white-space: normal;
  }
}
</style>
