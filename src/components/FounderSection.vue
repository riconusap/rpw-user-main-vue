<template>
  <section class="founder-section">
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-light" role="status">
        <span class="sr-only">Loading...</span>
      </div>
    </div>
    
    <div v-else-if="founder" class="container">
      <div class="founder-wrapper">
        <!-- Founder Photo -->
        <div class="founder-photo">
          <img 
            :src="founder.photo ? getImageUrl(founder.photo) : '/img/team-placeholder.jpg'" 
            :alt="founder.name"
            @error="handleImageError"
          />
        </div>

        <!-- Founder Info -->
        <div class="founder-info">
          <h2 class="founder-title">FOUNDER</h2>
          <div class="title-underline"></div>
          
          <h3 class="founder-name">{{ founder.full_name }}</h3>
          
          <div class="founder-bio">
            <div v-html="founder.bio" class="text-center"></div>
          </div>
        </div>

        <!-- Gold Border Frame -->
        <div class="gold-border"></div>
      </div>
    </div>

    <div v-else class="container">
      <div class="founder-wrapper">
        <p class="text-center text-light">No founder information available.</p>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { supabase, getImageUrl } from '@/lib/supabase';

interface Founder {
  id: string;
  name: string;
  photo: string;
  bio: string;
  order_position: number;
  is_active: boolean;
}

export default defineComponent({
  name: 'FounderSection',
  setup() {
    const loading = ref(true);
    const founder = ref<Founder | null>(null);

    const loadFounder = async () => {
      loading.value = true;
      try {
        const { data, error } = await supabase
          .from('attorneys')
          .select('*')
          .eq('is_active', true)
          .eq('is_founder', true)
          .single();

        if (error) throw error;
        founder.value = data;
      } catch (error: any) {
        console.error('Error loading founder:', error.message);
      } finally {
        loading.value = false;
      }
    };

    const handleImageError = (event: Event) => {
      const target = event.target as HTMLImageElement;
      target.src = '/img/team-placeholder.jpg';
    };

    onMounted(() => {
      loadFounder();
    });

    return {
      loading,
      founder,
      getImageUrl,
      handleImageError,
    };
  },
});
</script>

<style scoped>
.founder-section {
  background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
  padding: 5rem 0;
  position: relative;
}

.founder-wrapper {
  position: relative;
  max-width: 900px;
  margin: 0 auto;
  padding: 4rem 3rem;
  text-align: center;
}

/* Founder Photo */
.founder-photo {
  margin: 0 auto 3rem;
  max-width: 450px;
}

.founder-photo img {
  width: 100%;
  height: auto;
  display: block;
  border-radius: 4px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

/* Founder Info */
.founder-info {
  color: #ffffff;
}

.founder-title {
  font-size: 2.5rem;
  font-weight: 700;
  letter-spacing: 3px;
  margin-bottom: 0.5rem;
  color: #ffffff;
}

.title-underline {
  width: 80px;
  height: 4px;
  background-color: #d4af37;
  margin: 0 auto 2rem;
}

.founder-name {
  font-size: 1.75rem;
  font-weight: 600;
  margin-bottom: 2rem;
  color: #ffffff;
}

.founder-bio p {
  font-size: 1rem;
  line-height: 1.8;
  margin-bottom: 1.5rem;
  text-align: justify;
  color: rgba(255, 255, 255, 0.95);
  font-weight: 300;
}

.founder-bio p:last-child {
  margin-bottom: 0;
}

.spinner-border {
  width: 3rem;
  height: 3rem;
  border-width: 0.25em;
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}

/* Gold Border Frame */
.gold-border {
  position: absolute;
  top: 2rem;
  left: 2rem;
  right: 2rem;
  bottom: 2rem;
  border: 3px solid #d4af37;
  pointer-events: none;
  z-index: 10;
}

/* Tablet */
@media (max-width: 991px) {
  .founder-section {
    padding: 4rem 0;
  }

  .founder-wrapper {
    padding: 3rem 2rem;
  }

  .founder-photo {
    max-width: 400px;
    margin-bottom: 2.5rem;
  }

  .founder-title {
    font-size: 2rem;
  }

  .founder-name {
    font-size: 1.5rem;
  }

  .gold-border {
    top: 1.5rem;
    left: 1.5rem;
    right: 1.5rem;
    bottom: 1.5rem;
  }
}

/* Mobile */
@media (max-width: 768px) {
  .founder-section {
    padding: 3rem 0;
  }

  .founder-wrapper {
    padding: 2.5rem 1.5rem;
  }

  .founder-photo {
    max-width: 350px;
    margin-bottom: 2rem;
  }

  .founder-title {
    font-size: 1.75rem;
    letter-spacing: 2px;
  }

  .title-underline {
    width: 60px;
    height: 3px;
    margin-bottom: 1.5rem;
  }

  .founder-name {
    font-size: 1.25rem;
    margin-bottom: 1.5rem;
  }

  .founder-bio p {
    font-size: 0.95rem;
    line-height: 1.7;
    text-align: left;
    margin-bottom: 1.25rem;
  }

  .gold-border {
    top: 1rem;
    left: 1rem;
    right: 1rem;
    bottom: 1rem;
    border-width: 2px;
  }
}

@media (max-width: 480px) {
  .founder-section {
    padding: 2rem 0;
  }

  .founder-wrapper {
    padding: 2rem 1rem;
  }

  .founder-photo {
    max-width: 300px;
  }

  .founder-title {
    font-size: 1.5rem;
  }

  .founder-name {
    font-size: 1.1rem;
  }

  .founder-bio p {
    font-size: 0.9rem;
  }

  .gold-border {
    top: 0.75rem;
    left: 0.75rem;
    right: 0.75rem;
    bottom: 0.75rem;
  }
}
</style>
