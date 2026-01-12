<template>
  <div class="attorneys-page">
    <div class="page-header">
      <h1>Attorneys Management</h1>
      <button @click="openModal()" class="btn btn-primary">
        <i class="fas fa-plus"></i> Add Attorney
      </button>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="loading">
      <i class="fas fa-spinner fa-spin"></i> Loading...
    </div>

    <!-- Attorneys Grid -->
    <div v-else class="attorneys-grid">
      <div
        v-for="attorney in attorneys"
        :key="attorney.id"
        class="attorney-card"
        :class="{ inactive: !attorney.is_active, founder: attorney.is_founder }"
      >
        <div class="attorney-photo">
          <img
            v-if="attorney.photo"
            :src="getImageUrl(attorney.photo)"
            :alt="attorney.full_name"
            @error="(e) => (e.target as HTMLImageElement).src = '/img/user.jpg'"
          />
          <div v-else class="photo-placeholder">
            <i class="fas fa-user"></i>
          </div>
          <div class="badges">
            <span v-if="attorney.is_founder" class="badge founder">Founder</span>
            <span v-if="attorney.is_featured" class="badge featured">Featured</span>
          </div>
        </div>

        <div class="attorney-content">
          <h3>{{ attorney.full_name }}</h3>
          <p class="position">{{ attorney.position }}</p>
          <p v-if="attorney.bio" class="bio">{{ truncateBio(attorney.bio) }}</p>

          <div class="attorney-meta">
            <span v-if="attorney.experience_years" class="meta-item">
              <i class="fas fa-briefcase"></i> {{ attorney.experience_years }} years
            </span>
            <span v-if="attorney.languages" class="meta-item">
              <i class="fas fa-language"></i> {{ attorney.languages }}
            </span>
          </div>

          <div class="attorney-actions">
            <button @click="openModal(attorney)" class="btn-action btn-edit">
              <i class="fas fa-edit"></i> Edit
            </button>
            <button @click="toggleActive(attorney)" class="btn-action btn-toggle">
              <i :class="attorney.is_active ? 'fas fa-eye-slash' : 'fas fa-eye'"></i>
              {{ attorney.is_active ? 'Deactivate' : 'Activate' }}
            </button>
            <button @click="deleteAttorney(attorney)" class="btn-action btn-delete">
              <i class="fas fa-trash"></i> Delete
            </button>
          </div>
        </div>
      </div>

      <div v-if="attorneys.length === 0" class="empty-state">
        <i class="fas fa-user-tie"></i>
        <p>No attorneys yet</p>
        <button @click="openModal()" class="btn btn-primary">Add Your First Attorney</button>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <div class="modal-header">
          <h2>{{ editingAttorney ? 'Edit Attorney' : 'Add Attorney' }}</h2>
          <button @click="closeModal" class="btn-close">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <form @submit.prevent="saveAttorney" class="modal-body">
          <div class="form-group">
            <label>Photo</label>
            <ImageUpload
              v-model="formData.photo"
              folder="attorneys"
              :placeholder="'Upload attorney photo (square, 500x500px recommended)'"
              :max-size="3"
            />
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="full_name">Full Name *</label>
              <input
                id="full_name"
                v-model="formData.full_name"
                type="text"
                class="form-control"
                required
                placeholder="John Doe, S.H."
              />
            </div>

            <div class="form-group">
              <label for="position">Position *</label>
              <input
                id="position"
                v-model="formData.position"
                type="text"
                class="form-control"
                required
                placeholder="Senior Associate"
              />
            </div>
          </div>

          <div class="form-group">
            <label for="bio">Biography</label>
            <textarea
              id="bio"
              v-model="formData.bio"
              class="form-control"
              rows="4"
              placeholder="Brief biography and experience..."
            ></textarea>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="experience_years">Experience (Years)</label>
              <input
                id="experience_years"
                v-model.number="formData.experience_years"
                type="number"
                class="form-control"
                min="0"
                placeholder="10"
              />
            </div>

            <div class="form-group">
              <label for="languages">Languages</label>
              <input
                id="languages"
                v-model="formData.languages"
                type="text"
                class="form-control"
                placeholder="Indonesian, English"
              />
            </div>
          </div>

          <div class="form-group">
            <label for="bar_admission">Bar Admission</label>
            <input
              id="bar_admission"
              v-model="formData.bar_admission"
              type="text"
              class="form-control"
              placeholder="Indonesian Bar Association"
            />
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="email">Email</label>
              <input
                id="email"
                v-model="formData.email"
                type="email"
                class="form-control"
                placeholder="john@rpwadvocates.com"
              />
            </div>

            <div class="form-group">
              <label for="phone">Phone</label>
              <input
                id="phone"
                v-model="formData.phone"
                type="text"
                class="form-control"
                placeholder="+62-21-XXXXXXX"
              />
            </div>
          </div>

          <div class="form-group">
            <label for="linkedin_url">LinkedIn URL</label>
            <input
              id="linkedin_url"
              v-model="formData.linkedin_url"
              type="url"
              class="form-control"
              placeholder="https://linkedin.com/in/username"
            />
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
                <input v-model="formData.is_founder" type="checkbox" />
                <span>Founder</span>
              </label>
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
              <span v-if="!saving">Save Attorney</span>
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

