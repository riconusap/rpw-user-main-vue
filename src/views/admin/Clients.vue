<template>
  <div class="clients-page">
    <div class="page-header-admin">
      <h1>Clients Management</h1>
      <button @click="openModal()" class="btn btn-primary">
        <i class="fas fa-plus"></i> Add Client
      </button>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="loading">
      <i class="fas fa-spinner fa-spin"></i> Loading...
    </div>

    <!-- Clients Grid -->
    <div v-else class="clients-grid">
      <div
        v-for="client in clients"
        :key="client.id"
        class="client-card"
        :class="{ inactive: !client.is_active }"
      >
        <div class="client-logo">
          <img v-if="client.logo_url" :src="getImageUrl(client.logo_url, 'clients')" :alt="client.name" />
          <div v-else class="logo-placeholder">
            <i class="fas fa-building"></i>
          </div>
        </div>
        <div class="client-content">
          <h3>{{ client.name }}</h3>
          <div class="client-meta">
            <span class="order-badge">Order: {{ client.order_position }}</span>
            <span :class="['status-badge', client.is_active ? 'active' : 'inactive']">
              {{ client.is_active ? 'Active' : 'Inactive' }}
            </span>
          </div>
        </div>
        <div class="client-actions">
          <button @click="openModal(client)" class="btn-action btn-edit">
            <i class="fas fa-edit"></i>
          </button>
          <button @click="toggleActive(client)" class="btn-action btn-toggle">
            <i :class="client.is_active ? 'fas fa-eye-slash' : 'fas fa-eye'"></i>
          </button>
          <button @click="deleteClient(client)" class="btn-action btn-delete">
            <i class="fas fa-trash"></i>
          </button>
        </div>
      </div>

      <div v-if="clients.length === 0" class="empty-state">
        <i class="fas fa-briefcase"></i>
        <p>No clients yet</p>
        <button @click="openModal()" class="btn btn-primary">Add Your First Client</button>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <div class="modal-header">
          <h2>{{ editingClient ? 'Edit Client' : 'Add Client' }}</h2>
          <button @click="closeModal" class="btn-close">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <form @submit.prevent="saveClient" class="modal-body">
          <div class="form-group">
            <label for="name">Client Name *</label>
            <input
              id="name"
              v-model="formData.name"
              type="text"
              class="form-control"
              required
              placeholder="Company Name"
            />
          </div>

          <div class="form-group">
            <label>Logo *</label>
            <ImageUpload
              v-model="formData.logo_url"
              :bucket="'clients'"
              :label="'Upload Logo'"
            />
            <small class="form-help">Recommended: PNG with transparent background, max 500KB</small>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="order">Order Position *</label>
              <input
                id="order"
                v-model.number="formData.order_position"
                type="number"
                class="form-control"
                required
                min="0"
              />
            </div>
          </div>

          <div class="form-row w-100">
            <div class="checkbox-group">
              <label class="checkbox-label">
                <input v-model="formData.is_active" type="checkbox" />
                <span>Active</span>
              </label>
            </div>
          </div>

          <div class="modal-footer">
            <button type="button" @click="closeModal" class="btn btn-secondary">
              Cancel
            </button>
            <button type="submit" class="btn btn-primary" :disabled="saving">
              <span v-if="!saving">Save Client</span>
              <span v-else><i class="fas fa-spinner fa-spin"></i> Saving...</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, reactive } from 'vue';
import { supabase, getImageUrl } from '@/lib/supabase';
import ImageUpload from '@/components/ImageUpload.vue';

interface Client {
  id: string;
  name: string;
  logo_url: string;
  order_position: number;
  is_active: boolean;
  created_at?: string;
  updated_at?: string;
}

interface FormData {
  name: string;
  logo_url: string;
  order_position: number;
  is_active: boolean;
}

