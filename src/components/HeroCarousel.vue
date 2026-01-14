<template>
  <section id="home" data-aos-duration="1000" data-aos="fade-down">
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary" role="status">
        <span class="sr-only">Loading...</span>
      </div>
    </div>
    <div v-else-if="slides.length > 0" class="container-fluid p-0 mb-5">
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
              <div class="p-5" style="width: 100%; max-width: 900px">
                <h5 v-if="slide.subtitle" class="text-white text-uppercase mb-md-3">
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
/* Component-specific styles if needed */
</style>
