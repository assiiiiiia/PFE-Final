<template>
  <div class="tenders-container">
<div class="button-group">
    <button 
      @click="setTenderType('Appel d\'offre')" 
      type="button" 
      class="button"
      :class="{ active: activeTenderType === 'Appel d\'offre' }"
      data-type="call"
    >
      <i class="fas fa-file-contract"></i>
      {{ $t("tenders.callForTender") }}
    </button>
    <button 
      @click="setTenderType('Avis de consultation')" 
      type="button" 
      class="button"
      :class="{ active: activeTenderType === 'Avis de consultation' }"
      data-type="consultation"
    >
      <i class="fas fa-search-dollar"></i>
      {{ $t("tenders.consultationNotice") }}
    </button>
    <button 
      @click="setTenderType('Avis de manifestation')" 
      type="button" 
      class="button"
      :class="{ active: activeTenderType === 'Avis de manifestation' }"
      data-type="manifestation"
    >
      <i class="fas fa-bullhorn"></i>
      {{ $t("tenders.manifestationNotice") }}
    </button>
  </div>

  
    <div class="search-container">
      <h2 class="title">
        <i class="fas fa-search" :style="{ color: selectedType === 'Appel d\'offre' ? '#1417b9' : selectedType === 'Avis de consultation' ? '#00a86b' : '#ffc107' }"></i>
        {{ selectedType === 'Appel d\'offre' ? $t('tenders.callForTender') : selectedType === 'Avis de consultation' ? $t('tenders.consultationNotice') : $t('tenders.manifestationNotice') }}
      </h2>
      <div class="search">
        <input v-model="searchQuery" type="text" :placeholder="$t('tenders.searchPlaceholder')" class="input" />
        <select v-model="selectedWilaya" class="search-select">
          <option value="">{{ $t("tenders.selectWilaya") }}</option>
          <option v-for="wilaya in wilayas" :key="wilaya.id" :value="wilaya.name">
            {{ wilaya.name }}
          </option>
        </select>
        <select v-model="selectedCompany" class="search-select">
          <option value="">{{ $t("tenders.selectCompany") }}</option>
          <option v-for="(entreprise, index) in entreprises" :key="index" :value="entreprise.id">
            {{ entreprise.nom }} ({{ entreprise.abreviation }})
          </option>
        </select>
        <input v-model="startDate" type="date" class="search-select" />
        <input v-model="endDate" type="date" class="search-select" />
      </div>
    </div>

   
    <div v-if="paginatedTenders.length" class="tenders-list">
      <Offre
        v-for="tender in paginatedTenders"
        :key="tender.id"
        :tender="tender"
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
    <p v-else class="no-tenders">{{ $t("tenders.noTenders") }}</p>

 
    <Pagination 
      :totalPages="totalPages" 
      :currentPage="currentPage" 
      @page-changed="handlePageChange" 
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";
import wilayasFr from "../data/wilayas_fr.json";
import wilayasAr from "../data/wilayas_ar.json";

import Pagination from "@/components/Pagination.vue";
import Offre from "../components/Offre.vue";

import { useI18n } from "vue-i18n";

const apiUrl = import.meta.env.VITE_API_URL;
const tenders = ref([]);
const searchQuery = ref(""); 
const currentPage = ref(1);
const itemsPerPage = 5;
const selectedType = ref("Appel d'offre"); 
const selectedWilaya = ref("");
const selectedCompany = ref(""); 
const isLoggedIn = ref(false);
const showModal = ref(false);
const selectedTender = ref(null);
const user = ref({});
const startDate = ref("");
const endDate = ref("");

const { locale } = useI18n();
const wilayas = computed(() => {
  const data = locale.value === "fr" ? wilayasFr : wilayasAr;
  return Object.entries(data).map(([id, name]) => ({
    id: Number(id),
    name,
  }));
});
const entreprises = ref([]);
const fetchEntreprises = async () => {
  try {
    const token = localStorage.getItem("token");
    const response = await axios.get(`${apiUrl}/api/secteurs`, { 
      headers: { Authorization: `Bearer ${token}` },
    });
    entreprises.value = response.data; 
  } catch (error) {
    console.error("Erreur de chargement des secteurs :", error); 
  }
};
onMounted(fetchEntreprises);
onMounted(() => {
  const token = localStorage.getItem("token");
  if (token) {
    isLoggedIn.value = true;
  }
});

