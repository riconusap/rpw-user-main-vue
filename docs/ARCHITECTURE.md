# Project Architecture Diagram

## 📐 Application Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Browser (Client)                     │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │              index-vue.html (Entry)                 │ │
│  │                                                      │ │
│  │           <div id="app"></div>                      │ │
│  └──────────────────┬───────────────────────────────────┘ │
│                     │ mount                              │
└─────────────────────┼──────────────────────────────────┘
                      │
                      ▼
        ┌─────────────────────────┐
        │      src/main.ts         │
        │  (Application Entry)     │
        │                          │
        │  • Import Vue            │
        │  • Import Router         │
        │  • Import Pinia          │
        │  • Import Global CSS     │
        │  • Import Global JS      │
        └────────┬─────────────────┘
                 │
                 ▼
        ┌────────────────────────┐
        │     src/App.vue         │
        │   (Root Component)      │
        │                         │
        │  • Initialize AOS       │
        │  • Layout structure     │
        └────┬───────────────────┘
             │
             ├─────────────────────────┐
             │                          │
             ▼                          ▼
    ┌────────────────┐        ┌─────────────────┐
    │  Navbar.vue    │        │   Footer.vue     │
    │  (Global Nav)  │        │  (Global Footer) │
    └────────────────┘        └─────────────────┘
             │
             ▼
    ┌────────────────────┐
    │   <router-view>    │ ◄─── Vue Router
    │  (Page Container)  │
    └─────────┬──────────┘
              │
              ▼
    ┌─────────────────────────────────────────┐
    │              Routes                     │
    │                                         │
    │  ┌─────────────────────────────────┐   │
    │  │  /          → Home.vue           │   │
    │  │  /teams     → Teams.vue          │   │
    │  │  /articles  → Articles.vue       │   │
    │  │  /contact   → Contact.vue        │   │
    │  │  /about     → About.vue          │   │
    │  └─────────────────────────────────┘   │
    └─────────────────────────────────────────┘
```

---

## 🏠 Home Page Component Tree

```
Home.vue
├── HeroCarousel.vue
│   └── Bootstrap Carousel
│       └── onMounted: Initialize carousel
│
├── AboutSection.vue
│   ├── Company Info
│   ├── RouterLink to /about
│   └── Contact Cards
│       ├── Email
│       ├── Phone
│       └── Office
│
├── ServicesSection.vue
│   └── Services Array (ref)
│       └── v-for: Service Cards
│           ├── Image
│           ├── Title
│           └── Description
│
├── TeamSection.vue
│   ├── Team Members Array (ref)
│   └── Owl Carousel
│       ├── onMounted: Initialize Owl
│       └── v-for: Team Member Cards
│           ├── Image
│           ├── Name
│           ├── Position
│           └── RouterLink to detail
│
└── ArticlesSection.vue
    └── Articles Array (ref)
        └── v-for: Article Cards
            ├── Image
            ├── Date Badge
            ├── Category
            └── Title
```

---

## 🔄 Data Flow Diagram

```
┌──────────────────────────────────────────────────────────┐
│                    User Interaction                       │
└───────────────────┬──────────────────────────────────────┘
                    │
                    ▼
        ┌────────────────────────┐
        │   Vue Component         │
        │                         │
        │  • Template (View)      │
        │  • Script (Logic)       │
        │  • Style (CSS)          │
        └────┬───────────────────┘
             │
             ├──────────────────────┐
             │                       │
             ▼                       ▼
    ┌─────────────────┐    ┌────────────────┐
    │  Local State    │    │   Props         │
    │  (ref, reactive)│    │   (from parent) │
    └─────────────────┘    └────────────────┘
             │                       │
             └───────────┬───────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │  Computed Properties  │
              │  (Derived state)      │
              └──────────┬────────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │   Methods/Functions   │
              │   (Event handlers)    │
              └──────────┬────────────┘
                         │
                         ├─────────────────────┐
                         │                     │
                         ▼                     ▼
              ┌──────────────────┐   ┌────────────────┐
              │  Lifecycle Hooks  │   │  Emit Events   │
              │  • onMounted      │   │  (to parent)   │
              │  • onUnmounted    │   └────────────────┘
              └──────────────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │   Return to Template │
              │   (Exposed data)     │
              └──────────────────────┘
