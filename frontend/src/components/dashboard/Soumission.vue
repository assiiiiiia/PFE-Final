<template>
  <div class="card">
    <header class="card-header">
     <i class="fa-solid fa-ranking-star"></i> Top 3 des offres les plus soumissionnées
    </header>
    <div class="card-body">
      <ul v-if="topSoumissions.length" class="list">
        <li
          v-for="(offre, index) in topSoumissions"
          :key="offre.offre_id"
          class="list-item"
          :class="positionClasses[index]"
        >
          <div class="item-left">
            <span class="icon">{{ icons[index] }}</span>
            <span class="title">{{ offre.titre_offre }}</span>
          </div>
          <div class="item-right">
            <span class="badge">{{ offre.total_soumissions }}</span>
          </div>
        </li>
      </ul>
      <p v-else class="empty">Aucune soumission à afficher pour l’instant.</p>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { ref, onMounted } from 'vue'
const apiUrl = import.meta.env.VITE_API_URL

export default {
  name: 'TopSoumissionsCard',
  setup() {
    const topSoumissions = ref([])

    const fetchTopSoumissions = async () => {
      try {
        const token = localStorage.getItem('token')
        const { data } = await axios.get(`${apiUrl}/api/admin/top-soumissions`, {
          headers: { Authorization: `Bearer ${token}` }
        })
        const list = Array.isArray(data) ? data : data.data ?? []
        topSoumissions.value = list.slice(0, 3)
      } catch (err) {
        console.error(err)
      }
    }

    onMounted(fetchTopSoumissions)

    const icons = ['🥇', '🥈', '🥉']
    const positionClasses = ['first', 'second', 'third']

    return { topSoumissions, icons, positionClasses }
  }
}
</script>

<style scoped>
/* Container */
.card {
  max-width: 480px;
  margin: 2rem auto;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* Header */
.card-header {
  padding: 1rem;
  font-size: 1.1rem;
  font-weight: bold;
color:#1e3c64
}

/* Body */
.card-body {
  padding: 1rem;
}

/* List reset */
.list {
  list-style: none;
  padding: 0;
  margin: 0;
}

/* Empty state */
.empty {
  margin: 0;
  color: #888;
  font-style: italic;
}

/* List items */
.list-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1rem;
  margin-bottom: 0.5rem;
  border-radius: 8px;
  animation: fadeInUp 0.5s ease-in-out both;
}

/* Left side: icon + title */
.item-left {
  display: flex;
  align-items: center;
}
.icon {
  font-size: 1.5rem;
  margin-right: 0.5rem;
}
.title {
  flex-shrink: 1;
}

/* Right side: badge */
.badge {
  min-width: 2rem;
  text-align: center;
  padding: 0.25rem 0.5rem;
  margin-left: 20px;
  border-radius: 12px;
  background: #274b7d;
  color: #fff;
  font-size: 0.9rem;
}

/* Position-specific colors */
.first {
  background-color: #f0f0f084;
  border-left: 5px solid #274b7d;
}
.second {
  background-color: #f0f0f084;
  border-left: 5px solid #5ca1cc;
}
.third {
  background-color: #f0f0f084;
  border-left: 5px solid #a8dadc;
}

/* Fade-in animation */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
