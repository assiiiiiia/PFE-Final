<template>
    <div class="dashboard">   
      <div class="section">
      
        <div class="side1">
        
          <div class="cards">
            <div class="cards">
    <StatCards 
        colorScheme="blue"
        title="Appels d'offres"
        :value="stats.totalAppelsOffre"
        :tagFR="stats.totalAppelsOffreFR"
        :tagAR="stats.totalAppelsOffreAR"
        iconClassName="fa-file-contract"
        iconClass="fas"
    />
    <StatCards 
        colorScheme="green"
        title="Avis de consultation"
        :value="stats.totalAvisConsultation"
        :tagFR="stats.totalAvisConsultationFR"
        :tagAR="stats.totalAvisConsultationAR"
        iconClassName="fa-envelope-open-text"
        iconClass="fas"
    />
    <StatCards 
        colorScheme="purple"
        title="Avis de manifestation"
        :value="stats.totalAvisManifestation"
        :tagFR="stats.totalAvisManifestationFR"
        :tagAR="stats.totalAvisManifestationAR"
        iconClassName="fa-bullhorn"
        iconClass="fas"
    />
</div>
          </div>
     
          <div class="charts">
            <div class="chart pie-chart"><PieChart /></div>
            <div class="chart line-chart"><LineChart/></div>
          </div>
 

        </div>
       
        <div class="side2">

<StatCardSide 
  title="Total Offres"
  :value="stats.totalOffers"
  iconClassName="fas fa-folder-open"
  iconClass="card-icon"

/>


<StatCardSide 
  title="Total Utilisateurs"
  :value="stats.totalUsers"
  iconClassName="fas fa-users"
  iconClass="card-icon"
 
/>


<StatCardSide 
  title="Offres avec Lot"
  :value="stats.totalOffersWithLot"
  iconClassName="fas fa-layer-group"
  iconClass="card-icon"
 
/>

      </div>
      </div>
      <div class="admin-stat">
        <AdminStat />
        <Soumission />
      </div>

<div><BarChart /></div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue'
  import axios from 'axios'
 
  import StatCards from '../components/dashboard/StatCards.vue'
  import PieChart from '../components/dashboard/PieChart.vue'
  import LineChart from '../components/dashboard/LineChart.vue'
import StatCardSide from '../components/dashboard/StatCardSide.vue'
import AdminStat from '../components/dashboard/AdminStat.vue'

 import BarChart from '../components/dashboard/BarChart.vue'
import Soumission from '../components/dashboard/Soumission.vue'
  

const apiUrl = import.meta.env.VITE_API_URL
  
  const stats = ref({
    totalAppelsOffre: 0,
    totalAppelsOffreFR: 0,
    totalAppelsOffreAR: 0,
    totalAvisConsultation: 0,
    totalAvisConsultationFR: 0,
    totalAvisConsultationAR: 0,
    totalAvisManifestation: 0,
    totalAvisManifestationFR: 0,
    totalAvisManifestationAR: 0,
    totalOffers: 0,
  totalUsers: 0,
  totalOffersWithLot: 0,
  })
  
  const loading = ref(true)
  const error = ref(null)
  
  const token = localStorage.getItem('token')
  const fetchOfferCardStats = async () => {
  try {
    const response = await axios.get(`${apiUrl}/api/admin/offer-cards-stats`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
    stats.value.totalOffers = response.data.totalOffers
    stats.value.totalUsers = response.data.totalUsers
    stats.value.totalOffersWithLot = response.data.totalOffersWithLot
  } catch (err) {
    console.error('Erreur lors du chargement des infos des cartes :', err)
  }
}

  if (!token) {
    console.error('Token is missing. Please login first.')
  } else {
    const fetchStats = async () => {
      try {
        const response = await axios.get(`${apiUrl}/api/admin/stats`, {
          headers: { 'Authorization': `Bearer ${token}` }
        })
        stats.value = response.data
      } catch (err) {
        error.value = 'Failed to load statistics. Please try again later.'
      } finally {
        loading.value = false
      }
    }
    onMounted(() => {
  fetchStats()
  fetchOfferCardStats()
})

  }
  </script>
  
  <style scoped>
.dashboard {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-top: 60px;
  padding: 1rem;
}

.section {
  display: flex;
  gap: 1rem;
}

.side1 {
  flex: 3;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}


.cards {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
}


.cards > * {
  flex: 1 1 200px;
 width: 400px;
}


.charts {
  display: flex;
  gap: 20px;
  width: 100%;
  flex-wrap: wrap;
}


.chart {
  flex: 1;
  padding: 1rem;
  background-color: #ffffff;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  text-align: center;
  border-radius: 9px;
}


.side2 {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.admin-stat {
  display: flex;
  gap: 1rem;
}

.admin-stat > *:first-child {
  flex: 3;
}

.admin-stat > *:not(:first-child) {
  flex: 1;
}

@media (max-width: 768px) {

  .section {
    flex-direction: column;
  }
 
  .side1,
  .side2 {
    width: 100%;
  }
  

  .cards {
    flex-direction: column;
  }
  

  .charts {
    flex-direction: column;
  }


  .admin-stat {
    flex-direction: column;
  }

  .admin-stat > * {
    flex: 1 1 100%;
  }
}


@media (max-width: 480px) {
  .cards > *,
  .chart {
    flex: 1 1 100%;
  }
}

  </style>
