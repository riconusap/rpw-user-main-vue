<template>
  <section id="home" data-aos-duration="1000" data-aos="fade-down">
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary" role="status">
        <span class="sr-only">Loading...</span>
      </div>
    </div>
    <div v-else-if="slides.length > 0" class="container-fluid p-0 hero-container">
      <div id="header-carousel" class="carousel slide carousel-fade" data-ride="carousel">
        <ol class="carousel-indicators">
          <li 
            v-for="(slide, index) in slides" 
            :key="slide.id"
            data-target="#header-carousel" 
            :data-slide-to="index" 
            :class="{ active: index === 0 }"
          ></li>
        </ol>
        <div class="carousel-inner">
          <div 
            v-for="(slide, index) in slides" 
            :key="slide.id"
            class="carousel-item" 
            :class="{ active: index === 0 }"
          >
            <img 
              class="img-fluid w-100" 
              style="height: 100vh; object-fit: cover;" 
              :src="getImageUrl(slide.background_image)" 
              :alt="slide.title"
              @error="handleImageError"
            />
            
            <div class="carousel-caption d-flex align-items-center justify-content-center">
              <div class="p-5" style="width: 100%; max-width: 900px;">
                <h5 v-if="slide.subtitle" class="text-white mb-md-3">
                  {{ slide.subtitle }}
                </h5>
                <h1 class="display-3 text-white mb-md-4">{{ slide.title }}</h1>
                <p v-if="slide.description !== '-'" class="text-white mb-md-4">{{ slide.description }}</p>
                <a 
                  v-if="slide.cta_text && slide.cta_link" 
                  :href="slide.cta_link" 
                  class="btn btn-primary py-md-3 px-md-5 mt-2"
                >
                  {{ slide.cta_text }}
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div v-else class="container-fluid p-0 mb-5">
      <div class="alert alert-info text-center m-5">
        No hero slides available. Please add slides in the admin panel.
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { supabase, getImageUrl } from '@/lib/supabase';
import $ from 'jquery';

interface HeroSlide {
  id: string;
  title: string;
  subtitle: string | null;
  description: string;
  background_image: string;
  cta_text: string | null;
  cta_link: string | null;
  order_position: number;
}

export default defineComponent({
  name: 'HeroCarousel',
  setup() {
    const loading = ref(true);
    const slides = ref<HeroSlide[]>([]);

    const loadSlides = async () => {
      try {
        const { data, error } = await supabase
          .from('hero_slides')
          .select('*')
          .eq('is_active', true)
          .order('order_position', { ascending: true });

        if (error) throw error;
        slides.value = data || [];
      } catch (error) {
        console.error('Error loading hero slides:', error);
      } finally {
        loading.value = false;
      }
    };

    onMounted(async () => {
      await loadSlides();
      
      // Initialize Bootstrap carousel after slides are loaded
      setTimeout(() => {
        ($('#header-carousel') as any).carousel({
          interval: 5000,
          ride: 'carousel',
        });
      }, 100);
    });

    const handleImageError = (event: Event) => {
      const target = event.target as HTMLImageElement;
      target.src = '/img/bg1.jpg';
    };

    return {
      loading,
      slides,
      getImageUrl,
      handleImageError,
    };
  },
});
</script>

<style scoped>
.hero-container {
  margin-bottom: 5rem;
}

/* Mobile optimizations */
@media (max-width: 768px) {
  .hero-container {
    margin-bottom: 0 !important;
  }

  .carousel-item {
    position: relative;
    overflow: hidden;
  }

  .carousel-item img {
    height: 100vh !important;
    object-fit: cover !important;
    object-position: center;
  }

  /* Logo positioning */
  .hero-logo {
    position: absolute;
    top: 20px;
    right: 20px;
    z-index: 15;
    width: 140px;
  }

  .hero-logo img {
    width: 100%;
    height: auto;
    filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
  }

  .carousel-caption {
    top: auto !important;
    bottom: 0 !important;
    left: 0 !important;
    right: 0 !important;
    transform: none !important;
    padding: 0 !important;
    background: none !important;
    height: auto !important;
    justify-content: flex-end !important;
    align-items: center !important;
    clip-path: polygon(0 25%, 100% 0%, 100% 100%, 0 100%);
  }

  .carousel-caption .p-5 {
    padding: 3rem 2rem 2.5rem 2rem !important;
    text-align: center !important;
    width: 100% !important;
    max-width: 100% !important;
    background-color: #E8E3D6 !important;
    position: relative;
    min-height: 32vh;
    display: flex !important;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }

  .carousel-caption h5 {
    font-size: 0.75rem !important;
    margin-bottom: 1rem !important;
    letter-spacing: 3px;
    color: #4A5568 !important;
    font-weight: 500;
    display: none !important;
  }

  .carousel-caption h1 {
    font-size: 2.25rem !important;
    line-height: 1.15 !important;
    margin-bottom: 0 !important;
    font-weight: 700;
    color: #2C4058 !important;
    letter-spacing: 0.5px;
    text-transform: uppercase;
    max-width: 90%;
  }

  .carousel-caption p {
    font-size: 0.9rem !important;
    margin-bottom: 1rem !important;
    display: none !important;
  }

  .carousel-caption .btn {
    padding: 0.75rem 1.5rem !important;
    font-size: 0.9rem !important;
    display: none !important;
  }

  .carousel-indicators {
    bottom: 20px;
    z-index: 10;
  }

  .carousel-indicators li {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background-color: rgba(255, 255, 255, 0.4);
    border: none;
  }

  .carousel-indicators .active {
    background-color: rgba(255, 255, 255, 0.9);
  }
}

/* Tablet and desktop */
@media (min-width: 769px) {
  .carousel-caption {
    background: rgba(0, 0, 0, 0.3);
  }
  
  .hero-logo {
    display: none;
  }
}
</style>
