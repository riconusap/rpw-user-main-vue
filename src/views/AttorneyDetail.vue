<template>
  <div class="attorney-detail-page">
    <!-- Page Header -->
    <div class="container-fluid page-header d-flex flex-column align-items-center justify-content-center pt-0 pt-lg-5 mb-5">
      <h1 class="display-4 text-white mb-3 mt-0 mt-lg-5">Attorney Profile</h1>
      <div class="d-inline-flex text-white">
        <p class="m-0">
          <router-link class="text-white" to="/">Home</router-link>
        </p>
        <p class="m-0 px-2">/</p>
        <p class="m-0">
          <router-link class="text-white" to="/attorneys">Our Team</router-link>
        </p>
        <p class="m-0 px-2">/</p>
        <p class="m-0">Profile</p>
      </div>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="container py-5">
      <div class="text-center py-5">
        <div class="spinner-border text-primary" role="status">
          <span class="sr-only">Loading...</span>
        </div>
      </div>
    </div>

    <!-- Attorney Detail Content -->
    <div v-else-if="attorney" class="container py-5">
      <div class="row">
        <!-- Attorney Photo & Info Card -->
        <div class="col-lg-4 mb-4">
          <div class="attorney-card-detail">
            <div class="attorney-photo">
              <img 
                :src="getImageUrl(attorney.photo)" 
                :alt="attorney.full_name" 
                @error="handleImageError"
              />
              <div v-if="attorney.is_founder" class="founder-badge">
                <i class="fas fa-crown"></i> Founder
              </div>
            </div>
            <div class="attorney-info-card">
              <h2 class="attorney-name">{{ attorney.full_name }}</h2>
              <p class="attorney-position">{{ attorney.position }}</p>
              
              <div v-if="attorney.email || attorney.phone" class="contact-info">
                <h6 class="contact-title">Contact Information</h6>
                <div v-if="attorney.email" class="contact-item">
                  <i class="fas fa-envelope"></i>
                  <a :href="`mailto:${attorney.email}`">{{ attorney.email }}</a>
                </div>
                <div v-if="attorney.phone" class="contact-item">
                  <i class="fas fa-phone"></i>
                  <a :href="`tel:${attorney.phone}`">{{ attorney.phone }}</a>
                </div>
              </div>

              <!-- <div v-if="attorney.specializations && attorney.specializations.length > 0" class="specializations">
                <h6 class="spec-title">Specializations</h6>
                <div class="spec-tags">
                  <span 
                    v-for="(spec, index) in attorney.specializations" 
                    :key="index"
                    class="spec-tag"
                  >
                    {{ spec }}
                  </span>
                </div>
              </div> -->
            </div>
          </div>
        </div>

        <!-- Biography & Details -->
        <div class="col-lg-8">
          <div class="attorney-bio">
            <h3 class="section-title">About {{ attorney.full_name }}</h3>
            <div class="bio-content text-justify" v-html="attorney.bio"></div>

            <!-- <div v-if="attorney.education && attorney.education.length > 0" class="section mt-5">
              <h4 class="subsection-title">
                <i class="fas fa-graduation-cap"></i> Education
              </h4>
              <ul class="detail-list">
                <li v-for="(edu, index) in attorney.education" :key="index">
                  {{ edu }}
                </li>
              </ul>
            </div> -->

            <!-- <div v-if="attorney.experience && attorney.experience.length > 0" class="section mt-4">
              <h4 class="subsection-title">
                <i class="fas fa-briefcase"></i> Professional Experience
              </h4>
              <ul class="detail-list">
                <li v-for="(exp, index) in attorney.experience" :key="index">
                  {{ exp }}
                </li>
              </ul>
            </div> -->

            <!-- <div v-if="attorney.achievements && attorney.achievements.length > 0" class="section mt-4">
              <h4 class="subsection-title">
                <i class="fas fa-trophy"></i> Achievements & Awards
              </h4>
              <ul class="detail-list">
                <li v-for="(achievement, index) in attorney.achievements" :key="index">
                  {{ achievement }}
                </li>
              </ul>
            </div> -->

            <!-- CTA Section -->
            <div class="cta-section mt-5">
              <div class="cta-card">
                <h4>Need Legal Consultation?</h4>
                <p>Contact {{ attorney.full_name }} for professional legal advice and representation.</p>
                <div class="cta-buttons">
                  <router-link to="/contact" class="btn btn-primary">
                    <i class="fas fa-envelope"></i> Contact Now
                  </router-link>
                  <router-link to="/attorneys" class="btn btn-outline">
                    <i class="fas fa-users"></i> View All Attorneys
                  </router-link>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Not Found -->
    <div v-else class="container py-5">
      <div class="alert alert-warning text-center">
        <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
        <h4>Attorney Not Found</h4>
        <p>The attorney profile you're looking for doesn't exist or has been removed.</p>
        <router-link to="/attorneys" class="btn btn-primary mt-3">
          View All Attorneys
        </router-link>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { supabase, getImageUrl } from '@/lib/supabase';
import { useSEO } from '@/composables/useSEO';

interface Attorney {
  id: string;
  full_name: string;
  position: string;
  photo: string;
  bio: string;
  email?: string;
  phone?: string;
  specializations?: string[];
  education?: string[];
  experience?: string[];
  achievements?: string[];
  is_founder: boolean;
  is_featured: boolean;
}

