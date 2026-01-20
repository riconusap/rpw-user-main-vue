<template>
  <div>
    <!-- Hero Carousel Section -->
    <HeroCarousel />

    <!-- Intro Section -->
    <IntroSection />

    <!-- About Section -->
    <AboutSection />

    <!-- Value Proposition Section -->
    <ValuePropositionSection />

    <!-- Founder Section -->
    <FounderSection />

    <!-- Services Section -->
    <ServicesSection />

    <!-- Team Section -->
    <TeamSection />

    <!-- Articles Section -->
    <ArticlesSection />

    <!-- Clients Section -->
    <ClientsSection />

    <!-- Floating WhatsApp Button -->
    <a 
      v-if="whatsappNumber" 
      :href="whatsappLink" 
      target="_blank" 
      rel="noopener noreferrer"
      class="whatsapp-float"
      title="Chat via WhatsApp"
    >
      <i class="fab fa-whatsapp"></i>
    </a>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, computed } from 'vue';
import { useSEO, seoConfigs } from '@/composables/useSEO';
import { useSettings } from '@/composables/useSettings';
import HeroCarousel from '@/components/HeroCarousel.vue';
import IntroSection from '@/components/IntroSection.vue';
import ValuePropositionSection from '@/components/ValuePropositionSection.vue';
import FounderSection from '@/components/FounderSection.vue';
import AboutSection from '@/components/AboutSection.vue';
import ServicesSection from '@/components/ServicesSection.vue';
import ClientsSection from '@/components/ClientsSection.vue';
import TeamSection from '@/components/TeamSection.vue';
import ArticlesSection from '@/components/ArticlesSection.vue';

export default defineComponent({
  name: 'Home',
  components: {
    IntroSection,
    HeroCarousel,
    ValuePropositionSection,
    FounderSection,
    AboutSection,
    ServicesSection,
    ClientsSection,
    TeamSection,
    ArticlesSection,
  },
  setup() {
    // SEO Meta Tags
    useSEO(seoConfigs.home);

    const { settings } = useSettings();

    const whatsappNumber = computed(() => settings.value?.contact_whatsapp || '');
    
    const whatsappLink = computed(() => {
      if (!whatsappNumber.value) return '#';
      // Remove non-numeric characters and ensure it starts with country code
      const cleaned = whatsappNumber.value.replace(/\D/g, '');
      return `https://wa.me/${cleaned}`;
    });

    onMounted(() => {
      // Any initialization logic
    });

    return {
      whatsappNumber,
      whatsappLink,
    };
  },
});
</script>

<style scoped>
/* Floating WhatsApp Button */
.whatsapp-float {
  position: fixed;
  bottom: 30px;
  right: 30px;
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, #25D366 0%, #128C7E 100%);
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 32px;
  box-shadow: 0 4px 20px rgba(37, 211, 102, 0.4);
  z-index: 1000;
  transition: all 0.3s ease;
  text-decoration: none;
}

.whatsapp-float:hover {
  background: linear-gradient(135deg, #128C7E 0%, #075E54 100%);
  transform: scale(1.1) translateY(-5px);
  box-shadow: 0 6px 30px rgba(37, 211, 102, 0.6);
  color: white;
}

.whatsapp-float i {
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
}

@media (max-width: 767px) {
  .whatsapp-float {
    width: 50px;
    height: 50px;
    bottom: 20px;
    right: 20px;
    font-size: 26px;
  }
}
</style>
