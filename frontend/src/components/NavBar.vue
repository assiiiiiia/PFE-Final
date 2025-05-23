<template>
  <div :dir="locale === 'ar' ? 'rtl' : 'ltr'">
    <div v-if="isLoading" class="loading-overlay">
      <div class="spinner"></div>
    </div>

    <!-- Navbar for non-logged in users -->
    <nav class="navbar" v-if="!user">
      <div class="header">
        <div class="logo">
          <router-link to="/" class="logo-link">
            <img src="@/assets/logo-safqatic.png" alt="Logo" class="logo-image" />
          </router-link>
        </div>
        <div class="nav">
          <router-link class="nav-item" to="/">{{ $t("nav.home") }}</router-link>
          <router-link to="/offres" class="nav-item">{{ $t("nav.offers") }}</router-link>
        
  <router-link
  class="nav-item"
  :to="{ path: '/', hash: '#how-it-works' }"
  exact-active-class="active-hash"
>
  {{ $t("nav.howItWorks") }}
</router-link>

<router-link
  class="nav-item"
  :to="{ path: '/', hash: '#interactive-section' }"
  exact-active-class="active-hash"
>
  {{ $t("nav.suggestions") }}
</router-link> </div>
        <div class="side">
          <button class="btn" @click="showLoginModal = true">
  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15m3 0l3-3m0 0l-3-3m3 3H9" />
  </svg>
  {{ $t("nav.login") }}
</button>
          <div class="language-switch">
            <img 
              :src="currentFlag" 
              :alt="locale === 'fr' ? 'Français' : 'العربية'"
              class="flag"
              @click="switchLanguage"
            />
          </div>
        </div>
      </div>
    </nav>

    <!-- Navbar for logged in users -->
    <nav class="navbar" v-if="user">
      <div class="header">
        <div class="logo">
          <router-link to="/" class="logo-link">
            <img src="@/assets/logo-safqatic.png" alt="Logo" class="logo-image" />
          </router-link>
        </div>

        <div class="nav-links">
          <router-link class="nav-item" to="/">{{ $t("nav.home") }}</router-link>
          <router-link to="/offres" class="nav-item">{{ $t("nav.offers") }}</router-link>
          <router-link to="/favorites" class="nav-item">{{ $t("nav.favorites") }}</router-link>
          <router-link to="/etat-soumission" class="nav-item">{{ $t("nav.etat") }}</router-link>
        </div>

        <div class="user-section">
          <NotificationBell />
          <router-link to="/profile" class="profile">
            <img :src="user.profilePic || defaultProfilePic" alt="Photo de profil" class="profile-pic" />
            <span>{{ (user.nom && user.prenom) ? user.nom + ' ' + user.prenom : 'Utilisateur' }}</span>
          </router-link>
                
              <div class="language-switch">
    <img 
      :src="currentFlag" 
      :alt="locale === 'fr' ? 'Français' : 'العربية'"
      class="flag"
      @click="switchLanguage"
    />
  </div>
          <i 
            class="fas fa-sign-out-alt logout-btn"
            @click="logout"
            role="button"
            tabindex="0"
            aria-label="Déconnexion"
          ></i>
       
        </div>
      </div>
    </nav>

    
    <Login 
      :showModal="showLoginModal" 
      @close="showLoginModal = false" 
      @login-success="handleLoginSuccess" 
    />
  </div>
</template>
<script>
import { ref, onMounted, onBeforeUnmount, computed } from 'vue';
import { useI18n } from 'vue-i18n'; // import the hook
const apiUrl = import.meta.env.VITE_API_URL;
import { useRouter, useRoute } from 'vue-router';
import api from '../api';
import Login from '@/components/Login.vue';
import defaultProfilePic from '@/assets/user-img.png';

