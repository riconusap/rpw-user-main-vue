<template>
  <div class="login-page">
    <div class="login-container">
      <div class="login-card">
        <div class="login-header">
          <img src="/img/logo.png" alt="RPW Logo" class="logo" />
          <h1>Admin Login</h1>
          <p>R. Prama Wijaya & Partners</p>
        </div>

        <form @submit.prevent="handleLogin" class="login-form">
          <div v-if="errorMessage" class="alert alert-danger">
            {{ errorMessage }}
          </div>

          <div class="form-group">
            <label for="email">Email</label>
            <input
              id="email"
              v-model="email"
              type="email"
              class="form-control"
              placeholder="admin@rpwadvocates.com"
              required
              :disabled="loading"
            />
          </div>

          <div class="form-group">
            <label for="password">Password</label>
            <input
              id="password"
              v-model="password"
              type="password"
              class="form-control"
              placeholder="Enter your password"
              required
              :disabled="loading"
            />
          </div>

          <button type="submit" class="btn btn-login" :disabled="loading">
            <span v-if="!loading">Login</span>
            <span v-else>
              <i class="fas fa-spinner fa-spin"></i> Logging in...
            </span>
          </button>
        </form>

        <div class="login-footer">
          <router-link to="/" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Website
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { signIn } from '@/lib/supabase';

export default defineComponent({
  name: 'AdminLogin',
  setup() {
    const router = useRouter();
    const route = useRoute();
    const email = ref('');
    const password = ref('');
    const loading = ref(false);
    const errorMessage = ref('');

    const handleLogin = async () => {
      loading.value = true;
      errorMessage.value = '';

      try {
        const { data, error } = await signIn(email.value, password.value);

        if (error) throw error;

        if (data.session) {
          // Redirect to intended page or dashboard
          const redirect = route.query.redirect as string || '/admin';
          router.push(redirect);
        }
      } catch (error: any) {
        errorMessage.value = error.message || 'Login failed. Please check your credentials.';
      } finally {
        loading.value = false;
      }
    };

    return {
      email,
      password,
      loading,
      errorMessage,
      handleLogin,
    };
  },
});
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
  padding: 2rem;
}

.login-container {
  width: 100%;
  max-width: 440px;
}

.login-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  overflow: hidden;
}

.login-header {
  background: linear-gradient(135deg, #d4a948 0%, #c69840 100%);
  color: white;
  padding: 3rem 2rem;
  text-align: center;
}

.logo {
  width: 80px;
  height: auto;
  margin-bottom: 1rem;
  filter: brightness(0) invert(1);
}

.login-header h1 {
  font-size: 1.75rem;
  margin-bottom: 0.5rem;
  font-weight: 600;
}

.login-header p {
  font-size: 0.875rem;
  opacity: 0.9;
  margin: 0;
}

.login-form {
  padding: 2rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #1e293b;
}

.form-control {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  font-size: 1rem;
  transition: all 0.2s;
}

.form-control:focus {
  outline: none;
  border-color: #d4a948;
  box-shadow: 0 0 0 3px rgba(212, 169, 72, 0.1);
}

.form-control:disabled {
  background: #f1f5f9;
  cursor: not-allowed;
}

.btn-login {
  width: 100%;
  padding: 0.875rem;
  background: #d4a948;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-login:hover:not(:disabled) {
  background: #c69840;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(212, 169, 72, 0.3);
}

.btn-login:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.alert {
  padding: 0.875rem;
  border-radius: 8px;
  margin-bottom: 1.5rem;
}

.alert-danger {
  background: #fee;
  color: #c00;
  border: 1px solid #fcc;
}

.login-footer {
  padding: 1.5rem 2rem;
  background: #f8fafc;
  text-align: center;
  border-top: 1px solid #e2e8f0;
}

.back-link {
  color: #64748b;
  text-decoration: none;
  font-size: 0.875rem;
  transition: color 0.2s;
}

.back-link:hover {
  color: #d4a948;
}

.back-link i {
  margin-right: 0.5rem;
}
</style>
