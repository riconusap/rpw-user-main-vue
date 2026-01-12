# Vue 3 Migration Guide

## Overview

This document outlines the complete migration of the R. Prama Wijaya Law Firm website from raw HTML/JavaScript to Vue 3 with TypeScript.

## Dependencies Installation

Run the following command to install all required dependencies:

```bash
npm install vue@^3.4.0 vue-router@^4.2.5 pinia@^2.1.7 bootstrap@^4.6.2 jquery@^3.7.1 @fortawesome/fontawesome-free@^6.5.1 aos@^2.3.4 owl.carousel@^2.3.4 waypoints@^4.0.1 counterup@^1.0.2 jquery.easing@^1.4.1
```

**Development Dependencies:**

```bash
npm install -D @vitejs/plugin-vue@^5.0.0 @types/node@^20.10.0 @types/jquery@^3.5.29 @types/bootstrap@^5.2.10 typescript@^5.3.0 vite@^5.0.0 vue-tsc@^1.8.27
```

Or install everything at once using the provided `package.json`:

```bash
npm install
```

## Global Imports (main.ts)

All global dependencies are registered in `src/main.ts`:

### CSS Dependencies
```typescript
import 'bootstrap/dist/css/bootstrap.min.css';
import '@fortawesome/fontawesome-free/css/all.min.css';
import 'owl.carousel/dist/assets/owl.carousel.min.css';
import 'aos/dist/aos.css';
```

### JavaScript Dependencies
```typescript
import 'jquery';
import 'bootstrap/dist/js/bootstrap.bundle.min.js';
import 'owl.carousel';
import 'waypoints/lib/jquery.waypoints.min.js';
import 'counterup/jquery.counterup.min.js';
import 'easing/jquery.easing.min.js';
import 'aos';
```

**Note:** jQuery is imported before Bootstrap and jQuery plugins to ensure proper initialization.

## Router Configuration

### Route Mapping

| Original HTML | Vue Route | Component |
|--------------|-----------|-----------|
| index.html | `/` | Home.vue |
| teams.html | `/teams` | Teams.vue |
| blog.html | `/articles` | Articles.vue |
| contact.html | `/contact` | Contact.vue |
| about.html | `/about` | About.vue |

### Scroll Behavior

The router includes scroll behavior configuration:
- Restores saved position when using browser back/forward
- Smooth scrolls to hash anchors (e.g., `#about`)
- Scrolls to top for new routes

```typescript
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
}
```

## Component Breakdown

### 1. Navbar.vue

**Original HTML:**
```html
<a href="teams.html" class="nav-item nav-link">Our Attorney</a>
```

**Vue Component:**
```vue
<RouterLink to="/teams" class="nav-item nav-link">Our Attorney</RouterLink>
```

**Key Changes:**
- Replaced `<a href="">` with `<RouterLink to="">`
- Bootstrap collapse functionality preserved with `data-toggle` attributes

### 2. HeroCarousel.vue

**Original HTML:**
```html
<div id="header-carousel" class="carousel slide carousel-fade" data-ride="carousel">
  <!-- Carousel content -->
</div>
<script>
  // jQuery initialization
</script>
```

**Vue Component:**
```typescript
setup() {
  onMounted(() => {
    ($('#header-carousel') as any).carousel({
      interval: 5000,
      ride: 'carousel',
    });
  });
}
```

**Key Changes:**
- Bootstrap carousel initialized in `onMounted()` lifecycle hook
- jQuery remains for Bootstrap JS compatibility

### 3. AboutSection.vue

**Original HTML:**
```html
<a href="about.html" class="btn">Read More</a>
```

**Vue Component:**
```vue
<RouterLink to="/about" class="btn btn-primary">Read More</RouterLink>
```

**Key Changes:**
- Static content preserved
- Navigation links converted to RouterLink

### 4. ServicesSection.vue

**Original HTML:**
```html
<div class="col-md-6 mb-5">
  <div class="d-flex">
    <img src="img/claw.jpg" width="150px" />
    <div class="d-flex flex-column ml-3">
      <h5>Corporate Law</h5>
      <p>Description...</p>
    </div>
  </div>
</div>
```

**Vue Component:**
```typescript
interface Service {
  image: string;
  title: string;
  description: string;
}

setup() {
  const services = ref<Service[]>([
    {
      image: '/img/claw.jpg',
      title: 'Corporate Law',
      description: 'Advising clients on corporate structures...',
    },
    // ... more services
  ]);

  return { services };
}
```

**Template:**
```vue
<div v-for="(service, index) in services" :key="index" class="col-md-6 mb-5">
  <div class="d-flex">
    <img :src="service.image" width="150px" :alt="service.title" />
    <div class="d-flex flex-column ml-3">
      <h5>{{ service.title }}</h5>
      <p>{{ service.description }}</p>
    </div>
  </div>
</div>
```

