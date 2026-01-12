<template>
  <section id="home" data-aos-duration="1000" data-aos="fade-down">
    <div class="container-fluid p-0 mb-5">
      <div id="header-carousel" class="carousel slide carousel-fade" data-ride="carousel">
        <ol class="carousel-indicators">
          <li data-target="#header-carousel" data-slide-to="0" class="active"></li>
        </ol>
        <div class="carousel-inner">
          <div class="carousel-item active">
            <img class="img-fluid w-100" style="height: 100vh" src="/img/bg1.jpg" alt="Hero Image" />
            <div class="carousel-caption d-flex align-items-center justify-content-center">
              <div class="p-5" style="width: 100%; max-width: 900px">
                <h5 class="text-white text-uppercase mb-md-3">R .PRAMA WIJAWA & PARTNERS</h5>
                <h1 class="display-3 text-white mb-md-4">COMMITTED TO EXCELLENCE</h1>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, onMounted } from 'vue';
import $ from 'jquery';

export default defineComponent({
  name: 'HeroCarousel',
  setup() {
    onMounted(() => {
      // Initialize Bootstrap carousel
      ($('#header-carousel') as any).carousel({
        interval: 5000,
        ride: 'carousel',
      });
    });

    return {};
  },
});
</script>

<style scoped>
/* Component-specific styles if needed */
</style>
