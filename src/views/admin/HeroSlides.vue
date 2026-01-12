<template>
  <div class="hero-slides-page">
    <div class="page-header">
      <h1>Hero Slides Management</h1>
      <button @click="openModal()" class="btn btn-primary">
        <i class="fas fa-plus"></i> Add New Slide
      </button>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="loading">
      <i class="fas fa-spinner fa-spin"></i> Loading...
    </div>

    <!-- Slides List -->
    <div v-else class="slides-grid">
      <div
        v-for="slide in slides"
        :key="slide.id"
        class="slide-card"
        :class="{ inactive: !slide.is_active }"
      >
        <div class="slide-image">
          <img :src="getImageUrl(slide.background_image)" :alt="slide.title" @error="(e) => (e.target as HTMLImageElement).src = '/img/bg1.jpg'" />
          <span v-if="!slide.is_active" class="badge-inactive">Inactive</span>
          <span class="badge-order">{{ slide.order_position }}</span>
        </div>

        <div class="slide-content">
          <h3>{{ slide.title }}</h3>
          <p v-if="slide.subtitle" class="subtitle">{{ slide.subtitle }}</p>
          <p class="description">{{ slide.description }}</p>

          <div class="slide-actions">
            <button @click="openModal(slide)" class="btn-action btn-edit">
              <i class="fas fa-edit"></i> Edit
            </button>
            <button @click="toggleActive(slide)" class="btn-action btn-toggle">
              <i :class="slide.is_active ? 'fas fa-eye-slash' : 'fas fa-eye'"></i>
              {{ slide.is_active ? 'Deactivate' : 'Activate' }}
            </button>
            <button @click="deleteSlide(slide)" class="btn-action btn-delete">
              <i class="fas fa-trash"></i> Delete
            </button>
          </div>
        </div>
      </div>

      <div v-if="slides.length === 0" class="empty-state">
        <i class="fas fa-image"></i>
        <p>No hero slides yet</p>
        <button @click="openModal()" class="btn btn-primary">Add Your First Slide</button>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <div class="modal-header">
          <h2>{{ editingSlide ? 'Edit Slide' : 'Add New Slide' }}</h2>
          <button @click="closeModal" class="btn-close">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <form @submit.prevent="saveSlide" class="modal-body">
          <div class="form-group">
            <label>Background Image *</label>
            <ImageUpload
              v-model="formData.background_image"
              folder="hero"
              :placeholder="'Upload hero image (1920x1080px recommended)'"
              :max-size="5"
            />
          </div>

          <div class="form-group">
            <label for="title">Title *</label>
            <input
              id="title"
              v-model="formData.title"
              type="text"
              class="form-control"
              required
              placeholder="We Provide Legal Solutions"
            />
          </div>

          <div class="form-group">
            <label for="subtitle">Subtitle</label>
            <input
              id="subtitle"
              v-model="formData.subtitle"
              type="text"
              class="form-control"
              placeholder="For Your Business"
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
              placeholder="Enter slide description"
            ></textarea>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="cta_text">CTA Button Text</label>
              <input
                id="cta_text"
                v-model="formData.cta_text"
                type="text"
                class="form-control"
                placeholder="Get A Quote"
              />
            </div>

            <div class="form-group">
              <label for="cta_link">CTA Button Link</label>
              <input
                id="cta_link"
                v-model="formData.cta_link"
                type="text"
                class="form-control"
                placeholder="/contact"
              />
            </div>
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
              <span v-if="!saving">Save Slide</span>
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

interface HeroSlide {
  id: string;
  title: string;
  subtitle: string | null;
  description: string;
  background_image: string;
  cta_text: string | null;
  cta_link: string | null;
  order_position: number;
  is_active: boolean;
}

interface FormData {
  title: string;
  subtitle: string;
  description: string;
  background_image: string;
  cta_text: string;
  cta_link: string;
  order_position: number;
  is_active: boolean;
}

