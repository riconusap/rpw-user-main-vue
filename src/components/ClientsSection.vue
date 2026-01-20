<template>
  <section class="clients-section py-5">
    <div class="container">
      <div class="text-center mx-auto mb-5" style="max-width: 600px">
        <h6 class="section-title bg-white text-center text-primary px-3">Our Clients</h6>
        <h1 class="display-6 mb-4">Trusted by Leading Organizations</h1>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
      </div>

      <!-- Clients Grid -->
      <div v-else-if="clients.length > 0" class="clients-grid">
        <div
          v-for="client in clients"
          :key="client.id"
          class="client-item"
          :data-aos="'fade-up'"
          :data-aos-delay="client.order_position * 100"
        >
          <div class="client-logo-wrapper">
            <img
              v-if="client.logo_url"
              :src="getImageUrl(client.logo_url, 'clients')"
              :alt="client.name"
              :title="client.name"
              class="client-logo"
            />
            <div v-else class="client-name-display">
              <span>{{ client.name }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div v-else class="text-center py-5">
        <p class="text-muted">No clients to display at this time.</p>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { supabase, getImageUrl } from '@/lib/supabase';

interface Client {
  id: string;
  name: string;
  logo_url: string;
  order_position: number;
  is_active: boolean;
}

export default defineComponent({
  name: 'ClientsSection',
  setup() {
    const loading = ref(true);
    const clients = ref<Client[]>([]);

    const loadClients = async () => {
      loading.value = true;
      try {
        const { data, error } = await supabase
          .from('clients')
          .select('*')
          .eq('is_active', true)
          .order('order_position', { ascending: true });

        if (error) throw error;
        clients.value = data || [];
      } catch (error: any) {
        console.error('Error loading clients:', error.message);
      } finally {
        loading.value = false;
      }
    };

    onMounted(() => {
      loadClients();
    });

    return {
      loading,
      clients,
      getImageUrl,
    };
  },
});
</script>

<style scoped>
.clients-section {
  background-color: #f8f9fa;
}

.section-title {
  position: relative;
  display: inline-block;
  text-transform: uppercase;
  font-weight: 600;
  letter-spacing: 1px;
}

.clients-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 2rem;
  align-items: center;
  justify-items: center;
}

.client-item {
  width: 100%;
  max-width: 200px;
}

.client-logo-wrapper {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 120px;
}

.client-logo-wrapper:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
}

.client-logo {
  max-width: 100%;
  max-height: 80px;
  width: auto;
  height: auto;
  object-fit: contain;
  filter: grayscale(100%);
  opacity: 0.7;
  transition: all 0.3s ease;
}

.client-logo-wrapper:hover .client-logo {
  filter: grayscale(0%);
  opacity: 1;
}

.client-name-display {
  width: 100%;
  text-align: center;
  font-size: 1rem;
  font-weight: 600;
  color: #6c757d;
  padding: 1rem;
  transition: all 0.3s ease;
}

.client-logo-wrapper:hover .client-name-display {
  color: #495057;
  transform: scale(1.05);
}

@media (max-width: 768px) {
  .clients-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 1.5rem;
  }

  .client-item {
    max-width: 150px;
  }

  .client-logo-wrapper {
    padding: 1.5rem;
    min-height: 100px;
  }

  .client-logo {
    max-height: 60px;
  }
}

@media (max-width: 480px) {
  .clients-grid {
    grid-template-columns: 1fr;
  }
}
</style>