export default defineComponent({
  name: 'AttorneyDetail',
  setup() {
    const route = useRoute();
    const loading = ref(true);
    const attorney = ref<Attorney | null>(null);

    const loadAttorney = async () => {
      try {
        const attorneyId = route.params.id as string;

        console.log('Loading attorney with ID:', attorneyId);
        
        const { data, error } = await supabase
          .from('attorneys')
          .select('*')
          .eq('id', attorneyId)
          .eq('is_active', true)
          .single();

        if (error) throw error;
        
        attorney.value = data;

        // Update SEO
        if (data) {
          useSEO({
            title: `${data.full_name} - ${data.position}`,
            description: data.bio || `Professional attorney at R. Prama Wijaya & Partners`,
            keywords: `${data.full_name}, attorney, lawyer, legal services, ${data.position}`,
          });
        }
      } catch (error) {
        console.error('Error loading attorney:', error);
        attorney.value = null;
      } finally {
        loading.value = false;
      }
    };

    const handleImageError = (event: Event) => {
      const target = event.target as HTMLImageElement;
      target.src = '/img/user.jpg';
    };

    onMounted(() => {
      loadAttorney();
    });

    return {
      loading,
      attorney,
      getImageUrl,
      handleImageError,
    };
  },
});
</script>

<style scoped>
.attorney-detail-page {
  min-height: 100vh;
}

.page-header {
  background: linear-gradient(rgba(33, 40, 50, 0.8), rgba(33, 40, 50, 0.8)), url('/img/carousel-1.jpg');
  background-position: center center;
  background-repeat: no-repeat;
  background-size: cover;
}

/* Attorney Card Detail */
.attorney-card-detail {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 2rem;
}

.attorney-photo {
  position: relative;
  width: 100%;
  padding-top: 120%;
  background: #f8fafc;
}

.attorney-photo img {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.founder-badge {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: linear-gradient(135deg, #d4a948 0%, #c69840 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: 600;
  box-shadow: 0 4px 12px rgba(212, 169, 72, 0.3);
}

.attorney-info-card {
  padding: 2rem;
}

.attorney-name {
  font-size: 1.75rem;
  font-weight: 700;
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.attorney-position {
  font-size: 1.125rem;
  color: #d4a948;
  font-weight: 600;
  margin-bottom: 1.5rem;
}

/* Contact Info */
.contact-info {
  margin-top: 1.5rem;
  padding-top: 1.5rem;
  border-top: 2px solid #f1f5f9;
}

.contact-title {
  font-size: 0.875rem;
  font-weight: 700;
  text-transform: uppercase;
  color: #64748b;
  margin-bottom: 1rem;
  letter-spacing: 0.5px;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.75rem;
}

.contact-item i {
  color: #d4a948;
  width: 20px;
  text-align: center;
}

.contact-item a {
  color: #475569;
  text-decoration: none;
  transition: color 0.3s ease;
}

.contact-item a:hover {
  color: #d4a948;
}

/* Specializations */
.specializations {
  margin-top: 1.5rem;
  padding-top: 1.5rem;
  border-top: 2px solid #f1f5f9;
}

.spec-title {
  font-size: 0.875rem;
  font-weight: 700;
  text-transform: uppercase;
  color: #64748b;
  margin-bottom: 1rem;
  letter-spacing: 0.5px;
}

.spec-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.spec-tag {
  padding: 0.5rem 1rem;
  background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
  color: #d97706;
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: 600;
}

/* Biography Section */
.attorney-bio {
  background: white;
  border-radius: 16px;
  padding: 2.5rem;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.section-title {
  font-size: 2rem;
  font-weight: 700;
  color: #1e293b;
  margin-bottom: 1.5rem;
  position: relative;
  padding-bottom: 1rem;
}

.section-title::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 60px;
  height: 4px;
  background: linear-gradient(90deg, #d4a948 0%, transparent 100%);
}

.bio-content {
  color: #475569;
  line-height: 1.8;
  font-size: 1.0625rem;
}

.subsection-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1e293b;
  margin-bottom: 1rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.subsection-title i {
  color: #d4a948;
  font-size: 1.125rem;
}

.detail-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.detail-list li {
  padding: 0.75rem 0;
  color: #475569;
  line-height: 1.6;
  position: relative;
  padding-left: 1.5rem;
}

.detail-list li::before {
  content: '\f105';
  font-family: 'Font Awesome 5 Free';
  font-weight: 900;
  position: absolute;
  left: 0;
  color: #d4a948;
}

/* CTA Section */
.cta-section {
  margin-top: 3rem;
}

.cta-card {
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
  border-radius: 16px;
  padding: 2.5rem;
  text-align: center;
  border: 2px solid #e2e8f0;
}

.cta-card h4 {
  font-size: 1.75rem;
  font-weight: 700;
  color: #1e293b;
  margin-bottom: 1rem;
}

.cta-card p {
  color: #64748b;
  font-size: 1.0625rem;
  margin-bottom: 2rem;
}

.cta-buttons {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

.btn {
  padding: 1rem 2rem;
  border-radius: 50px;
  font-weight: 600;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
  border: none;
}

.btn-primary {
  background: linear-gradient(135deg, #d4a948 0%, #c69840 100%);
  color: white;
  box-shadow: 0 4px 12px rgba(212, 169, 72, 0.3);
}

.btn-primary:hover {
  background: linear-gradient(135deg, #c69840 0%, #b88738 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(212, 169, 72, 0.4);
  color: white;
}

.btn-outline {
  background: white;
  color: #1e293b;
  border: 2px solid #e2e8f0;
}

.btn-outline:hover {
  background: #f8fafc;
  border-color: #d4a948;
  color: #d4a948;
}

/* Responsive */
@media (max-width: 991px) {
  .attorney-card-detail {
    position: relative;
    top: 0;
    margin-bottom: 2rem;
  }

  .attorney-bio {
    padding: 1.5rem;
  }

  .cta-card {
    padding: 1.5rem;
  }

  .cta-buttons {
    flex-direction: column;
  }
}
</style>