export default defineComponent({
  name: 'AdminClients',
  components: {
    ImageUpload,
  },
  setup() {
    const loading = ref(false);
    const saving = ref(false);
    const showModal = ref(false);
    const editingClient = ref<Client | null>(null);
    const clients = ref<Client[]>([]);

    const formData = reactive<FormData>({
      name: '',
      logo_url: '',
      order_position: 1,
      is_active: true,
    });

    const loadClients = async () => {
      loading.value = true;
      try {
        const { data, error } = await supabase
          .from('clients')
          .select('*')
          .order('order_position', { ascending: true });

        if (error) throw error;
        clients.value = data || [];
      } catch (error: any) {
        alert('Error loading clients: ' + error.message);
      } finally {
        loading.value = false;
      }
    };

    const openModal = (client?: Client) => {
      if (client) {
        editingClient.value = client;
        Object.assign(formData, {
          name: client.name,
          logo_url: client.logo_url,
          order_position: client.order_position,
          is_active: client.is_active,
        });
      } else {
        editingClient.value = null;
        Object.assign(formData, {
          name: '',
          logo_url: '',
          order_position: clients.value.length + 1,
          is_active: true,
        });
      }
      showModal.value = true;
    };

    const closeModal = () => {
      showModal.value = false;
      editingClient.value = null;
    };

    const saveClient = async () => {
      if (!formData.logo_url) {
        alert('Please upload a logo');
        return;
      }

      saving.value = true;
      try {
        const clientData = {
          name: formData.name,
          logo_url: formData.logo_url,
          order_position: formData.order_position,
          is_active: formData.is_active,
        };

        if (editingClient.value) {
          const { error } = await supabase
            .from('clients')
            .update(clientData)
            .eq('id', editingClient.value.id);

          if (error) throw error;
        } else {
          const { error } = await supabase.from('clients').insert([clientData]);

          if (error) throw error;
        }

        await loadClients();
        closeModal();
      } catch (error: any) {
        alert('Error saving client: ' + error.message);
      } finally {
        saving.value = false;
      }
    };

    const toggleActive = async (client: Client) => {
      try {
        const { error } = await supabase
          .from('clients')
          .update({ is_active: !client.is_active })
          .eq('id', client.id);

        if (error) throw error;
        await loadClients();
      } catch (error: any) {
        alert('Error updating client: ' + error.message);
      }
    };

    const deleteClient = async (client: Client) => {
      if (!confirm(`Delete "${client.name}"?`)) return;

      try {
        const { error } = await supabase.from('clients').delete().eq('id', client.id);

        if (error) throw error;
        await loadClients();
      } catch (error: any) {
        alert('Error deleting client: ' + error.message);
      }
    };

    onMounted(() => {
      loadClients();
    });

    return {
      loading,
      saving,
      showModal,
      editingClient,
      clients,
      formData,
      openModal,
      closeModal,
      saveClient,
      toggleActive,
      deleteClient,
      getImageUrl,
    };
  },
});
</script>

<style scoped>
.clients-page {
  max-width: 1400px;
}

.page-header-admin {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.page-header-admin h1 {
  font-size: 2rem;
  color: #1e293b;
  margin: 0;
}

.btn {
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  border: none;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
}

.btn-primary {
  background: #d4a948;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background: #c69840;
}

.btn-secondary {
  background: #e2e8f0;
  color: #1e293b;
}

.btn-secondary:hover {
  background: #cbd5e1;
}

.loading {
  text-align: center;
  padding: 3rem;
  color: #64748b;
}

/* Clients Grid */
.clients-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
  gap: 1.5rem;
}

.client-card {
  background: white;
  border-radius: 16px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  border: 1px solid #f1f5f9;
  display: grid;
  grid-template-columns: auto 1fr auto;
  gap: 1.5rem;
  transition: all 0.3s ease;
  align-items: center;
  position: relative;
}

.client-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.12);
  border-color: #e2e8f0;
}

.client-card.inactive {
  opacity: 0.5;
  background: #fafafa;
}

.client-card.inactive::after {
  content: 'Inactive';
  position: absolute;
  top: 0.75rem;
  right: 0.75rem;
  background: #ef4444;
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 20px;
  font-size: 0.7rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.client-logo {
  flex-shrink: 0;
  width: 100px;
  height: 100px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #ffffff;
  border: 2px solid #f1f5f9;
  border-radius: 12px;
  overflow: hidden;
  padding: 0.75rem;
  transition: all 0.3s ease;
}

.client-card:hover .client-logo {
  border-color: #d4a948;
  box-shadow: 0 0 0 4px rgba(212, 169, 72, 0.1);
}

.client-logo img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  transition: transform 0.3s ease;
}

.client-card:hover .client-logo img {
  transform: scale(1.05);
}

.logo-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #cbd5e1;
  font-size: 2.5rem;
}

