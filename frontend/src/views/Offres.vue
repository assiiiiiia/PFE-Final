<template>
  <div class="offres-table">
    <h2>Liste des publications</h2>
  
    <div class="filter-header">
      <button class="filter-toggle" @click="showFilters = !showFilters">
        <i class="fas fa-filter"></i> Filtrer les résultats
      </button>
      <div class="filter-item search-item">
        <label for="filter-search" class="sr-only">Recherche</label>
        <input type="text" id="filter-search" v-model="filterSearch" placeholder="Rechercher...">
      </div>
    </div>

    <div class="active-filters" v-if="hasActiveFilters">
      <span class="filter-badge" v-if="filterSearch">
        {{ filterSearch }}
        <button @click="filterSearch = ''">×</button>
      </span>
      <span class="filter-badge" v-if="selectedType">
        {{ selectedType }}
        <button @click="selectedType = ''">×</button>
      </span>
      <span class="filter-badge" v-if="selectedSecteur">
        {{ selectedSecteur }}
        <button @click="selectedSecteur = ''">×</button>
      </span>
      <span class="filter-badge" v-if="selectedEtat">
        {{ selectedEtat }}
        <button @click="selectedEtat = ''">×</button>
      </span>
      <span class="filter-badge" v-if="selectedEtatOffre">
        {{ selectedEtatOffre }}
        <button @click="selectedEtatOffre = ''">×</button>
      </span>
      <span class="filter-badge" v-if="selectedWilaya">
        {{ wilayas[selectedWilaya] }}
        <button @click="selectedWilaya = ''">×</button>
      </span>
      <span class="filter-badge" v-if="filterLangue">
        {{ filterLangue }}
        <button @click="filterLangue = ''">×</button>
      </span>
      <span class="filter-badge" v-if="filterHasLots">
  Avec lots
  <button @click="filterHasLots = false">×</button>
</span>
      <span class="filter-badge" v-if="filterDateDebut || filterDateFin">
        {{ filterDateDebut || '...' }} - {{ filterDateFin || '...' }}
        <button @click="clearDates">×</button>
      </span>
      <button class="reset-filters" @click="resetFilters">Réinitialiser</button>
    </div>


    <transition name="slide-fade">
      <div class="filters-panel" v-show="showFilters">
        <div class="filters">
     
          <div class="filter-item">
            <label for="filter-type">Type d'offre :</label>
            <select id="filter-type" v-model="selectedType">
              <option value="">--Tous--</option>
              <option value="Appel d'offre">Appel d'offre</option>
              <option value="Avis de consultation">Avis de consultation</option>
              <option value="Avis de manifestation">Avis de manifestation</option>
            </select>
          </div>
 
           
              <div class="filter-item" v-if="userRole !== 'admin'">
            <label for="filter-entreprise">Entreprise :</label>
            <select id="filter-entreprise" v-model="selectedSecteur">
              <option value="">--Toutes--</option>
              <option v-for="secteur in secteursList" :key="secteur.id" :value="secteur.nom">
                {{secteur.nom }}
              </option>
            </select>
          </div>
          <div class="filter-item">
            <label for="filter-etat-offre">État Offre :</label>
            <select id="filter-etat-offre" v-model="selectedEtatOffre">
              <option value="">--Tous--</option>
              <option value="En cours">En cours</option>
              <option value="Attribué">Attribué</option>
              <option value="Infructueux">Infructueux</option>
              <option value="Annulé">Annulé</option>
            </select>
          </div>
          <div class="filter-item">
            <label for="filter-etat">État :</label>
            <select id="filter-etat" v-model="selectedEtat">
              <option value="">--Tous--</option>
              <option value="En rédaction">En rédaction</option>
              <option value="Publiée">Publié</option>
              <option value="Supprimée">Supprimé</option>
            </select>
          </div>
          <div class="filter-item">
            <label for="filter-wilaya">Wilaya :</label>
            <select id="filter-wilaya" v-model="selectedWilaya">
              <option value="">--Toutes--</option>
              <option v-for="(name, key) in wilayas" :key="key" :value="key">
                {{ name }}
              </option>
            </select>
          </div>
          <div class="filter-item">
            <label for="filter-langue">Langue :</label>
            <select id="filter-langue" v-model="filterLangue">
              <option value="">--Toutes--</option>
              <option value="Francais">Français</option>
              <option value="Arabe">Arabe</option>
            </select>
          </div>
          <div class="filter-item">
            <label for="filter-has-lots">Avec lots :</label>
            <select id="filter-has-lots" v-model="filterHasLots">
              <option value="">--Tous--</option>
              <option value="true">Avec lots</option>
              <option value="false">Sans lots</option>
            </select>
          </div>
          <div class="filter-item date-group">
            <label for="filter-date-debut">Date Publication (de) :</label>
            <input type="date" id="filter-date-debut" v-model="filterDateDebut">
            <span class="date-separator">-</span>
            <label for="filter-date-fin">à :</label>
            <input type="date" id="filter-date-fin" v-model="filterDateFin">
          </div>
        </div>
      </div>
    </transition>


    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Entreprise</th>
          <th>Langue</th>
          <th>État Offre</th>
          <th>Wilaya</th>
          <th>Numéro Offre</th>
          <th>Titre Offre</th>
          <th>Type Offre</th>
          <th>Lots</th>
          <th>Date Publication</th>
          <th>Date Limite</th>
          <th>Date Prorogation</th>
          <th>Description</th>
          <th>Niveau</th>
          <th>État</th>
          <th>Document PDF</th>
         
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="loading" class="loading-row">
  <td colspan="17">
    <i class="fas fa-spinner fa-spin loading-icon"></i>
    Chargement des offres...
  </td>
