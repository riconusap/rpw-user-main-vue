<template>
  <section data-aos="fade-right" data-aos-duration="1000" id="service">
    <div class="container-fluid pt-5 pb-3">
      <div class="container">
        <div class="row">
          <div class="col-lg-12 mb-5" data-aos="fade-right" data-aos-duration="1500">
            <h1 class="mt-2 mb-3">OUR EXPERTISE</h1>
            <h4 class="font-weight-normal text-muted mb-4">
              Besides providing legal services from set up a new company, contract drafting and negotiation, we also
              provide legal advice and represent company in securing its business deals and resolve their legal problem
            </h4>
            <a href="#" class="btn btn-primary py-md-2 px-md-4 font-weight-semi-bold">Discover More</a>
          </div>
          <div class="col-lg-12" data-aos="fade-right" data-aos-duration="2000">
            <div class="row">
              <div v-for="(service, index) in services" :key="index" class="col-md-6 mb-5">
                <div class="d-flex">
                  <img :src="service.image" width="150px" class="rounded" :alt="service.title" />
                  <div class="d-flex flex-column ml-3">
                    <h5 class="font-weight-bold mb-3">{{ service.title }}</h5>
                    <p>{{ service.description }}</p>
                  </div>
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
import { defineComponent, ref } from 'vue';

interface Service {
  image: string;
  title: string;
  description: string;
}

export default defineComponent({
  name: 'ServicesSection',
  setup() {
    const services = ref<Service[]>([
      {
        image: '/img/claw.jpg',
        title: 'Corporate Law',
        description:
          'Advising clients on corporate structures, regulations and compliance. Assist join ventures, foreign and local labour.',
      },
      {
        image: '/img/claw.jpg',
        title: 'Corporate Law',
        description:
          'Advising clients on corporate structures, regulations and compliance. Assist join ventures, foreign and local labour.',
      },
      {
        image: '/img/claw.jpg',
        title: 'Corporate Law',
        description:
          'Advising clients on corporate structures, regulations and compliance. Assist join ventures, foreign and local labour.',
      },
      {
        image: '/img/claw.jpg',
        title: 'Corporate Law',
        description:
          'Advising clients on corporate structures, regulations and compliance. Assist join ventures, foreign and local labour.',
      },
    ]);

    return {
      services,
    };
  },
});
</script>

<style scoped>
/* Component-specific styles if needed */
</style>
