<template>
  <div class="container" :class="{ 'sidebar-collapsed': isCollapsed }">
    <TopBar :isCollapsed="isCollapsed" />
    <Sidebar :isCollapsed="isCollapsed" @toggleSidebar="toggleSidebar" />

    <div v-if="isLoading" class="loading-container">
      <div class="loader"></div>
    </div>
    <div class="main" :class="{ active: isCollapsed }" v-else>
      <router-view />
    </div>
  </div>
</template>

<script>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import TopBar from '@/components/TopBar.vue';
import Sidebar from '@/components/Sidebar.vue';

export default {
  name: "DashboardAdmin",
  components: { TopBar, Sidebar },
  setup() {
    const isCollapsed = ref(false);
    const isLoading = ref(true);
    const resizeThreshold = 768; 

 
    const toggleSidebar = () => {
      isCollapsed.value = !isCollapsed.value;
    };

    const checkWindowSize = () => {
      if (window.innerWidth < resizeThreshold) {
        isCollapsed.value = true;
      } else {
        isCollapsed.value = false;
      }
    };

    onMounted(() => {
      checkWindowSize(); 
      window.addEventListener('resize', checkWindowSize);

   
      setTimeout(() => {
        isLoading.value = false;
      }, 2000);
    });


    onBeforeUnmount(() => {
      window.removeEventListener('resize', checkWindowSize);
    });

    return { isCollapsed, toggleSidebar, isLoading };
  }
};
</script>
