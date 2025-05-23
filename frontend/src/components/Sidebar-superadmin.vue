<template>
  <div :class="['navigation', { collapsed: isCollapsed }]">
    <div :class="['sidebar', { collapsed: isCollapsed }]">

      <div class="logo-container" v-if="!isCollapsed">
        <img src="@/assets/7.png" alt="Algérie Télécom Logo" class="logo" />
      </div>
     

      <nav>
        <ul class="menu">
       
          <li :class="{ active: $route.path === '/dashboard-superadmin' }">
            <router-link to="/dashboard-superadmin" class="menu-item">
              <span class="icon"><font-awesome-icon icon="home" /></span>
              <span class="label" v-if="!isCollapsed">Dashboard</span>
            </router-link>
          </li>
            <li :class="{ active: $route.path === '/dashboard-superadmin/admins' }">
            <router-link to="/dashboard-superadmin/admins" class="menu-item">
              <span class="icon"><i class="fa-solid fa-user-shield"></i></span>
              <span class="label" v-if="!isCollapsed">Administrateurs</span>
            </router-link>
          </li>
          <li :class="{ active: $route.path === '/dashboard-superadmin/Entreprise' }">
            <router-link to="/dashboard-superadmin/Entreprise" class="menu-item">
              <span class="icon">
                <font-awesome-icon icon="building" />
              </span>
              <span class="label" v-if="!isCollapsed">Entreprises</span>
            </router-link>
          </li>
          <li :class="{ active: $route.path === '/dashboard-superadmin/users' }">
            <router-link to="/dashboard-superadmin/users" class="menu-item">
              <span class="icon"><font-awesome-icon icon="users" /></span>
              <span class="label" v-if="!isCollapsed">Utilisateurs</span>
            </router-link>
          </li>
      
        <li :class="{ active: $route.path === '/dashboard-superadmin/offres' }">
            <router-link to="/dashboard-superadmin/offres" class="menu-item">
              <span class="icon"><font-awesome-icon icon="newspaper" /></span>
              <span class="label" v-if="!isCollapsed">Publications</span>
            </router-link>
          </li>
        <li :class="{ active: $route.path === '/dashboard-superadmin/suggestions' }">
            <router-link to="/dashboard-superadmin/suggestions" class="menu-item">
              <span class="icon">  <i class="fas fa-lightbulb"></i></span>
              <span class="label" v-if="!isCollapsed">Suggestions</span>
            </router-link>
          </li> 
        
          <li :class="{ active: $route.path === '/dashboard-superadmin/profile' }">
            <router-link to="/dashboard-superadmin/profile" class="menu-item">
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
    name: "SidebarSuperadmin",
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
  
  
  <style>
/* =======================================================
   1. Root Variables
======================================================= */
:root {
  --white: #fcfcfc;
  --blue: #0d0a18;
  --primary: #4a6ee0; 
}

/* =======================================================
   2. Layout: Navigation & Sidebar
======================================================= */

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
  transition: width 0.3s ease;
}


.sidebar.collapsed {
  width: 80px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}


.sidebar.collapsed ~ .main,
.main.active {
  margin-left: 80px;
}

/* =======================================================
   3. Logo
======================================================= */
.logo-container {
  text-align: center;
  padding: 15px;
}

.logo {
  width: 150px;
  height: auto;
}

/* =======================================================
   4. Menu & Menu Items (Default/Expanded)
======================================================= */
.menu {
  display: flex;
  flex-direction: column;
  gap: 10px;
  list-style: none;
  padding: 0;
  margin: 0;

}

.menu li {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-right: 10px;
  border-radius: 100px;
  position: relative;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.label.main.active{
  color: #221d5f;
}

.menu li.active {
  background-color: var(--white);
  color: #06153f !important; 
  padding: 6px;
  transform: translateX(10px);
  box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
}


.menu li.active::before {
  content: "";
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 5px;
  background-color: var(--primary);
  border-radius: 50%;
}
.menu li.active .menu-item {
  color: var(--blue);
 font-weight: 500;
}
.menu{
  margin-top: 40px;
}

.menu li:hover {
  margin-left: 10px;
  transition: transform 0.3s ease, box-shadow 0.2s ease;
  transform: translateX(10px);
}


.menu-item {
  display: flex;
  align-items: center;
  text-decoration: none;
  color: var(--white);
  font-size: 16px;
  padding: 5px;
  width: 100%;
  margin-left: 20px;
  transition: color 0.3s ease;
}

/* =======================================================
   5. Icons
======================================================= */
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

/* =======================================================
   6. Navigation Decorative Effects
======================================================= */
.navigation ul li.active a::before {
  content: "";
  position: absolute;
  right: 0;
  top: -50px;
  width: 50px;
  height: 50px;
  background-color: transparent;
  border-radius: 50%;
  box-shadow: 35px 35px 0 10px var(--white);
  pointer-events: none;
}

.navigation ul li.active a::after {
  content: "";
  position: absolute;
  right: 0;
  bottom: -50px;
  width: 50px;
  height: 50px;
  background-color: transparent;
  border-radius: 50%;
  box-shadow: 35px -35px 0 10px var(--white);
  pointer-events: none;
}

/* =======================================================
   7. Toggle Button & Transitions
======================================================= */
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

/* =======================================================
   8. Main Content
======================================================= */
.main {
  margin-left: 250px;
  transition: margin-left 0.3s ease-in-out;
}

/* =======================================================
   9. Collapsed Menu Adjustments
======================================================= */
.sidebar.collapsed .menu li {
  justify-content: center;
  margin-right: 0;
  padding: 8px 0;
}

.sidebar.collapsed nav ul.menu li {
  justify-content: center;
  align-items: center;
}

.sidebar.collapsed nav ul.menu li .menu-item {
  flex-direction: column;
  align-items: center;
  padding: 10px 0;
  margin-right: 40px;
}

.sidebar.collapsed .menu {
  margin-top: 100px;
}

.sidebar.collapsed .menu li.active {
  background-color: var(--white);
  padding: 5px;
  margin-right: 10px;
}

/* =======================================================
   10. Mobile Responsiveness
======================================================= */
@media (max-width: 480px) {
  .sidebar.collapsed {
    width: 60px;
  }
  .sidebar.collapsed ~ .main,
  .main.active {
    margin-left: 60px;
  }
  .navigation {
    width: 100%;
    left: -100%;
  }
  .navigation.active {
    left: 0;
  }
  .main.active {
    margin-left: 0;
  }
}

/* =======================================================
   11. Animations & Loading
======================================================= */
.fade-slide-enter-active, 
.fade-slide-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.fade-slide-enter-from, 
.fade-slide-leave-to {
  opacity: 0;
  transform: translateX(-10px);
}

.loading-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: rgba(255, 255, 255, 0.8);
}

.loader {
  border: 6px solid #f3f3f3;
  border-top: 10px solid #221d5f;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>
