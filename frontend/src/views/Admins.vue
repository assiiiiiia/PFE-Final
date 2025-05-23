<template>
    <div class="container">
      <header>
        <h2>Liste des Administrateurs</h2>
      </header>
  
      <div class="add-group"> 
        <div class="user-count">
          Total Administrateurs: {{ users.length }}
        </div>
        <div class="filter">
         
        <FilterBar
          :search="searchQuery"
          :filters-list="filtersList"
          :initial-filters="{ status: selectedStatus, secteur: selectedSecteur }"
          @filters-changed="onFiltersChanged"
        />

        <button class="dropdown-button" @click.prevent="selectOption('addAdmin')">
          <i class="fas fa-user-shield"></i>  Ajouter un administrateur
        </button>
        </div>
      </div>
  
      <ModalUser 
        v-if="showModalUser" 
        :mode="modalMode" 
        :user="selectedUser" 
        @close="showModalUser = false"
        @user-updated="updateUserList"
      />
    
      
  
      <ConfirmDialog 
        v-if="showConfirmDialog" 
        :message="confirmMessage"
        @confirm="handleConfirm"
        @cancel="handleCancel"
      />
  
      <div class="table-responsive">
        <table>
          <thead>
            <tr>  
              <th>ID</th>
              <th>Secteur</th>
              <th>Nom</th>
              <th>Prénom</th>
              <th>Email</th> 
              <th>Téléphone</th>
              <th>Fonction</th>
              <th>Statut</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
 
            <tr v-if="loading" class="loading-row">
    <td colspan="9">
      <i class="fas fa-spinner fa-spin loading-icon"></i>
      Chargement des administrateurs...
    </td>
  </tr>


  <tr v-else-if="!loading && paginatedAdmins.length === 0" class="empty-row">
    <td colspan="9">
      <i class="fas fa-exclamation-circle empty-icon"></i>
      Aucun administrateur trouvé.
    </td>
  </tr>

  <tr v-else v-for="admin in paginatedAdmins" :key="admin.id">
    <td>{{ admin.id }}</td>
    <td v-if="admin.secteur">
      <img :src="getLogoUrl(admin.secteur.logo)" alt="Logo" class="logo-img" @error="handleImageError" />
    </td>
    <td v-else> - </td>
    <td>{{ admin.nom }}</td>
    <td>{{ admin.prenom }}</td>
    <td>{{ admin.email }}</td>
    <td>{{ admin.telephone }}</td>
    <td>{{ admin.fonction || "/" }}</td>
    <td :class="getStatusClass(admin.status)">{{ admin.status }}</td>
    <td>
      <ActionButtons
        :item="admin"
        :show-edit="true"
        :show-delete="true"
        :show-details="false"
        @edit="openModal('edit', admin)"
        @delete="confirmDelete(admin.id)"
      />
    </td>
  </tr>
