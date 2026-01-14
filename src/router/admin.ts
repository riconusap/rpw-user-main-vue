import { RouteRecordRaw } from 'vue-router'

export const adminRoutes: RouteRecordRaw[] = [
  {
    path: '/admin/login',
    name: 'AdminLogin',
    component: () => import('@/views/admin/Login.vue'),
    meta: { requiresAuth: false, layout: 'blank' }
  },
  {
    path: '/admin',
    component: () => import('@/layouts/AdminLayout.vue'),
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        name: 'AdminDashboard',
        component: () => import('@/views/admin/Dashboard.vue'),
      },
      {
        path: 'hero-slides',
        name: 'AdminHeroSlides',
        component: () => import('@/views/admin/HeroSlides.vue'),
      },
      {
        path: 'features',
        name: 'AdminFeatures',
        component: () => import('@/views/admin/Features.vue'),
      },
      {
        path: 'practice-areas',
        name: 'AdminPracticeAreas',
        component: () => import('@/views/admin/PracticeAreas.vue'),
      },
      {
        path: 'attorneys',
        name: 'AdminAttorneys',
        component: () => import('@/views/admin/Attorneys.vue'),
      },
      {
        path: 'clients',
        name: 'AdminClients',
        component: () => import('@/views/admin/Clients.vue'),
      },
      {
        path: 'articles',
        name: 'AdminArticles',
        component: () => import('@/views/admin/Articles.vue'),
      },
      {
        path: 'articles/new',
        name: 'AdminArticleNew',
        component: () => import('@/views/admin/ArticleEdit.vue'),
      },
      {
        path: 'articles/edit/:id',
        name: 'AdminArticleEdit',
        component: () => import('@/views/admin/ArticleEdit.vue'),
      },
      {
        path: 'contact-submissions',
        name: 'AdminContactSubmissions',
        component: () => import('@/views/admin/ContactSubmissions.vue'),
      },
      {
        path: 'settings',
        name: 'AdminSettings',
        component: () => import('@/views/admin/Settings.vue'),
      },
    ],
  },
]
