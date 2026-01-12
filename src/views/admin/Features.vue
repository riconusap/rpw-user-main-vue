<template>
  <div class="features-page">
    <div class="page-header-admin">
      <h1>Features Management</h1>
      <button @click="openModal()" class="btn btn-primary">
        <i class="fas fa-plus"></i> Add New Feature
      </button>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="loading">
      <i class="fas fa-spinner fa-spin"></i> Loading...
    </div>

    <!-- Features Grid -->
    <div v-else class="features-grid">
      <div
        v-for="feature in features"
        :key="feature.id"
        class="feature-card"
        :class="{ inactive: !feature.is_active }"
      >
        <div class="feature-icon">
          <i :class="feature.icon"></i>
        </div>
        <div class="feature-content">
          <h3>{{ feature.title }}</h3>
          <p class="description">{{ feature.description }}</p>
          <div class="feature-meta">
            <span class="order-badge">Order: {{ feature.order_position }}</span>
            <span :class="['status-badge', feature.is_active ? 'active' : 'inactive']">
              {{ feature.is_active ? 'Active' : 'Inactive' }}
            </span>
          </div>
        </div>
        <div class="feature-actions">
          <button @click="openModal(feature)" class="btn-action btn-edit">
            <i class="fas fa-edit"></i>
          </button>
          <button @click="toggleActive(feature)" class="btn-action btn-toggle">
            <i :class="feature.is_active ? 'fas fa-eye-slash' : 'fas fa-eye'"></i>
          </button>
          <button @click="deleteFeature(feature)" class="btn-action btn-delete">
            <i class="fas fa-trash"></i>
          </button>
        </div>
      </div>

      <div v-if="features.length === 0" class="empty-state">
        <i class="fas fa-star"></i>
        <p>No features yet</p>
        <button @click="openModal()" class="btn btn-primary">Add Your First Feature</button>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <div class="modal-header">
          <h2>{{ editingFeature ? 'Edit Feature' : 'Add New Feature' }}</h2>
          <button @click="closeModal" class="btn-close">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <form @submit.prevent="saveFeature" class="modal-body">
          <div class="form-group">
            <label for="icon">Icon Class *</label>
            <input
              id="icon"
              v-model="formData.icon"
              type="text"
              class="form-control"
              required
              placeholder="fas fa-balance-scale"
            />
            <small class="form-help">
              Browse icons at
              <a href="https://fontawesome.com/icons" target="_blank">FontAwesome</a>
            </small>
            <div class="icon-preview">
              <i :class="formData.icon"></i>
            </div>
          </div>

          <div class="form-group">
            <label for="title">Title *</label>
            <input
              id="title"
              v-model="formData.title"
              type="text"
              class="form-control"
              required
              placeholder="Expert Legal Team"
            />
          </div>

          <div class="form-group">
            <label for="description">Description *</label>
            <textarea
              id="description"
              v-model="formData.description"
              class="form-control"
              rows="4"
              required
              placeholder="Our experienced attorneys provide expert legal advice"
            ></textarea>
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

            <div class="form-group">
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
              <span v-if="!saving">Save Feature</span>
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
import { supabase } from '@/lib/supabase';

interface Feature {
  id: string;
  icon: string;
  title: string;
  description: string;
  order_position: number;
  is_active: boolean;
}

interface FormData {
  icon: string;
  title: string;
  description: string;
  order_position: number;
  is_active: boolean;
}