interface Attorney {
  id: string;
  full_name: string;
  position: string;
  photo: string | null;
  bio: string | null;
  experience_years: number | null;
  languages: string | null;
  bar_admission: string | null;
  email: string | null;
  phone: string | null;
  linkedin_url: string | null;
  order_position: number;
  is_founder: boolean;
  is_featured: boolean;
  is_active: boolean;
}

interface FormData {
  full_name: string;
  position: string;
  photo: string;
  bio: string;
  experience_years: number | null;
  languages: string;
  bar_admission: string;
  email: string;
  phone: string;
  linkedin_url: string;
  order_position: number;
  is_founder: boolean;
  is_featured: boolean;
  is_active: boolean;
}

export default defineComponent({
  name: 'AdminAttorneys',
  components: {
    ImageUpload,
  },
  setup() {
    const loading = ref(false);
    const saving = ref(false);
    const showModal = ref(false);
    const editingAttorney = ref<Attorney | null>(null);
    const attorneys = ref<Attorney[]>([]);

    const formData = reactive<FormData>({
      full_name: '',
      position: '',
      photo: '',
      bio: '',
      experience_years: null,
      languages: '',
      bar_admission: '',
      email: '',
      phone: '',
      linkedin_url: '',
      order_position: 1,
      is_founder: false,
      is_featured: false,
      is_active: true,
    });

    const loadAttorneys = async () => {
      loading.value = true;
      try {
        const { data, error } = await supabase
          .from('attorneys')
          .select('*')
          .order('order_position', { ascending: true });

        if (error) throw error;
        attorneys.value = data || [];
      } catch (error: any) {
        alert('Error loading attorneys: ' + error.message);
      } finally {
        loading.value = false;
      }
    };

    const truncateBio = (bio: string) => {
      return bio.length > 150 ? bio.substring(0, 150) + '...' : bio;
    };

    const openModal = (attorney?: Attorney) => {
      if (attorney) {
        editingAttorney.value = attorney;
        Object.assign(formData, {
          full_name: attorney.full_name,
          position: attorney.position,
          photo: attorney.photo || '',
          bio: attorney.bio || '',
          experience_years: attorney.experience_years,
          languages: attorney.languages || '',
          bar_admission: attorney.bar_admission || '',
          email: attorney.email || '',
          phone: attorney.phone || '',
          linkedin_url: attorney.linkedin_url || '',
          order_position: attorney.order_position,
          is_founder: attorney.is_founder,
          is_featured: attorney.is_featured,
          is_active: attorney.is_active,
        });
      } else {
        editingAttorney.value = null;
        Object.assign(formData, {
          full_name: '',
          position: '',
          photo: '',
          bio: '',
          experience_years: null,
          languages: '',
          bar_admission: '',
          email: '',
          phone: '',
          linkedin_url: '',
          order_position: attorneys.value.length + 1,
          is_founder: false,
          is_featured: false,
          is_active: true,
        });
      }
      showModal.value = true;
    };

    const closeModal = () => {
      showModal.value = false;
      editingAttorney.value = null;
    };

    const saveAttorney = async () => {
      saving.value = true;
      try {
        const attorneyData = {
          full_name: formData.full_name,
          position: formData.position,
          photo: formData.photo || null,
          bio: formData.bio || null,
          experience_years: formData.experience_years,
          languages: formData.languages || null,
          bar_admission: formData.bar_admission || null,
          email: formData.email || null,
          phone: formData.phone || null,
          linkedin_url: formData.linkedin_url || null,
          order_position: formData.order_position,
          is_founder: formData.is_founder,
          is_featured: formData.is_featured,
          is_active: formData.is_active,
        };

        if (editingAttorney.value) {
          const { error } = await supabase
            .from('attorneys')
            .update(attorneyData)
            .eq('id', editingAttorney.value.id);

          if (error) throw error;
        } else {
          const { error } = await supabase.from('attorneys').insert([attorneyData]);

          if (error) throw error;
        }

        await loadAttorneys();
        closeModal();
      } catch (error: any) {
        alert('Error saving attorney: ' + error.message);
      } finally {
        saving.value = false;
      }
    };

    const toggleActive = async (attorney: Attorney) => {
      try {
        const { error } = await supabase
          .from('attorneys')
          .update({ is_active: !attorney.is_active })
          .eq('id', attorney.id);

        if (error) throw error;
        await loadAttorneys();
      } catch (error: any) {
        alert('Error updating attorney: ' + error.message);
      }
    };

    const deleteAttorney = async (attorney: Attorney) => {
      if (!confirm(`Delete "${attorney.full_name}"?`)) return;

      try {
        const { error } = await supabase.from('attorneys').delete().eq('id', attorney.id);

        if (error) throw error;
        await loadAttorneys();
      } catch (error: any) {
        alert('Error deleting attorney: ' + error.message);
      }
    };

    onMounted(() => {
      loadAttorneys();
    });

    return {
      loading,
      saving,
      showModal,
      editingAttorney,
      attorneys,
      formData,
      openModal,
      closeModal,
      saveAttorney,
      toggleActive,
      deleteAttorney,
      truncateBio,
      getImageUrl,
    };
  },
});
</script>

