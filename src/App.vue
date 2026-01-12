<template>
  <div id="app">
    <Navbar />
    <router-view />
    <Footer />
    <BackToTop />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
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
    return {};
  },
});
</script>

<style>
/* Global styles can be placed here */
</style>
