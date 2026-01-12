<template>
  <div class="component-name">
    <!-- Component template goes here -->
    <h1>{{ title }}</h1>
    <p>{{ description }}</p>
    
    <!-- Example: Conditional rendering -->
    <div v-if="isLoading">Loading...</div>
    <div v-else>
      <!-- Content -->
    </div>
    
    <!-- Example: List rendering -->
    <ul>
      <li v-for="(item, index) in items" :key="item.id || index">
        {{ item.name }}
      </li>
    </ul>
    
    <!-- Example: Event handling -->
    <button @click="handleClick">Click Me</button>
    
    <!-- Example: Two-way binding -->
    <input v-model="inputValue" type="text" />
    
    <!-- Example: Dynamic attributes -->
    <img :src="imageSrc" :alt="imageAlt" />
    
    <!-- Example: Dynamic classes -->
    <div :class="{ active: isActive, disabled: isDisabled }">
      Dynamic classes
    </div>
    
    <!-- Example: Inline styles -->
    <div :style="{ color: textColor, fontSize: fontSize + 'px' }">
      Styled text
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted, onUnmounted, PropType } from 'vue';
// Import other dependencies
// import { useRouter } from 'vue-router';
// import { useMyStore } from '@/stores/myStore';

// Define interfaces for type safety
interface Item {
  id: number;
  name: string;
  description?: string;
}

// Define component props interface (if using props)
interface Props {
  title: string;
  subtitle?: string;
  items?: Item[];
}

export default defineComponent({
  name: 'ComponentName', // Always provide a name
  
  // Define props with types
  props: {
    title: {
      type: String as PropType<string>,
      required: true,
      default: 'Default Title',
    },
    subtitle: {
      type: String as PropType<string>,
      required: false,
    },
    items: {
      type: Array as PropType<Item[]>,
      default: () => [],
    },
  },
  
  // Define emits (if component emits events)
  emits: ['update', 'delete', 'custom-event'],
  
  // Setup function - where all the magic happens
  setup(props, { emit }) {
    // ====================
    // 1. HOOKS & STORES
    // ====================
    // const router = useRouter();
    // const myStore = useMyStore();
    
    // ====================
    // 2. REACTIVE STATE
    // ====================
    const isLoading = ref<boolean>(false);
    const inputValue = ref<string>('');
    const description = ref<string>('Component description');
    const isActive = ref<boolean>(false);
    const isDisabled = ref<boolean>(false);
    const imageSrc = ref<string>('/img/placeholder.jpg');
    const imageAlt = ref<string>('Image description');
    const textColor = ref<string>('#333');
    const fontSize = ref<number>(16);
    
    // ====================
    // 3. COMPUTED PROPERTIES
    // ====================
    const computedValue = computed(() => {
      return inputValue.value.toUpperCase();
    });
    
    const filteredItems = computed(() => {
      if (!props.items) return [];
      return props.items.filter(item => item.name.length > 3);
    });
    
    // ====================
    // 4. METHODS / FUNCTIONS
    // ====================
    const handleClick = () => {
      console.log('Button clicked');
      emit('custom-event', { message: 'Button was clicked' });
    };
    
    const fetchData = async () => {
      isLoading.value = true;
      try {
        // const response = await fetch('/api/data');
        // const data = await response.json();
        // Process data...
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {
        isLoading.value = false;
      }
    };
    
    const toggleActive = () => {
      isActive.value = !isActive.value;
    };
    
    // ====================
    // 5. LIFECYCLE HOOKS
    // ====================
    onMounted(() => {
      console.log('Component mounted');
      // Initialize third-party libraries here
      // Example: Initialize Bootstrap tooltips, carousels, etc.
      // Example: Add event listeners
      // fetchData();
    });
    
    onUnmounted(() => {
      console.log('Component unmounted');
      // Cleanup: Remove event listeners, clear timers, etc.
    });
    
    // ====================
    // 6. RETURN (EXPOSE TO TEMPLATE)
    // ====================
    return {
      // State
      isLoading,
      inputValue,
      description,
      isActive,
      isDisabled,
      imageSrc,
      imageAlt,
      textColor,
      fontSize,
      
      // Computed
      computedValue,
      filteredItems,
      
      // Methods
      handleClick,
      toggleActive,
      fetchData,
    };
  },
});
</script>

<style scoped>
/* Component-specific styles */
.component-name {
  padding: 20px;
}

/* Use scoped styles to avoid global CSS pollution */
h1 {
  color: #333;
  font-size: 2rem;
  margin-bottom: 1rem;
}

/* You can also use deep selectors for nested components */
:deep(.nested-class) {
  color: blue;
}

/* Media queries */
@media (max-width: 768px) {
  .component-name {
    padding: 10px;
  }
}
</style>

<!-- 
  COMPONENT TEMPLATE NOTES:
  
  1. Always use defineComponent() - DO NOT use <script setup>
  
  2. TypeScript:
     - Define interfaces for complex types
     - Use PropType for prop typing
     - Type all refs: ref<Type>()
  
  3. Props:
     - Always specify type and required
     - Use PropType for complex types
     - Provide defaults when appropriate
  
  4. Emits:
     - Declare all emitted events
     - Use emit() to trigger events
  
  5. Setup Function:
     - Organize code in logical sections
     - Import hooks at the top
     - Define state, computed, methods in order
     - Return everything needed in template
  
  6. Lifecycle:
     - Use onMounted for initialization
     - Use onUnmounted for cleanup
  
  7. Naming:
     - PascalCase for component names
     - camelCase for variables and functions
     - kebab-case in templates
  
  8. Styles:
     - Use scoped styles
     - Use :deep() for nested component styles
     - Keep styles minimal and specific
  
  9. Template:
     - Use v-if/v-else for conditional rendering
     - Use v-for with :key for lists
     - Use @ for event handlers
     - Use : for dynamic attributes
  
  10. Best Practices:
      - Keep components small and focused
      - Extract reusable logic
      - Handle errors appropriately
      - Clean up resources in onUnmounted
      - Use semantic HTML
      - Add proper ARIA labels for accessibility
-->
