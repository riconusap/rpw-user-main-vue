<template>
  <div class="services-page">
    <!-- Page Header Start -->
    <div class="container-fluid page-header d-flex flex-column align-items-center justify-content-center pt-0 pt-lg-5 mb-5">
      <h1 class="display-4 text-white mb-3 mt-0 mt-lg-5">Our Services</h1>
      <div class="d-inline-flex text-white">
        <p class="m-0">
          <router-link class="text-white" to="/">Home</router-link>
        </p>
        <p class="m-0 px-2">/</p>
        <p class="m-0">Services</p>
      </div>
    </div>
    <!-- Page Header End -->

    <!-- Services Content Start -->
    <div class="container py-5">
      <div class="text-center mb-5">
        <h6 class="text-uppercase text-primary mb-3">Our Practice Areas</h6>
        <h1>Comprehensive Legal Services</h1>
        <p class="text-muted mt-3">
          We provide professional legal services across various practice areas, 
          delivering expert solutions tailored to your needs.
        </p>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-primary" role="status">
          <span class="sr-only">Loading...</span>
        </div>
      </div>

      <!-- Services Grid -->
      <div v-else-if="practiceAreas.length > 0" class="row">
        <div
          v-for="area in practiceAreas"
          :key="area.id"
          class="col-lg-6 mb-4"
          data-aos="fade-up"
          data-aos-duration="1000"
        >
          <div class="service-card h-100">
            <div class="service-icon">
              <img
                v-if="area.icon_image_url"
                :src="getImageUrl(area.icon_image_url, 'icons')"
                :alt="area.title"
              />
              <i v-else :class="area.icon" class="fa-3x"></i>
            </div>
            <div class="service-content">
              <h4 class="mb-3">{{ area.title }}</h4>
              <p class="text-muted mb-3">{{ area.description }}</p>
              <span v-if="area.is_featured" class="featured-badge">
                <i class="fas fa-star"></i> Featured
              </span>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div v-else class="text-center py-5">
        <i class="fas fa-briefcase fa-3x text-muted mb-3"></i>
        <p class="text-muted">No services available at the moment.</p>
      </div>

      <!-- CTA Section -->
      <div class="text-center mt-5 pt-5">
        <div class="cta-box">
          <h3 class="mb-3">Need Legal Consultation?</h3>
          <p class="text-muted mb-4">
            Our experienced attorneys are ready to assist you with your legal matters.
          </p>
          <router-link to="/contact" class="btn btn-primary btn-lg px-5">
            Contact Us Today
          </router-link>
        </div>
      </div>
    </div>
    <!-- Services Content End -->
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { useSEO } from '@/composables/useSEO';
import { supabase, getImageUrl } from '@/lib/supabase';

interface PracticeArea {
  id: string;
  icon: string;
  icon_image_url?: string;
  title: string;
  slug: string;
  description: string;
  order_position: number;
  is_featured: boolean;
  is_active: boolean;
}

export default defineComponent({
  name: 'Services',
  setup() {
    // SEO Meta Tags
    useSEO({
      title: 'Our Legal Services',
      description: 'Comprehensive legal services including corporate law, civil litigation, contract law, and more. Professional legal expertise for all your needs.',
      keywords: 'legal services, practice areas, corporate law, civil litigation, attorney services, legal consultation',
    });

    const loading = ref(true);
    const practiceAreas = ref<PracticeArea[]>([]);

    const loadPracticeAreas = async () => {
      try {
        const { data, error } = await supabase
          .from('practice_areas')
          .select('*')
          .eq('is_active', true)
          .order('order_position', { ascending: true });

        if (error) throw error;
        practiceAreas.value = data || [];
      } catch (error) {
        console.error('Error loading practice areas:', error);
      } finally {
        loading.value = false;
      }
    };

    onMounted(() => {
      loadPracticeAreas();
    });

    return {
      loading,
      practiceAreas,
      getImageUrl,
    };
  },
});
</script>

<style scoped>
.services-page {
  min-height: 100vh;
}

.page-header {
  background: linear-gradient(rgba(33, 40, 50, 0.8), rgba(33, 40, 50, 0.8)), url('/img/carousel-1.jpg');
  background-position: center center;
  background-repeat: no-repeat;
  background-size: cover;
}

/* Service Card */
.service-card {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
  display: flex;
  gap: 1.5rem;
  border: 2px solid transparent;
}

.service-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(212, 169, 72, 0.15);
  border-color: #d4a948;
}

/* Service Icon */
.service-icon {
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #d4a948 0%, #c69840 100%);
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: all 0.3s ease;
}

.service-card:hover .service-icon {
  transform: scale(1.1) rotate(5deg);
  box-shadow: 0 4px 16px rgba(212, 169, 72, 0.3);
}

.service-icon img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  padding: 1rem;
}

.service-icon i {
  color: white;
  font-size: 2.5rem;
}

/* Service Content */
.service-content {
  flex: 1;
}

.service-content h4 {
  color: #1e293b;
  font-weight: 700;
  font-size: 1.5rem;
}

.featured-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.375rem 0.875rem;
  background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
  color: #d97706;
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: 600;
}

.featured-badge i {
  font-size: 0.75rem;
}

/* CTA Box */
.cta-box {
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
  border-radius: 16px;
  padding: 3rem 2rem;
  border: 2px solid #e2e8f0;
}

.cta-box h3 {
  color: #1e293b;
  font-weight: 700;
}

.btn-primary {
  background: linear-gradient(135deg, #d4a948 0%, #c69840 100%);
  border: none;
  border-radius: 50px;
  padding: 1rem 2.5rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(212, 169, 72, 0.3);
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(212, 169, 72, 0.4);
  background: linear-gradient(135deg, #c69840 0%, #b88738 100%);
}

/* Responsive */
@media (max-width: 768px) {
  .service-card {
    flex-direction: column;
    text-align: center;
  }

  .service-icon {
    margin: 0 auto;
  }

  .cta-box {
    padding: 2rem 1rem;
  }
}
</style>
