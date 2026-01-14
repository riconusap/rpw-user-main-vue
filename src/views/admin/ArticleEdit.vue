<template>
  <div class="article-edit-page">
    <div class="page-header-admin">
      <h1>{{ isEditing ? 'Edit Article' : 'Write New Article' }}</h1>
      <div class="header-actions">
        <router-link to="/admin/articles" class="btn btn-secondary">
          <i class="fas fa-arrow-left"></i> Back
        </router-link>
        <button @click="saveArticle(false)" class="btn btn-outline" :disabled="saving">
          <i class="fas fa-save"></i> Save as Draft
        </button>
        <button @click="saveArticle(true)" class="btn btn-primary" :disabled="saving">
          <i class="fas fa-paper-plane"></i>
          {{ isEditing ? 'Update & Publish' : 'Publish' }}
        </button>
      </div>
    </div>

    <form @submit.prevent="saveArticle(true)" class="article-form">
      <div class="form-row">
        <div class="main-column">
          <div class="form-group">
            <label for="title">Title *</label>
            <input
              id="title"
              v-model="formData.title"
              type="text"
              class="form-control"
              required
              placeholder="Article title..."
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
              placeholder="article-slug"
              pattern="[a-z0-9-]+"
            />
            <small class="form-help">Lowercase letters, numbers, and hyphens only</small>
          </div>

          <div class="form-group">
            <label for="excerpt">Excerpt *</label>
            <textarea
              id="excerpt"
              v-model="formData.excerpt"
              class="form-control"
              rows="3"
              required
              placeholder="Brief summary of the article..."
            ></textarea>
          </div>

          <div class="form-group">
            <label for="content">Content *</label>
            <TiptapEditor 
              v-model="formData.content"
              placeholder="Write your article content here... Use the toolbar to format your text."
            />
          </div>

          <!-- SEO Section -->
          <div class="section-header">
            <h3>SEO Settings</h3>
          </div>

          <div class="form-group">
            <label for="meta_title">Meta Title</label>
            <input
              id="meta_title"
              v-model="formData.meta_title"
              type="text"
              class="form-control"
              placeholder="SEO title (defaults to article title)"
              maxlength="60"
            />
            <small class="form-help">
              {{ formData.meta_title.length }}/60 characters
            </small>
          </div>

          <div class="form-group">
            <label for="meta_description">Meta Description</label>
            <textarea
              id="meta_description"
              v-model="formData.meta_description"
              class="form-control"
              rows="3"
              placeholder="SEO description (defaults to excerpt)"
              maxlength="160"
            ></textarea>
            <small class="form-help">
              {{ formData.meta_description.length }}/160 characters
            </small>
          </div>
        </div>

        <!-- Sidebar -->
        <div class="sidebar-column">
          <div class="sidebar-card">
            <h4>Featured Image</h4>
            <ImageUpload
              :key="formData.featured_image"
              v-model="formData.featured_image"
              :bucket="'images'"
              :folder="'articles'"
              :placeholder="'Upload featured image (1200x630px recommended)'"
              :max-size="3"
            />
            <small v-if="formData.featured_image" class="form-help">
              Current image: {{ formData.featured_image.split('/').pop() }}
            </small>
          </div>

          <div class="sidebar-card">
            <h4>Category</h4>
            <select v-model="formData.category_id" class="form-control">
              <option value="">Uncategorized</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">
                {{ cat.name }}
              </option>
            </select>
          </div>

          <div class="sidebar-card">
            <h4>Tags</h4>
            <div class="tags-input">
              <div class="tags-list">
                <span v-for="(tag, index) in tags" :key="index" class="tag">
                  {{ tag }}
                  <button type="button" @click="removeTag(index)" class="tag-remove">
                    ×
                  </button>
                </span>
              </div>
              <input
                v-model="newTag"
                type="text"
                class="form-control"
                placeholder="Add tag..."
                @keydown.enter.prevent="addTag"
              />
            </div>
          </div>

          <div class="sidebar-card">
            <h4>Settings</h4>
            <label class="checkbox-label">
              <input v-model="formData.is_featured" type="checkbox" />
              <span>Featured Article</span>
            </label>
          </div>

          <div v-if="saving" class="sidebar-card saving-status">
            <i class="fas fa-spinner fa-spin"></i> Saving...
          </div>
        </div>
      </div>
    </form>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { supabase } from '@/lib/supabase';
import ImageUpload from '@/components/ImageUpload.vue';
import TiptapEditor from '@/components/TiptapEditor.vue';

interface Category {
  id: string;
  name: string;
}

interface FormData {
  title: string;
  slug: string;
  excerpt: string;
  content: string;
  featured_image: string;
  category_id: string;
  meta_title: string;
  meta_description: string;
  is_featured: boolean;
}

