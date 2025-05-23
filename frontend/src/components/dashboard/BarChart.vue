<template>
  <div class="bar-chart-component">
   
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

    <div id="offers-chart" style="width: 100%; height: 500px;"></div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import axios from 'axios'
import Highcharts from 'highcharts'


const allWilayas = [
  "Adrar", "Chlef", "Laghouat", "Oum El Bouaghi", "Batna", "Bejaia", "Biskra", "Béchar", "Blida", "Bouira",
  "Tamanrasset", "Tébessa", "Tlemcen", "Tiaret", "Tizi Ouzou", "Alger", "Djelfa", "Jijel", "Sétif", "Saïda",
  "Skikda", "Sidi Bel Abbès", "Annaba", "Guelma", "Constantine", "Médéa", "Mostaganem", "M'Sila", "Mascara", "Ouargla",
  "Oran", "El Bayadh", "Illizi", "Bordj Bou Arréridj", "Boumerdès", "El Tarf", "Tindouf", "Tissemsilt", "El Oued", "Khenchela",
  "Souk Ahras", "Tipaza", "Mila", "Aïn Defla", "Naâma", "Aïn Témouchent", "Ghardaïa", "Relizane", "Timimoun", "Bordj Badji Mokhtar",
  "Ouled Djellal", "Béni Abbès", "In Salah", "In Guezzam", "Touggourt", "Djanet", "El M'Ghair", "El Menia"
]

const offerTypes = [
  "Appel d'offre",
  "Avis de consultation",
  "Avis de manifestation"
]
const typeColors = {
  "Appel d'offre": "#D40D0D",        
  "Avis de consultation": "#2346a8",  
  "Avis de manifestation": "#FF9F1C"  
}

const selectedType = ref(offerTypes[0])
const menuOpen = ref(false)
let chart = null

const apiUrl = import.meta.env.VITE_API_URL
const token = localStorage.getItem('token')


function toggleMenu() {
  menuOpen.value = !menuOpen.value
}


function changeType(option) {
  selectedType.value = option
  menuOpen.value = false
}


async function updateChart() {
  try {
    const res = await axios.get(`${apiUrl}/api/admin/offre-wilayas`, {
      headers: { 'Authorization': `Bearer ${token}` }
    })

    const dataSerie = allWilayas.map(w =>
      (res.data[w] && res.data[w][selectedType.value]) ? res.data[w][selectedType.value] : 0
    )

    const serieOptions = {
      name: selectedType.value,
      data: dataSerie,
      color: typeColors[selectedType.value]
    }

    if (!chart) {

      chart = Highcharts.chart('offers-chart', {
        chart: { type: 'column' },
        title: {
          text: `Nombre d'offres par wilaya – ${selectedType.value}`,
          style: {
            color: '#0c1d4d',
            fontSize: '1.5rem',
            maxWidth: '300px',
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis'
          }
        },
        xAxis: {
          categories: allWilayas,
          crosshair: true,
          title: { text: 'Wilayas' }
        },
        yAxis: {
          min: 0,
          title: { text: 'Nombre d\'offres' }
        },
        tooltip: {
          headerFormat: '<span style="font-size:10px">{point.key}</span><br/>',
          pointFormat: '<b>{point.y}</b> offres'
        },
        plotOptions: {
          column: {
            pointPadding: 0.2,
            borderWidth: 0
          }
        },
        series: [serieOptions]
      })
    } else {

      chart.update({
        title: { text: `Nombre d'offres par wilaya – ${selectedType.value}` },
        xAxis: { categories: allWilayas },
        series: [serieOptions]
      })
    }
  } catch (err) {
    console.error('Erreur fetch stats:', err)
  }
}

onMounted(() => {
  updateChart()
})


watch(selectedType, () => updateChart())
</script>

<style scoped>
.bar-chart-component {
  position: relative;
  padding: 20px;
  background-color: #fff;
  border-radius: 12px;
  box-shadow: 1px 4px 6px 1px rgba(0, 0, 0, 0.158);
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
</style>