**Key Changes:**
- Hardcoded HTML converted to data-driven `v-for` loop
- TypeScript interface for type safety
- Dynamic data binding with `:src` and `{{ }}`

### 5. TeamSection.vue

**Original HTML:**
```html
<div class="owl-carousel team-carousel">
  <div class="team-item">
    <img src="img/founder.png" />
    <h5>Ramon Prama Wijaya, S.H., M.H.</h5>
    <span>FOUNDER</span>
  </div>
</div>
<script>
  $('.team-carousel').owlCarousel({
    autoplay: true,
    smartSpeed: 1000,
    // ... options
  });
</script>
```

**Vue Component:**
```typescript
interface TeamMember {
  image: string;
  name: string;
  position: string;
  detailLink: string;
}

setup() {
  const teamMembers = ref<TeamMember[]>([
    {
      image: '/img/founder.png',
      name: 'Ramon Prama Wijaya, S.H., M.H.',
      position: 'FOUNDER',
      detailLink: '/teams',
    },
    // ... more members
  ]);

  onMounted(() => {
    ($('.team-carousel') as any).owlCarousel({
      autoplay: true,
      smartSpeed: 1000,
      margin: 30,
      dots: false,
      loop: true,
      responsive: {
        0: { items: 1 },
        576: { items: 2 },
        768: { items: 3 },
        992: { items: 4 },
      },
    });
  });

  return { teamMembers };
}
```

**Key Changes:**
- Team member data extracted to TypeScript array
- Owl Carousel initialized in `onMounted()`
- Dynamic rendering with `v-for`
- RouterLink for detail navigation

### 6. ArticlesSection.vue

**Original HTML:**
```html
<div class="col-md-4 mb-5">
  <div class="position-relative">
    <img src="img/blog-1.jpg" />
    <div class="position-absolute bg-primary">
      <h6>Jan</h6>
      <h1>01</h1>
    </div>
  </div>
  <div class="border border-top-0">
    <a href="#">Web Design</a>
    <a href="#">Article title...</a>
  </div>
</div>
```

**Vue Component:**
```typescript
interface Article {
  image: string;
  month: string;
  day: string;
  category: string;
  title: string;
}

setup() {
  const articles = ref<Article[]>([
    {
      image: '/img/blog-1.jpg',
      month: 'Jan',
      day: '01',
      category: 'Web Design',
      title: 'Kasd tempor diam sea justo...',
    },
    // ... more articles
  ]);

  return { articles };
}
```

**Key Changes:**
- Article data structured in TypeScript interface
- Dynamic rendering with `v-for`
- Prepared for future API integration

### 7. BackToTop.vue

**Original HTML:**
```html
<a href="#home" class="btn btn-lg btn-primary back-to-top">
  <i class="fa fa-angle-up"></i>
</a>
<script>
  $(window).scroll(function() {
    if ($(this).scrollTop() > 100) {
      $('.back-to-top').fadeIn('slow');
    } else {
      $('.back-to-top').fadeOut('slow');
    }
  });
</script>
```

**Vue Component:**
```typescript
setup() {
  const showButton = ref<boolean>(false);

  const handleScroll = () => {
    showButton.value = window.scrollY > 300;
  };

  const scrollToTop = () => {
    window.scrollTo({
      top: 0,
      behavior: 'smooth',
    });
  };

  onMounted(() => {
    window.addEventListener('scroll', handleScroll);
  });

  onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
  });

  return { showButton, scrollToTop };
}
```

**Template:**
```vue
<a
  v-show="showButton"
  href="#home"
  class="btn btn-lg btn-primary back-to-top"
  @click.prevent="scrollToTop"
>
  <i class="fa fa-angle-up"></i>
</a>
```

**Key Changes:**
- jQuery scroll event replaced with Vue `ref` and native event listeners
- Proper cleanup with `onUnmounted()`
- `v-show` directive for visibility toggle
- Smooth scroll with native `window.scrollTo()`

## State Management (Future)

Currently, the application doesn't require global state. However, Pinia stores can be added for:

### Example: Articles Store

```typescript
// src/stores/articles.ts
import { defineStore } from 'pinia';
import { ref } from 'vue';

interface Article {
  id: number;
  title: string;
  content: string;
  author: string;
  publishedAt: string;
}

export const useArticlesStore = defineStore('articles', () => {
  const articles = ref<Article[]>([]);
  const loading = ref<boolean>(false);

  const fetchArticles = async () => {
    loading.value = true;
    try {
      const response = await fetch('/api/articles');
      articles.value = await response.json();
    } catch (error) {
      console.error('Failed to fetch articles:', error);
    } finally {
      loading.value = false;
    }
  };

  return {
    articles,
    loading,
    fetchArticles,
  };
});
```

