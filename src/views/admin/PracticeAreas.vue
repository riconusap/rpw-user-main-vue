<template>
  <div class="practice-areas-page">
    <div class="page-header-admin">
      <h1>Practice Areas Management</h1>
      <button @click="openModal()" class="btn btn-primary">
        <i class="fas fa-plus"></i> Add Practice Area
      </button>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="loading">
      <i class="fas fa-spinner fa-spin"></i> Loading...
    </div>

    <!-- Practice Areas Grid -->
    <div v-else class="areas-grid">
      <div
        v-for="area in areas"
        :key="area.id"
        class="area-card"
        :class="{ inactive: !area.is_active, featured: area.is_featured }"
      >
        <div class="area-icon">
          <i :class="area.icon"></i>
        </div>
        <div class="area-content">
          <h3>{{ area.title }}</h3>
          <p class="slug">{{ area.slug }}</p>
          <p class="description">{{ area.description }}</p>
          <div class="area-meta">
            <span class="order-badge">Order: {{ area.order_position }}</span>
            <span v-if="area.is_featured" class="featured-badge">Featured</span>
            <span :class="['status-badge', area.is_active ? 'active' : 'inactive']">
              {{ area.is_active ? 'Active' : 'Inactive' }}
            </span>
          </div>
        </div>
        <div class="area-actions">
          <button @click="openModal(area)" class="btn-action btn-edit">
            <i class="fas fa-edit"></i>
          </button>
          <button @click="toggleFeatured(area)" class="btn-action btn-star">
            <i :class="area.is_featured ? 'fas fa-star' : 'far fa-star'"></i>
          </button>
          <button @click="toggleActive(area)" class="btn-action btn-toggle">
            <i :class="area.is_active ? 'fas fa-eye-slash' : 'fas fa-eye'"></i>
          </button>
          <button @click="deleteArea(area)" class="btn-action btn-delete">
            <i class="fas fa-trash"></i>
          </button>
        </div>
      </div>

      <div v-if="areas.length === 0" class="empty-state">
        <i class="fas fa-briefcase"></i>
        <p>No practice areas yet</p>
        <button @click="openModal()" class="btn btn-primary">Add Your First Area</button>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <div class="modal-header">
          <h2>{{ editingArea ? 'Edit Practice Area' : 'Add Practice Area' }}</h2>
          <button @click="closeModal" class="btn-close">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <form @submit.prevent="saveArea" class="modal-body">
          <div class="form-group">
            <label for="icon">Icon Class *</label>
            <input
              id="icon"
              v-model="formData.icon"
              type="text"
              class="form-control"
              required
              placeholder="fas fa-gavel"
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
              placeholder="Corporate Law"
              @input="generateSlug"
            />
          </div>

          <div class="form-group">
            <label for="slug">Slug *</label>
            <input
              id="slug"
              v-model="formData.slug"
              type="text"
              class="form-control"
              required
              placeholder="corporate-law"
              pattern="[a-z0-9-]+"
            />
            <small class="form-help">Lowercase letters, numbers, and hyphens only</small>
          </div>

          <div class="form-group">
            <label for="description">Description *</label>
            <textarea
              id="description"
              v-model="formData.description"
              class="form-control"
              rows="4"
              required
              placeholder="Comprehensive legal services for corporate matters..."
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

            <div class="form-group checkbox-group">
              <label class="checkbox-label">
                <input v-model="formData.is_featured" type="checkbox" />
                <span>Featured</span>
              </label>
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
              <span v-if="!saving">Save Area</span>
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

interface PracticeArea {
  id: string;
  icon: string;
  title: string;
  slug: string;
  description: string;
  order_position: number;
  is_featured: boolean;
  is_active: boolean;
}

interface FormData {
  icon: string;
  title: string;
  slug: string;
  description: string;
  order_position: number;
  is_featured: boolean;
  is_active: boolean;
}