</tr>

<tr v-else-if="!loading && paginatedOffres.length === 0" class="empty-row">
  <td colspan="17">
    <i class="fas fa-exclamation-circle empty-icon"></i>
    Aucune offre trouvée.
  </td>
</tr>

<tr v-else v-for="offre in paginatedOffres" :key="offre.id"  :class="{ highlighted: offre.id === highlightedId }">
          <td>{{ offre.id }}</td>
          <td class="entreprise-cell">
            <img 
              :src="getLogoUrl(offre.secteur?.logo)" 
              alt="Logo de l'entreprise" 
              class="logo"
              @error="handleImageError($event)"
            />
          </td>
          <td>{{ offre.langue }}</td>
          <td>{{ offre.etat_offre }}</td>
          <td>{{ offre.wilaya || 'Non spécifié' }}</td>
          <td class="numero-offre-cell">{{ offre.numero_offre }}</td>
          <td class="title-cell">
  <div class="title-wrapper" @click="openTitleModal(offre.titre_offre)">
    {{ offre.titre_offre || 'Aucun titre disponible.' }}
  </div>
</td>
          <td>{{ offre.type_offre }}</td>
          <td class="lots-cell">
            <button 
              v-if="offre.lots && offre.lots.length" 
              class="lots-btn" 
              @click="openLotsModal(offre.lots)"
            >Afficher</button>
            <span v-else>Aucun lot</span>
          </td>
          <td>{{ formatDate(offre.date_publication) }}</td>
          <td>{{ formatDate(offre.date_limite) }}</td>
          <td>{{ formatDate(offre.date_prorogation) }}</td>
          <td class="description-cell">
            <div class="description-wrapper" @click="openDescriptionModal(offre.description)">
              {{ offre.description || 'Aucune description disponible.' }}
            </div>
          </td>
          <td>{{ offre.niveau }}</td>
          <td>{{ offre.etat }}</td>
          <td>
            <a v-if="offre.documents && offre.documents.document_pdf" 
               :href="offre.documents.document_pdf" 
               target="_blank" 
               class="document-link">
              Document PDF <i class="fa-solid fa-file"></i>
            </a>
            <span v-else>N/A</span>
          </td>
     
          <td>
            <div class="action-dropdown">
              <button @click="toggleDropdown(offre.id)" class="action-btn">
                <i class="fa-solid fa-ellipsis-v"></i>
              </button>
              <div v-if="activeDropdown === offre.id" class="dropdown-menu dropdown-menu-over" :class="{'dropdown-up': isNearBottom(offre.id)}">
                <router-link 
                  :to="userRole === 'admin' ? `/dashboard-admin/consulter/${offre.id}` : `/dashboard-superadmin/consulter/${offre.id}`" 
                  class="view-btn">
                  <i class="fa-solid fa-eye"></i> Consulter
                </router-link>
                <button @click="deleteOffre(offre.id)">
                  <i class="fa-solid fa-trash"></i> Supprimer
                </button>
              </div>
            </div>
          </td>
        </tr>
        <div v-if="showTitleModal" class="modal-overlay">
  <div class="modal-content">
    <h3>Titre Complet</h3>
    <p class="full-title">{{ selectedTitle }}</p>
    <button class="close-btn" @click="closeTitleModal">×</button>
  </div>