.client-content {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.client-content h3 {
  font-size: 1.25rem;
  color: #1e293b;
  margin: 0;
  font-weight: 700;
  line-height: 1.3;
  word-wrap: break-word;
  overflow-wrap: break-word;
}

.client-meta {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
  align-items: center;
}

.order-badge {
  background: #eff6ff;
  color: #1e40af;
  padding: 0.375rem 0.875rem;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 600;
  border: 1px solid #bfdbfe;
}

.status-badge {
  padding: 0.375rem 0.875rem;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 600;
  border: 1px solid;
}

.status-badge.active {
  background: #d1fae5;
  color: #065f46;
  border-color: #6ee7b7;
}

.status-badge.inactive {
  background: #fee2e2;
  color: #991b1b;
  border-color: #fca5a5;
}

.client-actions {
  display: flex;
  gap: 0.625rem;
  flex-shrink: 0;
  flex-direction: column;
}

.btn-action {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  border: 2px solid transparent;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  background: #f8fafc;
  color: #64748b;
  font-size: 1rem;
}

.btn-action:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.btn-edit {
  background: #eff6ff;
  color: #1e40af;
}

.btn-edit:hover {
  background: #dbeafe;
  border-color: #93c5fd;
  color: #1e3a8a;
}

.btn-toggle {
  background: #fef3c7;
  color: #92400e;
}

.btn-toggle:hover {
  background: #fde68a;
  border-color: #fcd34d;
  color: #78350f;
}

.btn-delete {
  background: #fee2e2;
  color: #991b1b;
}

.btn-delete:hover {
  background: #fecaca;
  border-color: #fca5a5;
  color: #7f1d1d;
}

/* Empty State */
.empty-state {
  grid-column: 1 / -1;
  text-align: center;
  padding: 4rem 2rem;
  background: white;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.empty-state i {
  font-size: 4rem;
  color: #cbd5e1;
  margin-bottom: 1rem;
}

.empty-state p {
  color: #64748b;
  margin-bottom: 1.5rem;
}

/* Modal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 1rem;
}

.modal-content {
  background: white;
  border-radius: 16px;
  max-width: 600px;
  width: 100%;
  max-height: 90vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #e2e8f0;
}

.modal-header h2 {
  font-size: 1.5rem;
  color: #1e293b;
  margin: 0;
}

.btn-close {
  width: 36px;
  height: 36px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f8fafc;
  color: #64748b;
  transition: all 0.2s;
}

.btn-close:hover {
  background: #fee2e2;
  color: #991b1b;
}

.modal-body {
  padding: 1.5rem;
  overflow-y: auto;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: #334155;
  font-weight: 500;
}

.form-control {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  font-size: 1rem;
  transition: all 0.2s;
}

.form-control:focus {
  outline: none;
  border-color: #d4a948;
  box-shadow: 0 0 0 3px rgba(212, 169, 72, 0.1);
}

.form-help {
  display: block;
  margin-top: 0.5rem;
  color: #64748b;
  font-size: 0.875rem;
}

.form-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.form-row.w-100 {
  grid-template-columns: 1fr;
}

.checkbox-group {
  display: flex;
  gap: 1.5rem;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
  user-select: none;
}

.checkbox-label input[type='checkbox'] {
  width: 18px;
  height: 18px;
  cursor: pointer;
}

.modal-footer {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  padding: 1.5rem;
  border-top: 1px solid #e2e8f0;
  background: #f8fafc;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

@media (max-width: 768px) {
  .clients-grid {
    grid-template-columns: 1fr;
  }

  .modal-content {
    max-width: 100%;
    margin: 0;
    border-radius: 0;
    max-height: 100vh;
  }

  .client-card {
    grid-template-columns: auto 1fr;
    grid-template-rows: auto auto;
    gap: 1rem;
    padding: 1.5rem;
  }

  .client-logo {
    width: 80px;
    height: 80px;
  }

  .client-content {
    grid-column: 2;
    grid-row: 1;
  }

  .client-actions {
    grid-column: 1 / -1;
    grid-row: 2;
    flex-direction: row;
    justify-content: center;
    gap: 1rem;
    margin-top: 0.5rem;
  }

  .btn-action {
    width: 48px;
    height: 48px;
  }
}

@media (max-width: 480px) {
  .client-card {
    grid-template-columns: 1fr;
    text-align: center;
  }

  .client-logo {
    margin: 0 auto;
  }

  .client-content {
    grid-column: 1;
    grid-row: 2;
  }

  .client-meta {
    justify-content: center;
  }

  .client-actions {
    grid-row: 3;
  }
}
</style>
