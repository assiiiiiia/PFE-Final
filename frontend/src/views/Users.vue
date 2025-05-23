<template>
  <div class="container">
    <header>
      <h2>Liste des Utilisateurs</h2>
   
    </header>

    <div class="add-group">
        <div class="user-count">
      Total des utilisateurs  :<span>{{ users.length }}</span>
              </div>
      <div class="filter">
      <FilterBar
        :search="searchQuery"
        @filters-changed="onFiltersChanged"
      />

       <button class="pending-button" @click="showPendingModal = true">
        <i class="fas fa-hourglass-half"></i> Utilisateurs en attente
      </button> 
   </div>
     </div>
      
   
      <ModalPending 
        v-if="showPendingModal" 
        :users="pendingUsers" 
        @approve="approveUser" 
        @suspend="suspendUser"
        @close="showPendingModal = false"
      />
      <ModalDetail 
  v-if="showModalDetail" 
  :user="selectedUser" 
  @close="showModalDetail = false" 
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
         <th>Entreprise</th> 
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
            Chargement des utilisateurs...
          </td>
        </tr>

        
        <tr v-else-if="!loading && paginatedUsers.length === 0" class="empty-row">
          <td colspan="9">
            <i class="fas fa-exclamation-circle empty-icon"></i>
            Aucun utilisateur trouvé.
          </td>
        </tr>

        <tr v-else v-for="user in paginatedUsers" :key="user.id">
          <td>{{ user.id }}</td>
          <td>{{ user.entreprise ? user.entreprise.nom_entreprise : '-' }}</td>
          <td>{{ user.nom }}</td>
          <td>{{ user.prenom }}</td> 
          <td>{{ user.email}}</td>
          <td>{{ user.telephone  }}</td>
          <td>{{ user.fonction }}</td>
    
          <td :class="getStatusClass(user.status)">{{ user.status }}</td>
          <td>
            <ActionButtons
               :item="user"
               :show-edit="false"
               :show-delete="true"
               :show-details="false"
            @edit="openModal('edit', $event)"
            @delete="confirmDelete($event)"
            @details="openModal('details', $event)"
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

   <ConfirmDialog 
     v-if="showConfirmDialog" 
     :message="confirmMessage" 
     @confirm="handleConfirm" 
     @cancel="handleCancel" 
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
import ModalUser from "@/components/ModalUser.vue";
import ModalPending from "@/components/ModalPending.vue";
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
    ModalPending,
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
      selectedRole: "",
      selectedStatus: "",
      selectedUser: null,
      modalMode: "",
      showModalUser: false,
      dropdownOpen: false,
      showPendingOnly: false,
      currentPage: 1,
      usersPerPage: 10,
      loading: false,
      showPendingModal: false,
      showModalDetail: false,
      showConfirmDialog: false,
      confirmMessage: "",
      confirmCallback: null, 
      entrepriseToDelete: null,
      showSuccess: false,
      successMessage: "",
    };
  },
  methods: {
    getLogoUrl(logoPath) {
  if (!logoPath || logoPath === "null") {
    return `${apiUrl}/storage/logo/default.png`;
  }
  return `${apiUrl}/storage/logo/` + logoPath.split("/").pop();
},
    onFiltersChanged({ search }) {
      this.searchQuery = search;
      this.currentPage = 1; 
    },
    toggleDropdown() {
      this.dropdownOpen = !this.dropdownOpen;
    },
    async fetchUsers() {
      this.loading = true;
      try {
        const token = localStorage.getItem("token");
        const response = await fetch(`${apiUrl}/api/users`, {
          headers: {
            Accept: "application/json",
            Authorization: token ? `Bearer ${token}` : ""
          }
        });
        if (!response.ok) throw new Error(`Erreur ${response.status}`);
        const data = await response.json();
        this.users = Array.isArray(data) ? data : [];
      } catch (error) {
        console.error("Erreur de chargement des utilisateurs :", error.message);
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
    openModal(type, user = null) {
  if (type === "add") {
    this.modalMode = "add";
    this.selectedUser = null;
    this.showModalUser = true;
  } else if (type === "edit") {
    this.modalMode = "edit";
    this.selectedUser = user;
    this.showModalUser = true;
  } else if (type === "addAdmin") {
    this.modalMode = "addAdmin";
    this.selectedUser = { role: "admin" };
    this.showModalUser = true;
  } else if (type === "details") {
    this.selectedUser = user;
    this.showModalDetail = true;
  }
}
,
    selectOption(mode) {
      this.modalMode = mode;
      this.showModalUser = true;
      this.dropdownOpen = false;
    },
    closeModal() {
      this.showModalUser = false;
    },
    deleteUser(id) {
  const token = localStorage.getItem("token");
  fetch(`${apiUrl}/api/users/${id}`, {
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
      console.log("User with id", id, "deleted from backend.");
    })
    .catch(error => {
      console.error("Erreur de suppression de l'utilisateur :", error.message);
    });
},
confirmDelete(id) {
  this.confirmMessage = "Voulez-vous vraiment supprimer cet utilisateur ?";
  this.confirmCallback = () => {
    this.deleteUser(id);
  };
  this.showConfirmDialog = true;
}
,
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
    getRoleClass(role) {
      return {
        admin: "role-admin",
        entreprise: "role-entreprise",
        user: "role-user"
      }[role] || "role-user";
    },
    getStatusClass(status) {
      return {
        actif: "status-actif",
        "en attente": "status-en-attente",
        suspendu: "status-suspendu"
      }[status] || "status-suspendu";
    }
  },

  computed: {
    filteredUsers() {
      const q = this.searchQuery.toLowerCase();
      return this.users.filter(u => 
        !q || (u.nom && u.nom.toLowerCase().includes(q)) ||
        (u.prenom && u.prenom.toLowerCase().includes(q)) ||
        (u.email && u.email.toLowerCase().includes(q)) ||
        (u.telephone && u.telephone.toLowerCase().includes(q)) ||
        (u.fonction && u.fonction.toLowerCase().includes(q)) ||
        (u.entreprise && u.entreprise.nom_entreprise && u.entreprise.nom_entreprise.toLowerCase().includes(q))
      );
    },
    paginatedUsers() {
      const start = (this.currentPage - 1) * this.usersPerPage;
      return this.filteredUsers.slice(start, start + this.usersPerPage);
    },
    totalPages() {
      return Math.ceil(this.filteredUsers.length / this.usersPerPage);
    },
  },
  mounted() {
    this.fetchUsers();
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
header {
  display: flex;
  padding: 10px;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
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


.pending-button {
  background-color: #e60505;
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
.pending-button:hover {
  background-color: #8d1306;
}


.pending-button i {
  font-size: 14px;
}

@media screen and (max-width: 768px) {
  .dropdown-button,
  .pending-button {
    width: 100%;
   
  }
  .container{
    margin-left: 20px;
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
.logo {
  width: 50px;
  height: 50px;
  object-fit: contain;
  border-radius: 5px;
  border: 1px solid #ddd;
  padding: 2px;
  background-color: white;
}


.status-actif {
 
  color: #28a745;
  padding: 4px 8px;
  border-radius: 5px;
  font-weight: bold;
}

.status-en-attente {

  color: #ffc107;
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
  background-color: #007bff;
  color: #fff;
  border: none;
  padding: 10px 15px;
  border-radius: 5px;
  cursor: pointer;
  font-weight: bold;
  transition: background-color 0.3s ease;
  margin-bottom: 10px;
  margin-left: 10px;
  display: flex;
  align-items: center;
}

.dropdown-button:hover {
  background-color: #0056b3;
}

.dropdown-menu {
  position: absolute;
  top: calc(100% + 5px);
  left: 0;
  background-color: #fff;
  min-width: 250px;
  border: 1px solid #ddd;
  border-radius: 5px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  z-index: 1000;
  opacity: 0;
  visibility: hidden;
  transform: translateY(-10px);
  transition: opacity 0.3s ease, transform 0.3s ease, visibility 0.3s;
}

.dropdown-menu.show {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
}

.dropdown-item {
  display: block;
  padding: 10px 15px;
  font-size: 14px;
  text-decoration: none;
  color: #333;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.dropdown-item:hover {
  background-color: #f8f9fa;
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