import frFlag from '@/assets/fr-flag.png';
import arFlag from '@/assets/ar-flag.png';
import NotificationBell from '@/components/NotificationBell.vue';
const notificationCount = ref(0); 
export default {
  name: 'NavBar',
  components: { Login , NotificationBell},
  setup() {
    const router = useRouter();
const route = useRoute();
    const user = ref(null);
    const showLoginModal = ref(false);
   
    const isLoading = ref(false);
    const isDropdownOpen = ref(false);
    const dropdown = ref(null);


    const { locale } = useI18n();

    const currentFlag = computed(() => {
      return locale.value === 'fr' ? arFlag : frFlag ;
    });

    const switchLanguage = () => {
      locale.value = locale.value === 'fr' ? 'ar' : 'fr';
      localStorage.setItem('locale', locale.value);
    };
 
    const toggleDropdown = () => {
      isDropdownOpen.value = !isDropdownOpen.value;
    };

    const handleClickOutside = (event) => {
      if (dropdown.value && !dropdown.value.contains(event.target)) {
        isDropdownOpen.value = false;
      }
    };
  
   
    const onSubmissionStatusAdded = () => {
      notificationCount.value++;
    };

    onMounted(() => {
      document.addEventListener('click', handleClickOutside);
     
    });

    onBeforeUnmount(() => {
      document.removeEventListener('click', handleClickOutside);
      
    });

  
    const fetchUser = async () => {
      const token = localStorage.getItem('token');
      if (!token) return;
      
      isLoading.value = true;
      try {
        const response = await api.get(`${apiUrl}/api/user`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        user.value = response.data;
      } catch (error) {
        console.error("Erreur lors de la récupération de l'utilisateur", error);
        user.value = null;
      } finally {
        isLoading.value = false;
      }
    };

    onMounted(fetchUser);

    // Gestion du login
    const handleLoginSuccess = (loggedInUser) => {
      user.value = loggedInUser;
      showLoginModal.value = false;
    };

    // Déconnexion
    const logout = async () => {
      try {
        const token = localStorage.getItem('token');
        if (token) {
          await api.post('/logout', {}, {
            headers: { Authorization: `Bearer ${token}` }
          });
        }
        localStorage.removeItem('token');
        user.value = null;
        router.push('/');
      } catch (error) {
        console.error('Erreur de déconnexion', error);
      }
    };

    const navigateToRegister = () => {
      router.push('/register');
    };

    const isActiveSection = (hash) => {
      return route.path === '/' && route.hash === hash;
    };

    return {
      switchLanguage,
      locale 
   ,
      user,
      showLoginModal,
      isDropdownOpen,
      notificationCount,
      handleLoginSuccess,
      logout,
      isLoading,
      defaultProfilePic,
      switchLanguage,
      currentFlag,
      navigateToRegister,
isActiveSection,
    };
  }
};
</script>

<style scoped>

  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'poppins', sans-serif;
  }
  .loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.9);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
  backdrop-filter: blur(2px);
}

.spinner {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  border: 3px solid #f0f0f0;
  border-top-color: #1E3A8A;
  animation: spin 1s cubic-bezier(0.68, -0.55, 0.27, 1.55) infinite;
  box-shadow: 0 0 15px rgba(21, 99, 178, 0.1);
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
.active-hash {
  font-weight: bold;
  color: #3f51b5;

}
 
  .navbar {
    display: flex;
    flex-direction: column;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    position: relative;
    z-index: 1000;
  background-color: #ebedf590;
    
  }

  .logo-link.router-link-exact-active::after {
  display: none;
}
  .logo {
    display: flex;
    align-items: center;
    margin: 10px;
 
  }
  
  .logo-image {
    height: 40px;
    width: auto;
    margin-right: 1rem;
  }

  .btn {
    background: none;
    border: none;
    cursor: pointer;
    font-weight: bold;
    color: #4a4a4a;
  }
  

  /* Navigation items */
  .nav {
    display: flex;
    justify-content: center; 
    align-items: center;

    gap: 2rem;
  }

  .nav-item {
    color: #4a4a4a;
    text-decoration: none;
    font-weight: 500;
    padding: 0.2rem;
    transition: all 0.3s ease-in-out;
  }
  
  .nav-item:hover,
  .router-link-exact-active {
    color: #4565bd;
    transform: translateY(-3px);
  }
  
  .header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1800px;
  margin: 0 auto;
  width: 100%;
  padding: 1rem 1rem;
}

/* Navigation containers */
.nav, .nav-links {
  display: flex;
  align-items: center;
  gap: 2rem;
  margin: 0;
  padding: 0;
  list-style: none;
}
.side {
  display: flex;
  align-items: center;
 
}
/* User section alignment */
.user-section {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  margin-left: auto;
}
  .profile {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    text-decoration: none;
    color: inherit;
  }
  
  .profile-pic {
    width: 35px;
    height: 35px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #e0e0e0;
  }
  
/* Updated Dropdown Styling */
/* Dropdown container */
.dropdown {
  position: relative;
  display: inline-block;
  cursor: pointer;
}