```

---

## 🗂️ Folder Structure

```
rpw-user-main/
│
├── src/                          # Source code
│   ├── components/               # Reusable components
│   │   ├── Navbar.vue            # Navigation
│   │   ├── Footer.vue            # Footer
│   │   ├── BackToTop.vue         # Scroll button
│   │   ├── HeroCarousel.vue      # Hero section
│   │   ├── AboutSection.vue      # About section
│   │   ├── ServicesSection.vue   # Services grid
│   │   ├── TeamSection.vue       # Team carousel
│   │   └── ArticlesSection.vue   # Articles preview
│   │
│   ├── views/                    # Page components
│   │   ├── Home.vue              # Homepage
│   │   ├── Teams.vue             # Team page
│   │   ├── Articles.vue          # Articles page
│   │   ├── Contact.vue           # Contact page
│   │   └── About.vue             # About page
│   │
│   ├── router/                   # Routing
│   │   └── index.ts              # Router config
│   │
│   ├── stores/                   # State management
│   │   └── (empty - ready for Pinia stores)
│   │
│   ├── services/                 # API services (to be created)
│   │   └── (future: api.ts, articles.service.ts, etc.)
│   │
│   ├── types/                    # TypeScript types (to be created)
│   │   └── (future: interfaces and types)
│   │
│   ├── App.vue                   # Root component
│   ├── main.ts                   # Entry point
│   └── vite-env.d.ts             # Type declarations
│
├── public/                       # Static assets
│   └── (to be populated from root)
│
├── img/                          # Images (original)
├── css/                          # Styles (original)
├── lib/                          # Libraries (original)
│
├── package.json                  # Dependencies
├── vite.config.ts                # Vite config
├── tsconfig.json                 # TypeScript config
├── tsconfig.node.json            # Node TS config
├── index-vue.html                # HTML entry
├── .gitignore                    # Git ignore
├── .env.example                  # Env template
│
└── Documentation/
    ├── README-VUE.md             # Main docs
    ├── MIGRATION-GUIDE.md        # Migration details
    ├── QUICK-START.md            # Quick start
    ├── MIGRATION-SUMMARY.md      # Summary
    ├── CHECKLIST.md              # Dev checklist
    ├── COMPONENT-TEMPLATE.vue    # Component template
    └── ARCHITECTURE.md           # This file
```

---

## 🔌 Dependency Graph

```
┌─────────────────────────────────────────────────────────┐
│                     main.ts (Entry)                      │
│                                                          │
│  Imports:                                                │
│  ├── vue                     (Core framework)            │
│  ├── vue-router              (Routing)                   │
│  ├── pinia                   (State management)          │
│  ├── bootstrap               (UI framework)              │
│  ├── jquery                  (Required by Bootstrap)     │
│  ├── @fortawesome/fonts      (Icons)                     │
│  ├── owl.carousel            (Carousel)                  │
│  ├── aos                     (Animations)                │
│  ├── waypoints               (Scroll detection)          │
│  ├── counterup               (Number animation)          │
│  └── jquery.easing           (Smooth scrolling)          │
└──────────────────┬────────────────────────────────────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │      App.vue          │
        │                       │
        │  Imports:             │
        │  ├── Navbar           │
        │  ├── Footer           │
        │  ├── BackToTop        │
        │  └── AOS (init)       │
        └───────┬───────────────┘
                │
                ├─────────────────────────┐
                │                          │
                ▼                          ▼
    ┌───────────────────┐      ┌──────────────────┐
    │   Navbar.vue      │      │   Footer.vue      │
    │                   │      │                   │
    │   No imports      │      │   No imports      │
    └───────────────────┘      └──────────────────┘
                │
                ▼
    ┌───────────────────────┐
    │   Router (views)      │
    │                       │
    │   ├── Home.vue        │ ───┐
    │   ├── Teams.vue       │    │
    │   ├── Articles.vue    │    │
    │   ├── Contact.vue     │    │
    │   └── About.vue       │    │
    └───────────────────────┘    │
                                 │
                                 ▼
                    ┌─────────────────────────┐
                    │    Home.vue Imports:     │
                    │                          │
                    │  ├── HeroCarousel        │
                    │  ├── AboutSection        │
                    │  ├── ServicesSection     │
                    │  ├── TeamSection         │
                    │  └── ArticlesSection     │
                    └──────────────────────────┘
```

---

## 🎨 Component Communication

```
┌────────────────────────────────────────────────────────┐
│                    Parent Component                     │
│                                                         │
│  Data flow DOWN via props ↓                            │
│  Events flow UP via emits ↑                            │
└──────────────────┬─────────────────────────────────────┘
                   │
                   ├─────────────────────────────┐
                   │                              │
                   ▼                              ▼
        ┌──────────────────────┐      ┌──────────────────┐
        │  Child Component A    │      │ Child Component B │
        │                       │      │                   │
        │  props: {             │      │  props: {         │
        │    title: String,     │      │    items: Array   │
        │    active: Boolean    │      │  }                │
        │  }                    │      │                   │
        │                       │      │  emits: [         │
        │  emits: ['click']     │      │    'update',      │
        └───────────┬───────────┘      │    'delete'       │
                    │                  │  ]                │
                    │                  └──────────┬────────┘
                    │                             │
                    └──────────┬──────────────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │  Shared State        │
                    │  (Future: Pinia)     │
                    │                      │
                    │  • Global data       │
                    │  • Cross-component   │
                    │  • Persistent state  │
                    └──────────────────────┘
