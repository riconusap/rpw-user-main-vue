<template>
  <div class="teams-page">
    <!-- Page Header Start -->
    <div class="container-fluid page-header d-flex flex-column align-items-center justify-content-center pt-0 pt-lg-5 mb-5">
      <h1 class="display-4 text-white mb-3 mt-0 mt-lg-5">Our Attorney</h1>
      <div class="d-inline-flex text-white">
        <p class="m-0">
          <router-link class="text-white" to="/">Home</router-link>
        </p>
        <p class="m-0 px-2">/</p>
        <p class="m-0">Our People's</p>
      </div>
    </div>
    <!-- Page Header End -->

    <!-- Teams Content Start -->
    <div class="container py-5">
      <!-- Founder Section -->
      <div class="row d-flex align-items-center justify-content-center">
        <div class="col-lg-4">
          <img src="/img/founder.png" class="w-100 rounded shadow" alt="Founder">
        </div>
        <div class="col-lg-8 d-flex flex-column justify-content-around">
          <div class="people-name d-flex flex-column text-center justify-content-center align-items-center">
            <h4>FOUNDER</h4>
            <h4>{{ founder.name }}</h4>
          </div>
          <p>{{ founder.bio }}</p>
        </div>
      </div>

      <!-- Associates Section -->
      <div class="row mt-4">
        <div class="container">
          <div class="row">
            <div class="col-lg-12 mb-5">
              <div ref="teamCarousel" class="owl-carousel team-carousel" data-aos="fade-right" data-aos-duration="2000">
                <div 
                  v-for="associate in associates" 
                  :key="associate.id" 
                  class="team-item"
                >
                  <div class="position-relative">
                    <img class="img-fluid w-100" :src="associate.image" :alt="associate.name">
                    <div class="team-overlay position-absolute d-flex align-items-center justify-content-center m-3">
                      <div class="d-flex align-items-center justify-content-start">
                        <a 
                          class="btn btn-outline-secondary rounded-circle text-center mr-2 px-0" 
                          style="width: 38px; height: 38px;" 
                          href="#"
                          data-toggle="tooltip" 
                          data-placement="top" 
                          title="Detail"
                        >
                          <i class="fas fa-eye"></i>
                        </a>
                      </div>
                    </div>
                  </div>
                  <div class="border border-top-0 text-center" style="padding: 30px;">
                    <h5 class="font-weight-bold">{{ associate.name }}</h5>
                    <span>{{ associate.position }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Teams Content End -->
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, ref } from 'vue';
import { useSEO, seoConfigs } from '@/composables/useSEO';

interface Founder {
  name: string;
  bio: string;
}

interface Associate {
  id: number;
  name: string;
  position: string;
  image: string;
}

export default defineComponent({
  name: 'Teams',
  setup() {
    // SEO Meta Tags
    useSEO(seoConfigs.teams);

    const teamCarousel = ref<HTMLElement | null>(null);

    const founder: Founder = {
      name: 'Ramon Prama Wijaya, S.H., M.H.',
      bio: `He started his career as a legal practitioner in 2001 at Sijabat and 
      Partners Law Firm as a Junior Associate. Afterwards he joined to 
      Pamungkas, Noerdin, Wahyudi Law Firm as a Senior Associate. His last 
      position was a Partner at Wirsamulia & Ramon Law Firm.
      He has an extensive experience in Indonesia including civil court, 
      constitutional court, Indonesian Arbitration Board (BANI), commercial 
      court, administrative court, Islamic religion court, labour court (PHI), 
      also holds the advocate license issued by Indonesian Advocates 
      Association (PERADI).`,
    };

    const associates: Associate[] = [
      {
        id: 1,
        name: 'Niko Andro Syafril, SH',
        position: 'ASSOCIATE',
        image: '/img/ass-1.png',
      },
      {
        id: 2,
        name: 'Lamhot Pandapotan, SH',
        position: 'ASSOCIATE',
        image: '/img/ass-2.png',
      },
      {
        id: 3,
        name: 'Debbi Puspito, SH',
        position: 'ASSOCIATE',
        image: '/img/ass-3.png',
      },
    ];

    onMounted(() => {
      if (teamCarousel.value && (window as any).$) {
        (window as any).$(teamCarousel.value).owlCarousel({
          autoplay: true,
          smartSpeed: 1000,
          margin: 30,
          dots: false,
          loop: true,
          nav: true,
          navText: [
            '<i class="fa fa-angle-left" aria-hidden="true"></i>',
            '<i class="fa fa-angle-right" aria-hidden="true"></i>',
          ],
          responsive: {
            0: {
              items: 1,
            },
            576: {
              items: 1,
            },
            768: {
              items: 2,
            },
            992: {
              items: 3,
            },
          },
        });
      }

      // Initialize tooltips
      if ((window as any).$ && (window as any).$('[data-toggle="tooltip"]').tooltip) {
        (window as any).$('[data-toggle="tooltip"]').tooltip();
      }
    });

    return {
      founder,
      associates,
      teamCarousel,
    };
  },
});
</script>

<style scoped>
.teams-page {
  min-height: 100vh;
}

.page-header {
  background: linear-gradient(rgba(33, 40, 50, 0.8), rgba(33, 40, 50, 0.8)), url('/img/about.png');
  background-position: center center;
  background-repeat: no-repeat;
  background-size: cover;
}

.people-name h4 {
  margin: 10px 0;
}
</style>