export default defineComponent({
  name: 'AdminPracticeAreas',
  setup() {
    const loading = ref(false);
    const saving = ref(false);
    const showModal = ref(false);
    const editingArea = ref<PracticeArea | null>(null);
    const areas = ref<PracticeArea[]>([]);

    const formData = reactive<FormData>({
      icon: '',
      title: '',
      slug: '',
      description: '',
      order_position: 1,
      is_featured: false,
      is_active: true,
    });

    const loadAreas = async () => {
      loading.value = true;
      try {
        const { data, error } = await supabase
          .from('practice_areas')
          .select('*')
          .order('order_position', { ascending: true });

        if (error) throw error;
        areas.value = data || [];
      } catch (error: any) {
        alert('Error loading practice areas: ' + error.message);
      } finally {
        loading.value = false;
      }
    };

    const generateSlug = () => {
      if (!editingArea.value) {
        formData.slug = formData.title
          .toLowerCase()
          .replace(/[^a-z0-9]+/g, '-')
          .replace(/^-+|-+$/g, '');
      }
    };

    const openModal = (area?: PracticeArea) => {
      if (area) {
        editingArea.value = area;
        Object.assign(formData, {
          icon: area.icon,
          title: area.title,
          slug: area.slug,
          description: area.description,
          order_position: area.order_position,
          is_featured: area.is_featured,
          is_active: area.is_active,
        });
      } else {
        editingArea.value = null;
        Object.assign(formData, {
          icon: '',
          title: '',
          slug: '',
          description: '',
          order_position: areas.value.length + 1,
          is_featured: false,
          is_active: true,
        });
      }
      showModal.value = true;
    };

    const closeModal = () => {
      showModal.value = false;
      editingArea.value = null;
    };

    const saveArea = async () => {
      saving.value = true;
      try {
        const areaData = {
          icon: formData.icon,
          title: formData.title,
          slug: formData.slug,
          description: formData.description,
          order_position: formData.order_position,
          is_featured: formData.is_featured,
          is_active: formData.is_active,
        };

        if (editingArea.value) {
          const { error } = await supabase
            .from('practice_areas')
            .update(areaData)
            .eq('id', editingArea.value.id);

          if (error) throw error;
        } else {
          const { error } = await supabase.from('practice_areas').insert([areaData]);

          if (error) throw error;
        }

        await loadAreas();
        closeModal();
      } catch (error: any) {
        alert('Error saving practice area: ' + error.message);
      } finally {
        saving.value = false;
      }
    };

    const toggleFeatured = async (area: PracticeArea) => {
      try {
        const { error } = await supabase
          .from('practice_areas')
          .update({ is_featured: !area.is_featured })
          .eq('id', area.id);

        if (error) throw error;
        await loadAreas();
      } catch (error: any) {
        alert('Error updating area: ' + error.message);
      }
    };

    const toggleActive = async (area: PracticeArea) => {
      try {
        const { error } = await supabase
          .from('practice_areas')
          .update({ is_active: !area.is_active })
          .eq('id', area.id);

        if (error) throw error;
        await loadAreas();
      } catch (error: any) {
        alert('Error updating area: ' + error.message);
      }
    };

    const deleteArea = async (area: PracticeArea) => {
      if (!confirm(`Delete "${area.title}"?`)) return;

      try {
        const { error } = await supabase.from('practice_areas').delete().eq('id', area.id);

        if (error) throw error;
        await loadAreas();
      } catch (error: any) {
        alert('Error deleting area: ' + error.message);
      }
    };

    onMounted(() => {
      loadAreas();
    });

    return {
      loading,
      saving,
      showModal,
      editingArea,
      areas,
      formData,
      openModal,
      closeModal,
      saveArea,
      generateSlug,
      toggleFeatured,
      toggleActive,
      deleteArea,
    };
  },
});
</script>

<style scoped>
.practice-areas-page {
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

/* Areas Grid */
.areas-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
  gap: 1.5rem;
}

.area-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  display: flex;
  gap: 1.5rem;
  transition: transform 0.2s, box-shadow 0.2s;
  position: relative;
}

.area-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.area-card.inactive {
  opacity: 0.5;
}

.area-card.featured::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: #d4a948;
  border-radius: 12px 0 0 12px;
}

.area-icon {
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, #d4a948 0%, #c69840 100%);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.area-icon i {
  font-size: 1.75rem;
  color: white;
}

.area-content {
  flex: 1;
}

.area-content h3 {
  font-size: 1.25rem;
  color: #1e293b;
  margin-bottom: 0.25rem;
}

.slug {
  font-size: 0.75rem;
  color: #94a3b8;
  font-family: monospace;
  margin-bottom: 0.5rem;
}

.description {
  color: #64748b;
  font-size: 0.875rem;
  margin-bottom: 1rem;
  line-height: 1.6;
}

.area-meta {
  display: flex;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.order-badge,
.status-badge,
.featured-badge {
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 600;
}

.order-badge {
  background: #f1f5f9;
  color: #64748b;
}

.featured-badge {
  background: #fef3c7;
  color: #d97706;
}

.status-badge.active {
  background: #dcfce7;
  color: #22c55e;
}

.status-badge.inactive {
  background: #fee;
  color: #ef4444;
}

.area-actions {
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

.btn-star {
  background: #f59e0b;
}

.btn-star:hover {
  background: #d97706;
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

.checkbox-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem;
  background: #f8fafc;
  border-radius: 8px;
  cursor: pointer;
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
  .areas-grid {
    grid-template-columns: 1fr;
  }

  .form-row {
    grid-template-columns: 1fr;
  }

  .area-card {
    flex-direction: column;
  }

  .area-actions {
    flex-direction: row;
  }
}
</style>