</tbody>

        </table>
      </div>
  
      <SuccessNotification 
        v-if="showSuccess" 
        :message="successMessage" 
        @close="showSuccess = false" 
      />
  
      <Pagination 
        :totalPages="totalPages" 
        :currentPage="currentPage" 
        @page-changed="handlePageChange" 
      />
    </div>
  </template>
  
  <script>
  import "@fortawesome/fontawesome-free/css/all.css";
  import axios from 'axios'
  import ModalUser from "@/components/ModalUser.vue";
  import ModalDetail from "@/components/ModalDetail.vue";
  import Pagination from "@/components/Pagination.vue";
  import FilterBar from "@/components/FilterBar.vue";
  import SuccessNotification from "@/components/SuccessNotification.vue";
  import ConfirmDialog from "@/components/ConfirmDialog.vue";
  import ActionButtons from "@/components/ActionButtons.vue";
  const apiUrl = import.meta.env.VITE_API_URL;
  export default {
    components: {
      ModalUser,
      ModalDetail, 
      Pagination,
      FilterBar,
      ConfirmDialog,
      SuccessNotification,
      ActionButtons
    },
    data() {
      return {
        users: [],
        searchQuery: "",
        selectedStatus: "",
        selectedUser: null,
        modalMode: "",
        showModalUser: false,
        dropdownOpen: false,
        currentPage: 1,
        usersPerPage: 10,
        loading: false,
        showModalDetail: false,
        showConfirmDialog: false,
        confirmMessage: "",
        confirmCallback: null, 
        showSuccess: false,
        successMessage: "",
        secteursList: [],
        selectedSecteur: "",  
      };
    },
    methods: {
        getLogoUrl(logoPath) {
    if (!logoPath || logoPath === "null") {
      return `${apiUrl}/storage/logo/default.png`;
    }
    return `${apiUrl}/storage/logo/`+ logoPath.split("/").pop();
  },
  handleImageError(event) {
    event.target.src = `${apiUrl}/storage/logo/default.png`; 
  }
,
      onFiltersChanged({ search, status, secteur }) {
        this.searchQuery = search;
        this.selectedStatus = status;
        this.selectedSecteur = secteur;
        this.currentPage = 1;
      },
      toggleDropdown() {
        this.dropdownOpen = !this.dropdownOpen;
      },
      async fetchAdmins() {
        this.loading = true;
        try {
          const token = localStorage.getItem("token");
          const response = await fetch(`${apiUrl}/api/admin`, {
            headers: {
              Accept: "application/json",
              Authorization: token ? `Bearer ${token}` : "",
            },
          });
          if (!response.ok) throw new Error(`Erreur ${response.status}`);
          const data = await response.json();
          this.users = Array.isArray(data) ? data.filter(user => user.role === "admin") : [];
        } catch (error) {
          console.error("Erreur de chargement des administrateurs :", error.message);
        } finally {
          this.loading = false;
        }
      },
      updateUserList(updatedUser) {
  const index = this.users.findIndex((u) => u.id === updatedUser.id);
  if (index !== -1) {
    this.$set(this.users, index, updatedUser);
  } else {
    this.users.push(updatedUser);
  }
},

      openModal(type, admin = null) {
        if (type === "addAdmin") {
          this.modalMode = "addAdmin";
          this.selectedUser = { role: "admin" };
        } else if (type === "edit") {
          this.modalMode = "edit";
          this.selectedUser = admin;
        } 
        this.showModalUser = true;
      },
      selectOption(mode) {
        this.modalMode = mode;
        this.showModalUser = true;
        this.dropdownOpen = false;
      },
      deleteUser(id) {
        const token = localStorage.getItem("token");
        fetch(`${apiUrl}/api/admin/${id}`, {
          method: "DELETE",
          headers: {
            "Accept": "application/json",
            "Authorization": token ? `Bearer ${token}` : ""
          }
        })
          .then(response => {
            if (!response.ok) {
              throw new Error(`Erreur ${response.status}`);
            }
            this.users = this.users.filter(user => user.id !== id);
            this.showSuccess = true;
            this.successMessage = "Administrateur supprimé avec succès.";
          })
          .catch(error => {
            console.error("Erreur de suppression de l'administrateur :", error.message);
          });
      },
      confirmDelete(id) {
        this.confirmMessage = "Voulez-vous vraiment supprimer cet administrateur ?";
        this.confirmCallback = () => {
          this.deleteUser(id);
        };
        this.showConfirmDialog = true;
      },
      handleConfirm() {
        if (this.confirmCallback) {
          this.confirmCallback();
        }
        this.showConfirmDialog = false;
      },
      handleCancel() {
        this.showConfirmDialog = false;
      },
      handlePageChange(page) {
        this.currentPage = page;
      },
      async fetchSecteurs() {
      try {
        const token = localStorage.getItem('token')
        const res = await axios.get(`${apiUrl}/api/secteurs`, {
          headers: { Authorization: `Bearer ${token}` }
        })
        this.secteursList = Array.isArray(res.data) ? res.data : []
      } catch (e) {
        console.error('Erreur de chargement des secteurs :', e)
      }
    },
      getStatusClass(status) {
        return {
          actif: "status-actif",
          inactif: "status-suspendu"
        }[status] || "status-suspendu";
        
      },
    },
    computed: {
      filtersList() {
      return [
        { label: 'Statut',  field: 'status',  options: ['actif', 'inactif'] },
        { label: 'Secteur', field: 'secteur', options: this.secteursList.map(s => s.nom) }
      ];
    },

   
    filteredAdmins() {
      const q = this.searchQuery.toLowerCase();
      return this.users.filter(u => {
        const matchSearch =
          !q ||
          (u.nom       && u.nom.toLowerCase().includes(q)) ||
          (u.prenom    && u.prenom.toLowerCase().includes(q)) ||
          (u.email     && u.email.toLowerCase().includes(q)) ||
          (u.telephone && u.telephone.toLowerCase().includes(q)) ||
          (u.fonction  && u.fonction.toLowerCase().includes(q));

        const matchStatus =
          !this.selectedStatus ||
          u.status === this.selectedStatus;

        const matchSecteur =
          !this.selectedSecteur ||
          (u.secteur && u.secteur.nom === this.selectedSecteur);

        return matchSearch && matchStatus && matchSecteur;
      });
    },
  paginatedAdmins() {
    const start = (this.currentPage - 1) * this.usersPerPage;
    return this.filteredAdmins.slice(start, start + this.usersPerPage);
  },
  totalPages() {
    return Math.ceil(this.filteredAdmins.length / this.usersPerPage);
  }
},
    mounted() {
      this.fetchAdmins(),
      this.fetchSecteurs()
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
  
  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
   color: #dc3545 !important;
  
  }
    .container h2 {
 color: #11265e;
  font-size: 1.7rem;
  font-weight: 600;
  margin-bottom: 1rem;
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
  
  @media screen and (max-width: 768px) {
    .dropdown-button,
    .pending-button {
      width: 100%;
      margin-left: 0;
    }
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
  
  th, td {
    padding: 15px;
    border-bottom: 1px solid #ddd;
    text-align: left;
  }
  
  td {
    font-size: 14px;
    color: #333;
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
  
  
  
 
  .status-actif {
   
    color: #28a745;
    padding: 4px 8px;
    border-radius: 5px;
    font-weight: bold;
  }
  
  .status-suspendu {
  
    color: #dc3545;
    padding: 4px 8px;
    border-radius: 5px;
    font-weight: bold;
  }
  
  .fas{
    margin-right: 8px; 
  }
  .table-responsive {
    overflow-x: auto;
  }
  @media screen and (max-width: 768px) {

    .container {
      padding: 10px;
      margin-left: 20px;
    }
  
  
    .add-group {
      flex-direction: column;
      align-items: stretch;
     
    }

    .dropdown-button,
    .pending-button {
      width: 70%;
      margin: 0 0 10px 0;
   
    }
  

    th, td {
      padding: 8px;
      font-size: 13px;
    }
  }
  

  
  .dropdown {
    position: relative;
    display: inline-block;
  }
  
  .dropdown-button {
    background-color: #242b8d;
   color: rgb(255, 255, 255);
  border: none;
  padding: 8px 14px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: background-color 0.3s ease;

  }
  .logo-img {
  width: auto;
  height: auto;
  max-height: 60px;
  object-fit: cover;
  border-radius: 5px;
  margin-left: 10px;
  vertical-align: middle;
}

  .dropdown-button:hover {
    background-color: #0056b3;

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
