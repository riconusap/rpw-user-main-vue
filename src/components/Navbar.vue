<template>
  <div class="container-fluid nav-bar p-0">
    <div class="container-lg p-0">
      <nav class="navbar navbar-expand-lg bg-secondary navbar-dark">
        <RouterLink to="/" class="navbar-brand">
          <img 
            v-if="settings?.site_logo" 
            :src="getImageUrl(settings.site_logo, 'images')" 
            width="150px" 
            :alt="settings.site_name || 'Logo'" 
          />
          <img v-else src="/img/logo.png" width="100px" alt="R. Prama Wijaya Law Firm" />
        </RouterLink>
        <button
          type="button"
          class="navbar-toggler"
          data-toggle="collapse"
          data-target="#navbarCollapse"
          aria-controls="navbarCollapse"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-between" id="navbarCollapse">
          <div class="navbar-nav ml-auto py-0">
            <RouterLink to="/" class="nav-item nav-link">Home</RouterLink>
            <RouterLink to="/attorneys" class="nav-item nav-link">Our Attorney</RouterLink>
            <RouterLink to="/services" class="nav-item nav-link">Our Expertise</RouterLink>
            <RouterLink to="/articles" class="nav-item nav-link">Articles</RouterLink>
            <RouterLink to="/about" class="nav-item nav-link">About Us</RouterLink>
            <RouterLink to="/contact" class="nav-item nav-link">Contact Us</RouterLink>
          </div>
        </div>
      </nav>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted } from 'vue';
import { useSettings } from '@/composables/useSettings';
import { getImageUrl } from '@/lib/supabase';

export default defineComponent({
  name: 'Navbar',
  setup() {
    const { settings, loadSettings } = useSettings();

    onMounted(() => {
      loadSettings();
    });

    return {
      settings,
      getImageUrl,
    };
  },
});
</script>

<style scoped>
/* Component-specific styles if needed */
</style>
