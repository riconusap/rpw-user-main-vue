<template>
  <div class="submissions-page">
    <div class="page-header-admin">
      <h1>Contact Submissions</h1>
      <div class="header-actions">
        <select v-model="filterStatus" class="filter-select">
          <option value="all">All Status</option>
          <option value="new">New</option>
          <option value="read">Read</option>
          <option value="replied">Replied</option>
          <option value="archived">Archived</option>
        </select>
        <button @click="exportToCSV" class="btn btn-secondary">
          <i class="fas fa-download"></i> Export CSV
        </button>
      </div>
    </div>

    <!-- Stats -->
    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-icon new">
          <i class="fas fa-envelope"></i>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ stats.new }}</span>
          <span class="stat-label">New</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon read">
          <i class="fas fa-envelope-open"></i>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ stats.read }}</span>
          <span class="stat-label">Read</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon replied">
          <i class="fas fa-reply"></i>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ stats.replied }}</span>
          <span class="stat-label">Replied</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon archived">
          <i class="fas fa-archive"></i>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ stats.archived }}</span>
          <span class="stat-label">Archived</span>
        </div>
      </div>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="loading">
      <i class="fas fa-spinner fa-spin"></i> Loading submissions...
    </div>

    <!-- Submissions Table -->
    <div v-else class="table-container">
      <table class="submissions-table">
        <thead>
          <tr>
            <th>Status</th>
            <th>Name</th>
            <th>Email</th>
            <th>Subject</th>
            <th>Date</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="submission in filteredSubmissions"
            :key="submission.id"
            :class="{ 'unread': submission.status === 'new' }"
            @click="viewSubmission(submission)"
          >
            <td>
              <span class="status-badge" :class="submission.status">
                {{ submission.status }}
              </span>
            </td>
            <td class="name-cell">{{ submission.name }}</td>
            <td>{{ submission.email }}</td>
            <td class="subject-cell">{{ submission.subject || '-' }}</td>
            <td class="date-cell">{{ formatDate(submission.created_at) }}</td>
            <td class="actions-cell" @click.stop>
              <button
                @click="viewSubmission(submission)"
                class="btn-icon"
                title="Mark as replied"
              >
                <i class="fas fa-reply"></i>
              </button>
              <button
                @click="updateStatus(submission, 'archived')"
                class="btn-icon"
                title="Archive"
              >
                <i class="fas fa-archive"></i>
              </button>
              <button
                @click="deleteSubmission(submission)"
                class="btn-icon delete"
                title="Delete"
              >
                <i class="fas fa-trash"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <div v-if="filteredSubmissions.length === 0" class="empty-state">
        <i class="fas fa-inbox"></i>
        <p>No submissions found</p>
      </div>
    </div>

    <!-- View Modal -->
    <div v-if="viewingSubmission" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <div class="modal-header">
          <h2>Submission Details</h2>
          <button @click="closeModal" class="btn-close">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <div class="modal-body">
          <div class="submission-detail">
            <label>Status</label>
            <select
              v-model="viewingSubmission.status"
              @change="updateStatus(viewingSubmission, viewingSubmission.status)"
              class="status-select"
            >
              <option value="new">New</option>
              <option value="read">Read</option>
              <option value="replied">Replied</option>
              <option value="archived">Archived</option>
            </select>
          </div>

          <div class="submission-detail">
            <label>Name</label>
            <p>{{ viewingSubmission.name }}</p>
          </div>

          <div class="submission-detail">
            <label>Email</label>
            <p>
              <a :href="`mailto:${viewingSubmission.email}`">
                {{ viewingSubmission.email }}
              </a>
            </p>
          </div>

          <div class="submission-detail" v-if="viewingSubmission.phone">
            <label>Phone</label>
            <p>
              <a :href="`tel:${viewingSubmission.phone}`">
                {{ viewingSubmission.phone }}
              </a>
            </p>
          </div>

          <div class="submission-detail" v-if="viewingSubmission.subject">
            <label>Subject</label>
            <p>{{ viewingSubmission.subject }}</p>
          </div>

          <div class="submission-detail">
            <label>Message</label>
            <p class="message-text">{{ viewingSubmission.message }}</p>
          </div>

          <div class="submission-detail">
            <label>Submitted</label>
            <p>{{ formatDate(viewingSubmission.created_at) }}</p>
          </div>
        </div>

        <div class="modal-footer">
          <a
            :href="`mailto:${viewingSubmission.email}?subject=Re: ${viewingSubmission.subject || 'Your inquiry'}`"
            class="btn btn-primary"
            target="_blank"
          >
            <i class="fas fa-reply"></i> Reply via Email
          </a>
          <button @click="closeModal" class="btn btn-secondary">Close</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted } from 'vue';
import { supabase } from '@/lib/supabase';

