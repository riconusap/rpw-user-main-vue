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
            <div v-if="loading" class="text-center py-5">
              <div class="spinner-border text-primary" role="status">
                <span class="sr-only">Loading...</span>
              </div>
            </div>
            <div v-else-if="features.length > 0" class="row">
              <div v-for="feature in features" :key="feature.id" class="col-md-6 mb-5">
                <div class="d-flex">
                  <div class="feature-icon mr-3">
                    <i :class="feature.icon" class="fa-3x text-primary"></i>
                  </div>
                  <div class="d-flex flex-column">
                    <h5 class="font-weight-bold mb-3">{{ feature.title }}</h5>
                    <p>{{ feature.description }}</p>
                  </div>
                </div>
              </div>
            </div>
            <div v-else class="alert alert-info">
              No features available. Please add features in the admin panel.
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { supabase } from '@/lib/supabase';

interface Feature {
  id: string;
  title: string;
  description: string;
  icon: string;
  order_position: number;
}

export default defineComponent({
  name: 'ServicesSection',
  setup() {
    const loading = ref(true);
    const features = ref<Feature[]>([]);

    const loadFeatures = async () => {
      try {
        const { data, error } = await supabase
          .from('features')
          .select('*')
          .eq('is_active', true)
          .order('order_position', { ascending: true });

        if (error) throw error;
        features.value = data || [];
      } catch (error) {
        console.error('Error loading features:', error);
      } finally {
        loading.value = false;
      }
    };

    onMounted(() => {
      loadFeatures();
    });

    return {
      loading,
      features,
    };
  },
});
</script>

<style scoped>
.feature-icon {
  min-width: 60px;
  display: flex;
  align-items: flex-start;
  justify-content: center;
}
</style>

<style scoped>
/* Component-specific styles if needed */
</style>
