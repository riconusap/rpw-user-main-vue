<template>
  <section data-aos="fade-right" data-aos-duration="1000" id="teams">
    <div class="container-fluid pt-5">
      <div class="container">
        <div class="row">
          <div class="col-lg-4 mb-5" data-aos="fade-right" data-aos-duration="1000">
            <h1 class="mt-2 mb-3">Meet Experts of Behind Work</h1>
            <h4 class="font-weight-normal text-muted mb-4">
              We provide comprehensive and integrated answers, so it will eliminate doubts for individuals, business
              people and even companies to be able to take strategic steps legally
            </h4>
            <RouterLink to="/teams" class="btn btn-primary py-md-2 px-md-4 font-weight-semi-bold">
              Meet All Experts
            </RouterLink>
          </div>
          <div class="col-lg-8 mb-5">
            <div class="owl-carousel team-carousel" data-aos="fade-right" data-aos-duration="2000" ref="teamCarousel">
              <div v-for="(member, index) in teamMembers" :key="index" class="team-item">
                <div class="position-relative">
                  <img class="img-fluid w-100" :src="member.image" :alt="member.name" />
                  <div
                    class="team-overlay position-absolute d-flex align-items-center justify-content-center m-3"
                  >
                    <div class="d-flex align-items-center justify-content-start">
                      <RouterLink
                        :to="member.detailLink"
                        class="btn btn-outline-secondary rounded-circle text-center mr-2 px-0"
                        style="width: 38px; height: 38px"
                      >
                        <i class="fas fa-eye" data-toggle="tooltip" data-placement="top" title="Detail"></i>
                      </RouterLink>
                    </div>
                  </div>
                </div>
                <div class="border border-top-0 text-center" style="padding: 30px">
                  <h5 class="font-weight-bold">{{ member.name }}</h5>
                  <span>{{ member.position }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import $ from 'jquery';
import 'owl.carousel';

interface TeamMember {
  image: string;
  name: string;
  position: string;
  detailLink: string;
}

export default defineComponent({
  name: 'TeamSection',
  setup() {
    const teamCarousel = ref<HTMLElement | null>(null);
    const teamMembers = ref<TeamMember[]>([
      {
        image: '/img/founder.png',
        name: 'Ramon Prama Wijaya, S.H., M.H.',
        position: 'FOUNDER',
        detailLink: '/teams',
      },
      {
        image: '/img/ass-1.png',
        name: 'Niko Andro Syafril, SH',
        position: 'ASSOCIATE',
        detailLink: '#',
      },
      {
        image: '/img/ass-2.png',
        name: 'Lamhot Pandapotan, SH',
        position: 'ASSOCIATE',
        detailLink: '#',
      },
      {
        image: '/img/ass-3.png',
        name: 'Debbi Puspito, SH',
        position: 'ASSOCIATE',
        detailLink: '#',
      },
    ]);

    onMounted(() => {
      // Initialize Owl Carousel
      if (teamCarousel.value) {
        ($('.team-carousel') as any).owlCarousel({
          autoplay: true,
          smartSpeed: 1000,
          margin: 30,
          dots: false,
          loop: true,
          responsive: {
            0: {
              items: 1,
            },
            576: {
              items: 2,
            },
            768: {
              items: 3,
            },
            992: {
              items: 4,
            },
          },
        });
      }
    });

    return {
      teamCarousel,
      teamMembers,
    };
  },
});
</script>

<style scoped>
.team-overlay {
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  opacity: 0;
  transition: all 0.3s;
}

.team-item:hover .team-overlay {
  opacity: 1;
}
</style>
