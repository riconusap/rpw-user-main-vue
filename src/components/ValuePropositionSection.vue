<template>
  <section class="value-proposition-section">
    <div class="container">
      <!-- Header -->
      <div class="value-header">
        <h2 class="section-title">WHY CHOOSE US?</h2>
        <div class="title-underline"></div>
        
        <p class="intro-text">
          Not only provide legal services in business law, but we also have many years experiences in many kinds of litigation cases. So that handling litigation cases is one of our strength, whether in criminal law, private law, employment law or family law.
        </p>
        
        <p class="intro-text">
          Today we actively serving a legal service in business activities for both individual and corporate clients and we continuously seek ways to improve our specialized knowledge.
        </p>
      </div>

      <!-- Value Points -->
      <div class="value-points">
        <div class="row">
          <div class="col-md-6">
            <div class="value-item">
              <div class="value-number">1</div>
              <div class="value-content">
                <p>We are experienced in corporate and commercial law, commercial litigation, dispute resolution and versatile legal matter.</p>
              </div>
            </div>
          </div>

          <div class="col-md-6">
            <div class="value-item">
              <div class="value-number">2</div>
              <div class="value-content">
                <p>One of our excellences is to assist matters with our capability to figure client's matters by a proper legal advice.</p>
              </div>
            </div>
          </div>

          <div class="col-md-6">
            <div class="value-item">
              <div class="value-number">3</div>
              <div class="value-content">
                <p>We always keep client's information as surely our responsibilities to be very seriously implanted for us while providing our services.</p>
              </div>
            </div>
          </div>

          <div class="col-md-6">
            <div class="value-item">
              <div class="value-number">4</div>
              <div class="value-content">
                <p>Striving to maintain the highest standards of practice through a process of selectively recruiting the best people, careful supervision, and rigorous training dedicated to provide the best quality legal products to our clients.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Image Section -->
    <div class="value-image-section">
      <div class="container">
        <div class="value-image">
          <img 
            src="/img/bg-value.png" 
            alt="Our Team"
            @error="handleImageError"
          />
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'ValuePropositionSection',
  setup() {
    const handleImageError = (event: Event) => {
      const target = event.target as HTMLImageElement;
      target.src = '/img/team-placeholder.jpg';
    };

    return {
      handleImageError,
    };
  },
});
</script>

<style scoped>
.value-proposition-section {
  background-color: #f8f9fa;
  padding: 5rem 0 0 0;
}

.value-header {
  max-width: 900px;
  margin: 0 auto 4rem;
  text-align: left;
}

.section-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 0.5rem;
  letter-spacing: 1px;
}

.title-underline {
  width: 80px;
  height: 4px;
  background-color: #f39c12;
  margin-bottom: 2rem;
}

.intro-text {
  font-size: 1rem;
  line-height: 1.8;
  color: #4a5568;
  margin-bottom: 1.5rem;
  text-align: justify;
}

.intro-text:last-of-type {
  margin-bottom: 0;
}

/* Value Points */
.value-points {
  padding: 0 6rem;
  margin-bottom: 4rem;
}

.value-item {
  display: flex;
  gap: 1.5rem;
  margin-bottom: 2.5rem;
  align-items: flex-start;
}

.value-number {
  flex-shrink: 0;
  width: 60px;
  height: 60px;
  background-color: #d4af37;
  color: #ffffff;
  font-size: 1.75rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
}

.value-content {
  flex: 1;
}

.value-content p {
  font-size: 0.95rem;
  line-height: 1.7;
  color: #4a5568;
  margin: 0;
  text-align: justify;
}

/* Image Section */
.value-image-section {
  background: linear-gradient(180deg, #f8f9fa 0%, #2c3e50 50%);
  padding: 3rem 0 5rem 0;
}

.value-image {
  max-width: 800px;
  margin: 0 auto;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
}

.value-image img {
  width: 100%;
  height: auto;
  display: block;
}

/* Tablet */
@media (max-width: 991px) {
  .value-proposition-section {
    padding: 4rem 0 0 0;
  }

  .section-title {
    font-size: 2rem;
  }

  .value-header {
    margin-bottom: 3rem;
  }

  .value-points {
    padding: 0 2rem;
    margin-bottom: 3rem;
  }

  .value-item {
    margin-bottom: 2rem;
  }
}

/* Mobile */
@media (max-width: 768px) {
  .value-proposition-section {
    padding: 3rem 0 0 0;
  }

  .value-header {
    text-align: left;
    margin-bottom: 2.5rem;
  }

  .section-title {
    font-size: 1.75rem;
  }

  .title-underline {
    width: 60px;
    height: 3px;
    margin-bottom: 1.5rem;
  }

  .intro-text {
    font-size: 0.95rem;
    line-height: 1.7;
    text-align: left;
  }

  .value-points {
    padding: 0;
    margin-bottom: 2.5rem;
  }

  .value-item {
    gap: 1rem;
    margin-bottom: 1.5rem;
  }

  .value-number {
    width: 50px;
    height: 50px;
    font-size: 1.5rem;
  }

  .value-content p {
    font-size: 0.9rem;
    text-align: left;
  }

  .value-image-section {
    padding: 2rem 0 3rem 0;
  }

  .value-image {
    border-radius: 4px;
  }
}

@media (max-width: 480px) {
  .value-proposition-section {
    padding: 2rem 0 0 0;
  }

  .section-title {
    font-size: 1.5rem;
  }

  .value-points {
    padding: 0;
  }

  .value-number {
    width: 45px;
    height: 45px;
    font-size: 1.25rem;
  }

  .value-item {
    gap: 0.75rem;
  }
}
</style>
