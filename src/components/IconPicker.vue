<template>
  <div v-if="show" class="icon-picker-overlay" @click.self="$emit('close')">
    <div class="icon-picker-modal">
      <div class="icon-picker-header">
        <h3>Select Icon</h3>
        <button @click="$emit('close')" class="btn-close">
          <i class="fas fa-times"></i>
        </button>
      </div>

      <div class="icon-picker-search">
        <i class="fas fa-search"></i>
        <input
          v-model="searchQuery"
          type="text"
          placeholder="Search icons..."
          class="search-input"
        />
      </div>

      <div class="icon-picker-categories">
        <button
          v-for="cat in categories"
          :key="cat.id"
          @click="selectedCategory = cat.id"
          :class="['category-btn', { active: selectedCategory === cat.id }]"
        >
          <i :class="cat.icon"></i>
          {{ cat.name }}
        </button>
      </div>

      <div class="icon-picker-grid">
        <div
          v-for="icon in filteredIcons"
          :key="icon"
          @click="selectIcon(icon)"
          :class="['icon-item', { selected: modelValue === icon }]"
          :title="icon"
        >
          <i :class="icon"></i>
          <span class="icon-name">{{ icon.replace('fas fa-', '') }}</span>
        </div>
      </div>

      <div v-if="filteredIcons.length === 0" class="no-results">
        <i class="fas fa-search"></i>
        <p>No icons found</p>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, computed } from 'vue';

export default defineComponent({
  name: 'IconPicker',
  props: {
    show: {
      type: Boolean,
      default: false,
    },
    modelValue: {
      type: String,
      default: '',
    },
  },
  emits: ['close', 'select', 'update:modelValue'],
  setup(props, { emit }) {
    const searchQuery = ref('');
    const selectedCategory = ref('all');

    const categories = [
      { id: 'all', name: 'All', icon: 'fas fa-th' },
      { id: 'business', name: 'Business', icon: 'fas fa-briefcase' },
      { id: 'law', name: 'Law', icon: 'fas fa-gavel' },
      { id: 'communication', name: 'Communication', icon: 'fas fa-comments' },
      { id: 'interface', name: 'Interface', icon: 'fas fa-desktop' },
      { id: 'people', name: 'People', icon: 'fas fa-users' },
    ];

    const iconsByCategory: Record<string, string[]> = {
      business: [
        'fas fa-briefcase',
        'fas fa-building',
        'fas fa-chart-line',
        'fas fa-handshake',
        'fas fa-money-bill-wave',
        'fas fa-calculator',
        'fas fa-file-invoice-dollar',
        'fas fa-landmark',
        'fas fa-piggy-bank',
        'fas fa-coins',
        'fas fa-receipt',
        'fas fa-cash-register',
      ],
      law: [
        'fas fa-gavel',
        'fas fa-balance-scale',
        'fas fa-scale-balanced',
        'fas fa-book-open',
        'fas fa-certificate',
        'fas fa-file-contract',
        'fas fa-file-signature',
        'fas fa-stamp',
        'fas fa-shield-alt',
        'fas fa-user-shield',
        'fas fa-search',
        'fas fa-fingerprint',
      ],
      communication: [
        'fas fa-comments',
        'fas fa-phone',
        'fas fa-envelope',
        'fas fa-phone-alt',
        'fas fa-comment-dots',
        'fas fa-paper-plane',
        'fas fa-inbox',
        'fas fa-at',
        'fas fa-mobile-alt',
        'fas fa-fax',
        'fas fa-headset',
        'fas fa-bullhorn',
      ],
      interface: [
        'fas fa-home',
        'fas fa-cog',
        'fas fa-bars',
        'fas fa-check',
        'fas fa-times',
        'fas fa-plus',
        'fas fa-minus',
        'fas fa-edit',
        'fas fa-trash',
        'fas fa-save',
        'fas fa-download',
        'fas fa-upload',
        'fas fa-star',
        'fas fa-heart',
        'fas fa-eye',
        'fas fa-search',
        'fas fa-filter',
        'fas fa-sort',
        'fas fa-calendar',
        'fas fa-clock',
        'fas fa-bell',
        'fas fa-flag',
        'fas fa-bookmark',
        'fas fa-tag',
      ],
      people: [
        'fas fa-user',
        'fas fa-users',
        'fas fa-user-tie',
        'fas fa-user-circle',
        'fas fa-user-friends',
        'fas fa-user-graduate',
        'fas fa-user-md',
        'fas fa-user-shield',
        'fas fa-id-card',
        'fas fa-id-badge',
        'fas fa-address-card',
        'fas fa-crown',
      ],
    };

    const allIcons = computed(() => {
      const icons = new Set<string>();
      Object.values(iconsByCategory).forEach((categoryIcons) => {
        categoryIcons.forEach((icon) => icons.add(icon));
      });
      return Array.from(icons).sort();
    });

    const filteredIcons = computed(() => {
      let icons =
        selectedCategory.value === 'all'
          ? allIcons.value
          : iconsByCategory[selectedCategory.value] || [];

      if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        icons = icons.filter((icon) => icon.toLowerCase().includes(query));
      }

      return icons;
    });

    const selectIcon = (icon: string) => {
      emit('update:modelValue', icon);
      emit('select', icon);
      emit('close');
    };

    return {
      searchQuery,
      selectedCategory,
      categories,
      filteredIcons,
      selectIcon,
    };
  },
});
</script>

