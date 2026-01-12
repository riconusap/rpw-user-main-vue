
import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import { createPinia } from 'pinia';
import { createUnhead } from '@unhead/vue';

// Import global CSS dependencies
import 'bootstrap/dist/css/bootstrap.min.css';
import '@fortawesome/fontawesome-free/css/all.min.css';
import 'owl.carousel/dist/assets/owl.carousel.min.css';
import 'aos/dist/aos.css';
import './assets/css/style.css'; // Custom styles

// Import jQuery first and expose globally
import $ from 'jquery';
// Make jQuery available globally for plugins BEFORE importing them
(window as any).$ = $;
(window as any).jQuery = $;

// Now import plugins that depend on jQuery
import 'bootstrap/dist/js/bootstrap.bundle.min.js'; // Includes Popper.js
import AOS from 'aos';

// Load Owl Carousel and other jQuery plugins after jQuery is ready
const loadScript = (src: string) => {
  return new Promise((resolve, reject) => {
    const script = document.createElement('script');
    script.src = src;
    script.onload = resolve;
    script.onerror = reject;
    document.head.appendChild(script);
  });
};

// Load all jQuery-dependent plugins
Promise.all([
  loadScript('/lib/owlcarousel/owl.carousel.min.js'),
  loadScript('/lib/easing/easing.min.js'),
  loadScript('/lib/waypoints/waypoints.min.js'),
  loadScript('/lib/counterup/counterup.min.js'),
]).catch(err => console.warn('Some jQuery plugins failed to load:', err));

const app = createApp(App);
const pinia = createPinia();
const head = createUnhead();

app.use(pinia);
app.use(router);

// Make head available to the app
app.provide('head', head);

// Initialize AOS when app is mounted
app.mount('#app');

// Initialize AOS after mount
AOS.init({
  duration: 1000,
});
