<template>
  <div class="pie-chart-component">

    <div class="menu-button-container">
      <i class="fa-solid fa-bars menu-icon" @click="toggleMenu"></i>
      <div v-if="menuOpen" class="dropdown-menu">
        <button
          v-for="option in offerTypes"
          :key="option"
          @click="changeType(option)"
          :class="{ active: selectedType === option }"
        >
          {{ option }}
        </button>
      </div>
    </div>

    
    <div id="pieChartContainer"></div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import Highcharts from 'highcharts'

const offerTypes = [
  "Appel d'offre",
  "Avis de consultation",
  "Avis de manifestation"
]

const selectedType = ref(offerTypes[0])
const menuOpen = ref(false)
const apiUrl = import.meta.env.VITE_API_URL
let chart = null


function toggleMenu() {
  menuOpen.value = !menuOpen.value
}


function changeType(option) {
  selectedType.value = option
  menuOpen.value = false
  updateChart()
}


async function updateChart() {
  try {
    const token = localStorage.getItem('token')
    const response = await axios.get(`${apiUrl}/api/admin/detailed-offer-stats`, {
      headers: { 'Authorization': `Bearer ${token}` }
    })

    const etatData = response.data[selectedType.value] || {}

    const colorMap = {
      "En Cours": "#5b9dc7",  
      "Infructueux": "#1d3557", 
      "Attribué": "#a8dadc",       
      "Annulé": "#e63946"       
    }

    const pieData = Object.entries(etatData).map(([etat, count]) => ({
      name: etat,
      y: Number(count),
      color: colorMap[etat] || '#cccccc' 
    }))

    if (chart) {
      chart.series[0].setData(pieData)
      chart.setTitle({ 
        text: `Répartition des états - ${selectedType.value}`,
        style: {
          color: '#0c1d4d',
          maxWidth: '300px',
          whiteSpace: 'nowrap',
          overflow: 'hidden',
          textOverflow: 'ellipsis'
        }
      })
    }
  } catch (error) {
    console.error("Error fetching detailed offer stats:", error)
  }
}

onMounted(async () => {
  chart = Highcharts.chart('pieChartContainer', {
    chart: {
      type: 'pie',
      backgroundColor: '#ffffff'
    },
    title: {
      text: `Répartition des états - ${selectedType.value}`,
      style: {
        color: '#0c1d4d',
        maxWidth: '300px',
        whiteSpace: 'nowrap',
        overflow: 'hidden',
        textOverflow: 'ellipsis'
      }
    },
    accessibility: {
      enabled: false
    },
    exporting: {
      enabled: false
    },
    series: [{
      name: 'Nombre',
      colorByPoint: true,
      showInLegend: true,
      data: []
    }],
    plotOptions: {
      pie: {
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
          enabled: true,
          format: '<b>{point.name}</b>: {point.y}',
          style: {
            color: '#000000'
          }
        }
      }
    },
    legend: {
      itemStyle: {
        color: '#000000'
      }
    },
    credits: {
      enabled: false
    }
  })

  await updateChart()
})
</script>

<style scoped>
.pie-chart-component {
  position: relative;
  padding: 20px;
  background-color: #fff;
}


.menu-button-container {
  position: relative;
  display: flex;
  justify-content: flex-end;

}

.menu-icon {
  font-size: 1.25rem;
  color: #3d3d3d;
  cursor: pointer;
  transition: all 0.2s ease;
  z-index: 20;
  padding: 2px;
  border-radius: 50%;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.menu-icon:hover {
  color: #d40d0d;
}


.dropdown-menu {
  position: absolute;
  top: 100%;
  right: 0;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  z-index: 20;
  padding: 8px;
  min-width: 160px;
  border: 1px solid #f0f0f0;
  transform-origin: top right;
  animation: scaleIn 0.15s ease-out;
}

@keyframes scaleIn {
  from {
    transform: scale(0.95);
    opacity: 0;
  }
  to {
    transform: scale(1);
    opacity: 1;
  }
}

.dropdown-menu button {
  display: flex;
  width: 100%;
  padding: 10px 16px;
  border: none;
  background: transparent;
  color: #404040;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
  font-family: 'Segoe UI', system-ui, sans-serif;
  font-size: 0.9rem;
  font-weight: 500;
  margin: 2px 0;
}

.dropdown-menu button:hover {
  background: #f8f9fa;
  color: #d40d0d;
  transform: translateX(2px);
}

.dropdown-menu button.active {
  background: #d40d0d;
  color: white;
  font-weight: 600;
  box-shadow: 0 2px 8px rgba(255, 107, 0, 0.2);
}

.dropdown-menu button.active:hover {
  background: #870c0c;
}


#pieChartContainer {
  width: 100%;

}
</style>