</div>
      </tbody>
    </table>

 
    <div v-if="showLotsModal" class="modal-overlay">
      <div class="modal-content styled-modal">
        <button class="close-btn" @click="closeLotsModal">×</button>
        <h3>Détails des Lots</h3>
        <div class="lots-grid">
          <div v-for="lot in selectedLots" :key="lot.id" class="lot-card">
            <div class="lot-header">
              <p><strong>Numéro :</strong> {{ lot.numero_lot }}</p>
              <span :class="{'status-badge': true, 'status-encours': lot.statut === 'En cours', 'status-annule': lot.statut === 'Annulé', 'status-attribue': lot.statut === 'Attribué'}">
                {{ lot.statut || 'Non spécifié' }}
              </span>
            </div>
            <p><strong>Description :</strong> {{ lot.description }}</p>
          
          </div>
        </div>
      </div>
    </div>


    <div v-if="showDescriptionModal" class="modal-overlay">
      <div class="modal-content">
        <h3>Description Complète</h3>
        <p class="full-description">{{ selectedDescription }}</p>
        <button class="close-btn" @click="closeDescriptionModal">×</button>
      </div>
    </div>

 
    <Pagination 
  :totalPages="totalPages" 
  :currentPage="currentPage" 
  @page-changed="changePage" 
/>

  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue';
import axios from 'axios';
import wilayas from '../data/wilayas_fr.json';
import Pagination from '@/components/Pagination.vue';
import { useRoute } from 'vue-router'; 

const route = useRoute();
const offres = ref([]);
const secteursList = ref([]);
const showLotsModal = ref(false);
const selectedLots = ref([]);
const showDescriptionModal = ref(false);
const selectedDescription = ref('');
const apiUrl = import.meta.env.VITE_API_URL;


const filterLangue = ref('');
const filterSearch = ref('');
const selectedWilaya = ref('');
const selectedSecteur = ref('');
const selectedEtat = ref('');
const selectedEtatOffre = ref('');
const selectedType = ref('');
const filterDateDebut = ref('');
const filterDateFin = ref('');
const showFilters = ref(false);
const filterHasLots = ref('');

const activeDropdown = ref(null);


const userRole = ref(localStorage.getItem('userRole'));

const highlightedId = ref(null)


onMounted(() => {
  const h = route.query.highlight;
  if (h) {
    highlightedId.value = Number(h);
  }
});


watch(
  () => route.query.highlight,
  (newH) => {
    highlightedId.value = newH ? Number(newH) : null;
  }
);


onMounted(async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.get(`${apiUrl}/api/secteurs`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    secteursList.value = Array.isArray(response.data) ? response.data : [];
  } catch (error) {
    console.error("Erreur lors de la récupération des entreprises:", error);
  }
});