interface ContactSubmission {
  id: string;
  name: string;
  email: string;
  phone?: string;
  subject?: string;
  message: string;
  status: 'new' | 'read' | 'replied' | 'archived';
  created_at: string;
}

interface Stats {
  new: number;
  read: number;
  replied: number;
  archived: number;
}

export default defineComponent({
  name: 'AdminContactSubmissions',
  setup() {
    const loading = ref(false);
    const submissions = ref<ContactSubmission[]>([]);
    const filterStatus = ref('all');
    const viewingSubmission = ref<ContactSubmission | null>(null);

    const stats = computed<Stats>(() => {
      return {
        new: submissions.value.filter((s) => s.status === 'new').length,
        read: submissions.value.filter((s) => s.status === 'read').length,
        replied: submissions.value.filter((s) => s.status === 'replied').length,
        archived: submissions.value.filter((s) => s.status === 'archived').length,
      };
    });

    const filteredSubmissions = computed(() => {
      if (filterStatus.value === 'all') {
        return submissions.value;
      }
      return submissions.value.filter((s) => s.status === filterStatus.value);
    });

    const loadSubmissions = async () => {
      loading.value = true;
      try {
        const { data, error } = await supabase
          .from('contact_submissions')
          .select('*')
          .order('created_at', { ascending: false });

        if (error) throw error;
        submissions.value = data || [];
      } catch (error: any) {
        alert('Error loading submissions: ' + error.message);
      } finally {
        loading.value = false;
      }
    };

    const viewSubmission = async (submission: ContactSubmission) => {
      viewingSubmission.value = submission;

      // Mark as read if it's new
      if (submission.status === 'new') {
        await updateStatus(submission, 'read', false);
      }
    };

    const closeModal = () => {
      viewingSubmission.value = null;
    };

    const updateStatus = async (
      submission: ContactSubmission,
      status: string,
      showAlert = false
    ) => {
      try {
        const { error } = await supabase
          .from('contact_submissions')
          .update({ status })
          .eq('id', submission.id);

        if (error) throw error;

        // Update local state
        submission.status = status as ContactSubmission['status'];
        await loadSubmissions();

        if (showAlert) {
          alert('Status updated successfully');
        }
      } catch (error: any) {
        alert('Error updating status: ' + error.message);
      }
    };

    const deleteSubmission = async (submission: ContactSubmission) => {
      if (!confirm(`Delete submission from ${submission.name}?`)) return;

      try {
        const { error } = await supabase
          .from('contact_submissions')
          .delete()
          .eq('id', submission.id);

        if (error) throw error;
        await loadSubmissions();
      } catch (error: any) {
        alert('Error deleting submission: ' + error.message);
      }
    };

    const exportToCSV = () => {
      const headers = ['Date', 'Name', 'Email', 'Phone', 'Subject', 'Message', 'Status'];
      const rows = filteredSubmissions.value.map((s) => [
        formatDate(s.created_at),
        s.name,
        s.email,
        s.phone || '',
        s.subject || '',
        s.message.replace(/"/g, '""'),
        s.status,
      ]);

      const csvContent = [
        headers.join(','),
        ...rows.map((row) => row.map((cell) => `"${cell}"`).join(',')),
      ].join('\n');

      const blob = new Blob([csvContent], { type: 'text/csv' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `contact-submissions-${Date.now()}.csv`;
      a.click();
      URL.revokeObjectURL(url);
    };

    const formatDate = (dateString: string) => {
      const date = new Date(dateString);
      return new Intl.DateTimeFormat('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
      }).format(date);
    };

    onMounted(() => {
      loadSubmissions();
    });

    return {
      loading,
      submissions,
      filterStatus,
      viewingSubmission,
      stats,
      filteredSubmissions,
      viewSubmission,
      closeModal,
      updateStatus,
      deleteSubmission,
      exportToCSV,
      formatDate,
    };
  },
});
</script>

<style scoped>
.submissions-page {
  max-width: 1400px;
}

.page-header-admin {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  flex-wrap: wrap;
  gap: 1rem;
}

.page-header-admin h1 {
  font-size: 2rem;
  color: #1e293b;
  margin: 0;
}

.header-actions {
  display: flex;
  gap: 1rem;
  align-items: center;
}

.filter-select {
  padding: 0.75rem 1rem;
  padding-right: 2.5rem;
  border: 2px solid #e2e8f0;
  border-radius: 10px;
  font-size: 0.875rem;
  background: white;
  cursor: pointer;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23d4a948' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 0.75rem center;
  background-size: 16px;
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  font-weight: 500;
  color: #1e293b;
  transition: all 0.2s ease;
}

.filter-select:hover {
  border-color: #d4a948;
  box-shadow: 0 2px 8px rgba(212, 169, 72, 0.1);
}

.filter-select:focus {
  outline: none;
  border-color: #d4a948;
  box-shadow: 0 0 0 3px rgba(212, 169, 72, 0.1);
}

.btn {
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  border: none;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
}

.btn-primary {
  background: #d4a948;
  color: white;
}

.btn-primary:hover {
  background: #c69840;
}

.btn-secondary {
  background: #e2e8f0;
  color: #1e293b;
}

.btn-secondary:hover {
  background: #cbd5e1;
}

/* Stats */
.stats-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  display: flex;
  align-items: center;
  gap: 1rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  width: 50px;
  height: 50px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
}

.stat-icon.new {
  background: #dbeafe;
  color: #3b82f6;
}

.stat-icon.read {
  background: #f3e8ff;
  color: #a855f7;
}

.stat-icon.replied {
  background: #dcfce7;
  color: #22c55e;
}

.stat-icon.archived {
  background: #fef3c7;
  color: #f59e0b;
}

.stat-info {
  display: flex;
  flex-direction: column;
}

.stat-value {
  font-size: 2rem;
  font-weight: 700;
  color: #1e293b;
}

.stat-label {
  font-size: 0.875rem;
  color: #64748b;
}

/* Table */
.table-container {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.submissions-table {
  width: 100%;
  border-collapse: collapse;
}

.submissions-table thead {
  background: #f8fafc;
}

.submissions-table th {
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  color: #1e293b;
  font-size: 0.875rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.submissions-table tbody tr {
  border-top: 1px solid #e2e8f0;
  cursor: pointer;
  transition: background 0.2s;
}

.submissions-table tbody tr:hover {
  background: #f8fafc;
}

.submissions-table tbody tr.unread {
  background: #eff6ff;
}

.submissions-table td {
  padding: 1rem;
  color: #64748b;
}

.name-cell {
  font-weight: 600;
  color: #1e293b;
}

.subject-cell {
  max-width: 300px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.date-cell {
  white-space: nowrap;
}

.status-badge {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
}

.status-badge.new {
  background: #dbeafe;
  color: #3b82f6;
}

.status-badge.read {
  background: #f3e8ff;
  color: #a855f7;
}

.status-badge.replied {
  background: #dcfce7;
  color: #22c55e;
}

.status-badge.archived {
  background: #fef3c7;
  color: #f59e0b;
}

.actions-cell {
  display: flex;
  gap: 0.5rem;
}

.btn-icon {
  width: 32px;
  height: 32px;
  border: none;
  background: #f1f5f9;
  color: #64748b;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.btn-icon:hover {
  background: #e2e8f0;
  color: #1e293b;
}

.btn-icon.delete:hover {
  background: #fee;
  color: #ef4444;
}

.loading,
.empty-state {
  text-align: center;
  padding: 3rem;
  color: #64748b;
}

.empty-state i {
  font-size: 3rem;
  color: #cbd5e1;
  margin-bottom: 1rem;
}

/* Modal */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 2rem;
}

.modal-content {
  background: white;
  border-radius: 12px;
  width: 100%;
  max-width: 700px;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #e2e8f0;
}

.modal-header h2 {
  font-size: 1.5rem;
  color: #1e293b;
  margin: 0;
}

.btn-close {
  background: none;
  border: none;
  font-size: 1.5rem;
  color: #64748b;
  cursor: pointer;
  padding: 0.5rem;
}

.btn-close:hover {
  color: #1e293b;
}

.modal-body {
  padding: 1.5rem;
}

.submission-detail {
  margin-bottom: 1.5rem;
}

.submission-detail label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #1e293b;
  font-size: 0.875rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.submission-detail p {
  color: #64748b;
  margin: 0;
}

.submission-detail a {
  color: #3b82f6;
  text-decoration: none;
}

.submission-detail a:hover {
  text-decoration: underline;
}

.message-text {
  white-space: pre-wrap;
  line-height: 1.6;
  background: #f8fafc;
  padding: 1rem;
  border-radius: 8px;
}

.status-select {
  padding: 0.5rem 1rem;
  padding-right: 2.5rem;
  border: 2px solid #e2e8f0;
  border-radius: 10px;
  font-size: 0.875rem;
  background: white;
  cursor: pointer;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23d4a948' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 0.75rem center;
  background-size: 16px;
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  font-weight: 500;
  color: #1e293b;
  transition: all 0.2s ease;
}

.status-select:hover {
  border-color: #d4a948;
  box-shadow: 0 2px 8px rgba(212, 169, 72, 0.1);
}

.status-select:focus {
  outline: none;
  border-color: #d4a948;
  box-shadow: 0 0 0 3px rgba(212, 169, 72, 0.1);
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  padding: 1.5rem;
  border-top: 1px solid #e2e8f0;
}

@media (max-width: 768px) {
  .stats-row {
    grid-template-columns: 1fr 1fr;
  }

  .table-container {
    overflow-x: auto;
  }

  .submissions-table {
    min-width: 800px;
  }
}
</style>
