<template>
  <section id="project" data-aos="fade-up" data-aos-duration="1000">
    <div class="container-fluid pt-5">
      <div class="container">
        <div class="text-center">
          <h1 class="mt-2 mb-5">Articles</h1>
        </div>
        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-primary" role="status">
            <span class="sr-only">Loading...</span>
          </div>
        </div>
        <div v-else-if="articles.length > 0" class="row">
          <div v-for="article in articles" :key="article.id" class="col-md-4 mb-5">
            <div class="position-relative">
              <img class="img-fluid w-100" :src="getImageUrl(article.featured_image)" :alt="article.title" @error="handleImageError" />
              <div
                class="position-absolute bg-primary d-flex flex-column align-items-center justify-content-center"
                style="width: 80px; height: 80px; bottom: 0; left: 0"
              >
                <h6 class="text-uppercase mt-2 mb-n2">{{ formatMonth(article.published_date) }}</h6>
                <h1 class="m-0">{{ formatDay(article.published_date) }}</h1>
              </div>
            </div>
            <div class="border border-top-0" style="padding: 30px">
              <div class="d-flex mb-3">
                <div class="d-flex align-items-center">
                  <i class="far fa-bookmark text-primary"></i>
                  <a class="text-muted ml-2" href="#">{{ article.category?.name || 'Uncategorized' }}</a>
                </div>
              </div>
              <RouterLink :to="`/articles/${article.slug}`" class="h5 font-weight-bold">
                {{ article.title }}
              </RouterLink>
            </div>
          </div>
        </div>
        <div v-else class="alert alert-info">
          No articles available. Please add articles in the admin panel.
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { supabase, getImageUrl } from '@/lib/supabase';

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
}

export default defineComponent({
  name: 'ArticlesSection',
  setup() {
    const loading = ref(true);
    const articles = ref<Article[]>([]);

    const formatMonth = (date: string) => {
      return new Date(date).toLocaleDateString('en-US', { month: 'short' });
    };

    const formatDay = (date: string) => {
      return new Date(date).toLocaleDateString('en-US', { day: '2-digit' });
    };

    const loadArticles = async () => {
      try {
        const { data, error } = await supabase
          .from('articles')
          .select(`
            *,
            category:article_categories(name)
          `)
          .eq('is_published', true)
          .order('published_date', { ascending: false })
          .limit(3);

        if (error) throw error;
        articles.value = data || [];
      } catch (error) {
        console.error('Error loading articles:', error);
      } finally {
        loading.value = false;
      }
    };

    onMounted(() => {
      loadArticles();
    });

    const handleImageError = (event: Event) => {
      const target = event.target as HTMLImageElement;
      target.src = '/img/blog-1.jpg';
    };

    return {
      loading,
      articles,
      getImageUrl,
      formatMonth,
      formatDay,
      handleImageError,
    };
  },
});
</script>

<style scoped>
/* Component-specific styles if needed */
</style>

<style scoped>
/* Component-specific styles if needed */
</style>
