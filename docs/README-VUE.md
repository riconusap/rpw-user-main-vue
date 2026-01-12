# R. Prama Wijaya Law Firm - Vue 3 TypeScript

This project is a modern refactor of the R. Prama Wijaya Law Firm website, migrated from raw HTML/JS/CSS to Vue 3 with TypeScript.

## Tech Stack

- **Framework:** Vue 3
- **Language:** TypeScript
- **Component Syntax:** `export default defineComponent({ ... })` (NO `<script setup>`)
- **State Management:** Pinia
- **Routing:** Vue Router v4
- **Build Tool:** Vite
- **CSS Framework:** Bootstrap 4.6.2
- **Icons:** Font Awesome
- **Animation:** AOS (Animate on Scroll)
- **Carousel:** Owl Carousel

## Project Structure

```
src/
├── components/           # Reusable Vue components
│   ├── Navbar.vue
│   ├── Footer.vue
│   ├── BackToTop.vue
│   ├── HeroCarousel.vue
│   ├── AboutSection.vue
│   ├── ServicesSection.vue
│   ├── TeamSection.vue
│   └── ArticlesSection.vue
├── views/               # Route-level components
│   ├── Home.vue
│   ├── About.vue
│   ├── Teams.vue
│   ├── Articles.vue
│   └── Contact.vue
├── router/              # Vue Router configuration
│   └── index.ts
├── stores/              # Pinia stores (for future use)
├── App.vue              # Root component
├── main.ts              # Application entry point
└── vite-env.d.ts        # TypeScript declarations
```

## Installation

1. **Install dependencies:**

```bash
npm install
```

Or using yarn:

```bash
yarn install
```

## Development

Start the development server:

```bash
npm run dev
```

Or:

```bash
yarn dev
```

The application will open automatically at `http://localhost:3000`

## Build

Build for production:

```bash
npm run build
```

Preview the production build:

```bash
npm run preview
```

## Key Dependencies

### Core
- `vue`: ^3.4.0
- `vue-router`: ^4.2.5
- `pinia`: ^2.1.7

### UI & Styling
- `bootstrap`: ^4.6.2
- `@fortawesome/fontawesome-free`: ^6.5.1
- `aos`: ^2.3.4

### jQuery & Plugins
- `jquery`: ^3.7.1
- `owl.carousel`: ^2.3.4
- `waypoints`: ^4.0.1
- `counterup`: ^1.0.2
- `jquery.easing`: ^1.4.1

## Migration Notes

### From HTML to Vue Components

1. **Navigation Links:** All `<a href="page.html">` converted to `<RouterLink to="/route">`
2. **State Management:** Inline JS variables migrated to Vue `ref()` or `reactive()`
3. **DOM Manipulation:** jQuery selectors replaced with Vue Template Refs and `v-model`
4. **Bootstrap JS:** Initialized in `onMounted()` lifecycle hooks where needed
5. **Owl Carousel:** Initialized in `TeamSection.vue` using `onMounted()`
6. **AOS:** Initialized globally in `App.vue`

### Component Architecture

- **Navbar.vue:** Navigation bar with RouterLink integration
- **Footer.vue:** Site footer with contact info and social links
- **BackToTop.vue:** Smooth scroll to top button with scroll event listener
- **HeroCarousel.vue:** Bootstrap carousel for hero section
- **AboutSection.vue:** Company information and contact cards
- **ServicesSection.vue:** Services grid with dynamic data
- **TeamSection.vue:** Owl Carousel for team members
- **ArticlesSection.vue:** Blog/articles preview grid

### TypeScript Integration

All components use `defineComponent()` with explicit type definitions:
- Props are typed using TypeScript interfaces
- State uses `ref<Type>()` for type safety
- Event handlers have proper type signatures

## Environment Variables

If needed, create a `.env` file in the root directory:

```env
VITE_APP_TITLE=R. Prama Wijaya Law Firm
VITE_API_BASE_URL=your_api_url_here
```

## Static Assets

All static assets are now organized in the `public` directory:
- `/public/img/` - Images (accessible as `/img/` in templates)
- `/public/css/` - Custom stylesheets (accessible as `/css/` in templates)
- `/public/lib/` - Third-party libraries (accessible as `/lib/` in templates)

These are accessible in Vue templates using absolute paths: `/img/logo.png`

## Routing

Routes are defined in `src/router/index.ts`:
- `/` - Home (index.html)
- `/teams` - Our Attorneys (teams.html)
- `/articles` - Articles (blog.html)
- `/contact` - Contact Us (contact.html)
- `/about` - About Us (about.html)

## Future Enhancements

1. **Pinia Stores:** Implement state management for:
   - User authentication
   - Blog/articles data
   - Contact form state

2. **API Integration:** Connect to backend services for:
   - Dynamic content loading
   - Form submissions
   - User authentication

3. **Testing:** Add unit tests with Vitest and E2E tests with Cypress

4. **Accessibility:** Improve ARIA labels and keyboard navigation

5. **Performance:** Lazy load images and implement code splitting

## License

Copyright © 2026 R. Prama Wijaya Law Firm. All rights reserved.

---

**Note:** This is a modern Vue 3 refactor. The original HTML files remain in the root directory for reference. The new Vue application uses `index-vue.html` as the entry point.
