<template>
  <div>
    <!-- Hero Carousel Section -->
    <HeroCarousel />

    <!-- About Section -->
    <AboutSection />

    <!-- Services Section -->
    <ServicesSection />

    <!-- Team Section -->
    <TeamSection />

    <!-- Articles Section -->
    <ArticlesSection />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import HeroCarousel from '@/components/HeroCarousel.vue';
import AboutSection from '@/components/AboutSection.vue';
import ServicesSection from '@/components/ServicesSection.vue';
import TeamSection from '@/components/TeamSection.vue';
import ArticlesSection from '@/components/ArticlesSection.vue';

export default defineComponent({
  name: 'Home',
  components: {
    HeroCarousel,
    AboutSection,
    ServicesSection,
    TeamSection,
    ArticlesSection,
  },
  setup() {
    return {};
  },
});
</script>

<style scoped>
/* Component-specific styles if needed */
</style>