### Usage in Component:

```typescript
import { useArticlesStore } from '@/stores/articles';

setup() {
  const articlesStore = useArticlesStore();

  onMounted(() => {
    articlesStore.fetchArticles();
  });

  return {
    articles: articlesStore.articles,
    loading: articlesStore.loading,
  };
}
```

## TypeScript Integration

### Type Definitions

All components use explicit TypeScript types:

```typescript
// Props typing
interface Props {
  title: string;
  subtitle?: string;
}

export default defineComponent({
  props: {
    title: {
      type: String as PropType<string>,
      required: true,
    },
    subtitle: {
      type: String as PropType<string>,
      required: false,
    },
  },
});
```

### Module Declarations

Custom module declarations are in `src/vite-env.d.ts`:

```typescript
declare module 'owl.carousel' {
  const owlCarousel: any;
  export default owlCarousel;
}

declare module 'aos' {
  interface AosOptions {
    duration?: number;
    delay?: number;
    once?: boolean;
  }

  const AOS: {
    init: (options?: AosOptions) => void;
    refresh: () => void;
  };

  export default AOS;
}
```

## Asset Management

### Static Assets

Assets remain in their original locations:
- `/img/` - Images
- `/css/` - Custom CSS (imported in components if needed)
- `/scss/` - SCSS files
- `/lib/` - Third-party libraries (legacy)

### Accessing Assets in Vue

```vue
<!-- Absolute path from public directory -->
<img src="/img/logo.png" alt="Logo" />

<!-- Or imported in script (for assets processed by Vite) -->
<script>
import logo from '@/assets/logo.png';
</script>
<template>
  <img :src="logo" alt="Logo" />
</template>
```

## Performance Considerations

### Lazy Loading

Routes use lazy loading:

```typescript
{
  path: '/teams',
  name: 'OurAttorney',
  component: () => import('@/views/Teams.vue'),
}
```

### Code Splitting

Vite automatically splits code by route and component.

### Image Optimization

Consider implementing:
- WebP format with fallbacks
- Lazy loading images with Intersection Observer
- Responsive images with `srcset`

## Testing Strategy (Future)

### Unit Tests (Vitest)

```typescript
import { mount } from '@vue/test-utils';
import Navbar from '@/components/Navbar.vue';

describe('Navbar.vue', () => {
  it('renders navigation links', () => {
    const wrapper = mount(Navbar);
    expect(wrapper.find('.nav-link').text()).toBe('Our Attorney');
  });
});
```

### E2E Tests (Cypress)

```typescript
describe('Navigation', () => {
  it('navigates to Teams page', () => {
    cy.visit('/');
    cy.contains('Our Attorney').click();
    cy.url().should('include', '/teams');
  });
});
```

## Deployment

### Build for Production

```bash
npm run build
```

Output directory: `dist/`

### Preview Production Build

```bash
npm run preview
```

### Environment Configuration

Create `.env.production`:

```env
VITE_APP_TITLE=R. Prama Wijaya Law Firm
VITE_API_BASE_URL=https://api.rpwadvocates.com
```

## Troubleshooting

### jQuery Not Defined

Ensure jQuery is imported before Bootstrap and plugins in `main.ts`.

### Owl Carousel Not Initializing

Check that:
1. Owl Carousel CSS is imported
2. jQuery is available globally
3. Carousel initialization is in `onMounted()`
4. DOM elements exist before initialization

### AOS Animations Not Working

Ensure:
1. AOS CSS is imported in `main.ts`
2. `AOS.init()` is called in `App.vue`'s `onMounted()`
3. `data-aos` attributes are present in HTML

### Router Links Not Working

Verify:
1. Router is registered in `main.ts`: `app.use(router)`
2. Using `<RouterLink>` instead of `<a>`
3. Routes are defined in `router/index.ts`

## Next Steps

1. **Migrate Remaining Pages:**
   - Implement full content for Teams.vue
   - Implement full content for Articles.vue
   - Implement full content for Contact.vue (with form handling)
   - Implement full content for About.vue

2. **API Integration:**
   - Create services for API calls
   - Implement error handling
   - Add loading states

3. **Form Handling:**
   - Contact form validation
   - Form submission with API
   - Success/error feedback

4. **SEO Optimization:**
   - Add meta tags per route
   - Implement Vue Meta or Vueuse Head
   - Generate sitemap

5. **Accessibility:**
   - Add ARIA labels
   - Keyboard navigation
   - Screen reader testing

6. **Performance:**
   - Image lazy loading
   - Component lazy loading
   - Bundle size optimization

---

**Migration Completed By:** GitHub Copilot
**Date:** January 12, 2026
**Framework:** Vue 3.4.0 + TypeScript 5.3.0