const router = useRouter();

const openSubmissionModal = async (tender) => {
  selectedTender.value = tender;
  try {
    const token = localStorage.getItem("token");
    const response = await axios.get(`${apiUrl}/api/user`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    user.value = response.data;
  } catch (error) {
    console.error("Erreur de récupération des infos utilisateur :", error);
  }
  showModal.value = true;
};

const searchTenders = () => {
  return tenders.value.filter(tender => {
    const matchesQuery = searchQuery.value
      ? (
          (tender.titre_offre?.toLowerCase().includes(searchQuery.value.toLowerCase())) ||
          (tender.numero_offre?.toLowerCase().includes(searchQuery.value.toLowerCase())) ||
          (tender.wilaya?.toLowerCase().includes(searchQuery.value.toLowerCase())) ||
          (tender.description?.toLowerCase().includes(searchQuery.value.toLowerCase())) ||
          (tender.description_ar?.toLowerCase().includes(searchQuery.value.toLowerCase()))
        )
      : true;

    const matchesWilaya = selectedWilaya.value
      ? tender.wilaya?.toLowerCase() === selectedWilaya.value.toLowerCase()
      : true;

    const matchesCompany = selectedCompany.value
      ? Number(tender.secteur?.id) === Number(selectedCompany.value)
      : true;

    const matchesType = selectedType.value
      ? tender.type_offre === selectedType.value
      : true;

    const matchesEtat = tender.etat?.toLowerCase() === "publiée";

    const matchesLanguage = locale.value === "ar"
      ? tender.titre_offre_ar && tender.description_ar
      : true;

    const matchesDateRange = (!startDate.value || new Date(tender.date_publication) >= new Date(startDate.value)) &&
                             (!endDate.value || new Date(tender.date_publication) <= new Date(endDate.value));

    return matchesQuery && matchesWilaya && matchesCompany && matchesType && matchesEtat && matchesLanguage && matchesDateRange;
  });
};

const filteredTenders = computed(() => searchTenders());

watch([searchQuery, selectedWilaya, selectedCompany, selectedType], () => {
  currentPage.value = 1;
});

const getLogoUrl = (logoPath) => {
  if (!logoPath || logoPath === "null") {
    return `${apiUrl}/storage/logo/default.png`;
  }
  return`${apiUrl}/storage/logo/` + logoPath.split("/").pop();
};

const handleImageError = (event, entreprise) => {
  event.target.src = `${apiUrl}/storage/logo/default.png`;
};

onMounted(async () => {
  try {
    const response = await axios.get(`${apiUrl}/api/offres-pub`);
    tenders.value = Array.isArray(response.data) ? response.data : [];
    console.log(response.data);
  } catch (error) {
    console.error("Erreur lors de la récupération des appels d'offres:", error);
  }
});

const totalPages = computed(() =>
  Math.ceil(filteredTenders.value.length / itemsPerPage)
);

const paginatedTenders = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return filteredTenders.value.slice(start, start + itemsPerPage);
});

const goToPage = (page) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page;
  }
};

const handlePageChange = (page) => {
  goToPage(page);
};

const viewDetails = (id) => {
  if (id) {
    router.push({ name: "OffresDetails", params: { id } });
  }
};

const setTenderType = (type) => {
  selectedType.value = type;
  currentPage.value = 1;
};

const getDetailsButtonStyle = (tender) => {
  if (tender.type_offre === "Appel d'offre") {
    return { backgroundColor: "#2c5cc5" };
  } else if (tender.type_offre === "Avis de consultation") {
    return { backgroundColor: "#00a86b" };
  } else if (tender.type_offre === "Avis de manifestation") {
    return { backgroundColor: "#ffc107" };
  }
  return { backgroundColor: "#2c5cc5" };
};

