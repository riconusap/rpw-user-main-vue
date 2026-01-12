<template>
  <div id="app">
    <!-- Global Loading Overlay -->
    <transition name="fade">
      <div v-if="isLoading" class="global-loading-overlay">
        <div class="loading-content">
          <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;">
            <span class="sr-only">Loading...</span>
          </div>
          <h4 class="mt-3 text-primary">Loading...</h4>
        </div>
      </div>
    </transition>

    <!-- Public Layout (Landing Page) -->
    <template v-if="!isAdminRoute">
      <Navbar />
      <router-view />
      <Footer />
      <BackToTop />
    </template>

    <!-- Admin Layout (No Navbar/Footer) -->
    <template v-else>
      <router-view />
    </template>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed, ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import Navbar from '@/components/Navbar.vue';
import Footer from '@/components/Footer.vue';
import BackToTop from '@/components/BackToTop.vue';

export default defineComponent({
  name: 'App',
  components: {
    Navbar,
    Footer,
    BackToTop,
  },
  setup() {
    const route = useRoute();
    const isLoading = ref(true);

    // Check if current route is admin route
    const isAdminRoute = computed(() => {
      return route.path.startsWith('/admin');
    });

    // Hide loading overlay after app is mounted
    onMounted(() => {
      // Simulate minimum loading time for better UX
      setTimeout(() => {
        isLoading.value = false;
      }, 800);
    });

    return {
      isAdminRoute,
      isLoading,
    };
  },
});
</script>

<style>
/* Global styles can be placed here */

/* Global Loading Overlay */
.global-loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.98);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

.loading-content {
  text-align: center;
}

/* Fade Transition */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
