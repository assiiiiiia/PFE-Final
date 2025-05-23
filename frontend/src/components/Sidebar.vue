<template>
  <div :class="['navigation', { collapsed: isCollapsed }] ">
    <div :class="['sidebar', { collapsed: isCollapsed }]">

      <div class="logo-container" v-if="!isCollapsed">
        <img src="@/assets/7.png" alt="Algérie Télécom Logo" class="logo" />
      </div>
      <nav>
        <ul class="menu">
  
          <li :class="{ active: $route.path === '/dashboard-admin' }">
            <router-link to="/dashboard-admin" class="menu-item">
              <span class="icon"><font-awesome-icon icon="home" /></span>
              <span class="label" v-if="!isCollapsed">Dashboard</span>
            </router-link>
          </li>
      
      
        
          <li :class="{ active: $route.path === '/dashboard-admin/Offres' }" data-tooltip="Offres">
            <router-link to="/dashboard-admin/Offres" class="menu-item">
              <span class="icon">
                <font-awesome-icon icon="newspaper" />
              </span>
              <span class="label" v-if="!isCollapsed">Publications</span>
            </router-link>
          </li>
          <li :class="{ active: $route.path === '/dashboard-admin/offre-form' }">
            <router-link to="/dashboard-admin/offre-form" class="menu-item">
              <span class="icon">
                <font-awesome-icon icon="tag" />
              </span>
              <span class="label" v-if="!isCollapsed">Offres</span>
            </router-link>
          </li>
          <li :class="{ active: $route.path === '/dashboard-admin/Soumission' }">
            <router-link to="/dashboard-admin/Soumission" class="menu-item">
              <span class="icon">
                <font-awesome-icon icon="paper-plane" />
              </span>
              <span class="label" v-if="!isCollapsed">Soumissions</span>
            </router-link>
          </li>
          <li :class="{ active: $route.path === '/dashboard-admin/profile' }">
            <router-link to="/dashboard-admin/profile" class="menu-item">
              <span class="icon">
                <font-awesome-icon icon="cog" />
              </span>
              <span class="label" v-if="!isCollapsed">Profil</span>
            </router-link>
          </li>
        </ul>
      </nav>

     

      <div class="toggle-btn" @click="toggle">
        <font-awesome-icon
        :icon="['fas', isCollapsed ? 'circle-chevron-right' : 'circle-chevron-left']"

          class="toggle-icon"
        />
      </div>
    </div>
  </div>
</template>

<script>


export default {
  name: "Sidebar",
  props: {
    isCollapsed: {
      type: Boolean,
      default: false
    }
  },
  computed: {
  userRole() {
    const user = JSON.parse(localStorage.getItem('user'));
    return user?.role || null;
  }
},

  methods: {
    toggle() {
     
      this.$emit("toggleSidebar");
    }
  }
};
</script>

<style scoped>
/* ======================================================
   Variables & Global Styles
====================================================== */
:root {
  --white: #fcfcfc;
  --blue: #0d0a18;
  --primary: #4a6ee0;
}

/* ======================================================
   Layout & Navigation Container
====================================================== */
.navigation {
  position: fixed;
  left: 0;
  top: 0;
  width: 250px;
  height: 100vh;
  background: #0c1d4d;
  overflow: hidden;
  z-index: 1000;
  transition: width 0.3s ease;
}

.navigation.collapsed {
  width: 80px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Collapsed Navigation */
.sidebar.collapsed {
  width: 80px;
}

/* ======================================================
   Logo
====================================================== */
.logo-container {
  text-align: center;
  padding: 15px;
}
.logo {
  width: 150px;
  height: auto;
  margin-top: 20px;
  margin-bottom: 20px;
}


.sidebar.collapsed .logo-container {
  display: none;
}

/* ======================================================
   Menu Styles
====================================================== */
.menu {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 0;
  margin: 0;
 
  list-style: none;
}

.menu li {
  display: flex;
  align-items: center;
  margin-right: 20px;
  margin-left: 10px;
  border-radius: 100px;
  position: relative;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.menu li:hover {

  transition: transform 0.3s ease, box-shadow 0.2s ease;
}


.menu li.active {
  background-color: var(--white);
  padding: 5px;
  transform: translateX(20px);
  transition: transform 0.3s ease, box-shadow 0.2s ease;
}
.menu li.active .menu-item {
  color: var(--blue);
 
}

.menu li.active::before {
  content: "";
  position: absolute;
  left: 0;
  top: 50%;
  background-color: var(--primary);
  border-radius: 50%;
}


.menu-item {
  display: flex;
  align-items: center;
  width: 100%;
  text-decoration: none;
  color: var(--white);
  font-size: 16px;
  padding: 5px;
  margin-left: 20px;
  transition: color 0.3s ease;
}


.icon {
  font-size: 1rem;
  min-width: 40px;
  text-align: center;
  transition: color 0.3s ease, transform 0.3s ease;
}

.menu li:hover .icon,
.menu li.active .icon {
  color: #105c8f;
  transform: scale(1.1);
}

/* ------------------------------------------------------
   Collapsed Menu Adjustments
--------------------------------------------------------- */
.sidebar.collapsed nav ul.menu li {
  justify-content: center;
  align-items: center;

}

.sidebar.collapsed nav ul.menu li .menu-item {
  flex-direction: column;
  align-items: center;
  padding: 10px 0;
  
}
.sidebar.collapsed .menu {
  margin-top: 100px;
}
.sidebar.collapsed .menu li.active {
  background-color: var(--white);

}
/* ======================================================
   Toggle Button
====================================================== */
.toggle-btn {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  font-size: 24px;
  cursor: pointer;
  background: none;
  border: none;
  color: var(--white);
}

.toggle-icon {
  transition: transform 0.3s ease;
}

.sidebar.collapsed .toggle-icon {
  transform: rotate(360deg);
}
</style>