/* Dropdown content */
.dropdown-content {
  position: absolute;
  top: calc(100% + 10px); 
  left: 0;
  background-color: #fff;
  min-width: 200px;
  border: 1px solid #e0e0e0;
  border-radius: 6px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  padding: 0.5rem 0;
  z-index: 1000;
  opacity: 0;
  visibility: hidden;
  transform: translateY(10px);
  transition: opacity 0.3s ease, transform 0.3s ease, visibility 0.3s ease;
}

/* Show dropdown menu */
.dropdown-content.show {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
}

/* Dropdown links styling */
.dropdown-content .nav-item {
  display: block;
  padding: 0.8rem 1.5rem;
  color: #4a4a4a;
  text-decoration: none;
  transition: background 0.2s ease;
}

/* Hover state */
.dropdown-content .nav-item:hover {
  background: #f8fafc;
}

/* Mobile adjustments */
@media (max-width: 480px) {
  .dropdown-content {
    position: static;
    width: 100%;
    transform: translateY(0);
    opacity: 1;
    visibility: visible;
    box-shadow: none;
    border: none;
  }
}

.notification-bell {
  position: relative;
  display: flex;
  padding: 0.5rem;
}

.badge {
  position: absolute;
  top: -2px;
  right: -2px;
  background: #ff4757;
  color: white;
  min-width: 20px;
  height: 20px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  padding: 0 0.25rem;
}
  /* Logout button */
  .logout-btn {
    cursor: pointer;
    color: #4a4a4a;
    padding: 0.5rem;
    transition: color 0.3s;
  }
  
  .logout-btn:hover {
    color: #b71c1c;
  }
  
  @media (max-width: 1024px) {
  .header {
    padding: 1rem;
    gap: 1rem;
  }
  
  .nav, .nav-links {
    gap: 1.5rem;
  }
}

@media (max-width: 768px) {
  .navbar {
    padding: 0 1rem;
  }

  .header {
    flex-wrap: wrap;
  }

  .nav, .nav-links {
    order: 2;
    width: 100%;
    justify-content: center;
    gap: 1rem;
  }

  .user-section {
    order: 3;
    margin-left: 0;
  }
}

@media (max-width: 480px) {
  .btn {
    width: 100%;
    justify-content: center;
  }
  
  .dropdown-content {
    position: static;
    width: 100%;
  }
}
.language-switch {
  margin-left: 1rem;
}

.flag {
  width: 32px;
  height: 24px;
  cursor: pointer;
  border: 2px solid transparent;
  border-radius: 3px;
  transition: all 0.2s ease;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.flag:hover {
  transform: translateY(-1px);
  box-shadow: 0 3px 6px rgba(0,0,0,0.2);
}

[dir="rtl"] .language-switch {
  margin-left: 0;
  margin-right: 1rem;
}

.flag.active {
  border-color: #1E3A8A;
  transform: scale(1.05);
  box-shadow: 0 3px 6px rgba(21, 99, 178, 0.2);
}

.flag:not(.active):hover {
  opacity: 0.9;
  transform: translateY(-1px);
}



  /* Primary buttons */
  .btn {
  background: transparent !important;
  border: 2px solid #2b65a0 !important;
  color: #2b65a0 !important;
  padding: 0.6rem 1.5rem;
  border-radius: 6px;
  font-weight: 600;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  position: relative;
}

/* Hover Effect */
.btn:hover {
  color: white !important;
  transform: translateY(-2px);
  background: #1E3A8A !important;
  box-shadow: 0 2px 8px rgba(43, 101, 160, 0.3);
}

/* Icon Animation */
.btn svg {
  transition: transform 0.3s ease;
  width: 1.2rem;
  height: 1.2rem;
}

.btn:hover svg {
  transform: translateX(2px);
}

/* Active State */
.btn:active {
  transform: translateY(0);
  box-shadow: none;
}

.router-link-exact-active {
  color: #4565bd;
  position: relative;
  font-weight: 600;
}


.router-link-exact-active::after {
  content: '';
  position: absolute;
  bottom: -5px;
  left: 50%;
  transform: translateX(-50%);
  width: 60%;
  height: 2px;
  background: #4565bd;
  border-radius: 2px;
}

.nav-item.active-section {
  color: #ff5733; 
  font-weight: bold;
}



[dir="rtl"] .user-section {
  margin-left: 0;
  margin-right: auto;
}


[dir="rtl"] .logo {
  margin-right: 1rem;
  margin-left: 0;
}


[dir="rtl"] .language-switch {
  margin-left: 0;
  margin-right: 1rem;
}
  </style>
