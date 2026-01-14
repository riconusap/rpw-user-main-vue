<template>
  <div class="articles-page">
    <div class="page-header-admin">
      <h1>Articles Management</h1>
      <router-link to="/admin/articles/new" class="btn btn-primary">
        <i class="fas fa-plus"></i> Write New Article
      </router-link>
    </div>

    <!-- Filters -->
    <div class="filters">
      <select v-model="filterStatus" class="filter-select">
        <option value="all">All Status</option>
        <option value="published">Published</option>
        <option value="draft">Draft</option>
      </select>
      <select v-model="filterCategory" class="filter-select">
        <option value="all">All Categories</option>
        <option v-for="cat in categories" :key="cat.id" :value="cat.id">
          {{ cat.name }}
        </option>
      </select>
      <input
        v-model="searchQuery"
        type="text"
        placeholder="Search articles..."
        class="search-input"
      />
    </div>

    <!-- Loading -->
    <div v-if="loading" class="loading">
      <i class="fas fa-spinner fa-spin"></i> Loading articles...
    </div>

    <!-- Articles List -->
    <div v-else class="articles-list">
      <div
        v-for="article in filteredArticles"
        :key="article.id"
        class="article-card"
        :class="{ draft: !article.is_published, featured: article.is_featured }"
      >
        <div class="article-image">
          <img
            v-if="article.featured_image"
            :src="getImageUrl(article.featured_image)"
            :alt="article.title"
            @error="handleImageError"
          />
          <div v-else class="image-placeholder">
            <i class="fas fa-newspaper"></i>
          </div>
          <div class="badges">
            <span v-if="article.is_featured" class="badge featured">Featured</span>
            <span :class="['badge', 'status', article.is_published ? 'published' : 'draft']">
              {{ article.is_published ? 'Published' : 'Draft' }}
            </span>
          </div>
        </div>

        <div class="article-content">
          <div class="article-meta">
            <span class="category">{{ getCategoryName(article.category_id) }}</span>
            <span class="date">{{ formatDate(article.created_at) }}</span>
          </div>

          <h3>{{ article.title }}</h3>
          <p class="excerpt">{{ article.excerpt }}</p>

          <div class="article-stats">
            <span class="stat">
              <i class="fas fa-eye"></i> {{ article.views_count || 0 }} views
            </span>
            <span v-if="article.reading_time" class="stat">
              <i class="fas fa-clock"></i> {{ article.reading_time }} min read
            </span>
          </div>

          <div class="article-actions">
            <router-link
              :to="`/admin/articles/edit/${article.id}`"
              class="btn-action btn-edit"
            >
              <i class="fas fa-edit"></i> Edit
            </router-link>
            <button @click="togglePublished(article)" class="btn-action btn-toggle">
              <i :class="article.is_published ? 'fas fa-eye-slash' : 'fas fa-eye'"></i>
              {{ article.is_published ? 'Unpublish' : 'Publish' }}
            </button>
            <button @click="toggleFeatured(article)" class="btn-action btn-star">
              <i :class="article.is_featured ? 'fas fa-star' : 'far fa-star'"></i>
            </button>
            <button @click="deleteArticle(article)" class="btn-action btn-delete">
              <i class="fas fa-trash"></i>
            </button>
          </div>
        </div>
      </div>

      <div v-if="filteredArticles.length === 0" class="empty-state">
        <i class="fas fa-newspaper"></i>
        <p>No articles found</p>
        <router-link to="/admin/articles/new" class="btn btn-primary">
          Write Your First Article
        </router-link>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted } from 'vue';
import { supabase, getImageUrl } from '@/lib/supabase';

interface Article {
  id: string;
  title: string;
  slug: string;
  excerpt: string;
  featured_image: string | null;
  category_id: string | null;
  is_published: boolean;
  is_featured: boolean;
  views_count: number;
  reading_time: number | null;
  created_at: string;
}

interface Category {
  id: string;
  name: string;
}

