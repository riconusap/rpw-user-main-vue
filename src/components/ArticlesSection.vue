<template>
  <section id="project" data-aos="fade-up" data-aos-duration="1000">
    <div class="container-fluid pt-5">
      <div class="container">
        <div class="text-center">
          <h1 class="mt-2 mb-5">Articles</h1>
        </div>
        <div class="row">
          <div v-for="(article, index) in articles" :key="index" class="col-md-4 mb-5">
            <div class="position-relative">
              <img class="img-fluid w-100" :src="article.image" :alt="article.title" />
              <div
                class="position-absolute bg-primary d-flex flex-column align-items-center justify-content-center"
                style="width: 80px; height: 80px; bottom: 0; left: 0"
              >
                <h6 class="text-uppercase mt-2 mb-n2">{{ article.month }}</h6>
                <h1 class="m-0">{{ article.day }}</h1>
              </div>
            </div>
            <div class="border border-top-0" style="padding: 30px">
              <div class="d-flex mb-3">
                <div class="d-flex align-items-center">
                  <i class="far fa-bookmark text-primary"></i>
                  <a class="text-muted ml-2" href="#">{{ article.category }}</a>
                </div>
              </div>
              <a class="h5 font-weight-bold" href="#">{{ article.title }}</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';

interface Article {
  image: string;
  month: string;
  day: string;
  category: string;
  title: string;
}

export default defineComponent({
  name: 'ArticlesSection',
  setup() {
    const articles = ref<Article[]>([
      {
        image: '/img/blog-1.jpg',
        month: 'Jan',
        day: '01',
        category: 'Web Design',
        title: 'Kasd tempor diam sea justo dolor kasd amet dolor labore amet clita est diam dolor',
      },
      {
        image: '/img/blog-1.jpg',
        month: 'Jan',
        day: '01',
        category: 'Web Design',
        title: 'Kasd tempor diam sea justo dolor kasd amet dolor labore amet clita est diam dolor',
      },
      {
        image: '/img/blog-1.jpg',
        month: 'Jan',
        day: '01',
        category: 'Web Design',
        title: 'Kasd tempor diam sea justo dolor kasd amet dolor labore amet clita est diam dolor',
      },
    ]);

    return {
      articles,
    };
  },
});
</script>

<style scoped>
/* Component-specific styles if needed */
</style>
