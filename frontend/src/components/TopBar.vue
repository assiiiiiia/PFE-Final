<template>
  <div class="topbar" :style="topbarStyle">
    <div class="toggle" @click="$emit('toggle')">
      <i class="fas fa-bars"></i>
    </div>

   <div class="search">
  <label>
    <input
      type="text"
      placeholder="Rechercher ..."
      v-model="searchQuery"
      @input="handleSearch"
    />
    <i class="fas fa-search"></i>
  </label>
  <transition name="fade">
   <div v-if="searchQuery.length >= 2" class="search-results">
     <p v-if="isLoading" class="no-results">Recherche en cours…</p>
    <template v-if="!isLoading">
     <p
  v-for="offer in results"
  :key="offer.id"
  @click="selectOffer(offer)"
  :class="{ highlighted: offer.id === selectedOfferId }"
>
         {{ offer.title }}
       </p>

     
       <p v-if="results.length === 0" class="no-results">
         Aucun résultat trouvé.
       </p>
     </template>
    </div>
  </transition>
</div>
    <div class="user-info">
      <img 
        :src="user.profilePic || defaultProfilePic" 
        alt="Photo de profil" 
        class="profile-pic" 
        @click="goToProfile" 
      />
      <span 
        class="user-name"
        @click="goToProfile"
      >
        {{ (user.nom && user.prenom) ? user.nom + ' ' + user.prenom : 'Utilisateur' }}
      </span>
      <button @click="logout" class="btn logout-btn">
        <i class="fas fa-sign-out-alt"></i>
        <span>Déconnexion</span>
      </button>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import api from '../api';
const apiUrl = import.meta.env.VITE_API_URL;
import defaultProfilePic from '@/assets/user-img.png';

const dashboardRoutes = [
  { path: '', name: 'Dashboard' },
  { path: 'users', name: 'Utilisateurs' },
  { path: 'settings', name: 'Paramètres' },
  { path: 'entreprise', name: 'Entreprise' },
  { path: 'profile', name: 'Profil' },
  { path: 'offre-form', name: 'Créer Offre' },
  { path: 'offres', name: 'Offres' },
  { path: 'Soumission', name: 'Soumissions' },
];

export default {
  props: {
    isCollapsed: Boolean
  },
  setup(props) {
    const router = useRouter();
    const user = ref({ nom: '', prenom: '', profilePic: '' });
    const searchQuery = ref('');
    const results = ref([]);
    const showSearchResults = ref(false);
    const isLoading = ref(false);
const selectedOfferId = ref(null); 

const selectOffer = (offer) => {
  console.log('Offre sélectionnée :', offer); 
  selectedOfferId.value = offer.id; 
  searchQuery.value = ''
  showSearchResults.value = false

  const role = user.value.role
  const base = role === 'superadmin'
    ? '/dashboard-superadmin/offres'
    : '/dashboard-admin/offres'

  router.push(`${base}?highlight=${offer.id}`)
}
;
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

    const filteredResults = computed(() => {
      if (!searchQuery.value) return [];
      const query = searchQuery.value.toLowerCase();
      return dashboardRoutes.filter(route => 
        route.name.toLowerCase().includes(query)
      );
    });

 
    function debounce(fn, delay = 300) {
      let timer = null;
      return (...args) => {
        clearTimeout(timer);
        timer = setTimeout(() => fn(...args), delay);
      };
    }


    const performSearch = debounce(async (q) => {
  if (q.length < 2) {
    results.value = []
    isLoading.value = false
    return
  }

  isLoading.value = true
  try {
    const res = await api.get(`${apiUrl}/api/offres/search`, { params: { search: q } })
    results.value = Array.isArray(res.data.offres) ? res.data.offres : []
  } catch {
    results.value = []
  } finally {
    isLoading.value = false
  }
}, 300)

   const handleSearch = () => {
 
  performSearch(searchQuery.value.trim());
};

    const logout = async () => {
      try {
        await api.post('/logout');
        localStorage.removeItem('token');
        router.push('/');
      } catch (error) {
        console.error('Erreur lors de la déconnexion', error);
      }
    };

    const goToProfile = () => {
  const role = user.value.role;
  if (role === 'admin') {
    router.push('/dashboard-admin/profile');
  } else if (role === 'superadmin') {
    router.push('/dashboard-superadmin/profile');
  }
};


    const topbarStyle = computed(() => ({
      left: props.isCollapsed ? '70px' : '250px',
      width: props.isCollapsed ? 'calc(100% - 80px)' : 'calc(100% - 250px)',
    }));

    return {
      user,
      searchQuery,
      filteredResults,
      results,
      showSearchResults,
      handleSearch,
      selectOffer,
      logout,
      goToProfile,
      topbarStyle,
      defaultProfilePic,
      selectedOfferId,
      isLoading 
    };
  }
};
</script>

<style scoped>
.topbar {
  position: fixed;
  top: 0;
  height: 60px;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 1.5rem;
  background: #ffffff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
  z-index: 1000;
  transition: left 0.3s ease, width 0.3s ease;
}



.search {
  position: relative;
  flex-grow: 1;
  max-width: 500px;
  margin: 0 2rem;
}

.search label {
  display: flex;
  align-items: center;
  background: #f1f3f5;
  border-radius: 50px;
  padding: 0.5rem 1rem;
  width: 100%;
  transition: background 0.2s ease;
}

.search label:focus-within {
  background: #ffffff;
  box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.2);
}

.search input {
  flex: 1;
  border: none;
  background: transparent;
  font-size: 0.9rem;
  padding: 0.25rem;
  color: #333;
  outline: none;
}

.search input::placeholder {
  color: #aaa;
}

.search i {
  font-size: 1rem;
  
  color: #a1a1a1;
}

.search-results {
  position: absolute;
  top: 110%;
  left: 0;
  right: 0;
  background: #ffffff;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
  max-height: 300px;
  overflow-y: auto;
  z-index: 1001;
}

.search-results p {
  margin: 0;
  padding: 0.75rem 1.5rem;
  font-size: 0.9rem;
  color: #333;
  cursor: pointer;
  transition: background 0.2s ease, padding-left 0.2s ease;
}

.search-results p:hover {
  background: #f8f9fa;
  padding-left: 1.75rem;
  color: #007bff;
}

.no-results {
  margin: 0;
  padding: 0.75rem 1.5rem;
  font-size: 0.9rem;
  color: #999;
  text-align: center;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.profile-pic {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #e0e0e0;
  cursor: pointer;
  transition: border 0.2s ease;
}

.profile-pic:hover {
  border-color: #007bff;
}
.highlighted {
  background-color: #f0f8ff !important;
  color: #007bff !important;
  font-weight: bold !important;
}
.user-name {
  font-weight: 500;
  color: #333;
  cursor: pointer;
  white-space: nowrap;
}

.logout-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: transparent;
  border: none;
  color: #dc3545;
  font-size: 0.9rem;
  margin-right: 50px;
  cursor: pointer;
  transition: color 0.2s ease;
  padding: 0.5rem;
}

.logout-btn:hover {
  color: #c82333;
}

.logout-btn i {
  font-size: 1rem;
}

/* Responsive Design */
@media (max-width: 768px) {
  .topbar {
    padding: 0 1rem;
  }

  .search {
    margin: 0 1rem;
    max-width: 300px;
  }

  .user-name {
    display: none;
  }

  .logout-btn span {
    display: none;
  }
}

@media (max-width: 480px) {
  .search {
    max-width: 200px;
  }

  .toggle {
    margin-right: 0.5rem;
  }
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
