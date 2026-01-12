<template>
  <div class="dashboard">
    <!-- <div class="page-header">
      <h1>Dashboard</h1>
      <p>Welcome to RPW Law Firm Admin Panel</p>
    </div> -->

    <!-- Statistics Cards -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon" style="background: #3b82f6;">
          <i class="fas fa-newspaper"></i>
        </div>
        <div class="stat-content">
          <h3>{{ stats.articles }}</h3>
          <p>Articles</p>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon" style="background: #10b981;">
          <i class="fas fa-user-tie"></i>
        </div>
        <div class="stat-content">
          <h3>{{ stats.attorneys }}</h3>
          <p>Attorneys</p>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon" style="background: #f59e0b;">
          <i class="fas fa-envelope"></i>
        </div>
        <div class="stat-content">
          <h3>{{ stats.submissions }}</h3>
          <p>Contact Forms</p>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon" style="background: #8b5cf6;">
          <i class="fas fa-eye"></i>
        </div>
        <div class="stat-content">
          <h3>{{ stats.views }}</h3>
          <p>Total Views</p>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="section">
      <h2>Quick Actions</h2>
      <div class="actions-grid">
        <router-link to="/admin/articles/new" class="action-card">
          <i class="fas fa-plus-circle"></i>
          <span>New Article</span>
        </router-link>

        <router-link to="/admin/hero-slides" class="action-card">
          <i class="fas fa-image"></i>
          <span>Manage Hero Slides</span>
        </router-link>

        <router-link to="/admin/attorneys" class="action-card">
          <i class="fas fa-user-plus"></i>
          <span>Add Attorney</span>
        </router-link>

        <router-link to="/admin/settings" class="action-card">
          <i class="fas fa-cog"></i>
          <span>Settings</span>
        </router-link>
      </div>
    </div>

    <!-- Recent Submissions -->
    <div class="section">
      <div class="section-header">
        <h2>Recent Contact Submissions</h2>
        <router-link to="/admin/contact-submissions" class="btn-link">
          View All <i class="fas fa-arrow-right"></i>
        </router-link>
      </div>

      <div class="table-responsive">
        <table class="table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Email</th>
              <th>Subject</th>
              <th>Date</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="loading">
              <td colspan="5" class="text-center">
                <i class="fas fa-spinner fa-spin"></i> Loading...
              </td>
            </tr>
            <tr v-else-if="recentSubmissions.length === 0">
              <td colspan="5" class="text-center">No submissions yet</td>
            </tr>
            <tr v-else v-for="submission in recentSubmissions" :key="submission.id">
              <td>{{ submission.name }}</td>
              <td>{{ submission.email }}</td>
              <td>{{ submission.subject }}</td>
              <td>{{ formatDate(submission.created_at) }}</td>
              <td>
                <span :class="`badge badge-${getStatusColor(submission.status)}`">
                  {{ submission.status }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { supabase } from '@/lib/supabase';

interface Stats {
  articles: number;
  attorneys: number;
  submissions: number;
  views: number;
}

interface Submission {
  id: string;
  name: string;
  email: string;
  subject: string;
  status: string;
  created_at: string;
}

export default defineComponent({
  name: 'AdminDashboard',
  setup() {
    const loading = ref(false);
    const stats = ref<Stats>({
      articles: 0,
      attorneys: 0,
      submissions: 0,
      views: 0,
    });
    const recentSubmissions = ref<Submission[]>([]);

    const loadStats = async () => {
      try {
        // Count articles
        const { count: articlesCount } = await supabase
          .from('articles')
          .select('*', { count: 'exact', head: true });
        
        // Count attorneys
        const { count: attorneysCount } = await supabase
          .from('attorneys')
          .select('*', { count: 'exact', head: true });
        
        // Count submissions
        const { count: submissionsCount } = await supabase
          .from('contact_submissions')
          .select('*', { count: 'exact', head: true });
        
        // Sum article views
        const { data: viewsData } = await supabase
          .from('articles')
          .select('views_count');
        
        const totalViews = viewsData?.reduce((sum, article) => sum + (article.views_count || 0), 0) || 0;

        stats.value = {
          articles: articlesCount || 0,
          attorneys: attorneysCount || 0,
          submissions: submissionsCount || 0,
          views: totalViews,
        };
      } catch (error) {
        console.error('Error loading stats:', error);
      }
    };

    const loadRecentSubmissions = async () => {
      loading.value = true;
      try {
        const { data, error } = await supabase
          .from('contact_submissions')
          .select('*')
          .order('created_at', { ascending: false })
          .limit(5);

        if (error) throw error;
        recentSubmissions.value = data || [];
      } catch (error) {
        console.error('Error loading submissions:', error);
      } finally {
        loading.value = false;
      }
    };

    const formatDate = (dateString: string) => {
      const date = new Date(dateString);
      return date.toLocaleDateString('id-ID', {
        day: '2-digit',
        month: 'short',
        year: 'numeric',
      });
    };

    const getStatusColor = (status: string) => {
      const colors: Record<string, string> = {
        new: 'primary',
        read: 'info',
        replied: 'success',
        archived: 'secondary',
      };
      return colors[status] || 'secondary';
    };

    onMounted(() => {
      loadStats();
      loadRecentSubmissions();
    });

    return {
      loading,
      stats,
      recentSubmissions,
      formatDate,
      getStatusColor,
    };
  },
});
</script>

<style scoped>
.dashboard {
  max-width: 1400px;
}

.page-header {
  margin-bottom: 2rem;
}

.page-header h1 {
  font-size: 2rem;
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.page-header p {
  color: #64748b;
  margin: 0;
}

/* Stats Grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  display: flex;
  align-items: center;
  gap: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s, box-shadow 0.2s;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 1.5rem;
}

.stat-content h3 {
  font-size: 2rem;
  font-weight: 700;
  color: #1e293b;
  margin: 0;
}

.stat-content p {
  color: #64748b;
  margin: 0;
  font-size: 0.875rem;
}

/* Section */
.section {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 2rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.section h2 {
  font-size: 1.5rem;
  color: #1e293b;
  margin-bottom: 1.5rem;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.section-header h2 {
  margin: 0;
}

.btn-link {
  color: #d4a948;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.2s;
}

.btn-link:hover {
  color: #c69840;
}

/* Actions Grid */
.actions-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}

.action-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.75rem;
  padding: 1.5rem;
  border: 2px dashed #e2e8f0;
  border-radius: 12px;
  text-decoration: none;
  color: #64748b;
  transition: all 0.2s;
}

.action-card:hover {
  border-color: #d4a948;
  color: #d4a948;
  background: #fef9f0;
}

.action-card i {
  font-size: 2rem;
}

.action-card span {
  font-weight: 500;
}

/* Table */
.table-responsive {
  overflow-x: auto;
}

.table {
  width: 100%;
  border-collapse: collapse;
}

.table thead {
  background: #f8fafc;
}

.table th {
  padding: 0.875rem;
  text-align: left;
  font-weight: 600;
  color: #475569;
  font-size: 0.875rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.table td {
  padding: 0.875rem;
  border-top: 1px solid #e2e8f0;
}

.table tbody tr:hover {
  background: #f8fafc;
}

.text-center {
  text-align: center;
}

.badge {
  padding: 0.25rem 0.75rem;
  border-radius: 9999px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: capitalize;
}

.badge-primary {
  background: #dbeafe;
  color: #1e40af;
}

.badge-info {
  background: #e0f2fe;
  color: #0369a1;
}

.badge-success {
  background: #d1fae5;
  color: #065f46;
}

.badge-secondary {
  background: #f1f5f9;
  color: #475569;
}
</style>
