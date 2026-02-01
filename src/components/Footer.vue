<template>
  <footer class="footer">
    <div class="footer-main">
      <div class="container">
        <div class="row">
          <!-- About Section -->
          <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
            <div class="footer-widget">
              <RouterLink
                to="/"
                class="footer-logo"
              >
                <img
                  v-if="settings?.site_logo"
                  :src="getImageUrl(settings.site_logo, 'images')"
                  :alt="settings.site_name || 'Logo'"
                />
                <img
                  v-else
                  src="/img/logo.png"
                  alt="R. Prama Wijaya Law Firm"
                />
              </RouterLink>
              <!-- <p class="footer-description" v-html="settings.site_description">
              </p> -->
              <p class="footer-description">
                If you must confront a dispute and want to explore viable options and strategies, we invite you to reach out to our law firm. You will speak directly with a savvy, dynamic litigator who have an outstanding credentials and extensive high-value case experience.
                <br>
                <br>
                Please don’t hesitate to contact us if you need further assistance.
              </p>
              <div class="social-links">
                <a
                  v-if="settings?.social_facebook"
                  :href="settings.social_facebook"
                  target="_blank"
                  rel="noopener noreferrer"
                  aria-label="Facebook"
                  class="social-link"
                >
                  <i class="fab fa-facebook-f"></i>
                </a>
                <a
                  v-if="settings?.social_twitter"
                  :href="settings.social_twitter"
                  target="_blank"
                  rel="noopener noreferrer"
                  aria-label="Twitter"
                  class="social-link"
                >
                  <i class="fab fa-twitter"></i>
                </a>
                <a
                  v-if="settings?.social_linkedin"
                  :href="settings.social_linkedin"
                  target="_blank"
                  rel="noopener noreferrer"
                  aria-label="LinkedIn"
                  class="social-link"
                >
                  <i class="fab fa-linkedin-in"></i>
                </a>
                <a
                  v-if="settings?.social_instagram"
                  :href="settings.social_instagram"
                  target="_blank"
                  rel="noopener noreferrer"
                  aria-label="Instagram"
                  class="social-link"
                >
                  <i class="fab fa-instagram"></i>
                </a>
                <a
                  v-if="settings?.social_youtube"
                  :href="settings.social_youtube"
                  target="_blank"
                  rel="noopener noreferrer"
                  aria-label="YouTube"
                  class="social-link"
                >
                  <i class="fab fa-youtube"></i>
                </a>
              </div>
            </div>
          </div>

          <!-- Quick Links -->
          <div class="col-lg-2 col-md-6 mb-4 mb-lg-0">
            <div class="footer-widget">
              <h5 class="footer-title">Quick Links</h5>
              <ul class="footer-links">
                <li>
                  <RouterLink to="/">Home</RouterLink>
                </li>
                <li>
                  <RouterLink to="/about">About Us</RouterLink>
                </li>
                <li>
                  <RouterLink to="/teams">Our Attorneys</RouterLink>
                </li>
                <li>
                  <RouterLink to="/articles">Articles</RouterLink>
                </li>
                <li>
                  <RouterLink to="/contact">Contact Us</RouterLink>
                </li>
              </ul>
            </div>
          </div>

          <!-- Practice Areas (Optional) -->
          <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
            <div class="footer-widget">
              <h5 class="footer-title">Practice Areas</h5>
              <ul class="footer-links">
                <li><a href="#service">Corporate Law</a></li>
                <li><a href="#service">Civil Litigation</a></li>
                <li><a href="#service">Contract Law</a></li>
                <li><a href="#service">Legal Consultation</a></li>
                <li><a href="#service">Business Advisory</a></li>
              </ul>
            </div>
          </div>

          <!-- Contact Info -->
          <div class="col-lg-4 col-md-6 mb-4 mb-lg-0">
            <div class="footer-widget">
              <h5 class="footer-title">Get In Touch</h5>
              <ul class="contact-info">
                <li v-if="settings?.contact_address">
                  <i class="fas fa-map-marker-alt"></i>
                  <span>{{ settings.contact_address }}</span>
                </li>
                <li v-if="settings?.contact_address_secondary">
                  <i class="fas fa-map-marker-alt"></i>
                  <span>{{ settings.contact_address_secondary }}</span>
                </li>
                <li v-if="settings?.contact_phone">
                  <i class="fas fa-phone-alt"></i>
                  <a :href="`tel:${settings.contact_phone}`">{{ settings.contact_phone }}</a>
                </li>
                <li v-if="settings?.contact_whatsapp">
                  <i class="fab fa-whatsapp"></i>
                  <a
                    :href="`https://wa.me/${settings.contact_whatsapp.replace(/[^0-9]/g, '')}`"
                    target="_blank"
                    rel="noopener noreferrer"
                  >
                    {{ settings.contact_whatsapp }}
                  </a>
                </li>
                <li v-if="settings?.contact_email">
                  <i class="fas fa-envelope"></i>
                  <a :href="`mailto:${settings.contact_email}`">{{ settings.contact_email }}</a>
                </li>
                <li
                  v-if="settings?.business_hours"
                  class="business-hours"
                >
                  <i class="fas fa-clock"></i>
                  <span>{{ settings.business_hours }}</span>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Footer Bottom -->
    <div class="footer-bottom">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-md-6 text-center text-md-left mb-3 mb-md-0">
            <p class="copyright">
              &copy; {{ currentYear }}
              <a :href="settings?.social_linkedin || '#'">
                {{ settings?.site_name || 'R. Prama Wijaya Law Firm' }}
              </a>.
              All Rights Reserved.
            </p>
          </div>
          <div class="col-md-6 text-center text-md-right">
            <ul class="footer-legal">
              <li><a
                  href="#"
                  @click.prevent
                >Privacy Policy</a></li>
              <li><a
                  href="#"
                  @click.prevent
                >Terms of Service</a></li>
              <li><a
                  href="#"
                  @click.prevent
                >Disclaimer</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>

