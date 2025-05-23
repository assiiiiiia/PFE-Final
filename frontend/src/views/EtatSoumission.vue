<template>
  <div class="user-soumissions">
    <h2>{{ $t('soumissions.title') }}</h2>
    
    <div v-if="errorMessage" class="alert alert-danger">
      {{ errorMessage }}
    </div>
    
    <div v-if="loading" class="loading">
      Chargement...
    </div>
    
    <table v-if="paginatedSoumissions.length" class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Entreprise</th>
          <th>Offre</th>
          <th>Statut</th>
          <th>Commentaire</th>
          <th>Date de soumission</th>
          <th>Documents</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="s in paginatedSoumissions" :key="s.id">
          <td>{{ s.id }}</td>
          <td class="entreprise-cell">
            <img 
              :src="getLogoUrl(s.offre.secteur?.logo)" 
              alt="Logo de l'entreprise" 
              class="logo"
              @error="handleImageError"
            />
          </td>
          <td>{{ s.offre.titre_offre }}</td>
          <td :data-status="s.statut">{{ s.statut }}</td>
          <td>{{ s.commentaire_admin || "Aucun commentaire" }}</td>
          <td>{{ formatDate(s.date_soumission) }}</td>
     
          <td>
  <div v-if="s.documents.length > 0" class="documents-container">
    <button 
      @click="toggleDocuments(s.id)" 
      class="doc-toggle-btn"
      :class="{ active: documentVisibility[s.id] }"
    >
      Documents
      <i class="fas fa-chevron-down"></i>
    </button>
    <teleport to="body">
      <transition name="slide">
        <div v-if="documentVisibility[s.id]" class="documents-modal-overlay" @click.self="toggleDocuments(s.id)">
          <div class="documents-modal">
            <ul>
              <li v-for="doc in s.documents" :key="doc.id">
                <a :href="doc.chemin_fichier" target="_blank">
                  <i class="fas fa-file-pdf"></i>
                  {{ doc.nom_fichier }}
                </a>
              </li>
            </ul>
            <button class="close-modal-btn" @click="toggleDocuments(s.id)">Fermer</button>
          </div>
        </div>
      </transition>
    </teleport>
  </div>
</td>
        </tr>
      </tbody>
    </table>

   

    <div v-else-if="!loading" class="alert alert-info">
      Aucune soumission trouvée.
    </div>
     <Pagination 
  :totalPages="totalPages" 
  :currentPage="currentPage" 
  @page-changed="changePage" 
/>
  </div>
</template>

<script>
import axios from 'axios';
import moment from 'moment';
import Pagination from '@/components/Pagination.vue';
const apiUrl = import.meta.env.VITE_API_URL;

export default {
  name: 'UserSoumissionsComponent',
  components: {
    Pagination,
  },
  data() {
    return {
      soumissions: [],
      loading: false,
      errorMessage: '',
      currentPage: 1,
      itemsPerPage: 15,
      documentVisibility: {},
    };
  },
  computed: {
    paginatedSoumissions() {
      const start = (this.currentPage - 1) * this.itemsPerPage;
      return this.soumissions.slice(start, start + this.itemsPerPage);
    },
    totalPages() {
      return Math.ceil(this.soumissions.length / this.itemsPerPage);
    }
  },
  methods: {
    toggleDocuments(id) {
      this.documentVisibility[id] = !this.documentVisibility[id];

  },
  
    changePage(page) {
      if (page >= 1 && page <= this.totalPages) {
        this.currentPage = page;
      }
    },
    fetchSoumissions() {
      this.loading = true;
      axios.get(`${apiUrl}/api/user/soumissions`)
        .then(response => {
          this.soumissions = response.data;
          this.loading = false;
        })
        .catch(error => {
          this.errorMessage = error.response ? error.response.data.message : error.message;
          this.loading = false;
        });
    },
    // Formate la date pour l'affichage
    formatDate(date) {
      return moment(date).format('DD/MM/YYYY HH:mm');
    },
    getLogoUrl(logoPath) {
  if (!logoPath || logoPath === "null") {
    return `${apiUrl}/storage/logo/default.png`;
  }
  return `${apiUrl}/storage/logo/` + logoPath.split("/").pop();
},
    handleImageError(event) {
      event.target.src = `${apiUrl}/storage/logo/default.png`;
    }
  },
  mounted() {
 
    const token = localStorage.getItem('token');
    if (token) {
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
    }
    this.fetchSoumissions();
  }
};
</script>

