<template>
  <div class="container-fluid nav-bar p-0">
    <div class="container-lg p-0">
      <nav class="navbar navbar-expand-lg bg-secondary navbar-dark">
        <RouterLink to="/" class="navbar-brand">
          <img src="/img/logo.png" width="100px" alt="R. Prama Wijaya Law Firm" />
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
            <RouterLink to="/teams" class="nav-item nav-link">Our Attorney</RouterLink>
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
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Navbar',
  setup() {
    return {};
  },
});
</script>

<style scoped>
/* Component-specific styles if needed */
</style>
