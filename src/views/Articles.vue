<template>
  <div class="articles-page">
    <!-- Page Header Start -->
    <div class="container-fluid page-header d-flex flex-column align-items-center justify-content-center pt-0 pt-lg-5 mb-5">
      <h1 class="display-4 text-white mb-3 mt-0 mt-lg-5">Blog</h1>
      <div class="d-inline-flex text-white">
        <p class="m-0">
          <router-link class="text-white" to="/">Home</router-link>
        </p>
        <p class="m-0 px-2">/</p>
        <p class="m-0">Articles</p>
      </div>
    </div>
    <!-- Page Header End -->

    <!-- Blog Start -->
    <div class="container py-5">
      <div class="row">
        <!-- Sidebar Start -->
        <div class="col-lg-4 mt-5 mt-lg-0">
          <!-- Search Form Start -->
          <div class="mb-5">
            <form @submit.prevent="handleSearch">
              <div class="input-group">
                <input 
                  v-model="searchKeyword"
                  type="text" 
                  class="form-control form-control-lg" 
                  placeholder="Keyword"
                >
                <div class="input-group-append">
                  <span class="input-group-text bg-transparent text-primary">
                    <i class="fa fa-search"></i>
                  </span>
                </div>
              </div>
            </form>
          </div>
          <!-- Search Form End -->

          <!-- Category Start -->
          <div class="mb-5">
            <h3 class="font-weight-bold mb-4">Categories</h3>
            <ul v-if="categories.length > 0" class="list-group">
              <li 
                v-for="category in categories" 
                :key="category.id"
                class="list-group-item d-flex justify-content-between align-items-center"
                @click="filterByCategory(category.id)"
                style="cursor: pointer;"
              >
                <a class="font-weight-semi-bold text-decoration-none">
                  <i class="fa fa-angle-right mr-2"></i>{{ category.name }}
                </a>
                <span class="badge badge-primary badge-pill">{{ category.article_count }}</span>
              </li>
            </ul>
          </div>
          <!-- Category End -->

          <!-- Recent Post Start -->
          <div class="mb-5">
            <h3 class="font-weight-bold mb-4">Recent Post</h3>
            <div 
              v-for="post in recentPosts" 
              :key="post.id"
              class="d-flex mb-3"
            >
              <img class="img-fluid" :src="getImageUrl(post.featured_image)" style="width: 80px; height: 80px; object-fit: cover;" :alt="post.title" @error="handleImageError">
              <div class="d-flex align-items-center border border-left-0 px-3" style="height: 80px;">
                <RouterLink :to="`/articles/${post.slug}`" class="text-secondary font-weight-semi-bold">
                  {{ post.title }}
                </RouterLink>
              </div>
            </div>
          </div>
          <!-- Recent Post End -->
        </div>
        <!-- Sidebar End -->

        <!-- Blog Grid Start -->
        <div class="col-lg-8">
          <div v-if="loading" class="text-center py-5">
            <div class="spinner-border text-primary" role="status">
              <span class="sr-only">Loading...</span>
            </div>
          </div>
          <div v-else>
            <div v-if="articles.length > 0" class="row">
              <div 
                v-for="article in articles" 
                :key="article.id"
                class="col-md-6 mb-3"
              >
                <div class="position-relative">
                  <img class="img-fluid w-100" :src="getImageUrl(article.featured_image)" :alt="article.title" @error="handleImageError">
                  <div 
                    class="position-absolute bg-primary d-flex flex-column align-items-center justify-content-center"
                    style="width: 80px; height: 80px; bottom: 0; left: 0;"
                  >
                    <h6 class="text-uppercase mt-2 mb-n2">{{ formatMonth(article.published_date) }}</h6>
                    <h1 class="m-0">{{ formatDay(article.published_date) }}</h1>
                  </div>
                </div>
                <div class="border border-top-0 mb-3" style="padding: 30px;">
                  <div class="d-flex mb-3">
                    <div class="d-flex align-items-center">
                      <i class="far fa-user-circle text-primary" style="font-size: 40px;"></i>
                      <span class="text-muted ml-2">{{ article.author?.name || 'Admin' }}</span>
                    </div>
                    <div class="d-flex align-items-center ml-4">
                      <i class="far fa-bookmark text-primary"></i>
                      <span class="text-muted ml-2">{{ article.category?.name || 'Uncategorized' }}</span>
                    </div>
                  </div>
                  <RouterLink :to="`/articles/${article.slug}`" class="h4 font-weight-bold">
                    {{ article.title }}
                  </RouterLink>
                  <p class="mt-3">{{ article.excerpt }}</p>
                </div>
              </div>
            </div>
            <div v-else class="alert alert-info">
              No articles found.
            </div>
            
            <!-- Pagination -->
            <div v-if="totalPages > 1" class="row">
              <div class="col-12">
                <nav aria-label="Page navigation">
                  <ul class="pagination pagination-lg justify-content-center mb-0">
                    <li class="page-item" :class="{ disabled: currentPage === 1 }">
                      <a class="page-link" href="#" @click.prevent="changePage(currentPage - 1)" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                        <span class="sr-only">Previous</span>
                      </a>
                    </li>
                    <li 
                      v-for="page in totalPages" 
                      :key="page"
                      class="page-item" 
                      :class="{ active: currentPage === page }"
                    >
                      <a class="page-link" href="#" @click.prevent="changePage(page)">{{ page }}</a>
                    </li>
                    <li class="page-item" :class="{ disabled: currentPage === totalPages }">
                      <a class="page-link" href="#" @click.prevent="changePage(currentPage + 1)" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                        <span class="sr-only">Next</span>
                      </a>
                    </li>
                  </ul>
                </nav>
              </div>
            </div>
          </div>
        </div>
        <!-- Blog Grid End -->
      </div>
    </div>
    <!-- Blog End -->
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, computed } from 'vue';
import { useSEO, seoConfigs } from '@/composables/useSEO';
import { supabase, getImageUrl } from '@/lib/supabase';