<style scoped>
.user-soumissions {
  max-width: 1400px;
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

.alert {
  padding: 1rem 1.5rem;
  border-radius: 8px;
  margin-bottom: 1.5rem;
  display: flex;
  align-items: center;
  position: relative;
  font-size: 0.95rem;
}

.alert-danger {
  background: #ffebee;
  color: #b71c1c;
  border: 1px solid #ffcdd2;
}

.alert-danger:before {
  content: "⚠️";
  margin-right: 0.75rem;
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
  padding: 2rem;
  text-align: center;
  color: #64748b;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading:after {
  content: "";
  width: 18px;
  height: 18px;
  border: 2px solid #e2e8f0;
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

.table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  border-radius: 8px;
    border-collapse: separate;
  border-spacing: 0; 
 
  overflow: visible;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  position: relative;
  z-index: 0;
}

.table th,
.table td {
  padding: 1rem;
  text-align: left;
  border-bottom: 1px solid #f1f5f9;
  position: relative;
  z-index: 1;
  background: white;
    overflow: visible;

}

.table tr {
  position: relative;
  z-index: 1;
  
}

.table tr:hover {
  background-color: #f8fafc;
  z-index: 2;
}

.table th {
  background-color: #f8fafc;
  color: #64748b;
  font-weight: 600;
  text-transform: uppercase;
  font-size: 0.85rem;
  letter-spacing: 0.5px;
}

.table td:nth-child(3) {
max-width: 200px;
  font-size: 0.9rem;
}

.table td:nth-child(6) {
  font-family: 'JetBrains Mono', monospace;
  color: #64748b;
  font-size: 0.9rem;
}
.table td:nth-child(4):after {
  content: "";
  display: inline-block;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  margin-left: 0.5rem;
  background: #94a3b8;
}

.table td:nth-child(4)[data-status="En attente"]:after {
  background: #f59e0b; 
}

.table td:nth-child(4)[data-status="Acceptée"]:after {
  background: #22c55e;  
}

.table td:nth-child(4)[data-status="Rejetée"]:after {
  background: #ef4444; 
}


.logo {
  width: 50px;
  height: auto;
  object-fit: contain;
  border-radius: 4px;
  border: 1px solid #f1f5f9;
}


.documents-container {
  position: relative; 
  z-index: 1; 
}

.doc-toggle-btn {
  position: relative;

}


.doc-toggle-btn {
  padding: 10px 10px;
  background: linear-gradient(145deg, #1a237e, #0d47a1);
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: inline-flex;
  align-items: center;
  gap: 12px;
  color: white;
  box-shadow: 0 4px 6px rgba(13, 71, 161, 0.2);
  position: relative;
 
}

.doc-toggle-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.1);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.doc-toggle-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(13, 71, 161, 0.25);
}

.doc-toggle-btn:hover::before {
  opacity: 1;
}

.doc-toggle-btn.active {
  background: linear-gradient(145deg, #0d47a1, #1a237e);
}

.doc-toggle-btn i {
  font-size: 14px;
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.doc-toggle-btn.active i {
  transform: rotate(180deg) scale(1.1);
}

.documents-list {
  position: absolute;
  top: 100%;
  left: 0;
  right: auto;
  margin-top: 8px;
  background: white;
  border: 1px solid #e0e0e0;
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(26, 35, 126, 0.25);
  padding: 16px;
  min-width: 280px;
  z-index: 9999;
  max-height: 400px;
  animation: scaleIn 0.25s ease-out;
  overflow-y: auto;
  pointer-events: auto;
}

@keyframes scaleIn {
  from {
    transform: scale(0.95) translateY(-10px);
    opacity: 0;
  }
  to {
    transform: scale(1) translateY(0);
    opacity: 1;
  }
}

.documents-list ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.documents-list li {
  padding: 12px;
  border-radius: 6px;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  gap: 12px;
}

.documents-list li:hover {
  background: #f8f9ff;
  transform: translateX(4px);
}

.documents-list a {
  color: #1a237e;
  text-decoration: none;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
}

.fa-file-pdf {
  color: #e53935;
  transition: transform 0.2s ease;
}

.documents-list a:hover .fa-file-pdf {
  animation: bounce 0.5s ease;
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-4px); }
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

.table {
  border-radius: 12px;
  overflow: hidden;
  background: white;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

th {
  background: #1a237e;
  color: white;
  font-weight: 600;
  letter-spacing: 0.5px;
  padding: 16px;
}

tr:hover {
  background: #f8f9ff;
}

.slide-enter-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.slide-leave-active {
  transition: all 0.2s cubic-bezier(0.4, 0, 1, 1);
}

/* Add modal styles at the end of your <style scoped> */
.documents-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(30, 41, 59, 0.35);
  z-index: 99999;
  display: flex;
  align-items: center;
  justify-content: center;
}

.documents-modal {
  background: white;
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(26, 35, 126, 0.25);
  padding: 32px 24px 24px 24px;
  min-width: 320px;
  max-width: 90vw;
  max-height: 80vh;
  overflow-y: auto;
  position: relative;
  animation: scaleIn 0.25s ease-out;
}

.documents-modal ul {
  list-style: none;
  padding: 0;
  margin: 0;
  display: block;
}

.documents-modal li {
  padding: 14px 0;
  border-bottom: 1px solid #f1f5f9;
  display: flex;
  align-items: center;
  gap: 14px;
  font-size: 1.05rem;
  transition: background 0.2s;
  justify-content: flex-start;
  width: 100%;
}

.documents-modal a {
  color: #1a237e;
  text-decoration: none;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 10px;
  transition: color 0.2s;
  margin-left: 30px;
  justify-content: flex-start;
}

.documents-modal a:hover {
  color: #1563b2;
  text-decoration: underline;
}

.documents-modal .fa-file-pdf {
  color: #e53935;
  font-size: 1.3rem;
  margin-right: 6px;
}

.documents-modal li:hover {
  background: #f8f9ff;
  border-radius: 4px;
}

.close-modal-btn {
  margin-top: 24px;
  background: #1a237e;
  color: white;
  border: none;
  border-radius: 8px;
  padding: 10px 24px;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s;
  display: block;
  margin-left: auto;
  margin-right: auto;
}
</style>