const toggleFavorite = (tender) => {
  tender.isFavorite = !tender.isFavorite;
};
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal {
  background: white;
  padding: 20px;
  width: 400px;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.modal-content {
  margin-top: 10px;
}

.info {
  margin-bottom: 10px;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 5px;
}

.search-container {
  max-width: 1200px;
  margin: 20px auto;
  text-align: center;
  border-radius: 4px;
  background-color: #ffffff;
  padding: 2rem;
  box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s;
}

.search {
  display: flex;
  justify-content: space-between;
  gap: 10px;
}

.title {
  font-size: 1.75rem;       
  font-weight: 600;          
  color: #434448;         
  margin-bottom: 1.5rem;  
}

.title .fas {
  font-size: 1.5rem;      
  margin-right: 0.75rem;     
  color: var(--icon-color);
}


.title:hover .fas {
  color: #007bb5;
  transform: translateX(2px);
  transition: color 0.2s ease, transform 0.2s ease;
}


@media (max-width: 600px) {
  .title {
    font-size: 1.5rem;
  }
  .title .fas {
    font-size: 1.25rem;
    margin-right: 0.5rem;
  }
}

.search-select {
  width: 70%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 5px;
  background-color: #fff; 
  color: #242424;
}

.input {
  flex: 1;
  padding: 12px 20px;
  border: 2px solid #e0e0e0;
  border-radius: 25px;
  font-size: 16px;
  transition: all 0.3s ease;
}

.input:focus {
  border-color: #007bff;
  box-shadow: 0 0 8px rgba(0, 123, 255, 0.2);
}

.search-select {
  width: 240px;
  padding: 10px 15px;
  border: 2px solid #e0e0e0;
  border-radius: 25px;
  background-color: white;
  appearance: none;
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 12px center;
  background-size: 18px;
}


@media (max-width: 768px) {
  .search {
    flex-direction: column;
  }
  
  .input, .search-select {
    width: 100%;
  }
}
.no-tenders {
  text-align: center;
  font-size: 16px;
  color: #777;
}


.title-icon{
  height: 23px;
  margin-right: 20px;
}
.button-group {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
  justify-content: center;
}

.button {
  padding: 1rem 2rem;
  border-radius: 12px;
  margin-top: 60px;
  border: 2px solid transparent;
  background-color: #fff;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.8rem;
  font-size: 1rem;
  font-weight: 600;
  position: relative;
  overflow: hidden;
}

.button i {
  transition: transform 0.3s ease;

}

.button[data-type="call"] {
  color: #2c5cc5;
  background-color: rgba(44, 92, 197, 0.1);
}

.button[data-type="consultation"] {
  color: #00a86b;
  background-color: rgba(0, 168, 107, 0.1);
}

.button[data-type="manifestation"] {
  color: #ffc107;
  background-color: rgba(214, 226, 43, 0.1);
}

.button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);

}
.button[data-type="call"]:hover {
background-color: rgba(21, 64, 156, 0.231);
}
.button[data-type="consultation"]:hover {
  background-color: rgba(0, 168, 107, 0.231);
}
.button[data-type="manifestation"]:hover {
  background-color: rgba(214, 226, 43, 0.231);
}
/* Active state */
.button.active {
  border-color: currentColor;
  background-color: rgba(255, 255, 255, 0.9);
  box-shadow: 0 4px 16px rgba(0,0,0,0.15);
  transform: scale(1.05);
}

.button.active[data-type="call"] {
  background-color: rgba(44, 92, 197, 0.15);
}

.button.active[data-type="consultation"] {
  background-color: rgba(0, 168, 107, 0.15);
}

.button.active[data-type="manifestation"] {
  background-color: rgba(138, 43, 226, 0.15);
}

/* Responsive */
@media (max-width: 768px) {
  .button-group {
    flex-direction: column;
    width: 100%;
  }
  
  .button {
    width: 100%;
    justify-content: center;
    padding: 1rem;
  }
}
</style>
