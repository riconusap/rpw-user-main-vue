<template>
  <div class="admin-layout">
    <!-- Sidebar -->
    <aside class="sidebar" :class="{ 'sidebar-collapsed': !sidebarOpen }">
      <div class="sidebar-header">
        <router-link to="/" class="brand">
          <img src="/img/logo.png" alt="RPW Logo" class="logo" />
          <span v-if="sidebarOpen">Admin Panel</span>
        </router-link>
      </div>

      <nav class="sidebar-nav">
        <router-link 
          v-for="item in menuItems" 
          :key="item.path"
          :to="item.path" 
          class="nav-item"
          :class="{ active: isActive(item.path) }"
        >
          <i :class="item.icon"></i>
          <span v-if="sidebarOpen">{{ item.label }}</span>
        </router-link>
      </nav>

      <div class="sidebar-footer">
        <button @click="handleLogout" class="btn-logout">
          <i class="fas fa-sign-out-alt"></i>
          <span v-if="sidebarOpen">Logout</span>
        </button>
      </div>
    </aside>

    <!-- Main Content -->
    <div class="main-content">
      <!-- Top Navbar -->
      <header class="top-navbar">
        <button @click="toggleSidebar" class="btn-toggle">
          <i class="fas fa-bars"></i>
        </button>

        <div class="navbar-right">
          <span class="user-email">{{ userEmail }}</span>
          <div class="user-avatar">
            <i class="fas fa-user-circle"></i>
          </div>
        </div>
      </header>

      <!-- Page Content -->
      <main class="page-content">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { signOut, getCurrentUser } from '@/lib/supabase';

export default defineComponent({
  name: 'AdminLayout',
  setup() {
    const router = useRouter();
    const route = useRoute();
    const sidebarOpen = ref(true);
    const userEmail = ref('');

    const menuItems = [
      { path: '/admin', label: 'Dashboard', icon: 'fas fa-home' },
      { path: '/admin/hero-slides', label: 'Hero Slides', icon: 'fas fa-image' },
      { path: '/admin/features', label: 'Features', icon: 'fas fa-star' },
      { path: '/admin/practice-areas', label: 'Practice Areas', icon: 'fas fa-gavel' },
      { path: '/admin/attorneys', label: 'Attorneys', icon: 'fas fa-user-tie' },
      { path: '/admin/articles', label: 'Articles', icon: 'fas fa-newspaper' },
      { path: '/admin/contact-submissions', label: 'Contact Forms', icon: 'fas fa-envelope' },
      { path: '/admin/settings', label: 'Settings', icon: 'fas fa-cog' },
    ];

    const toggleSidebar = () => {
      sidebarOpen.value = !sidebarOpen.value;
    };

    const isActive = (path: string) => {
      if (path === '/admin') {
        return route.path === '/admin';
      }
      return route.path.startsWith(path);
    };

    const handleLogout = async () => {
      const { error } = await signOut();
      if (!error) {
        router.push({ name: 'AdminLogin' });
      }
    };

    onMounted(async () => {
      const { user } = await getCurrentUser();
      if (user) {
        userEmail.value = user.email || '';
      }
    });

    return {
      sidebarOpen,
      menuItems,
      userEmail,
      toggleSidebar,
      isActive,
      handleLogout,
    };
  },
});
</script>

<style scoped>
.admin-layout {
  display: flex;
  min-height: 100vh;
  background: #fafafa;
}

/* Sidebar */
.sidebar {
  width: 240px;
  background: #ffffff;
  border-right: 1px solid #e5e7eb;
  transition: width 0.3s ease;
  display: flex;
  flex-direction: column;
  position: fixed;
  height: 100vh;
  overflow-y: auto;
  z-index: 1000;
}

.sidebar-collapsed {
  width: 64px;
}

.sidebar-header {
  padding: 1.25rem;
  border-bottom: 1px solid #e5e7eb;
}

.brand {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  color: #111827;
  text-decoration: none;
  font-weight: 600;
  font-size: 1rem;
  transition: all 0.2s;
}

.logo {
  width: 32px;
  height: auto;
  flex-shrink: 0;
}

.sidebar-nav {
  flex: 1;
  padding: 0.5rem 0;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.625rem 1rem;
  margin: 0.125rem 0.5rem;
  color: #6b7280;
  text-decoration: none;
  transition: all 0.2s;
  border-radius: 6px;
  font-size: 0.875rem;
}

.nav-item:hover {
  background: #f3f4f6;
  color: #111827;
}

.nav-item.active {
  background: #d4a948;
  color: white;
}

.nav-item i {
  width: 18px;
  text-align: center;
  font-size: 0.875rem;
  flex-shrink: 0;
}

.sidebar-collapsed .nav-item {
  justify-content: center;
  padding: 0.625rem;
}

.sidebar-collapsed .nav-item span {
  display: none;
}

.sidebar-collapsed .brand span {
  display: none;
}

.sidebar-footer {
  padding: 0.75rem;
  border-top: 1px solid #e5e7eb;
}

.btn-logout {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.625rem 1rem;
  background: transparent;
  border: 1px solid #e5e7eb;
  color: #6b7280;
  cursor: pointer;
  border-radius: 6px;
  transition: all 0.2s;
  font-size: 0.875rem;
}

.btn-logout:hover {
  background: #fef2f2;
  border-color: #fca5a5;
  color: #dc2626;
}

.sidebar-collapsed .btn-logout {
  justify-content: center;
  padding: 0.625rem;
}

.sidebar-collapsed .btn-logout span {
  display: none;
}

/* Main Content */
.main-content {
  flex: 1;
  margin-left: 240px;
  transition: margin-left 0.3s ease;
  display: flex;
  flex-direction: column;
}

.sidebar-collapsed + .main-content {
  margin-left: 64px;
}

/* Top Navbar */
.top-navbar {
  background: white;
  padding: 0.875rem 1.5rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid #e5e7eb;
  position: sticky;
  top: 0;
  z-index: 100;
}

.btn-toggle {
  background: none;
  border: none;
  font-size: 1.125rem;
  cursor: pointer;
  color: #6b7280;
  padding: 0.5rem;
  border-radius: 6px;
  transition: all 0.2s;
}

.btn-toggle:hover {
  background: #f3f4f6;
  color: #111827;
}

.navbar-right {
  display: flex;
  align-items: center;
  gap: 0.875rem;
}

.user-email {
  color: #6b7280;
  font-size: 0.813rem;
}

.user-avatar {
  font-size: 1.75rem;
  color: #d4a948;
}

/* Page Content */
.page-content {
  flex: 1;
  padding: 1.5rem;
  max-width: 1400px;
  width: 100%;
  margin: 0 auto;
}

/* Responsive */
@media (max-width: 768px) {
  .sidebar {
    transform: translateX(-100%);
  }

  .sidebar-collapsed {
    transform: translateX(0);
  }

  .main-content {
    margin-left: 0;
  }
}
</style>