const hasActiveFilters = computed(() => {
  return (
    filterSearch.value ||
    selectedType.value ||
    selectedSecteur.value ||
    selectedEtat.value ||
    selectedEtatOffre.value ||
    selectedWilaya.value ||
    filterLangue.value ||
    filterDateDebut.value ||
    filterDateFin.value
  );
});


function resetFilters() {
  filterSearch.value = '';
  selectedType.value = '';
  selectedSecteur.value = '';
  selectedEtat.value = '';
  selectedEtatOffre.value = '';
  selectedWilaya.value = '';
  filterLangue.value = '';
  filterDateDebut.value = '';
  filterDateFin.value = '';
}

function clearDates() {
  filterDateDebut.value = '';
  filterDateFin.value = '';
}


const loading = ref(false);

onMounted(async () => {
  loading.value = true; 
  try {
    const token = localStorage.getItem('token');
    const response = await axios.get(`${apiUrl}/api/offres`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    console.log("API Response:", response.data); 
    userRole.value = response.data.role;
    offres.value = response.data.publications || []; 
  } catch (error) {
    console.error("Erreur lors de la récupération des offres:", error);
  } finally {
    loading.value = false; 
  }
});


const filteredOffres = computed(() => {
  return offres.value.filter(offre => {
    const search = filterSearch.value.trim().toLowerCase();
    const matchSearch =
      search === '' ||
      (offre.titre_offre && offre.titre_offre.toLowerCase().includes(search)) ||
      (offre.numero_offre && offre.numero_offre.toString().toLowerCase().includes(search)) ||
      (offre.description && offre.description.toLowerCase().includes(search));

    const matchLangue = filterLangue.value === '' ||
      (offre.langue && offre.langue.toLowerCase() === filterLangue.value.toLowerCase());

const matchWilaya = selectedWilaya.value === '' ||
  (offre.wilaya &&
    offre.wilaya.toLowerCase() ===
      wilayas[selectedWilaya.value].toLowerCase());
    const matchSecteur = selectedSecteur.value === '' ||
      (offre.secteur && offre.secteur.nom &&
       offre.secteur.nom.toLowerCase() === selectedSecteur.value.toLowerCase());

    const matchEtat = selectedEtat.value === '' ||
      (offre.etat && offre.etat.toLowerCase() === selectedEtat.value.toLowerCase()) ||
      (offre.etat_offre && offre.etat_offre.toLowerCase() === selectedEtat.value.toLowerCase());

    const matchEtatOffre = selectedEtatOffre.value === '' ||
      (offre.etat_offre && offre.etat_offre.toLowerCase() === selectedEtatOffre.value.toLowerCase());
   
    const matchType = selectedType.value === '' ||
      (offre.type_offre && offre.type_offre.toLowerCase() === selectedType.value.toLowerCase());


    const hasLots = filterHasLots.value === '' ||
      (filterHasLots.value === 'true' && Array.isArray(offre.lots) && offre.lots.length > 0) ||
      (filterHasLots.value === 'false' && (!Array.isArray(offre.lots) || offre.lots.length === 0));

    const offreDate = new Date(offre.date_publication);
    const debutOk = filterDateDebut.value === '' || offreDate >= new Date(filterDateDebut.value);
    const finOk = filterDateFin.value === '' || offreDate <= new Date(filterDateFin.value);

    return matchSearch && matchLangue && matchWilaya && matchSecteur &&
           matchEtat && matchEtatOffre && matchType && debutOk && finOk && hasLots;
  });
});


const offersPerPage = 10;
const paginatedOffres = computed(() => {
  const start = (currentPage.value - 1) * offersPerPage;
  const end = start + offersPerPage;
  return filteredOffres.value.slice(start, end);
});


const totalPages = computed(() => {
  return Math.ceil(filteredOffres.value.length / offersPerPage);
});


const currentPage = ref(1);
function changePage(newPage) {
  currentPage.value = newPage;
}


const getLogoUrl = (logoPath) => {
  if (!logoPath || logoPath === "null") {
    return `${apiUrl}/storage/logo/default.png`;
  }
  return `${apiUrl}/storage/logo/` + logoPath.split("/").pop();
};

const handleImageError = (event) => {
  event.target.src = `${apiUrl}/storage/logo/default.png`;
};

const formatDate = (date) => {
  if (!date) return 'N/A';
  return new Date(date).toLocaleDateString();
};

const openLotsModal = (lots) => {
  selectedLots.value = lots;
  showLotsModal.value = true;
};

const closeLotsModal = () => {
  showLotsModal.value = false;
};

const openDescriptionModal = (description) => {
  selectedDescription.value = description;
  showDescriptionModal.value = true;
};

const closeDescriptionModal = () => {
  showDescriptionModal.value = false;
};


const toggleDropdown = (offreId) => {
  activeDropdown.value = activeDropdown.value === offreId ? null : offreId;
};

const closeDropdown = (offreId) => {
  if (activeDropdown.value === offreId) {
    activeDropdown.value = null;
  }
};


const deleteOffre = async (offreId) => {
  if (confirm("Êtes-vous sûr de vouloir supprimer cette offre ?")) {
    try {
      await axios.delete(`${apiUrl}/api/offres/${offreId}`, {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
      });
      offres.value = offres.value.filter(offre => offre.id !== offreId);
    } catch (error) {
      console.error("Erreur lors de la suppression de l'offre:", error);
    }
  }
};
const showTitleModal = ref(false);
const selectedTitle = ref('');

const openTitleModal = (title) => {
  selectedTitle.value = title;
  showTitleModal.value = true;
};

const closeTitleModal = () => {
  showTitleModal.value = false;
};


const isNearBottom = (offreId) => {
  const dropdown = document.querySelector(`.dropdown-menu-over[activeDropdown="${offreId}"]`);
  if (!dropdown) return false;
  const rect = dropdown.getBoundingClientRect();
  return rect.bottom > window.innerHeight;
};
</script>


<style scoped>
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css');

/* Variables */
:root {
  --primary-color: #2c3e50;
  --secondary-color: #3498db;
  --accent-color: #e74c3c;
  --hover-bg: #f8f9fa;
  --success-color: #27ae60;
  --warning-color: #f1c40f;
}


.offres-table {
  padding: 2rem;
  margin-top: 60px;
  min-height: 900px;
  background-color: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  font-family: 'Segoe UI', sans-serif;
  font-size: smaller;
  overflow-x: auto;
  position: relative;
}
h2{
  font-size: x-large;
  color: #11265e;
  text-align: start;

}

.filter-header {
  display: flex;
  gap: 10px;
  align-items: center;
  margin-bottom: 1rem;
  flex-wrap: wrap;
  position: sticky;
  top: 0;
  background-color: #fff;
  z-index: 10;
  padding-bottom: 1rem;
  border-bottom: 1px solid #e5e7eb;
}


.filter-toggle {
  background-color: #2b2c7f;
  color: white;
  border: none;
  padding: 0.6rem 1rem;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.filter-toggle i {
  font-size: 1rem;
}


.search-item input {
  padding: 0.6rem;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  width: 650px;
}
.search-item {
  width: 500px;
}

.active-filters {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-bottom: 1rem;
  align-items: center;
}
.highlighted {
 
  color: #10c47c;
  font-weight: bold;
}
.filter-badge {
  background-color: #e0e7ff;
  color: #11265e;
  padding: 0.4rem 0.8rem;
  border-radius: 20px;
  display: flex;
  align-items: center;
  font-size: 0.875rem;
  gap: 0.4rem;
}

.filter-badge button {
  background: none;
  border: none;
  font-size: 1rem;
  line-height: 1;
  color: #1e3a8a;
  cursor: pointer;
}

.reset-filters {
  background-color: transparent;
  border: 1px solid #1e3a8a;
  color: #1e3a8a;
  padding: 0.4rem 0.8rem;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
}


.filters-panel {
  background-color: #f9fafb;
  padding: 1.5rem;
  border-radius: 10px;
  border: 1px solid #e5e7eb;
  margin-bottom: 1rem;
  overflow: hidden;
}

.slide-fade-enter-active,
.slide-fade-leave-active {
  transition: all 0.4s ease;
}
.slide-fade-enter-from,
.slide-fade-leave-to {
  max-height: 0;
  opacity: 0;
}


.filters {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 1.2rem;
}

.filter-item label {
  display: block;
  font-size: 0.875rem;
  font-weight: 600;
  margin-bottom: 0.4rem;
  color: #374151;
}

.filter-item select,
.filter-item input[type="date"],
.filter-item input[type="text"] {
  width: 100%;
  padding: 0.6rem;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  font-size: 0.9rem;
}

.date-group {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.date-separator {
  font-size: 1.2rem;
  margin: 0 0.3rem;
}


table {
  width: 100%;
  border-collapse: collapse;
  box-shadow: 0 1px 3px rgba(0,0,0,0.12);
  border-radius: 8px;
  overflow: hidden;
  animation: slideUp 0.5s ease;
  color: var(--primary-color);
}

@keyframes slideUp {
  from { transform: translateY(20px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

th, td {
 padding-left: 0.7rem;
 padding-right: 0.8rem;
  text-align: left;
  border-bottom: 1px solid #ecf0f1;
  transition: background 0.3s ease;
}

th {
  background-color: var(--primary-color);
  color: rgb(37, 37, 37);
  font-weight: 600;
  position: sticky;
  top: 0;
}

tr:nth-child(even) {
  background-color: #f8f9fa;
}

tr:hover {
  background-color: var(--hover-bg);
  transform: translateX(4px);
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.entreprise-cell {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.logo {
  width: 60px;
  height: 60px;
  object-fit: contain;
  border: 2px solid #ecf0f1;
  border-radius: 8px;
  padding: 4px;
  transition: transform 0.3s ease;
}

.logo:hover {
  transform: scale(1.05);
}
.title-cell {
  max-width: 250px;
  position: relative;
}

.title-wrapper {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  cursor: pointer;
  border-radius: 4px;
  transition: all 0.3s ease;
}

.title-wrapper:hover {
  background-color: var(--secondary-color);
  color: rgb(52, 46, 69);
}

.full-title {
  white-space: pre-wrap;
  line-height: 1.6;
  background: #f8f9fa;
  padding: 1rem;
  border-radius: 8px;
}
.description-cell {
  max-width: 100px;
  position: relative;
}

.description-wrapper {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  cursor: pointer;
  border-radius: 4px;
  transition: all 0.3s ease;
}

.description-wrapper:hover {
  background-color: var(--secondary-color);
  color: rgb(52, 46, 69);
}

.description-wrapper:hover::after {
  content: "\f06e";
  font-family: "Font Awesome 5 Free";
  margin-left: 8px;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.modal-content {
  background: white;
  padding: 2rem;
  width: 90%;
  max-width: 600px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  transform: translateY(-20px);
  animation: modalSlideUp 0.3s ease forwards;
}

@keyframes modalSlideUp {
  to { transform: translateY(0); }
}

.document-link {
  display: flex;
  color: #3c925f;
  font-weight: 500;
  text-decoration: none;
  transition: background-color 0.3s ease, color 0.3s ease;
  gap: 10px;
}

.document-link:hover {

  color:#27ae60;
}



.lots-btn {
  background-color: #1e3a8a;
  color: white;
  border: none;
  padding: 0.6rem 1rem;
  border-radius: 20px;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  justify-content: center;
}

.lots-btn:hover {
  background-color: #2980b9;
  transform: translateY(-2px);
}


.modal-content {
  position: relative; 
  background: white;
  padding: 2rem;
  width: 90%;
  max-width: 600px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  transform: translateY(-20px);
  animation: modalSlideUp 0.3s ease forwards;
}

.close-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  background: transparent;
  border: none;
  font-size: 1.5rem;
  color: rgb(133, 20, 20);
  cursor: pointer;
  transition: color 0.3s ease, transform 0.3s ease;
}

.close-btn:hover {
  color: #c0392b;
  transform: scale(1.1);
}


.full-description {
  white-space: pre-wrap;
  line-height: 1.6;
  background: #f8f9fa;
  padding: 1rem;
  border-radius: 8px;
}

.lot-item {
  padding: 1rem;
  background: #f8f9fa;
  margin: 1rem 0;
  border-radius: 8px;
}



.lot-item {
  padding: 1rem;
  background: #f8f9fa;
  margin: 1rem 0;
  border-radius: 8px;
}


.action-dropdown {
  position: relative;
  display: inline-block;
  z-index: 9999;
}

.action-btn {
  background-color: var(--primary-color);
  color: rgb(95, 95, 95);
  border: none;
  padding: 0.5rem 0.8rem;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1rem;
  transition: background-color 0.3s ease, transform 0.3s ease;
}

.action-btn:hover {
  background-color: var(--secondary-color);
  transform: scale(1.05);
}
 .view-btn {
  color: rgb(53, 53, 53);
  text-decoration: none;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.9rem;
  transition: background-color 0.3s ease, transform 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.view-btn:hover {
  color: #2b4bc0;
  transform: scale(1.05);
}

.dropdown-menu {
  position: absolute;
  top: 100%;
  right: 0;
  background-color: white;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  z-index: 10000; 
  min-width: 150px;
  padding: 0.5rem 0;
  display: flex;
  flex-direction: column;
}

.dropdown-menu-over {
  z-index: 99999;
}

.dropdown-menu button {
  background: none;
  border: none;
  padding: 0.5rem 1rem;
  text-align: left;
  font-size: 0.9rem;
  color: var(--primary-color);
  cursor: pointer;
  transition: background-color 0.3s ease, color 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.dropdown-menu button:hover {
  background-color: var(--hover-bg);
}

.dropdown-menu button:nth-child(1):hover {
  color: #27ae60;
}

.dropdown-menu button:nth-child(2):hover {
  color: #e74c3c; 
}

.dropdown-menu button i {
  font-size: 1rem;
}


.offres-table::-webkit-scrollbar {
  height: 8px;
}
.offres-table::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}
.offres-table::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 4px;
}


@media (max-width: 768px) {
  th, td {
    padding: 0.75rem;
    font-size: 0.9rem;
  }
  
  .logo {
    width: 40px;
    height: 40px;
  }
  
  .modal-content {
    padding: 1rem;
  }

  .search-item input {
    width: 100%;
  }
}


.styled-modal {
  max-width: 700px;
  padding: 2rem;
  background-color: #f9f9f9;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  animation: fadeIn 0.3s ease;
}

.lots-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1rem;
}

.lot-card {
  background: #ffffff;
  padding: 1rem;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.lot-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.lot-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.status-badge {
  padding: 0.3rem 0.6rem;
  border-radius: 12px;
  font-size: 0.8rem;
 
  color: #fafafa;
}

.status-annule {
  background-color: #f32112;
}

.status-attribue {
  background-color: #27ae60;
}

.status-encours {
  background-color: #3498db;
}

.lot-card p {
  margin: 0.5rem 0;
  font-size: 0.9rem;
  color: #333;
}

.lot-card strong {
  color: #2c3e50;
}

.lot-card a {
  color: #3498db;
  text-decoration: none;
  font-weight: bold;
  margin-left: 10px;
}

.lot-card a:hover {
  text-decoration: underline;
}

.lot-card i {
  margin-right: 0.3rem;
}
.loading-row td,
.empty-row td {
  text-align: center;
  padding: 1rem;
  color: #718096; 
  font-style: italic;
}


.loading-icon {
  margin-right: 0.5rem;
  color: #2c5282; 
}


.empty-icon {
  margin-right: 0.5rem;
  color: #c23d3d; 
}
 
.numero-offre-cell {
  max-width: 100px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

</style>
