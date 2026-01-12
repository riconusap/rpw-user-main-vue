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
            <ul class="list-group">
              <li 
                v-for="category in categories" 
                :key="category.name"
                class="list-group-item d-flex justify-content-between align-items-center"
              >
                <a class="font-weight-semi-bold text-decoration-none" href="#">
                  <i class="fa fa-angle-right mr-2"></i>{{ category.name }}
                </a>
                <span class="badge badge-primary badge-pill">{{ category.count }}</span>
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
              <img class="img-fluid" :src="post.image" style="width: 80px; height: 80px;" :alt="post.title">
              <div class="d-flex align-items-center border border-left-0 px-3" style="height: 80px;">
                <a class="text-secondary font-weight-semi-bold" href="#">{{ post.title }}</a>
              </div>
            </div>
          </div>
          <!-- Recent Post End -->
        </div>
        <!-- Sidebar End -->

        <!-- Blog Grid Start -->
        <div class="col-lg-8">
          <div class="row">
            <div 
              v-for="article in articles" 
              :key="article.id"
              class="col-md-6 mb-3"
            >
              <div class="position-relative">
                <img class="img-fluid w-100" :src="article.image" :alt="article.title">
                <div 
                  class="position-absolute bg-primary d-flex flex-column align-items-center justify-content-center"
                  style="width: 80px; height: 80px; bottom: 0; left: 0;"
                >
                  <h6 class="text-uppercase mt-2 mb-n2">{{ article.month }}</h6>
                  <h1 class="m-0">{{ article.day }}</h1>
                </div>
              </div>
              <div class="border border-top-0 mb-3" style="padding: 30px;">
                <div class="d-flex mb-3">
                  <div class="d-flex align-items-center">
                    <img class="rounded-circle" style="width: 40px; height: 40px;" :src="article.authorImage" :alt="article.author">
                    <a class="text-muted ml-2" href="#">{{ article.author }}</a>
                  </div>
                  <div class="d-flex align-items-center ml-4">
                    <i class="far fa-bookmark text-primary"></i>
                    <a class="text-muted ml-2" href="#">{{ article.category }}</a>
                  </div>
                </div>
                <a class="h4 font-weight-bold" href="#">{{ article.title }}</a>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-12">
              <nav aria-label="Page navigation">
                <ul class="pagination pagination-lg justify-content-center mb-0">
                  <li class="page-item disabled">
                    <a class="page-link" href="#" aria-label="Previous">
                      <span aria-hidden="true">&laquo;</span>
                      <span class="sr-only">Previous</span>
                    </a>
                  </li>
                  <li class="page-item active"><a class="page-link" href="#">1</a></li>
                  <li class="page-item"><a class="page-link" href="#">2</a></li>
                  <li class="page-item"><a class="page-link" href="#">3</a></li>
                  <li class="page-item">
                    <a class="page-link" href="#" aria-label="Next">
                      <span aria-hidden="true">&raquo;</span>
                      <span class="sr-only">Next</span>
                    </a>
                  </li>
                </ul>
              </nav>
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
import { defineComponent, ref } from 'vue';

interface Category {
  name: string;
  count: number;
}

interface RecentPost {
  id: number;
  title: string;
  image: string;
}

interface Article {
  id: number;
  title: string;
  image: string;
  author: string;
  authorImage: string;
  category: string;
  month: string;
  day: string;
}

export default defineComponent({
  name: 'Articles',
  setup() {
    const searchKeyword = ref('');

    const categories: Category[] = [
      { name: 'Corporate Law', count: 150 },
      { name: 'Civil Law', count: 131 },
      { name: 'Criminal Law', count: 78 },
      { name: 'Tax Law', count: 56 },
      { name: 'Labor Law', count: 98 },
    ];

    const recentPosts: RecentPost[] = [
      {
        id: 1,
        title: 'Understanding Corporate Governance in Indonesia',
        image: '/img/blog-1.jpg',
      },
      {
        id: 2,
        title: 'Key Changes in Indonesian Tax Regulations 2025',
        image: '/img/blog-2.jpg',
      },
      {
        id: 3,
        title: 'Labor Law Updates and Employee Rights',
        image: '/img/blog-1.jpg',
      },
      {
        id: 4,
        title: 'Navigating Investment Laws in Southeast Asia',
        image: '/img/blog-2.jpg',
      },
    ];

    const articles: Article[] = [
      {
        id: 1,
        title: 'Understanding the New Corporate Regulations in Indonesia',
        image: '/img/blog-1.jpg',
        author: 'John Doe',
        authorImage: '/img/user.jpg',
        category: 'Corporate Law',
        month: 'Jan',
        day: '01',
      },
      {
        id: 2,
        title: 'Navigating Labor Laws: A Comprehensive Guide',
        image: '/img/blog-2.jpg',
        author: 'John Doe',
        authorImage: '/img/user.jpg',
        category: 'Labor Law',
        month: 'Jan',
        day: '05',
      },
      {
        id: 3,
        title: 'Tax Planning Strategies for Indonesian Businesses',
        image: '/img/blog-1.jpg',
        author: 'John Doe',
        authorImage: '/img/user.jpg',
        category: 'Tax Law',
        month: 'Jan',
        day: '10',
      },
      {
        id: 4,
        title: 'Intellectual Property Rights Protection',
        image: '/img/blog-2.jpg',
        author: 'John Doe',
        authorImage: '/img/user.jpg',
        category: 'Civil Law',
        month: 'Jan',
        day: '15',
      },
    ];

    const handleSearch = () => {
      console.log('Searching for:', searchKeyword.value);
      // Implement search functionality here
    };

    return {
      searchKeyword,
      categories,
      recentPosts,
      articles,
      handleSearch,
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
