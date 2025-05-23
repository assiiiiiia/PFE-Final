<template>
  <div class="soumissions">
    <h2>Liste des soumissions</h2>
    
    <div v-if="errorMessage" class="alert alert-danger">
      {{ errorMessage }}
    </div>
    
    <div v-if="loading">Chargement...</div>
    
 
    <table v-if="paginatedSoumissions.length" class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Utilisateur</th>
          <th>Entreprise</th>
          <th>Offre</th>
          <th>Statut</th>
          <th>Date de soumission</th>
          <th>Document Offre</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="soumission in paginatedSoumissions" :key="soumission.id" :class="{'bg-rejected': soumission.statut === 'Rejetée', 'bg-accepted': soumission.statut === 'Acceptée'}">
          <td>{{ soumission.id }}</td>
          <td>{{ soumission.user.nom }} {{ soumission.user.prenom }}</td>
          <td>{{ soumission.user.entreprise.nom_entreprise }}</td>
          <td>{{ soumission.offre.titre_offre }}</td>
          <td>{{ soumission.statut }}</td>
          <td>{{ formatDate(soumission.date_soumission) }}</td>
          <td>
            <a :href="soumission.offre.documents.document_pdf" target="_blank" class="btn btn-document">
              <i class="fas fa-file-pdf document-icon"></i>   PDF
            </a>
          </td>
          <td>
            <button type="button" @click="selectSoumission(soumission)" class="btn btn-primary">
              Gérer
            </button>
          </td>
        </tr>
      </tbody>
    </table>
    <div v-else class="no-soumissions">
      <p>Aucune soumission n'a été trouvée.</p>
    </div>
    <pagination 
      :totalPages="totalPages" 
      :currentPage="currentPage" 
      @page-changed="changePage" 
    />
    <div v-if="selectedSoumission" class="modal-overlay">
      <div class="modal-content">
        <div class="modal-header">
          <h3>Gérer la soumission #{{ selectedSoumission.id }}</h3>
        </div>

        <div class="modal-body">
          <div class="details">
            <p><strong>Utilisateur :</strong> {{ selectedSoumission.user?.nom }} {{ selectedSoumission.user?.prenom }}</p>
            <p><strong>Entreprise :</strong> {{ selectedSoumission.user?.entreprise?.nom_entreprise }}</p>
            <p><strong>Offre :</strong> {{ selectedSoumission.offre.titre_offre }}</p>
            <p v-if="selectedSoumission.proposition"><strong>Détails :</strong> {{ selectedSoumission.proposition }}</p>

            <button @click="toggleDocuments" class="btn btn-secondary">
              <i :class="showDocuments ? 'fas fa-folder-minus' : 'fas fa-folder-open'"></i>
              {{ showDocuments ? 'Cacher les documents' : 'Afficher les documents' }}
            </button>

            <div v-if="showDocuments" class="documents-section">
              <p><strong>Documents :</strong></p>
              <ul>
                <li v-for="doc in selectedSoumission.documents" :key="doc.id">
                  <a :href="doc.chemin_fichier" target="_blank">
                    <i class="fas fa-file-pdf"></i> {{ doc.nom_fichier }}
                  </a>
                </li>
              </ul>
            </div>
          </div>

          <div class="update-form">
            <div v-if="selectedLots && selectedLots.length" class="lots-section">
              <h4>Lots associés :</h4>
              <div class="lots-grid">
                <div class="lot-card" v-for="lot in selectedLots" :key="lot.id">
                  <div class="lot-header">
                    <input type="checkbox" :value="lot.id" v-model="form.selectedLots" />
                    <strong>Lot #{{ lot.numero_lot }}</strong>
                  </div>
                  <div class="lot-body">
                    <p><strong>Description :</strong> {{ lot.description }}</p>
                  </div>
                </div>
              </div>
              <button @click="toggleSelectAllLots" class="btn btn-lot">
                {{ areAllLotsSelected ? 'Désélectionner tous les lots' : 'Sélectionner tous les lots' }}
              </button>
            </div>

            <div class="status-container">
              <strong>Statut :</strong>
              <div class="radio-group">
                <label class="radio-option">
                  <input type="radio" value="Acceptée" v-model="form.statut" />
                  <i class="fas fa-check-circle success-icon"></i> Acceptée
                </label>
                <label class="radio-option">
                  <input type="radio" value="Rejetée" v-model="form.statut" />
                  <i class="fas fa-times-circle danger-icon"></i> Rejetée
                </label>
              </div>
            </div>

            <div class="comment-container">
              <label for="commentaire_admin"><strong>Commentaire (optionnel) :</strong></label>
              <textarea
                v-model="form.commentaire_admin"
                id="commentaire_admin"
                class="form-control"
                rows="3"
                placeholder="Ajouter un commentaire..."
              ></textarea>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button @click="updateSoumission" class="btn btn-success">
            <i class="fas fa-check"></i> Valider
          </button>
          <button @click="cancelSelection" class="btn btn-secondary">
            <i class="fas fa-times"></i> Annuler
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import moment from 'moment';
const apiUrl = import.meta.env.VITE_API_URL;
import { emitter } from '@/eventBus';
import Pagination from '@/components/pagination.vue';

