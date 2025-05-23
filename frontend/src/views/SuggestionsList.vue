<template>
    <div class="container">
      <header>
        <h2>Liste des Suggestions</h2>
      </header>
      <div class="table-responsive">
        <table>
          <thead>
            <tr>
              <th><i class="fas fa-hashtag"></i> ID</th>
              <th><i class="fas fa-envelope"></i> Email</th>
              <th><i class="fas fa-comment"></i> Content</th>
              <th><i class="fas fa-calendar-alt"></i> Date</th>
            </tr>
          </thead>
          <tbody>
            <tr 
              v-for="(suggestion, index) in paginatedSuggestions" 
              :key="suggestion.id"
              :style="{ animationDelay: `${index * 0.05}s` }"
            >
              <td>{{ suggestion.id }}</td>
              <td>{{ suggestion.email }}</td>
              <td>{{ suggestion.content }}</td>
              <td>{{ formatDate(suggestion.created_at) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <Pagination 
        :totalPages="totalPages" 
        :currentPage="currentPage" 
        @page-changed="handlePageChange" 
      />
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, computed } from 'vue';
  import axios from 'axios'
  import Pagination from '@/components/Pagination.vue'
  
  const apiUrl = import.meta.env.VITE_API_URL
  const suggestions = ref([])
  const currentPage = ref(1)
  const itemsPerPage = 15
  
  const formatDate = (dateString) => {
    const options = { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit' }
    return new Date(dateString).toLocaleDateString('fr-FR', options)
  }
  
  const fetchSuggestions = async () => {
    try {
      const response = await axios.get(`${apiUrl}/api/suggestions`, {
        headers: {
          Authorization: `Bearer ${localStorage.getItem('token')}`
        }
      })
      suggestions.value = response.data
    } catch (error) {
      console.error('Error fetching suggestions:', error)
    }
  }
  
  const handlePageChange = (newPage) => {
    currentPage.value = newPage
  }
  
  onMounted(() => {
    fetchSuggestions()
  })
  
  const totalPages = computed(() => {
    return Math.ceil(suggestions.value.length / itemsPerPage)
  })
  
  const paginatedSuggestions = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage
    const end = start + itemsPerPage
    return suggestions.value.slice(start, end)
  })
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
    align-items: center;
    margin-bottom: 20px;
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
  flex-wrap: wrap;  
  justify-content: flex-start;
  gap: 10px;

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
  .table-responsive {
    overflow-x: auto;
  }
  


  th i {
    margin-right: 8px;
    color: #2fa08bf9;
  }
 
  tbody tr:nth-child(even) {
    background-color: #f8fafc;
  }
  
  tbody tr:hover {
    background: #f1f1f1;
    transform: scale(1.01);
    z-index: 10;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
  }
  
  @keyframes slideIn {
    from {
      opacity: 0;
      transform: translateX(-20px);
    }
    to {
      opacity: 1;
      transform: translateX(0);
    }
  }
  
  @keyframes fadeIn {
    from {
      opacity: 0;
      transform: translateY(-10px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  /* Responsive */
  @media (max-width: 768px) {
    .container {
      padding: 20px;
    }
  
    th, td {
      padding: 10px;
      font-size: 13px;
    }
  }

  td:nth-child(3) {
  max-width:700px;
  white-space: normal;
  overflow-wrap: break-word;
  word-break: break-word;
  text-overflow: ellipsis;
}
  </style>
