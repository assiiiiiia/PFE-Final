<template>
  <div class="container" :class="{ 'sidebar-collapsed': isCollapsed }">
    <TopBar :isCollapsed="isCollapsed" />
    <Sidebar-superadmin :isCollapsed="isCollapsed" @toggleSidebar="toggleSidebar" />

    <div v-if="isLoading" class="loading-container">
      <div class="loader"></div>
    </div>
    <div class="main" :class="{ active: isCollapsed }" v-else>
      <router-view />
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import TopBar from '@/components/TopBar.vue';
import SidebarSuperadmin from '@/components/Sidebar-superadmin.vue';

export default {
  name: "DashboardAdmin",
  components: { TopBar, SidebarSuperadmin },
  setup() {
    const isCollapsed = ref(false);
    const isLoading = ref(true);

    const toggleSidebar = () => {
      isCollapsed.value = !isCollapsed.value;
    };

    onMounted(() => {
      setTimeout(() => {
        isLoading.value = false;
      }, 2000);
    });

    return { isCollapsed, toggleSidebar, isLoading };
  }
};
</script>
