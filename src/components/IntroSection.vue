<template>
  <section class="intro-section">
    <div class="container-fluid p-0">
      <div class="intro-wrapper">
        <div class="row g-0">
          <!-- Full Width Background with Overlay Content -->
          <div class="col-12 intro-content-col">
            <div class="intro-content">
              <div class="content-divider"></div>
              
              <p class="intro-paragraph">
                Our firm is focused on the results. With exceptional experiences and depth of knowledge, we delivers a practical and effective solutions to solving your legal problems. Our mindset is understanding what your needs and deliver a top notch legal services.
              </p>

              <p class="intro-paragraph">
                The firm is committed to provide excellent service to develop a long-term relationship with clients. We believe that our dedication in understanding client's objectives are finding the right approach to achieve those objectives will be a strength point in developing a long-term mutual relationship between the firm and its clients.
              </p>
            </div>
          </div>
        </div>

        <!-- Gold Border Frame -->
        <div class="gold-border"></div>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'IntroSection',
});
</script>

<style scoped>
.intro-section {
  position: relative;
  padding: 4rem 0;
  background-color: #ffffff;
  overflow: hidden;
}

.intro-wrapper {
  position: relative;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 2rem;
}

.row {
  min-height: 600px;
}

/* Full Width Content with Background */
.intro-content-col {
  position: relative;
  background-image: url('/img/bg-intro.avif');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 4rem 3rem;
  min-height: 600px;
}

.intro-content-col::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, rgba(44, 62, 80, 0.85) 0%, rgba(52, 73, 94, 0.85) 100%);
  z-index: 1;
}

.intro-content {
  max-width: 800px;
  position: relative;
  z-index: 2;
}

.content-divider {
  width: 60px;
  height: 3px;
  background-color: #f39c12;
  margin-bottom: 2.5rem;
}

.intro-paragraph {
  color: #ffffff;
  font-size: 1rem;
  line-height: 1.8;
  margin-bottom: 1.5rem;
  text-align: justify;
  font-weight: 300;
  letter-spacing: 0.3px;
}

.intro-paragraph:last-child {
  margin-bottom: 0;
}

/* Gold Border Frame */
.gold-border {
  position: absolute;
  top: 2rem;
  left: 2rem;
  right: 2rem;
  bottom: 2rem;
  border: 3px solid #d4af37;
  pointer-events: none;
  z-index: 10;
}

/* Tablet */
@media (max-width: 991px) {
  .row {
    min-height: auto;
  }

  .intro-content-col {
    min-height: 500px;
    padding: 3rem 2rem;
  }

  .gold-border {
    top: 1rem;
    left: 1rem;
    right: 1rem;
    bottom: 1rem;
  }
}

/* Mobile */
@media (max-width: 768px) {
  .intro-section {
    padding: 0 0 2rem 0;
  }

  .intro-wrapper {
    padding: 0 1.5rem;
  }

  .intro-content-col {
    min-height: 450px;
    padding: 2.5rem 1.5rem;
  }

  .intro-content {
    max-width: 100%;
  }

  .content-divider {
    margin-bottom: 2rem;
  }

  .intro-paragraph {
    font-size: 0.95rem;
    line-height: 1.7;
    margin-bottom: 1.25rem;
  }

  .gold-border {
    top: 1rem;
    left: 1rem;
    right: 1rem;
    bottom: 1rem;
    border-width: 2px;
  }
}

@media (max-width: 480px) {
  .intro-section {
    padding: 0 0 1.5rem 0;
  }

  .intro-wrapper {
    padding: 0 1rem;
  }

  .intro-content-col {
    min-height: 400px;
    padding: 2rem 1.25rem;
  }

  .intro-paragraph {
    font-size: 0.9rem;
    text-align: left;
  }

  .content-divider {
    width: 50px;
    margin-bottom: 1.5rem;
  }

  .gold-border {
    top: 0.75rem;
    left: 0.75rem;
    right: 0.75rem;
    bottom: 0.75rem;
  }
}
</style>