<style scoped>
.icon-picker-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
  padding: 1rem;
}

.icon-picker-modal {
  background: white;
  border-radius: 12px;
  width: 100%;
  max-width: 900px;
  max-height: 85vh;
  display: flex;
  flex-direction: column;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
}

.icon-picker-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #e2e8f0;
}

.icon-picker-header h3 {
  margin: 0;
  font-size: 1.5rem;
  color: #1e293b;
}

.btn-close {
  background: none;
  border: none;
  font-size: 1.5rem;
  color: #64748b;
  cursor: pointer;
  padding: 0.5rem;
  transition: color 0.2s;
}

.btn-close:hover {
  color: #1e293b;
}

.icon-picker-search {
  padding: 1rem 1.5rem;
  border-bottom: 1px solid #e2e8f0;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.icon-picker-search i {
  color: #94a3b8;
  font-size: 1.125rem;
}

.search-input {
  flex: 1;
  border: none;
  outline: none;
  font-size: 1rem;
  color: #1e293b;
}

.search-input::placeholder {
  color: #cbd5e1;
}

.icon-picker-categories {
  display: flex;
  gap: 0.5rem;
  padding: 1rem 1.5rem;
  border-bottom: 1px solid #e2e8f0;
  overflow-x: auto;
  flex-wrap: wrap;
}

.category-btn {
  padding: 0.5rem 1rem;
  border: 2px solid #e2e8f0;
  background: white;
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.875rem;
  font-weight: 500;
  color: #64748b;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  white-space: nowrap;
}

.category-btn:hover {
  border-color: #d4a948;
  background: #fef3c7;
  color: #1e293b;
}

.category-btn.active {
  background: #d4a948;
  border-color: #d4a948;
  color: white;
}

.icon-picker-grid {
  padding: 1.5rem;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
  gap: 0.75rem;
  overflow-y: auto;
  flex: 1;
}

.icon-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
  background: white;
}

.icon-item:hover {
  border-color: #d4a948;
  background: #fef3c7;
  transform: translateY(-2px);
}

.icon-item.selected {
  border-color: #d4a948;
  background: #d4a948;
  color: white;
}

.icon-item i {
  font-size: 1.75rem;
  margin-bottom: 0.5rem;
  color: currentColor;
}

.icon-name {
  font-size: 0.75rem;
  text-align: center;
  color: currentColor;
  word-break: break-word;
  line-height: 1.2;
}

.no-results {
  padding: 3rem;
  text-align: center;
  color: #94a3b8;
}

.no-results i {
  font-size: 3rem;
  margin-bottom: 1rem;
  opacity: 0.5;
}

.no-results p {
  margin: 0;
  font-size: 1rem;
}

@media (max-width: 768px) {
  .icon-picker-grid {
    grid-template-columns: repeat(auto-fill, minmax(80px, 1fr));
  }

  .icon-picker-categories {
    flex-wrap: nowrap;
  }
}
</style>