```

---

## 🔐 State Management (Future)

```
┌─────────────────────────────────────────────────────────┐
│                   Pinia Store Architecture               │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │              Articles Store                         │ │
│  │                                                      │ │
│  │  State:                                              │ │
│  │  • articles: Article[]                               │ │
│  │  • loading: boolean                                  │ │
│  │  • error: string | null                              │ │
│  │                                                      │ │
│  │  Actions:                                            │ │
│  │  • fetchArticles()                                   │ │
│  │  • fetchArticleById(id)                              │ │
│  │  • createArticle(data)                               │ │
│  │                                                      │ │
│  │  Getters:                                            │ │
│  │  • recentArticles                                    │ │
│  │  • articlesByCategory                                │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │              Contact Store                          │ │
│  │                                                      │ │
│  │  State:                                              │ │
│  │  • formData: ContactForm                             │ │
│  │  • submitting: boolean                               │ │
│  │  • success: boolean                                  │ │
│  │                                                      │ │
│  │  Actions:                                            │ │
│  │  • submitForm(data)                                  │ │
│  │  • resetForm()                                       │ │
│  └────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

---

## 🌐 Routing Flow

```
User enters URL
      │
      ▼
┌──────────────────┐
│  Vue Router      │
│  (router/index.ts)│
└─────┬────────────┘
      │
      ├─── / ──────────────────► Home.vue
      │                              │
      │                              ├─► HeroCarousel
      │                              ├─► AboutSection
      │                              ├─► ServicesSection
      │                              ├─► TeamSection
      │                              └─► ArticlesSection
      │
      ├─── /teams ─────────────► Teams.vue
      │
      ├─── /articles ──────────► Articles.vue
      │
      ├─── /contact ───────────► Contact.vue
      │
      └─── /about ─────────────► About.vue

Navigation Methods:
• <RouterLink to="/path">  (Declarative)
• router.push('/path')     (Programmatic)
• Browser back/forward     (History API)

Scroll Behavior:
• New route → Scroll to top
• Hash route → Scroll to anchor
• Back/forward → Restore position
```

---

## 📦 Build Process

```
┌─────────────────────────────────────────────────────────┐
│                   Development Mode                       │
│                   (npm run dev)                          │
│                                                          │
│  Source Files ──► Vite Dev Server ──► Hot Module Replace│
│                   │                                      │
│                   ├─► Fast refresh                       │
│                   ├─► Source maps                        │
│                   └─► No bundling                        │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                   Production Build                       │
│                   (npm run build)                        │
│                                                          │
│  Source Files                                            │
│       │                                                  │
│       ▼                                                  │
│  TypeScript Check (vue-tsc)                              │
│       │                                                  │
│       ▼                                                  │
│  Vite Build Process                                      │
│       │                                                  │
│       ├─► Bundle & minify                                │
│       ├─► Code splitting                                 │
│       ├─► Tree shaking                                   │
│       ├─► Asset optimization                             │
│       └─► Generate sourcemaps                            │
│       │                                                  │
│       ▼                                                  │
│  dist/ folder                                            │
│       │                                                  │
│       ├─► index.html                                     │
│       ├─► assets/                                        │
│       │   ├─► *.js (bundled)                             │
│       │   ├─► *.css (bundled)                            │
│       │   └─► images                                     │
│       └─► Ready to deploy!                               │
└─────────────────────────────────────────────────────────┘
```

---

## 🎯 Key Architectural Decisions

### 1. Component Strategy
- **Composition over Options**: Using `defineComponent()` with setup()
- **Single Responsibility**: Each component has one clear purpose
- **Reusability**: Components are designed to be reused
- **Props down, Events up**: Clear data flow patterns

### 2. State Management
- **Local state first**: Use component state by default
- **Pinia for shared state**: Only when needed across components
- **No over-engineering**: Keep it simple initially

### 3. Type Safety
- **TypeScript everywhere**: All components use TS
- **Interface-driven**: Clear type definitions
- **PropType usage**: Type-safe component props

### 4. Performance
- **Lazy loading**: Routes loaded on demand
- **Code splitting**: Automatic with Vite
- **Tree shaking**: Remove unused code
- **Asset optimization**: Images and CSS optimized

### 5. Developer Experience
- **Hot Module Replacement**: Fast development
- **TypeScript errors**: Catch issues early
- **Vue DevTools**: Debugging support
- **Clear documentation**: Easy onboarding

---

**Document Version:** 1.0
**Last Updated:** January 12, 2026
**Created By:** GitHub Copilot
