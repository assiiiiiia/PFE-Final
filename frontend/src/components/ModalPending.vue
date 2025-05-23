<template>
    <div class="modal-overlay" @click.self="$emit('close')">
      <div class="modal-content">
        <h3>Utilisateurs en attente</h3>
  
        <div class="table-container" v-if="pendingUsers.length > 0">
          <table class="user-table">
            <thead>
              <tr>
                <th>Nom</th>
                <th>Prénom</th>
                <th>Statut</th>
               
              </tr>
            </thead>
            <tbody>
              <tr v-for="user in pendingUsers" :key="user.id">
                <td>{{ user.nom }}</td>
                <td>{{ user.prenom }}</td>
                <td>{{ getStatusLabel(user.status) }}</td>
                
              </tr>
            </tbody>
          </table>
        </div>
  
        <p v-else>Aucun utilisateur en attente.</p>
  
        <button class="close-btn" @click="$emit('close')">Fermer</button>
      </div>
    </div>
</template>
  
<script>
import axios from "axios";
const apiUrl = import.meta.env.VITE_API_URL;

export default {
  data() {
    return {
      pendingUsers: [],
      loadingUserId: null,
    };
  },
  methods: {
    async fetchPendingUsers() {
      try {
        const token = localStorage.getItem("token");
        if (!token) {
          alert("Erreur : Vous devez être connecté.");
          return;
        }

        const response = await axios.get("http://127.0.0.1:8000/api/users/pending", {
          headers: { Authorization: `Bearer ${token}` },
        });

        this.pendingUsers = response.data; 
      } catch (error) {
        console.error("Erreur lors de la récupération des utilisateurs :", error);
      }
    },

    async updateUserStatus(userId, action) {
      try {
        this.loadingUserId = userId;

        let url = `${apiUrl}/api/users/${userId}`;
        url += action === "approve" ? "/approve" : "/reject";

        const token = localStorage.getItem("token");
        if (!token) {
          alert("Erreur : Vous devez être connecté.");
          return;
        }

        const response = await axios.post(url, {}, {
          headers: { Authorization: `Bearer ${token}` },
        });

        alert(response.data.message);
        this.fetchPendingUsers(); 
      } catch (error) {
        console.error("Erreur de requête:", error.response?.data || error);
        alert(error.response?.data?.message || "Une erreur s'est produite.");
      } finally {
        this.loadingUserId = null;
      }
    },

    getStatusLabel(status) {
      const statusLabels = {
        "en attente": "🟡 En attente",
        "actif": "🟢 Actif",
        "suspendu": "🔴 Suspendu"
      };
      return statusLabels[status] || status;
    }
  },
  mounted() {
    this.fetchPendingUsers();
  },
};
</script>
  
<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: #fff;
  padding: 25px;
  border-radius: 12px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
  width: 90%;
  max-width: 700px;
  max-height: 80vh;
  overflow-y: auto; 
  overflow-x: hidden; 
}

h3 {
  margin-top: 0;
  font-size: 22px;
  color: #333;
  text-align: center;
  margin-bottom: 20px;
}

.table-container {
  overflow-x: auto;
}

.user-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 20px;
}

.user-table th,
.user-table td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #e0e0e0;
}

.user-table th {
  background-color: #f7f9fc;
  color: #555;
  font-weight: 600;
}

.user-table td {
  color: #444;
}

button {
  padding: 8px 14px;
  border: none;
  border-radius: 6px;
  font-size: 14px;
  margin-top: 10px;
  transition: background 0.3s ease;
}

.approve-btn {
  background: #28a745;
  color: white;
}

.suspend-btn {
  background: #dc3545;
  color: white;
}

.close-btn {
  background: #6c757d;
  color: white;
  display: block;
  margin: 0 auto;
}

button:hover {
  filter: brightness(1.1);
}

button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

</style>