interface Category {
  id: string;
  name: string;
  slug: string;
  article_count: number;
}

interface Article {
  id: string;
  title: string;
  slug: string;
  content: string;
  excerpt: string;
  featured_image: string;
  published_date: string;
  is_published: boolean;
  is_featured: boolean;
  category?: {
    name: string;
  };
  author?: {
    name: string;
  };
}

export default defineComponent({
  name: 'Articles',
  setup() {
    // SEO Meta Tags
    useSEO(seoConfigs.articles);

    const loading = ref(true);
    const searchKeyword = ref('');
    const selectedCategory = ref<string | null>(null);
    const currentPage = ref(1);
    const pageSize = 6;
    const totalCount = ref(0);

    const categories = ref<Category[]>([]);
    interface RecentPost {
      id: string;
      title: string;
      slug: string;
      featured_image: string;
      published_date: string;
    }
    const recentPosts = ref<RecentPost[]>([]);
    const articles = ref<Article[]>([]);

    const totalPages = computed(() => Math.ceil(totalCount.value / pageSize));

    const formatMonth = (date: string) => {
      return new Date(date).toLocaleDateString('en-US', { month: 'short' });
    };

    const formatDay = (date: string) => {
      return new Date(date).toLocaleDateString('en-US', { day: '2-digit' });
    };

    const loadCategories = async () => {
      try {
        const { data, error } = await supabase
          .from('article_categories')
          .select('*, articles(count)')
          .eq('is_active', true)
          .order('name', { ascending: true });

        if (error) throw error;
        categories.value = (data || []).map(cat => ({
          ...cat,
          article_count: cat.articles?.[0]?.count || 0,
        }));
      } catch (error) {
        console.error('Error loading categories:', error);
      }
    };

    const loadRecentPosts = async () => {
      try {
        const { data, error } = await supabase
          .from('articles')
          .select('id, title, slug, featured_image, published_date')
          .eq('is_published', true)
          .order('published_date', { ascending: false })
          .limit(4);

        if (error) throw error;
        recentPosts.value = data || [];
      } catch (error) {
        console.error('Error loading recent posts:', error);
      }
    };

    const loadArticles = async () => {
      loading.value = true;
      try {
        let query = supabase
          .from('articles')
          .select(`
            *,
            category:article_categories(name),
            author:attorneys(name)
          `, { count: 'exact' })
          .eq('is_published', true);

        // Apply category filter
        if (selectedCategory.value) {
          query = query.eq('category_id', selectedCategory.value);
        }

        // Apply search filter
        if (searchKeyword.value) {
          query = query.or(`title.ilike.%${searchKeyword.value}%,excerpt.ilike.%${searchKeyword.value}%`);
        }

        // Apply pagination
        const from = (currentPage.value - 1) * pageSize;
        const to = from + pageSize - 1;
        query = query.range(from, to);

        // Order by date
        query = query.order('published_date', { ascending: false });

        const { data, error, count } = await query;

        if (error) throw error;
        articles.value = data || [];
        totalCount.value = count || 0;
      } catch (error) {
        console.error('Error loading articles:', error);
      } finally {
        loading.value = false;
      }
    };

    const handleSearch = () => {
      currentPage.value = 1;
      loadArticles();
    };

    const filterByCategory = (categoryId: string | null) => {
      selectedCategory.value = categoryId;
      currentPage.value = 1;
      loadArticles();
    };

    const changePage = (page: number) => {
      if (page < 1 || page > totalPages.value) return;
      currentPage.value = page;
      loadArticles();
      window.scrollTo({ top: 0, behavior: 'smooth' });
    };

    onMounted(async () => {
      await Promise.all([
        loadCategories(),
        loadRecentPosts(),
        loadArticles(),
      ]);
    });

    const handleImageError = (event: Event) => {
      const target = event.target as HTMLImageElement;
      target.src = '/img/blog-1.jpg';
    };

    return {
      loading,
      searchKeyword,
      categories,
      recentPosts,
      articles,
      currentPage,
      totalPages,
      handleSearch,
      filterByCategory,
      changePage,
      formatMonth,
      formatDay,
      getImageUrl,
      handleImageError,
    };
  },
});
</script>

<style scoped>
.articles-page {
  min-height: 100vh;
}

.page-header {
  background: linear-gradient(rgba(33, 40, 50, 0.8), rgba(33, 40, 50, 0.8)), url('/img/about.png');
  background-position: center center;
  background-repeat: no-repeat;
  background-size: cover;
}
</style>
