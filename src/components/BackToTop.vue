<template>
  <a
    v-show="showButton"
    href="#home"
    class="btn btn-lg btn-primary back-to-top"
    @click.prevent="scrollToTop"
    aria-label="Back to top"
  >
    <i class="fa fa-angle-up"></i>
  </a>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, onUnmounted } from 'vue';

export default defineComponent({
  name: 'BackToTop',
  setup() {
    const showButton = ref<boolean>(false);

    const handleScroll = () => {
      showButton.value = window.scrollY > 300;
    };

    const scrollToTop = () => {
      window.scrollTo({
        top: 0,
        behavior: 'smooth',
      });
    };

    onMounted(() => {
      window.addEventListener('scroll', handleScroll);
    });

    onUnmounted(() => {
      window.removeEventListener('scroll', handleScroll);
    });

    return {
      showButton,
      scrollToTop,
    };
  },
});
</script>

<style scoped>
.back-to-top {
  position: fixed;
  bottom: 30px;
  right: 30px;
  z-index: 999;
}
</style>
