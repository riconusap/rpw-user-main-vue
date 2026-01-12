<template>
  <div class="settings-page">
    <h1>Settings</h1>
    <p class="subtitle">Configure your website settings</p>

    <div class="settings-grid">
      <div class="settings-card">
        <div class="card-icon">
          <i class="fas fa-cog"></i>
        </div>
        <h3>Site Configuration</h3>
        <p>Coming soon - Manage site name, logo, and general settings</p>
      </div>

      <div class="settings-card">
        <div class="card-icon">
          <i class="fas fa-envelope"></i>
        </div>
        <h3>Contact Information</h3>
        <p>Coming soon - Update office address, phone, and email</p>
      </div>

      <div class="settings-card">
        <div class="card-icon">
          <i class="fas fa-share-alt"></i>
        </div>
        <h3>Social Media</h3>
        <p>Coming soon - Manage social media links</p>
      </div>

      <div class="settings-card">
        <div class="card-icon">
          <i class="fas fa-search"></i>
        </div>
        <h3>SEO Settings</h3>
        <p>Coming soon - Configure meta tags and SEO options</p>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'AdminSettings',
});
</script>

<style scoped>
.settings-page {
  max-width: 1200px;
}

.settings-page h1 {
  font-size: 2rem;
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.subtitle {
  color: #64748b;
  margin-bottom: 2rem;
}

.settings-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.settings-card {
  background: white;
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.card-icon {
  width: 60px;
  height: 60px;
  margin: 0 auto 1rem;
  background: linear-gradient(135deg, #d4a948 0%, #c69840 100%);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.card-icon i {
  font-size: 1.75rem;
  color: white;
}

.settings-card h3 {
  font-size: 1.25rem;
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.settings-card p {
  color: #64748b;
  font-size: 0.875rem;
  line-height: 1.6;
}
</style>