export default defineComponent({
  name: 'AdminArticles',
  setup() {
    const loading = ref(false);
    const articles = ref<Article[]>([]);
    const categories = ref<Category[]>([]);
    const filterStatus = ref('all');
    const filterCategory = ref('all');
    const searchQuery = ref('');

    const filteredArticles = computed(() => {
      let result = articles.value;

      // Filter by status
      if (filterStatus.value === 'published') {
        result = result.filter((a) => a.is_published);
      } else if (filterStatus.value === 'draft') {
        result = result.filter((a) => !a.is_published);
      }

      // Filter by category
      if (filterCategory.value !== 'all') {
        result = result.filter((a) => a.category_id === filterCategory.value);
      }

      // Search
      if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        result = result.filter(
          (a) =>
            a.title.toLowerCase().includes(query) ||
            a.excerpt.toLowerCase().includes(query)
        );
      }

      return result;
    });

    const loadArticles = async () => {
      loading.value = true;
      try {
        const { data, error } = await supabase
          .from('articles')
          .select('*')
          .order('created_at', { ascending: false });

        if (error) throw error;
        articles.value = data || [];
      } catch (error: any) {
        alert('Error loading articles: ' + error.message);
      } finally {
        loading.value = false;
      }
    };

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

    const getCategoryName = (categoryId: string | null) => {
      if (!categoryId) return 'Uncategorized';
      const cat = categories.value.find((c) => c.id === categoryId);
      return cat ? cat.name : 'Unknown';
    };

    const formatDate = (dateString: string) => {
      const date = new Date(dateString);
      return new Intl.DateTimeFormat('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
      }).format(date);
    };

    const togglePublished = async (article: Article) => {
      try {
        const { error } = await supabase
          .from('articles')
          .update({
            is_published: !article.is_published,
            published_date: !article.is_published ? new Date().toISOString() : null,
          })
          .eq('id', article.id);

        if (error) throw error;
        await loadArticles();
      } catch (error: any) {
        alert('Error updating article: ' + error.message);
      }
    };

    const toggleFeatured = async (article: Article) => {
      try {
        const { error } = await supabase
          .from('articles')
          .update({ is_featured: !article.is_featured })
          .eq('id', article.id);

        if (error) throw error;
        await loadArticles();
      } catch (error: any) {
        alert('Error updating article: ' + error.message);
      }
    };

    const deleteArticle = async (article: Article) => {
      if (!confirm(`Delete "${article.title}"?`)) return;

      try {
        const { error } = await supabase.from('articles').delete().eq('id', article.id);

        if (error) throw error;
        await loadArticles();
      } catch (error: any) {
        alert('Error deleting article: ' + error.message);
      }
    };

    const handleImageError = (event: Event) => {
      const target = event.target as HTMLImageElement;
      target.src = '/img/blog-1.jpg';
    };

    onMounted(() => {
      loadArticles();
      loadCategories();
    });

    return {
      loading,
      articles,
      categories,
      filterStatus,
      filterCategory,
      searchQuery,
      filteredArticles,
      getCategoryName,
      formatDate,
      togglePublished,
      toggleFeatured,
      deleteArticle,
      getImageUrl,
      handleImageError,
    };
  },
});
</script>

<style scoped>
.articles-page {
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
  text-decoration: none;
}

.btn-primary {
  background: #d4a948;
  color: white;
}

.btn-primary:hover {
  background: #c69840;
}

/* Filters */
.filters {
  display: flex;
  gap: 1rem;
  margin-bottom: 2rem;
  flex-wrap: wrap;
}

.filter-select,
.search-input {
  padding: 0.75rem 1rem;
  border: 2px solid #e2e8f0;
  border-radius: 10px;
  font-size: 0.875rem;
  background: white;
  transition: all 0.2s ease;
}

.filter-select {
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

.filter-select:hover {
  border-color: #d4a948;
  box-shadow: 0 2px 8px rgba(212, 169, 72, 0.1);
}

.filter-select:focus {
  outline: none;
  border-color: #d4a948;
  box-shadow: 0 0 0 3px rgba(212, 169, 72, 0.1);
}

.search-input {
  flex: 1;
  min-width: 250px;
}

.search-input:focus {
  outline: none;
  border-color: #d4a948;
  box-shadow: 0 0 0 3px rgba(212, 169, 72, 0.1);
}

.loading {
  text-align: center;
  padding: 3rem;
  color: #64748b;
}

/* Articles List */
.articles-list {
  display: grid;
  gap: 1.5rem;
}

.article-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  display: flex;
  gap: 1.5rem;
  transition: transform 0.2s, box-shadow 0.2s;
}

.article-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.article-card.draft {
  opacity: 0.7;
}

.article-card.featured {
  border-left: 4px solid #d4a948;
}

.article-image {
  position: relative;
  width: 280px;
  /* height: 200px; */
  flex-shrink: 0;
  overflow: hidden;
  background: #f8fafc;
  border-right: 1px solid #f1f5f9;
}

.article-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.image-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.image-placeholder i {
  font-size: 3rem;
  color: #cbd5e1;
}

.badges {
  position: absolute;
  top: 0.75rem;
  left: 0.75rem;
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

.badge.featured {
  background: #d4a948;
  color: white;
}

.badge.status.published {
  background: #dcfce7;
  color: #22c55e;
}

.badge.status.draft {
  background: #fee;
  color: #ef4444;
}

.article-content {
  flex: 1;
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
}

.article-meta {
  display: flex;
  gap: 1rem;
  margin-bottom: 0.5rem;
  font-size: 0.875rem;
}

.category {
  color: #d4a948;
  font-weight: 600;
}

.date {
  color: #94a3b8;
}

.article-content h3 {
  font-size: 1.25rem;
  color: #1e293b;
  margin-bottom: 0.5rem;
  line-height: 1.4;
}

.excerpt {
  color: #64748b;
  font-size: 0.875rem;
  line-height: 1.6;
  margin-bottom: 1rem;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.article-stats {
  display: flex;
  gap: 1.5rem;
  padding: 1rem 0;
  border-top: 1px solid #e2e8f0;
  border-bottom: 1px solid #e2e8f0;
  margin-bottom: 1rem;
}

.stat {
  font-size: 0.875rem;
  color: #64748b;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.stat i {
  color: #d4a948;
}

.article-actions {
  display: flex;
  gap: 0.5rem;
  flex-wrap: wrap;
  margin-top: auto;
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
  text-decoration: none;
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

.btn-star {
  background: #f59e0b;
}

.btn-star:hover {
  background: #d97706;
}

.btn-delete {
  background: #ef4444;
}

.btn-delete:hover {
  background: #dc2626;
}

.empty-state {
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

@media (max-width: 768px) {
  .article-card {
    flex-direction: column;
  }

  .article-image {
    width: 100%;
    height: 200px;
  }

  .article-actions {
    flex-direction: column;
  }

  .btn-action {
    width: 100%;
    justify-content: center;
  }
}
</style>
