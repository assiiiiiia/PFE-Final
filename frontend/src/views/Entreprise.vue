<template>
  <div class="container">
    <header>
      <h2>Liste des Secteurs</h2>
    </header>

    <div class="add-group">
      <div class="user-count">
        Total Secteurs: {{ secteurs.length }}
      </div>
      <div class="filter">
        <FilterBar 
          :search="searchQuery" 
          @filters-changed="onFiltersChanged" 
        />
     
        <button class="add-secteur" @click="openModal('add')">
          <i class="fas fa-building"></i> Ajouter un Secteur
        </button>
      </div>
    </div>

    <div class="table-responsive">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Logo</th>
            <th>Nom</th>
            <th>Abréviation</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading" class="loading-row">
            <td colspan="5">
              <i class="fas fa-spinner fa-spin loading-icon"></i>
              Chargement des secteurs...
            </td>
          </tr>

       
          <tr v-else-if="!loading && paginatedSecteurs.length === 0" class="empty-row">
            <td colspan="5">
              <i class="fas fa-exclamation-circle empty-icon"></i>
              Aucun secteur trouvé.
            </td>
          </tr>

          <tr v-else v-for="secteur in paginatedSecteurs" :key="secteur.id">
            <td>{{ secteur.id }}</td>
            <td>
              <img :src="getLogoUrl(secteur.logo)" class="logo" @error="handleImageError($event, secteur)" />
            </td>
            <td>{{ secteur.nom }}</td>
            <td>{{ secteur.abreviation }}</td>
            <td>
              <ActionButtons 
               :item="secteur"
               @edit="openModal('edit', secteur)"
                @delete="confirmDelete(secteur.id)"
                 :show-details="false"
              />
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <Pagination 
      :totalPages="totalPages" 
      :currentPage="currentPage" 
      @page-changed="handlePageChange" 
    />
   <ModalSecteur
     :show="showModalSecteur"
     :mode="modalMode"
     :secteur="selectedSecteur"
     :api-url="apiUrl"
     @close="closeModal"
     @save="handleSubmit"
   />

   <SuccessNotification 
     v-if="showSuccess" 
     :message="successMessage" 
     @close="showSuccess = false" 
   />

   <ConfirmDialog 
     v-if="showConfirmDialog" 
     :message="confirmMessage" 
     @confirm="handleConfirm" 
     @cancel="handleCancel" 
   />
  
  </div>
</template>

<script>
import axios from "axios";
import Pagination from "@/components/Pagination.vue";
import ActionButtons from "@/components/ActionButtons.vue";
import ModalSecteur from "@/components/ModalSecteur.vue";
import SuccessNotification from "@/components/SuccessNotification.vue";
import ConfirmDialog from "@/components/ConfirmDialog.vue";
import FilterBar from "@/components/FilterBar.vue";
const apiUrl = import.meta.env.VITE_API_URL;