export default defineComponent({
  name: 'AdminHeroSlides',
  components: {
    ImageUpload,
  },
  setup() {
    const loading = ref(false);
    const saving = ref(false);
    const showModal = ref(false);
    const editingSlide = ref<HeroSlide | null>(null);
    const slides = ref<HeroSlide[]>([]);

    const formData = reactive<FormData>({
      title: '',
      subtitle: '',
      description: '',
      background_image: '',
      cta_text: '',
      cta_link: '',
      order_position: 1,
      is_active: true,
    });

    const loadSlides = async () => {
      loading.value = true;
      try {
        const { data, error } = await supabase
          .from('hero_slides')
          .select('*')
          .order('order_position', { ascending: true });

        if (error) throw error;
        slides.value = data || [];
      } catch (error: any) {
        alert('Error loading slides: ' + error.message);
      } finally {
        loading.value = false;
      }
    };

    const openModal = (slide?: HeroSlide) => {
      if (slide) {
        editingSlide.value = slide;
        Object.assign(formData, {
          title: slide.title,
          subtitle: slide.subtitle || '',
          description: slide.description,
          background_image: slide.background_image,
          cta_text: slide.cta_text || '',
          cta_link: slide.cta_link || '',
          order_position: slide.order_position,
          is_active: slide.is_active,
        });
      } else {
        editingSlide.value = null;
        Object.assign(formData, {
          title: '',
          subtitle: '',
          description: '',
          background_image: '',
          cta_text: '',
          cta_link: '',
          order_position: slides.value.length + 1,
          is_active: true,
        });
      }
      showModal.value = true;
    };

    const closeModal = () => {
      showModal.value = false;
      editingSlide.value = null;
    };

    const saveSlide = async () => {
      if (!formData.background_image) {
        alert('Please upload a background image');
        return;
      }

      saving.value = true;
      try {
        const slideData = {
          title: formData.title,
          subtitle: formData.subtitle || null,
          description: formData.description,
          background_image: formData.background_image,
          cta_text: formData.cta_text || null,
          cta_link: formData.cta_link || null,
          order_position: formData.order_position,
          is_active: formData.is_active,
        };

        if (editingSlide.value) {
          // Update existing slide
          const { error } = await supabase
            .from('hero_slides')
            .update(slideData)
            .eq('id', editingSlide.value.id);

          if (error) throw error;
        } else {
          // Insert new slide
          const { error } = await supabase.from('hero_slides').insert([slideData]);

          if (error) throw error;
        }

        await loadSlides();
        closeModal();
      } catch (error: any) {
        alert('Error saving slide: ' + error.message);
      } finally {
        saving.value = false;
      }
    };

    const toggleActive = async (slide: HeroSlide) => {
      try {
        const { error } = await supabase
          .from('hero_slides')
          .update({ is_active: !slide.is_active })
          .eq('id', slide.id);

        if (error) throw error;
        await loadSlides();
      } catch (error: any) {
        alert('Error updating slide: ' + error.message);
      }
    };

    const deleteSlide = async (slide: HeroSlide) => {
      if (!confirm(`Are you sure you want to delete "${slide.title}"?`)) return;

      try {
        const { error } = await supabase.from('hero_slides').delete().eq('id', slide.id);

        if (error) throw error;
        await loadSlides();
      } catch (error: any) {
        alert('Error deleting slide: ' + error.message);
      }
    };

    onMounted(() => {
      loadSlides();
    });

    return {
      loading,
      saving,
      showModal,
      editingSlide,
      slides,
      formData,
      openModal,
      closeModal,
      saveSlide,
      toggleActive,
      deleteSlide,
      getImageUrl,
    };
  },
});
</script>

<style scoped>
.hero-slides-page {
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

/* Slides Grid */
.slides-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
  gap: 1.5rem;
}

.slide-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s, box-shadow 0.2s;
}

.slide-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.slide-card.inactive {
  opacity: 0.6;
}

.slide-image {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.slide-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.badge-inactive,
.badge-order {
  position: absolute;
  padding: 0.25rem 0.75rem;
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: 600;
}

.badge-inactive {
  top: 0.75rem;
  left: 0.75rem;
  background: #ef4444;
  color: white;
}

.badge-order {
  top: 0.75rem;
  right: 0.75rem;
  background: rgba(0, 0, 0, 0.7);
  color: white;
}

.slide-content {
  padding: 1.5rem;
}

.slide-content h3 {
  font-size: 1.25rem;
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.subtitle {
  color: #d4a948;
  font-weight: 500;
  margin-bottom: 0.5rem;
}

.description {
  color: #64748b;
  font-size: 0.875rem;
  margin-bottom: 1rem;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.slide-actions {
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
  max-width: 800px;
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
  .slides-grid {
    grid-template-columns: 1fr;
  }

  .form-row {
    grid-template-columns: 1fr;
  }

  .slide-actions {
    flex-direction: column;
  }

  .btn-action {
    width: 100%;
    justify-content: center;
  }
}
</style>
