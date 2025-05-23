<template>
  <div class="chart-wrapper">
   
    <i class="fa-solid fa-bars menu-icon" @click="toggleMenu"></i>
    <div v-if="menuOpen" class="dropdown-menu">
      <button
        v-for="scale in scales"
        :key="scale"
        @click="changeScale(scale)"
        :class="{ active: currentScale === scale }"
      >
        {{ scale }}
      </button>
    </div>
  
    <div id="lineChartContainer"></div>
  </div>
</template>
<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import axios from 'axios';
import Highcharts from 'highcharts';

const apiUrl = import.meta.env.VITE_API_URL;
const scales = ['Jour', 'Mois', 'Année'];
const currentScale = ref('Mois');
const menuOpen = ref(false);
let chart = null;
let intervalId = null;


const colorMapping = {
  "appel d'offre": "#1f77b4",          
  "avis de manifestation": "#d40d0d",   
  "avis de consultation": "#2ca02c"     
};


function toggleMenu() {
  menuOpen.value = !menuOpen.value;
}


function getChartTitle(scale) {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.toLocaleDateString('fr-FR', { month: 'long' });
  
  switch (scale) {
    case 'Jour': 
      return `Tendance hebdomadaire des offres (${month} ${year})`;
    case 'Mois': 
      return `Tendance mensuelle des offres - ${year}`;
    case 'Année': 
      return `Tendance annuelle des offres`;
    default: 
      return `Tendance des Offres`;
  }
}


function getCurrentWeekDates() {
  const result = [];
  const today = new Date();

  const day = today.getDay();
  const diff = day === 0 ? -6 : 1 - day;
  const monday = new Date(today);
  monday.setDate(today.getDate() + diff);
  
  for (let i = 0; i < 7; i++) {
    const d = new Date(monday);
    d.setDate(monday.getDate() + i);
    const formatted = new Intl.DateTimeFormat('fr-FR', { day: 'numeric', month: 'long' }).format(d);
    result.push({
      date: d.toISOString().split('T')[0], 
      label: formatted,
      isToday: d.toDateString() === today.toDateString()
    });
  }
  return result;
}


function formatPeriod(period, scale) {
  if (scale === 'Mois') {
    const [year, monthNumber] = period.split('-');
    const months = {
      '01': 'Janvier',
      '02': 'Février',
      '03': 'Mars',
      '04': 'Avril',
      '05': 'Mai',
      '06': 'Juin',
      '07': 'Juillet',
      '08': 'Août',
      '09': 'Septembre',
      '10': 'Octobre',
      '11': 'Novembre',
      '12': 'Décembre'
    };
    return `${months[monthNumber]} ${year}`;
  } else if (scale === 'Jour') {
    const date = new Date(period);
    const options = { weekday: 'long', day: 'numeric', month: 'long' };
    return new Intl.DateTimeFormat('fr-FR', options).format(date);
  } else {
    return period;
  }
}


