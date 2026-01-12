import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router';

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/Home.vue'),
  },
  {
    path: '/teams',
    name: 'OurAttorney',
    component: () => import('@/views/Teams.vue'),
  },
  {
    path: '/articles',
    name: 'Articles',
    component: () => import('@/views/Articles.vue'),
  },
  {
    path: '/contact',
    name: 'ContactUs',
    component: () => import('@/views/Contact.vue'),
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('@/views/About.vue'),
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition;
    } else if (to.hash) {
      return {
        el: to.hash,
        behavior: 'smooth',
      };
    } else {
      return { top: 0 };
    }
  },
});

export default router;
