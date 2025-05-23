<template>
  <div class="favorites-container">
    <h2>{{ $t('favorites.title') }}</h2>

    <div v-if="isLoading" class="loading">
      Chargement...
    </div>

    <div v-else-if="!favorites.length" class="alert alert-info">
      Aucun favori disponible.
    </div>

    <div v-else class="favorites-list">
      <Offre
        v-for="favorite in favorites"
        :key="favorite.id"
        :tender="favorite.offre"
        :get-logo-url="getLogoUrl"
        :handle-image-error="handleImageError"
        :open-submission-modal="openSubmissionModal"
        :view-details="viewDetails"
        :toggle-favorite="toggleFavorite"
        :get-details-button-style="getDetailsButtonStyle"
        :is-logged-in="isLoggedIn"
        :user="user"
      />
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import Offre from '../components/Offre.vue';
const apiUrl = import.meta.env.VITE_API_URL;

export default {
  name: "Favorites",
  props: {
    user: {
      type: Object,
      required: false,
      default: () => ({})
    },
  },
  components: {
    Offre,
  },
  data() {
    return {
      favorites: [],
      isLoggedIn: false,
      isLoading: false, 
    };
  },
  created() {
    this.fetchFavorites();
    const token = localStorage.getItem('token');
    if (token) {
      this.isLoggedIn = true;
    }
  },
  methods: {
    fetchFavorites() {
      const token = localStorage.getItem('token');
      if (!token) {
        console.error('Token is missing. Please login first.');
        return;
      }
      this.isLoading = true;
      axios
        .get(`${apiUrl}/api/favorites`, {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        })
        .then(response => {
          this.favorites = response.data;
        })
        .catch(error => {
          console.error('Error fetching favorites:', error);
        })
        .finally(() => {
          this.isLoading = false;
        });
    },
 
    getLogoUrl(logoPath) {
      if (!logoPath || logoPath === "null") {
        return `${apiUrl}/storage/logo/default.png`;
      }
      return `${apiUrl}/storage/logo/` + logoPath.split("/").pop();
    },
    handleImageError(event, entreprise) {
      event.target.src = `${apiUrl}/storage/logo/default.png`;
    },
    openSubmissionModal(tender) {
      console.log("Open submission modal for:", tender);
    },
    viewDetails(id) {
      if (id) {
        this.$router.push({ name: 'OffresDetails', params: { id } });
      }
    },
    toggleFavorite(tender) {
      tender.isFavorite = !tender.isFavorite;
    },
    getDetailsButtonStyle(tender) {
      if (tender.type_offre === "Appel d'offre") {
        return { backgroundColor: "#2c5cc5" };
      } else if (tender.type_offre === "Avis de consultation") {
        return { backgroundColor: "#28a745" };
      } else if (tender.type_offre === "Avis de manifestation") {
        return { backgroundColor: "#ffc107" };
      }
      return { backgroundColor: "#007bff" };
    },
  },
};
</script>

<style scoped>
.favorites-container {
  max-width: 1200px;
  margin: 2rem auto;
  padding: 2rem;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 15px rgba(0, 0, 0, 0.08);
  font-family: 'Inter', system-ui, sans-serif;
}

h2 {
  color: #2c3e50;
  font-size: 1.8rem;
  font-weight: 600;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 2px solid #f0f2f5;
}

.favorites-list {
  display: block;
  gap: 15px;
}


.alert {
  padding: 1rem 1.5rem;
  border-radius: 8px;
  margin-bottom: 1.5rem;
  display: flex;
  align-items: center;
  position: relative;
  font-size: 0.95rem;
}
.alert-info {
  background: #e3f2fd;
  color: #0d47a1;
  border: 1px solid #bbdefb;
}
.alert-info:before {
  content: "ℹ️";
  margin-right: 0.75rem;
}
.loading {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 2rem;
  color: #1a237e;
}

.loading::after {
  content: '';
  width: 24px;
  height: 24px;
  border: 3px solid #1a237e;
  border-top-color: transparent;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>