export default {
  name: 'SoumissionsComponent',
  components: {
    Pagination,
  },
  data() {
    return {
      soumissions: [],
      selectedSoumission: null,
      form: {
        statut: 'Acceptée',
        commentaire_admin: '',
        selectedLots: []
      },
      loading: false,
      errorMessage: '',
      showDocuments: false,
      areAllLotsSelected: false,
      currentPage: 1,
      itemsPerPage: 10
    };
  },
  computed: {
    paginatedSoumissions() {
      const start = (this.currentPage - 1) * this.itemsPerPage;
      const end = start + this.itemsPerPage;
      return this.soumissions.slice(start, end);
    },
    totalPages() {
      return Math.ceil(this.soumissions.length / this.itemsPerPage);
    },
  },
  methods: {
    getStatutClass(statut) {
      if (statut === 'Attribué') return 'statut-attribue';
      if (statut === 'En cours') return 'statut-encours';
      if (statut === 'Annulé') return 'statut-annule';
      return 'statut-default';
    },
    fetchSoumissions() {
      const token = localStorage.getItem('token');
      axios.get(`${apiUrl}/api/soumissions`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then(response => {
        this.soumissions = response.data;
        this.loading = false;
      })
      .catch(error => {
        this.errorMessage = error.response ? error.response.data.message : error.message;
        this.loading = false;
      });
    },
    selectSoumission(soumission) {
      const token = localStorage.getItem('token');
      axios.get(`${apiUrl}/api/soumissions/${soumission.id}`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then(response => {
        this.selectedSoumission = response.data.soumission;
        this.selectedLots = response.data.lots; 
        this.form = {
          statut: 'Acceptée',
          commentaire_admin: '',
          selectedLots: []
        };
        this.showDocuments = false;
        this.areAllLotsSelected = false;
      })
      .catch(error => {
        this.errorMessage = error.response ? error.response.data.message : error.message;
      });
    },
    updateSoumission() {
      if (!this.selectedSoumission) return;
      const token = localStorage.getItem('token');
      const payload = {
        statut: this.form.statut,
        commentaire_admin: this.form.commentaire_admin,
        lots: this.form.selectedLots 
      };
      axios.put(`${apiUrl}/api/soumissions/${this.selectedSoumission.id}`, payload, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then(response => {
        alert(response.data.message);
        emitter.emit('submissionStatusAdded');
        this.fetchSoumissions();
        this.selectedSoumission = null;
      })
      .catch(error => {
        this.errorMessage = error.response ? error.response.data.message : error.message;
      });
    },
    cancelSelection() {
      this.selectedSoumission = null;
    },
    formatDate(date) {
      return moment(date).format('DD/MM/YYYY HH:mm');
    },
    toggleDocuments() {
      this.showDocuments = !this.showDocuments;
    },
    selectAllLots() {
      if (this.selectedLots && this.selectedLots.length) {
        this.form.selectedLots = this.selectedLots.map(lot => lot.id);
      }
    },
    unselectAllLots() {
      this.form.selectedLots = [];
    },
    toggleSelectAllLots() {
      if (this.areAllLotsSelected) {
        this.unselectAllLots();
      } else {
        this.selectAllLots();
      }
      this.areAllLotsSelected = !this.areAllLotsSelected;
    },
    changePage(page) {
      if (page >= 1 && page <= this.totalPages) {
        this.currentPage = page;
      }
    },
    fetchLotsByOfferId(offerId) {
      const token = localStorage.getItem('token');
      axios.get(`${apiUrl}/api/offres/${offerId}/lots`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then(response => {
        this.selectedSoumission.lots = response.data;
      })
      .catch(error => {
        console.error('Error fetching lots:', error);
      });
    }
  },
  mounted() {
    axios.interceptors.request.use(
      config => {
        const token = localStorage.getItem('token');
        if (token) {
          config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
      },
      error => Promise.reject(error)
    );
    this.fetchSoumissions();
  }
};
</script>

<style scoped>

.soumissions {
  margin-top: 80px;
    max-width: 1600px;
    padding: 0 1rem;
    font-family: 'Inter', system-ui, sans-serif;
}

h2, h3 {
    color: #223e6c;
    margin-bottom: 1.6rem;
    font-weight: 600;
}

.alert {
    padding: 1rem;
    border-radius: 8px;
    margin-bottom: 1.5rem;
    font-size: 0.9rem;
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.alert-danger {
    background: #fff0f0;
    border: 2px solid #ffcccc;
    color: #dc2626;
}

.table {
    width: 100%;
    border-collapse: collapse;
    background: white;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.155);
    position: relative;
}

.table thead {
    background: rgb(255, 255, 255);
}

.table th {
    padding: 0.9rem;
    text-align: center;
    font-weight: 600;
    font-size: 0.85rem;
    color: rgb(71, 71, 71);
    letter-spacing: 0.5px;
}

.table td {
    padding: 1rem;
    color: #475569;
    border-bottom: 1px solid #f1f5f9;
    font-size: 0.95rem;
}

.table tbody tr {
    transition: all 0.2s ease;
}

.table tbody tr:not(:last-child) td {
    border-bottom: 1px solid #e2e8f0;
}

.table tbody tr:nth-child(even) {
    background-color: #f8fafc;
}

.table tbody tr:hover {
    background-color: #f1f5f9;
    transform: translateX(4px);
}

.btn {
    padding: 0.65rem 1.25rem;
    border-radius: 8px;
    font-weight: 500;
    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
    border: none;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.9rem;
}

.btn-primary {
    background: #152a64;
    color: white;
}

.btn-primary:hover {
    background: #2b4d97;
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}

.btn-info {
    background: #06b6d4;
    color: white;
}

.btn-info:hover {
    background: #0891b2;
    box-shadow: 0 4px 12px rgba(6, 182, 212, 0.2);
}

.btn-document {
  display: flex;

  gap: 0.1rem;
  font-weight: 200;
  color: #1f2987;
  border-radius: 6px;
  transition: all 0.3s ease;
  text-decoration: none;
}

.btn-document:hover {

  color: #30c8f2;
  border-color: #60a5fa;
}

.btn-document .document-icon {
  color: #1f2987;
  font-size: 1rem;
  transition: color 0.3s ease;
}

.btn-document:hover .document-icon {
  color: #30c8f2;
}

.gestion-soumission {
    background: white;
    border-radius: 16px;
    padding: 2rem;
    margin-top: 2rem;
    box-shadow: 0 4px 24px rgba(0, 0, 0, 0.05);
    border: 1px solid #e2e8f0;
}

.details {
    background: #f8fafcb8;
    padding: 1.5rem;
    border-radius: 12px;
    margin-bottom: 2rem;
    border: 1px dashed #cbd5e1;
}

.details p {
    margin: 0.8rem 0;
    color: #475569;
    display: flex;
    gap: 0.5rem;
}

.details strong {
    color: #1e293b;
    min-width: 120px;
    font-weight: 500;
}

.update-form {
    display: grid;
    gap: 1.5rem;
}

.form-control {
    padding: 0.8rem 1rem;
    border: 2px solid #e2e8f0;
    border-radius: 8px;
    transition: all 0.2s ease;
    width: 100%;
    max-width: 400px;
    font-size: 0.95rem;
}

.form-control:focus {
    border-color: #3B82F6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
}

textarea.form-control {
    min-height: 100px;
    resize: vertical;
}

.actions {
    display: flex;
    gap: 1rem;
    margin-top: 1rem;
    flex-wrap: wrap;
}

.btn-success {
    background: #10b981;
    color: white;
}

.btn-success:hover {
    background: #059669;
    box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
}

.btn-secondary {
    background: #e2e8f0;
    color: #475569;
}
.btn-lot {
    background: #e2e8f0;
    color: #475569;
    margin-top: 40px;
}
.btn-lot:hover {
    background: #cbd5e1;
    color: #1e293b;
}
.btn-secondary:hover {
    background: #cbd5e1;
    color: #1e293b;
}

ul {
    list-style: none;
    padding: 0;
    margin: 1rem 0 0 0;
    display: grid;
    gap: 0.5rem;
}

ul li a {
    color: #3B82F6;
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 1rem;
    border-radius: 6px;
    transition: all 0.2s ease;
}

ul li a:hover {
    background: #eff6ff;
    color: #2563eb;
    text-decoration: underline;
}



.loading {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1rem;
    padding: 2rem;
    color: #64748b;
    font-weight: 500;
}

.no-soumissions {
    background: #f8fafc;
    padding: 2rem;
    text-align: center;
    border-radius: 16px;
    color: #64748b;
    margin-top: 2rem;
    border: 2px dashed #e2e8f0;
}

@media (max-width: 768px) {
    .soumissions {
        margin: 1rem;
        padding: 0;
    }
    
    .table {
        display: block;
        overflow-x: auto;
        border-radius: 12px;
    }
    
    .table th,
    .table td {
        min-width: 120px;
    }
    
    .gestion-soumission {
        padding: 1.5rem;
    }
}

/* Modal Overlay */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

/* Modal Content */
.modal-content {
  background: #fff;
  border-radius: 1rem;
  padding: 1.5rem;
  max-width: 600px;
  width: 95%;
  max-height: 85vh;
  display: flex;
  flex-direction: column;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
  overflow: hidden;
}

/* Header */
.modal-header {
  position: sticky;
  top: 0;
  background: white;
  z-index: 10;
  padding-bottom: 1rem;
  margin-bottom: 1rem;
  border-bottom: 1px solid #e5e7eb;
}

/* Body */
.modal-body {
  overflow-y: auto;
  flex-grow: 1;
  padding-right: 0.5rem;
}

/* Footer */
.modal-footer {
  margin-top: 1.5rem;
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
}

/* Buttons */
.btn {
  padding: 0.6rem 1.2rem;
  border-radius: 8px;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  border: none;
  transition: all 0.2s ease-in-out;
}

.btn-success {
  background-color: #10b981;
  color: white;
}

.btn-success:hover {
  background-color: #059669;
  box-shadow: 0 0 10px rgba(16, 185, 129, 0.3);
}

.btn-secondary {
  background-color: #e5e7eb;
  color: #374151;
}

.btn-secondary:hover {
  background-color: #cbd5e1;
}

/* Custom Scrollbar */
.modal-body::-webkit-scrollbar {
  width: 6px;
}

.modal-body::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 6px;
}

/* Styled radio buttons */
.radio-group {
  display: flex;
  gap: 1rem;
  margin: 1rem 0;
}

.status-container {
  display: flex;
  align-items: center;
  gap: 1rem;
  justify-content: center;
  margin: 1.5rem 0;
  color: #64748b;
}

.radio-option {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.8rem 1.2rem;
  border: 2px solid #e5e7eb;
  border-radius: 0.8rem;
  transition: all 0.2s ease;
  cursor: pointer;
}

/* Hover states */
.radio-option:has(input[value="Acceptée"]:hover) {
  border-color: #10b981;
  background-color: #f0fdf4;
}

.radio-option:has(input[value="Rejetée"]:hover) {
  border-color: #ef4444;
  background-color: #fef2f2;
}

/* Checked states */
.radio-option:has(input[value="Acceptée"]:checked) {
  border-color: #10b981;
  background-color: #f0fdf4;
}

.radio-option:has(input[value="Rejetée"]:checked) {
  border-color: #ef4444;
  background-color: #fef2f2;
}

/* Icônes quand sélectionné */
.radio-option input[value="Acceptée"]:checked ~ .success-icon {
  color: #059669;
}

.radio-option input[value="Rejetée"]:checked ~ .danger-icon {
  color: #dc2626;
}

/* Couleur des radio boutons */
.radio-option input[type="radio"] {
  accent-color: #10b981;
}

.radio-option input[value="Rejetée"] {
  accent-color: #ef4444;
}
.comment-container {
  text-align: center;
  margin: 1.5rem 0;
  position: relative;
}

.comment-container textarea {
  max-width: 80%;
  margin: 0.5rem auto;
  padding: 0.8rem;
  border: 2px solid #e5e7eb;
  border-radius: 0.8rem;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-family: inherit;
  outline: none;
}

/* Style au focus/actif */
.comment-container textarea:focus,
.comment-container textarea:active {
  border-color: #251682;
  box-shadow: 0 0 0 3px rgba(27, 16, 185, 0.15);
}

/* Style du placeholder */
.comment-container textarea::placeholder {
  color: #94a3b8;
  opacity: 1;
  transition: opacity 0.2s ease;
}

.comment-container textarea:focus::placeholder {
  opacity: 0.6;
}

/* Optionnel : Animation du label si présent */
.comment-container label {
  display: block;
  margin-bottom: 0.5rem;
  color: #64748b;
  transition: color 0.3s ease;
}

.comment-container:focus-within label {
  color: #1d2374;
  font-weight: 500;
}
.lots-section {
  margin-bottom: 1.1rem;
  padding: 1rem;


}

.lots-section h4 {
  color: #2d3748;
  font-size: 1.25rem;
  margin-bottom: 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 2px solid #e2e8f0;
}

.lots-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.lot-card {
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  padding: 1rem;
  background-color: white;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  cursor: pointer;
}

.lot-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.lot-header {
  font-size: 1.rem;
  margin-bottom: 0.75rem;
  color: #1a365d;
  font-weight: 600;
}

.lot-header strong {
  color: #2d3748;
}

.lot-body p {
  margin: 0.5rem 0;
  font-size: 0.95rem;
  color: #4a5568;
  line-height: 1.4;
}

.lot-body strong {
  color: #4a5568;
  font-weight: 500;
}

/* Status badge styling */
[class^="statut-"] {
  display: inline-block;
  padding: 0.25rem 0.5rem;
  border-radius: 20px;
  font-size: 0.85rem;
  font-weight: 500;

}

.statut-attribue {
  background-color: #dcfce7;
  color: #166534;
}

.statut-encours{
  background-color: #dbeafe;
  color: #1e40af;
}

.statut-default {
  background-color: #f1f5f9;
  color: #64748b;
}



.success-icon {
  color: #10b981;
}

.danger-icon {
  color: #ef4444;
}

.documents-section ul {
  list-style: none;
  padding: 0;
}

.documents-section li {
  margin: 0.5rem 0;
}

.fa-file-pdf {
  color: #ef4444;
  margin-right: 0.5rem;
}

.modal-body {
  text-align: center;
}

.btn i {
  margin-right: 0.5rem;
}

tr.bg-rejected {
  background-color: #ffe5e5 !important;
}

tr.bg-accepted {
  background-color: #e5ffe8 !important;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
  margin-top: 1.5rem;
}
</style>