export default defineComponent({
  name: 'AdminFeatures',
  setup() {
    const loading = ref(false);
    const saving = ref(false);
    const showModal = ref(false);
    const editingFeature = ref<Feature | null>(null);
    const features = ref<Feature[]>([]);

    const formData = reactive<FormData>({
      icon: '',
      title: '',
      description: '',
      order_position: 1,
      is_active: true,
    });

    const loadFeatures = async () => {
      loading.value = true;
      try {
        const { data, error } = await supabase
          .from('features')
          .select('*')
          .order('order_position', { ascending: true });

        if (error) throw error;
        features.value = data || [];
      } catch (error: any) {
        alert('Error loading features: ' + error.message);
      } finally {
        loading.value = false;
      }
    };

    const openModal = (feature?: Feature) => {
      if (feature) {
        editingFeature.value = feature;
        Object.assign(formData, {
          icon: feature.icon,
          title: feature.title,
          description: feature.description,
          order_position: feature.order_position,
          is_active: feature.is_active,
        });
      } else {
        editingFeature.value = null;
        Object.assign(formData, {
          icon: '',
          title: '',
          description: '',
          order_position: features.value.length + 1,
          is_active: true,
        });
      }
      showModal.value = true;
    };

    const closeModal = () => {
      showModal.value = false;
      editingFeature.value = null;
    };

    const saveFeature = async () => {
      saving.value = true;
      try {
        const featureData = {
          icon: formData.icon,
          title: formData.title,
          description: formData.description,
          order_position: formData.order_position,
          is_active: formData.is_active,
        };

        if (editingFeature.value) {
          const { error } = await supabase
            .from('features')
            .update(featureData)
            .eq('id', editingFeature.value.id);

          if (error) throw error;
        } else {
          const { error } = await supabase.from('features').insert([featureData]);

          if (error) throw error;
        }

        await loadFeatures();
        closeModal();
      } catch (error: any) {
        alert('Error saving feature: ' + error.message);
      } finally {
        saving.value = false;
      }
    };

    const toggleActive = async (feature: Feature) => {
      try {
        const { error } = await supabase
          .from('features')
          .update({ is_active: !feature.is_active })
          .eq('id', feature.id);

        if (error) throw error;
        await loadFeatures();
      } catch (error: any) {
        alert('Error updating feature: ' + error.message);
      }
    };

    const deleteFeature = async (feature: Feature) => {
      if (!confirm(`Delete "${feature.title}"?`)) return;

      try {
        const { error } = await supabase.from('features').delete().eq('id', feature.id);

        if (error) throw error;
        await loadFeatures();
      } catch (error: any) {
        alert('Error deleting feature: ' + error.message);
      }
    };

    onMounted(() => {
      loadFeatures();
    });

    return {
      loading,
      saving,
      showModal,
      editingFeature,
      features,
      formData,
      openModal,
      closeModal,
      saveFeature,
      toggleActive,
      deleteFeature,
    };
  },
});
</script>

<style scoped>
.features-page {
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

/* Features Grid */
.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 1.5rem;
}

.feature-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  display: flex;
  gap: 1.5rem;
  transition: transform 0.2s, box-shadow 0.2s;
  position: relative;
}

.feature-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.feature-card.inactive {
  opacity: 0.5;
}

.feature-icon {
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, #d4a948 0%, #c69840 100%);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.feature-icon i {
  font-size: 1.75rem;
  color: white;
}

.feature-content {
  flex: 1;
}

.feature-content h3 {
  font-size: 1.25rem;
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.description {
  color: #64748b;
  font-size: 0.875rem;
  margin-bottom: 1rem;
  line-height: 1.6;
}

.feature-meta {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.order-badge,
.status-badge {
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 600;
}

.order-badge {
  background: #f1f5f9;
  color: #64748b;
}

.status-badge.active {
  background: #dcfce7;
  color: #22c55e;
}

.status-badge.inactive {
  background: #fee;
  color: #ef4444;
}

.feature-actions {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.btn-action {
  width: 36px;
  height: 36px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  color: white;
}

.btn-edit {
  background: #3b82f6;
}

.btn-edit:hover {
  background: #2563eb;
}

.btn-toggle {
  background: #10b981;
}

.btn-toggle:hover {
  background: #059669;
}

.btn-delete {
  background: #ef4444;
}

.btn-delete:hover {
  background: #dc2626;
}

.empty-state {
  grid-column: 1 / -1;
  text-align: center;
  padding: 4rem 2rem;
  background: white;
  border-radius: 12px;
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
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 2rem;
}

.modal-content {
  background: white;
  border-radius: 12px;
  width: 100%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
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
  background: none;
  border: none;
  font-size: 1.5rem;
  color: #64748b;
  cursor: pointer;
  padding: 0.5rem;
}

.btn-close:hover {
  color: #1e293b;
}

.modal-body {
  padding: 1.5rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #1e293b;
}

.form-control {
  width: 100%;
  padding: 0.75rem;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  font-size: 1rem;
  transition: border-color 0.2s;
}

.form-control:focus {
  outline: none;
  border-color: #d4a948;
}

.form-help {
  display: block;
  margin-top: 0.5rem;
  font-size: 0.875rem;
  color: #64748b;
}

.form-help a {
  color: #3b82f6;
  text-decoration: none;
}

.form-help a:hover {
  text-decoration: underline;
}

.icon-preview {
  margin-top: 1rem;
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, #d4a948 0%, #c69840 100%);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.icon-preview i {
  font-size: 1.75rem;
  color: white;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem;
  background: #f8fafc;
  border-radius: 8px;
  cursor: pointer;
  height: fit-content;
}

.checkbox-label input {
  width: 20px;
  height: 20px;
  cursor: pointer;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  padding: 1.5rem;
  border-top: 1px solid #e2e8f0;
  margin-top: 1rem;
}

@media (max-width: 768px) {
  .features-grid {
    grid-template-columns: 1fr;
  }

  .form-row {
    grid-template-columns: 1fr;
  }

  .feature-card {
    flex-direction: column;
  }

  .feature-actions {
    flex-direction: row;
  }
}
</style>