async function fetchTrendData() {
  try {
    const response = await axios.get(`${apiUrl}/api/admin/offer-trend-stats`, {
      params: { scale: currentScale.value },
      headers: { 'Authorization': `Bearer ${localStorage.getItem('token')}` }
    });
    
    let series = [];

    if (currentScale.value === 'Jour') {
   
      const weekDates = getCurrentWeekDates();
      const categories = weekDates.map(item => item.label);

      for (const [type, data] of Object.entries(response.data)) {
        const dataByDate = {};
        data.forEach(item => {
          dataByDate[item.period] = Number(item.total);
        });
        const dataForWeek = weekDates.map(dayObj => dataByDate[dayObj.date] || 0);
        series.push({
          name: type,
          data: dataForWeek,
          color: colorMapping[type.toLowerCase()] || undefined
        });
      }

      if (chart) {
        chart.destroy();
        chart = null;
      }
      chart = Highcharts.chart('lineChartContainer', {
        chart: { type: 'line', backgroundColor: '#fff' },
        title: {
          text: getChartTitle(currentScale.value),
          style: { color: '#0c1d4d', maxWidth: '300px', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }
        },
        xAxis: {
          categories,
          title: { text: 'Jour de la semaine' },
          labels: {
            useHTML: true,
            formatter: function() {
              const weekDates = getCurrentWeekDates();
              const dayObj = weekDates[this.pos];
              if (dayObj && dayObj.isToday) {
                return '<span style="font-weight:bold; color:#d40d0d;">' + this.value + '</span>';
              }
              return this.value;
            }
          }
        },
        yAxis: { title: { text: 'Nombre d\'offres' } },
        credits: { enabled: false },
        series
      });
  
    } else {
 
      const categorySet = new Set();
      for (const [, data] of Object.entries(response.data)) {
        data.forEach(item => {
          const label = formatPeriod(item.period, currentScale.value);
          categorySet.add(label);
        });
      }
      
      let xCategories = Array.from(categorySet);

      if (currentScale.value === 'Mois') {
      
        const currentYear = new Date().getFullYear();
        xCategories = xCategories.filter(label => {
          const parts = label.split(' ');
          return parts.length === 2 && parseInt(parts[1]) === currentYear;
        });
        xCategories = xCategories.sort((a, b) => {
          const [monthA, yearA] = a.split(' ');
          const [monthB, yearB] = b.split(' ');
          const months = {
            'Janvier': 1, 'Février': 2, 'Mars': 3, 'Avril': 4, 'Mai': 5, 'Juin': 6,
            'Juillet': 7, 'Août': 8, 'Septembre': 9, 'Octobre': 10, 'Novembre': 11, 'Décembre': 12
          };
          return (parseInt(yearA) * 12 + months[monthA]) - (parseInt(yearB) * 12 + months[monthB]);
        });
      } else if (currentScale.value === 'Année') {
        xCategories = xCategories.sort((a, b) => parseInt(a) - parseInt(b));
      }


   
      const newSeries = [];
      for (const [type, data] of Object.entries(response.data)) {
        const dataMap = {};
        data.forEach(item => {
          const label = formatPeriod(item.period, currentScale.value);
          dataMap[label] = Number(item.total);
        });
        const seriesData = xCategories.map(label => dataMap[label] || 0);
        newSeries.push({
          name: type,
          data: seriesData,
          color: colorMapping[type.toLowerCase()] || undefined
        });
      }
      series = newSeries;

      if (chart) {
        chart.destroy();
        chart = null;
      }
      chart = Highcharts.chart('lineChartContainer', {
        chart: { type: 'line', backgroundColor: '#fff' },
        title: {
          text: getChartTitle(currentScale.value),
          style: { color: '#0c1d4d', maxWidth: '300px', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }
        },
        xAxis: {
          categories: xCategories,
          title: { text: currentScale.value === 'Mois' ? 'Mois' : 'Année' }
        },
        yAxis: { title: { text: 'Nombre d\'offres' } },
        credits: { enabled: false },
        exporting: {
          enabled: false
        },
        series
      });
      
    }
    
  } catch (error) {
    console.error('Erreur lors de la récupération des données:', error);
  }
}

function changeScale(scale) {
  currentScale.value = scale;
  menuOpen.value = false;
  fetchTrendData();
}

onMounted(() => {
  fetchTrendData();
  intervalId = setInterval(fetchTrendData, 60000);
});

onUnmounted(() => {
  clearInterval(intervalId);
});
</script>



<style scoped>
.chart-wrapper {
  position: relative;
}

.menu-icon {
  position: absolute;
  top: 16px;
  right: 20px;
  cursor: pointer;
  font-size: 1.25rem;
  color: #3d3d3d;
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
  top: 60px;
  right: 20px;
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


#lineChartContainer {
  margin-top: 0;
  padding-top: 60px; 
}
</style>