export default {
  components: {
    FilterBar,
    Pagination,
    ActionButtons,
    ModalSecteur,
    SuccessNotification,
    ConfirmDialog,
      
 
  },
  data() {
    return {
      secteurs: [],
     apiUrl: import.meta.env.VITE_API_URL,
      selectedSecteur: null,
      currentPage: 1,
      secteursPerPage: 10,
      showModalSecteur: false,
      searchQuery: "",
      showModal: false,
      modalMode: "add",
      loading: false,
      currentSecteur: {},
      showSuccess: false,
      successMessage: "",
      showConfirmDialog: false,
      confirmMessage: "",
      secteurIdToDelete: null,
    };
  },
  methods: {
    async fetchSecteurs() {
           this.loading = true;
      try {
        const token = localStorage.getItem("token");
        const response = await axios.get(`${apiUrl}/api/secteurs`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        this.secteurs = response.data;
      } catch (error) {
        console.error("Erreur de chargement :", error);
      } finally {
        this.loading = false;
      }
    },
    onFiltersChanged({ search }) {
      this.searchQuery = search;
      this.currentPage = 1; 
    },
    getLogoUrl(logoPath) {
      if (!logoPath || logoPath === "null") {
        return `${apiUrl}/storage/logo/default.png`; 
      }
      return `${apiUrl}/storage/logo/` + logoPath.split("/").pop();
    },
    handleImageError(event, secteur) {
      console.error("Image non trouvée pour:", secteur.nom, "Chemin:", secteur.logo);
      event.target.src = `${apiUrl}/storage/logo/default.png`;
    },
    openModal(mode, secteur = null) {
      this.modalMode = mode;
 
      this.selectedSecteur = mode === 'edit' ? { ...secteur } : {};
      this.showModalSecteur = true;
    },
    closeModal() {
      this.showModalSecteur = false;
    },
    openDetailsModal(secteur) {
      this.selectedSecteur = secteur;
      this.showModalDetail = true; 
    },
    closeDetailsModal() {
      this.showModalDetail = false; 
    },
    async handleSubmit(payload) {
      if (!payload || !payload.secteur || Object.keys(payload.secteur).length === 0) {
        console.error("Aucune donnée de secteur reçue", payload);
        return;
      }

      const { mode, secteur } = payload;
      console.log("Payload reçu :", payload);

      const token = localStorage.getItem("token");
      try {
        let formData = new FormData();
        const fields = ["logo", "nom", "abreviation"];
        fields.forEach((key) => {
          if (key === "logo" && secteur.logo instanceof File) {
            formData.append(key, secteur.logo);
          } else if (key === "logo" && typeof secteur.logo === 'string' && secteur.logo !== '') {
         
          } else {
            formData.append(key, secteur[key] || "");
          }
        });

        if (mode === "add") {
          await axios.post(`${apiUrl}/api/secteurs`, formData, {
            headers: {
              Authorization: `Bearer ${token}`,
              "Content-Type": "multipart/form-data",
            },
          });
        } else if (mode === "edit" && secteur.id) {
  await axios.post(
  `${apiUrl}/api/secteurs/${secteur.id}?_method=PUT`,
  formData,
  {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  }
);
        } else {
          console.error("ID du secteur manquant pour la modification.");
          return;
        }

        this.successMessage = mode === "add" ? "Secteur ajouté avec succès." : "Secteur modifié avec succès.";
        this.showSuccess = true;
        this.fetchSecteurs();
        this.closeModal();
      } catch (error) {
        console.error("Erreur lors de la soumission :", error);
      }
    },
    confirmDelete(secteurId) {
      this.secteurIdToDelete = secteurId;
      this.confirmMessage = "Êtes-vous sûr de vouloir supprimer ce secteur ?";
      this.showConfirmDialog = true;
    },
    handleConfirm() {
      const token = localStorage.getItem("token");
      axios
        .delete(`${apiUrl}/api/secteurs/${this.secteurIdToDelete}`, {
          headers: { Authorization: `Bearer ${token}` },
        })
        .then(() => {
          this.successMessage = "Secteur supprimé avec succès.";
          this.showSuccess = true;
          this.fetchSecteurs();
        })
        .catch((error) => {
          console.error("Erreur lors de la suppression :", error);
        })
        .finally(() => {
          this.showConfirmDialog = false;
          this.secteurIdToDelete = null;
        });
    },
    handleCancel() {
      this.showConfirmDialog = false;
      this.secteurIdToDelete = null;
    },
    handlePageChange(page) {
      this.currentPage = page;
    },
  },
  computed: {
   filteredSecteurs() {
      const q = this.searchQuery.toLowerCase();
      return this.secteurs.filter(s => 
        !q || (s.nom && s.nom.toLowerCase().includes(q))
             || (s.abreviation && s.abreviation.toLowerCase().includes(q))
      );
    },
    paginatedSecteurs() {
      const start = (this.currentPage - 1) * this.secteursPerPage;
      return this.filteredSecteurs.slice(start, start + this.secteursPerPage);
    },
    totalPages() {
      return Math.ceil(this.filteredSecteurs.length / this.secteursPerPage);
    },
  },
  mounted() {
    this.fetchSecteurs();
  },
};
</script>

<style scoped>
.container {
  padding: 2rem;
  margin-top: 60px;
  height: 100%;
  min-height: 900px;
  background-color: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  font-family: 'Segoe UI', sans-serif;
  font-size: smaller;
  overflow-x: auto;
  position: relative;
  }
  .container h2 {
color: #11265e;
  font-size: 1.7rem;
  font-weight: 600;
  margin-bottom: 0rem;
  padding-bottom: 0.1rem;
  border-bottom: 2px solid #f0f2f5;
}
.add-group {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  padding: 10px 0;
  gap: 10px;
}

.user-count {
  font-weight: 700;
  font-size: 16px;
  color: #11265e;
}

.user-count span {
  color: #9f9fa0;
  margin-left: 4px;
}

.filter {
  display: flex;
  align-items: center;
  gap: 10px;
}

header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

button.add-secteur {
  background: #28a745;
  color: white;
  border: none;
  padding: 10px 15px;
  border-radius: 5px;
  cursor: pointer;
  transition: background 0.3s;
}

button.add-secteur:hover {
  background: #218838;
}


.table-responsive {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  border-radius: 10px;
  overflow: hidden;
}

thead {
  background: #f8f9fa;
  font-weight: bold;
}

th {
  padding: 15px;
  border-bottom: 1px solid #ddd;
  text-align: left;
}
td {
  padding-left: 30px;
  border-bottom: 1px solid #ddd;
  text-align: left;

}
  th {
    font-size: 15px;
    color: #6c757d;
  }
tr:hover {
  background: #f1f1f1;
}

tbody tr {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

tbody tr:hover {
  transform: scale(1.01);
  z-index: 10;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
}


button.edit {
  background: #17b847;
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 5px;
  cursor: pointer;
  margin-right: 10px;
  transition: background 0.3s;
}

button.edit:hover {
  background: #147414;
}

button.delete {
  background: #e3342f;
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 5px;
  cursor: pointer;
  margin-right: 10px;
  transition: background 0.3s;
}

button.delete:hover {
  background: #cc1f1a;
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

.search-container {
  margin-left: auto;
}

.search-container input {
  padding: 8px;
  border-radius: 5px;
  border: 1px solid #ccc;
}


.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.pagination button {
  background: #007bff;
  color: white;
  border: none;
  padding: 5px 10px;
  margin: 0 5px;
  cursor: pointer;
}

.pagination button:disabled {
  background: #ccc;
}

@media screen and (max-width: 768px) {
  .container {
    padding: 10px;
    margin-left: 20px;
  }
  th, td {
    padding: 8px;
    font-size: 13px;
  }
}
.table-responsive td:nth-child(3) {
  width: 40%; 
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.table-responsive td:nth-child(4) {
  width: 15%; 
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
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
</style>

