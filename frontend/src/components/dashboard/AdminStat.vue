<template>
    <div class="stats-card">
      <div class="stats-card-header">
        <i class="fas fa-chart-line"></i>
        <h3>Statistiques administrateur  </h3>
      </div>
      <div v-if="loading" class="loading">
        <div class="spinner"></div>
        <span>Loading statistics...</span>
      </div>
      <div v-else class="stats-table-container">
        <table class="stats-table">
          <tbody>
            <tr v-for="(admin, index) in stats" :key="admin.admin_id" class="data-row">
              <td>{{ admin.nom }}</td>
              <td>{{ admin.prenom }}</td>
              <td>{{ admin.telephone }}</td>
              <td class="email-cell">{{ admin.email }}</td>
              <td class="count-badge">{{ admin.total_offres }}</td>
              <td class="toggle-cell">
              
                <i 
                  @click="toggleTypes(index)" 
                  :class="admin.showTypes ? 'fas fa-eye-slash toggle-icon' : 'fas fa-eye toggle-icon'">
                </i>
            
                <span v-if="admin.showTypes" class="types-inline">
                  <span v-for="(count, type) in admin.types" :key="type" class="type-inline">
                    <i class="fas fa-circle type-bullet"></i>
                    <span class="type-name">{{ type }}</span>
                    <span class="type-count">{{ count }}</span>
                  </span>
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </template>
  
  <style scoped>
 
  .stats-card {
    background: #ffffff;
    border-radius: 12px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
    margin: 2rem auto;
    width: 100%;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
 
  }
  

  .stats-card-header {
  background: linear-gradient(90deg, #0c1d4d, #152a6c, #1e3a8a);
  color: #ffffff;
  padding: 1.5rem;
  display: flex;
  align-items: center;
  gap: 1rem;
  border-top-left-radius: 12px;
  border-top-right-radius: 12px;
}

  .stats-card-header h3 {
    margin: 0;
    font-size: 1.5rem;
    font-weight: bold;
  }
  .stats-card-header i {
    font-size: 1.5rem;
  }
  
  
  .stats-table-container {
    overflow-x: auto;
    padding: 1rem;
      max-height: 400px; 
    overflow-y: auto;
  }
  
 
  .stats-table {
    width: 100%;
    border-collapse: collapse;
  }
  .data-row {
    border-bottom: 1px solid #e0e0e0;
    transition: background 0.2s ease-in-out;
  }
  .data-row:hover {
    background: #f5f5f5;
  }
  .data-row td {
    padding: 1rem;
    font-size: 0.95rem;
    color: #333333;
    vertical-align: middle;
  }
  

  .email-cell {
    max-width: 200px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  

  .count-badge {
 
    color: rgb(52, 89, 181) !important;
    font-weight: bold;
    padding: 0.3rem 0.6rem;

    font-size: 0.85rem;
  }
  

  .toggle-cell {
    text-align: right;
    position: relative;
  }
  

  .toggle-icon {
    font-size: 1.2rem;
    cursor: pointer;
    color: #007acc;
    transition: color 0.3s ease;
  }
  .toggle-icon:hover {
    color: #005f99;
  }
  

  .types-inline {
    display: inline-flex;
    gap: 1rem;
    margin-left: 1rem;
    align-items: center;
  }
  .type-inline {
    display: flex;
    align-items: center;
    gap: 0.3rem;
  }
  .type-bullet {
    font-size: 0.5rem;
    color: #007acc;
  }
  .type-name {
    font-size: 0.85rem;
    color: #555555;
  }
  .type-count {
    background: #e0f7fa;
    padding: 0.1rem 0.4rem;
    border-radius: 8px;
    font-size: 0.75rem;
    font-weight: 500;
  }

  .loading {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 2rem;
    gap: 1rem;
    color: #666666;
  }
  .spinner {
    width: 32px;
    height: 32px;
    border: 4px solid #e0e0e0;
    border-top-color: #007acc;
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }
  @keyframes spin {
    to { transform: rotate(360deg); }
  }
  </style>
  
  <script>
  import axios from 'axios';
  
  const apiUrl = import.meta.env.VITE_API_URL;
  
  export default {
    name: 'StatsCard',
    data() {
      return {
        stats: [],
        loading: false,
        scale: 'Mois'
      };
    },
    created() {
      this.fetchStats();
    },
    methods: {
      async fetchStats() {
        this.loading = true;
        try {
          const response = await axios.get(`${apiUrl}/api/admin/admin-offer-stats`, {
            params: { scale: this.scale },
            headers: {
              'Authorization': `Bearer ${localStorage.getItem('token')}`
            }
          });
       
          this.stats = response.data.map(admin => ({
            ...admin,
            showTypes: false
          }));
        } catch (error) {
          console.error('Error fetching statistics:', error);
        } finally {
          this.loading = false;
        }
      },
      toggleTypes(index) {

        this.stats[index].showTypes = !this.stats[index].showTypes;
      }
    }
  };
  </script>