<style scoped>
.attorneys-page {
  max-width: 1400px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.page-header h1 {
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

/* Attorneys Grid */
.attorneys-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 1.5rem;
}

.attorney-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s, box-shadow 0.2s;
}

.attorney-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.attorney-card.inactive {
  opacity: 0.5;
}

.attorney-card.founder {
  border: 2px solid #d4a948;
}

.attorney-photo {
  position: relative;
  height: 300px;
  overflow: hidden;
  background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
}

.attorney-photo img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.photo-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.photo-placeholder i {
  font-size: 5rem;
  color: #cbd5e1;
}

.badges {
  position: absolute;
  top: 1rem;
  left: 1rem;
  display: flex;
  gap: 0.5rem;
  flex-direction: column;
  align-items: flex-start;
}

.badge {
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 600;
}

.badge.founder {
  background: #d4a948;
  color: white;
}

.badge.featured {
  background: #3b82f6;
  color: white;
}

.attorney-content {
  padding: 1.5rem;
}

.attorney-content h3 {
  font-size: 1.25rem;
  color: #1e293b;
  margin-bottom: 0.25rem;
}

.position {
  color: #d4a948;
  font-weight: 500;
  margin-bottom: 0.75rem;
}

.bio {
  color: #64748b;
  font-size: 0.875rem;
  line-height: 1.6;
  margin-bottom: 1rem;
}

.attorney-meta {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
  margin-bottom: 1rem;
  padding-top: 1rem;
  border-top: 1px solid #e2e8f0;
}

.meta-item {
  font-size: 0.875rem;
  color: #64748b;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.meta-item i {
  color: #d4a948;
}

.attorney-actions {
  display: flex;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.btn-action {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 6px;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.2s;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
}

.btn-edit {
  background: #3b82f6;
  color: white;
}

.btn-edit:hover {
  background: #2563eb;
}

.btn-toggle {
  background: #10b981;
  color: white;
}

.btn-toggle:hover {
  background: #059669;
}

.btn-delete {
  background: #ef4444;
  color: white;
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
  max-width: 700px;
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
  padding: 0.5rem 0.75rem;
  background: #f8fafc;
  border-radius: 8px;
  cursor: pointer;
}

.checkbox-label input {
  width: 18px;
  height: 18px;
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
  .attorneys-grid {
    grid-template-columns: 1fr;
  }

  .form-row {
    grid-template-columns: 1fr;
  }

  .attorney-actions {
    flex-direction: column;
  }

  .btn-action {
    width: 100%;
    justify-content: center;
  }
}
</style>