<script lang="ts">
import { defineComponent, onMounted, computed } from "vue";
import { useSettings } from "@/composables/useSettings";
import { getImageUrl } from "@/lib/supabase";

export default defineComponent({
  name: "Footer",
  setup() {
    const { settings, loadSettings } = useSettings();

    onMounted(() => {
      loadSettings();
    });

    const currentYear = computed(() => new Date().getFullYear());

    return {
      settings,
      getImageUrl,
      currentYear,
    };
  },
});
</script>

<style scoped>
footer {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  color: #e1e8ed;
  margin-top: 5rem;
}

.footer-main {
  padding: 4rem 0 2rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

/* Footer Logo */
.footer-logo {
  display: inline-block;
  margin-bottom: 1.5rem;
}

.footer-logo img {
  height: 100px;
  width: auto;
  filter: brightness(1.1);
}

/* Footer Widget */
.footer-widget {
  height: 100%;
}

.footer-title {
  color: #d4a948;
  font-size: 1.125rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  position: relative;
  padding-bottom: 0.75rem;
}

.footer-title::after {
  content: "";
  position: absolute;
  bottom: 0;
  left: 0;
  width: 40px;
  height: 2px;
  background: linear-gradient(90deg, #d4a948 0%, transparent 100%);
}

.footer-description {
  color: #b0b8c0;
  line-height: 1.8;
  margin-bottom: 1.5rem;
  font-size: 0.90rem;
}

/* Social Links */
.social-links {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.social-link {
  width: 40px;
  height: 40px;
  background: rgba(212, 169, 72, 0.1);
  border: 1px solid rgba(212, 169, 72, 0.3);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #d4a948;
  font-size: 1rem;
  transition: all 0.3s ease;
  text-decoration: none;
}

.social-link:hover {
  background: #d4a948;
  color: #1a1a2e;
  border-color: #d4a948;
  transform: translateY(-3px);
  box-shadow: 0 4px 12px rgba(212, 169, 72, 0.3);
}

/* Footer Links */
.footer-links {
  list-style: none;
  padding: 0;
  margin: 0;
}

.footer-links li {
  margin-bottom: 0.75rem;
}

.footer-links a {
  color: #b0b8c0;
  text-decoration: none;
  font-size: 0.9375rem;
  transition: all 0.3s ease;
  display: inline-flex;
  align-items: center;
  position: relative;
  padding-left: 1rem;
}

.footer-links a::before {
  content: "\f105";
  font-family: "Font Awesome 5 Free";
  font-weight: 900;
  position: absolute;
  left: 0;
  color: #d4a948;
  opacity: 0;
  transition: all 0.3s ease;
}

.footer-links a:hover {
  color: #d4a948;
  padding-left: 1.25rem;
}

.footer-links a:hover::before {
  opacity: 1;
  left: 0;
}

/* Contact Info */
.contact-info {
  list-style: none;
  padding: 0;
  margin: 0;
}

.contact-info li {
  display: flex;
  align-items: flex-start;
  margin-bottom: 1.25rem;
  font-size: 0.9375rem;
  line-height: 1.6;
}

.contact-info li i {
  color: #d4a948;
  width: 20px;
  margin-right: 1rem;
  margin-top: 2px;
  flex-shrink: 0;
  font-size: 1rem;
}

.contact-info li span,
.contact-info li a {
  color: #b0b8c0;
  text-decoration: none;
  transition: color 0.3s ease;
}

.contact-info li a:hover {
  color: #d4a948;
}

.contact-info li.business-hours span {
  white-space: pre-line;
  font-size: 0.875rem;
}

/* Footer Bottom */
.footer-bottom {
  padding: 1.5rem 0;
  background: rgba(0, 0, 0, 0.2);
}

.copyright {
  margin: 0;
  color: #b0b8c0;
  font-size: 0.875rem;
}

.copyright a {
  color: #d4a948;
  text-decoration: none;
  font-weight: 600;
  transition: color 0.3s ease;
}

.copyright a:hover {
  color: #e5ba5a;
}

.footer-legal {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  justify-content: center;
  gap: 1.5rem;
  flex-wrap: wrap;
}

.footer-legal li a {
  color: #b0b8c0;
  text-decoration: none;
  font-size: 0.875rem;
  transition: color 0.3s ease;
}

.footer-legal li a:hover {
  color: #d4a948;
}

/* Responsive */
@media (max-width: 991px) {
  .footer-main {
    padding: 3rem 0 1.5rem;
  }

  .footer-title::after {
    width: 30px;
  }
}

@media (max-width: 767px) {
  .footer-legal {
    justify-content: center;
    margin-top: 1rem;
  }

  .social-links {
    justify-content: flex-start;
  }

  .footer-bottom .col-md-6 {
    text-align: center !important;
  }
}

@media (max-width: 575px) {
  .footer-main {
    padding: 2rem 0 1rem;
  }

  .footer-legal {
    flex-direction: column;
    gap: 0.5rem;
  }

  .contact-info li {
    font-size: 0.875rem;
  }

  .text-white:hover {
    color: var(--primary) !important;
  }
}
</style>
