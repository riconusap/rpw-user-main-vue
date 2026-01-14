import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router';
import { adminRoutes } from './admin';
import { checkSession } from '@/lib/supabase';

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/Home.vue'),
  },
  {
    path: '/attorneys',
    name: 'OurAttorney',
    component: () => import('@/views/Teams.vue'),
  },
  {
    path: '/attorneys/:id',
    name: 'AttorneyDetail',
    component: () => import('@/views/AttorneyDetail.vue'),
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
  {
    path: '/services',
    name: 'Services',
    component: () => import('@/views/Services.vue'),
  },
  // Admin routes
  ...adminRoutes,
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
  scrollBehavior(to, _from, savedPosition) {
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

// Auth guard

router.beforeEach(async (to, _from, next) => {
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth);

  if (requiresAuth) {
    const { session } = await checkSession();
    
    if (!session) {
      next({ name: 'AdminLogin', query: { redirect: to.fullPath } });
    } else {
      next();
    }
  } else {
    next();
  }
});

export default router;