export default defineComponent({
  name: 'AdminArticleEdit',
  components: {
    ImageUpload,
    TiptapEditor,
  },
  setup() {
    const route = useRoute();
    const router = useRouter();
    const saving = ref(false);
    const isEditing = ref(false);
    const articleId = ref('');
    const categories = ref<Category[]>([]);
    const tags = ref<string[]>([]);
    const newTag = ref('');

    const formData = reactive<FormData>({
      title: '',
      slug: '',
      excerpt: '',
      content: '',
      featured_image: '',
      category_id: '',
      meta_title: '',
      meta_description: '',
      is_featured: false,
    });

    const loadCategories = async () => {
      try {
        const { data, error } = await supabase
          .from('article_categories')
          .select('id, name')
          .order('name');

        if (error) throw error;
        categories.value = data || [];
      } catch (error: any) {
        console.error('Error loading categories:', error);
      }
    };

    const loadArticle = async (id: string) => {
      try {
        const { data, error } = await supabase
          .from('articles')
          .select('*')
          .eq('id', id)
          .single();

        if (error) throw error;

        if (data) {
          Object.assign(formData, {
            title: data.title,
            slug: data.slug,
            excerpt: data.excerpt,
            content: data.content,
            featured_image: data.featured_image || '',
            category_id: data.category_id || '',
            meta_title: data.meta_title || '',
            meta_description: data.meta_description || '',
            is_featured: data.is_featured || false,
          });

          if (data.tags && Array.isArray(data.tags)) {
            tags.value = data.tags;
          }

          // Log for debugging
          console.log('Article loaded:', data);
          console.log('Featured image path:', formData.featured_image);
        }
      } catch (error: any) {
        alert('Error loading article: ' + error.message);
        router.push('/admin/articles');
      }
    };

    const generateSlug = () => {
      if (!isEditing.value) {
        formData.slug = formData.title
          .toLowerCase()
          .replace(/[^a-z0-9]+/g, '-')
          .replace(/^-+|-+$/g, '');
      }
    };

    const addTag = () => {
      const tag = newTag.value.trim();
      if (tag && !tags.value.includes(tag)) {
        tags.value.push(tag);
        newTag.value = '';
      }
    };

    const removeTag = (index: number) => {
      tags.value.splice(index, 1);
    };

    const saveArticle = async (publish: boolean) => {
      saving.value = true;
      try {
        const articleData = {
          title: formData.title,
          slug: formData.slug,
          excerpt: formData.excerpt,
          content: formData.content,
          featured_image: formData.featured_image || null,
          category_id: formData.category_id || null,
          tags: tags.value.length > 0 ? tags.value : null,
          meta_title: formData.meta_title || null,
          meta_description: formData.meta_description || null,
          is_featured: formData.is_featured,
          is_published: publish,
          published_date: publish ? new Date().toISOString() : null,
        };

        if (isEditing.value) {
          const { error } = await supabase
            .from('articles')
            .update(articleData)
            .eq('id', articleId.value);

          if (error) throw error;
          alert('Article updated successfully!');
        } else {
          const { error } = await supabase.from('articles').insert([articleData]);

          if (error) throw error;
          alert('Article created successfully!');
        }

        router.push('/admin/articles');
      } catch (error: any) {
        alert('Error saving article: ' + error.message);
      } finally {
        saving.value = false;
      }
    };

    onMounted(async () => {
      await loadCategories();

      const id = route.params.id as string;
      if (id && id !== 'new') {
        isEditing.value = true;
        articleId.value = id;
        await loadArticle(id);
      }
    });

    // Watch for featured_image changes
    watch(() => formData.featured_image, (newVal) => {
      console.log('Featured image updated:', newVal);
    });

    return {
      saving,
      isEditing,
      categories,
      formData,
      tags,
      newTag,
      generateSlug,
      addTag,
      removeTag,
      saveArticle,
    };
  },
});
</script>

<style scoped>
.article-edit-page {
  max-width: 1400px;
}

.page-header-admin {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  flex-wrap: wrap;
  gap: 1rem;
}

.page-header-admin h1 {
  font-size: 2rem;
  color: #1e293b;
  margin: 0;
}

.header-actions {
  display: flex;
  gap: 0.75rem;
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
  text-decoration: none;
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

.btn-outline {
  background: white;
  color: #1e293b;
  border: 2px solid #e2e8f0;
}

.btn-outline:hover:not(:disabled) {
  border-color: #cbd5e1;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Form */
.article-form {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 350px;
  gap: 2rem;
}

.main-column {
  min-width: 0;
}

.section-header {
  margin: 2rem 0 1rem;
  padding-bottom: 0.75rem;
  border-bottom: 2px solid #e2e8f0;
}

.section-header h3 {
  font-size: 1.25rem;
  color: #1e293b;
  margin: 0;
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
  border-radius: 10px;
  font-size: 1rem;
  transition: all 0.2s ease;
  background: white;
}

.form-control:hover {
  border-color: #cbd5e1;
}

.form-control:focus {
  outline: none;
  border-color: #d4a948;
  box-shadow: 0 0 0 3px rgba(212, 169, 72, 0.1);
}

select.form-control {
  cursor: pointer;
  padding-right: 2.5rem;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23d4a948' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 0.75rem center;
  background-size: 16px;
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  font-weight: 500;
  color: #1e293b;
}

.content-editor {
  font-size: 0.875rem;
  line-height: 1.6;
}

.form-help {
  display: block;
  margin-top: 0.5rem;
  font-size: 0.875rem;
  color: #64748b;
}

/* Sidebar */
.sidebar-column {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.sidebar-card {
  background: #f8fafc;
  padding: 1.5rem;
  border-radius: 12px;
}

.sidebar-card h4 {
  font-size: 1rem;
  color: #1e293b;
  margin: 0 0 1rem 0;
}

.sidebar-card .form-control {
  background: white;
}

.saving-status {
  text-align: center;
  color: #d4a948;
  font-weight: 500;
}

/* Tags */
.tags-input {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.tags-list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.tag {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.25rem 0.75rem;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  font-size: 0.875rem;
  color: #1e293b;
}

.tag-remove {
  background: none;
  border: none;
  font-size: 1.25rem;
  line-height: 1;
  color: #94a3b8;
  cursor: pointer;
  padding: 0;
}

.tag-remove:hover {
  color: #ef4444;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem;
  background: white;
  border-radius: 8px;
  cursor: pointer;
}

.checkbox-label input {
  width: 20px;
  height: 20px;
  cursor: pointer;
}

@media (max-width: 1024px) {
  .form-row {
    grid-template-columns: 1fr;
  }

  .sidebar-column {
    order: -1;
  }
}
</style>
