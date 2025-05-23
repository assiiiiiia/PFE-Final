<template>
  <div class="admin-profile">
 
    <div class="profile-header">
      
      
    </div>

    <div class="content-container">
      



    
      <div class="double-section">
   
        <div class="profile-form glow-border">
          <h3><i class="fas fa-user-cog"></i> Modifier le Profil</h3>
          <form @submit.prevent="updateProfile">
            <div class="dual-input" >
  <div class="input-group half">
    <i class="fas fa-user icon"></i>
    <input type="text" v-model="user.nom" placeholder="Nom" class="half-input">
  </div>
  <div class="input-group half">
    <i class="fas fa-user-tag icon"></i>
    <input type="text" v-model="user.prenom" placeholder="Prénom" class="half-input">
  </div>
</div>
            <div class="input-group">
              <div class="telephone">
              <i class="fas fa-phone icon"></i>
              <input type="text" v-model="user.telephone" placeholder="Téléphone">
            </div>
          </div>
            <div class="input-group">
              <i class="fas fa-envelope icon"></i>
              <input type="email" v-model="user.email" placeholder="Email professionnel">
            </div>
            <div class="input-group">
              <i class="fas fa-key icon"></i>
              <input type="password" v-model="user.password" placeholder="Nouveau mot de passe">
            </div>
            <div class="input-group">
              <i class="fas fa-key icon"></i>
              <input type="password" v-model="user.password_confirmation" placeholder="Confirmation du mot de passe">
            </div>
            <button type="submit" class="save-button">
              <i class="fas fa-save"></i> Enregistrer
            </button>
          </form>
        </div>
</div>  
</div>

<div class="admin-actions">
        <h3><i class="fas fa-shield-alt"></i> Actions Administratives</h3>
        <div class="action-buttons">
       
          <button v-if="user.role == 'superadmin'" @click="navigateTo('/dashboard-superadmin/admins')" class="action-btn primary">
            <i class="fas fa-users"></i> Gérer les admins
          </button>
          <button v-else @click="navigateTo('/dashboard-admin/offre-form')" class="action-btn primary">
            <i class="fas fa-plus"></i> Ajouter des offres
          </button>
          
        
          <button v-if="user.role == 'superadmin'" @click="navigateTo('/dashboard-superadmin/Offres')" class="action-btn">
            <i class="fas fa-cogs"></i> Voir les offres
          </button> 
           <button v-else @click="navigateTo('/dashboard-admin/Offres')" class="action-btn">
            <i class="fas fa-cogs"></i> Voir les offres
          </button> 
          <button v-if="user.role == 'superadmin'" @click="navigateTo('/dashboard-superadmin')" class="action-btn warning">
            <i class="fas fa-scroll"></i> Voir le dashboard
          </button>
           <button v-else @click="navigateTo('/dashboard-admin')" class="action-btn warning">
            <i class="fas fa-scroll"></i> Voir le dashboard
          </button>
        </div>
      </div>
    </div>
  
</template>

<script>
import axios from 'axios';
const apiUrl = import.meta.env.VITE_API_URL;
export default {
  data() {
    return {
      user: {
        nom: '',
        prenom: '',
        role: '', 
        telephone: '',
        email: '',
        password: '',
        password_confirmation: ''
      }
    };
  },
  mounted() {
    this.fetchUserProfile();
    this.user = {
        nom: this.user.nom || '',
        prenom: this.user.prenom || '',
        telephone: this.user.telephone || '',
        email: this.user.email || '',
        role: this.user.role || '',
        password: '',
        password_confirmation: ''
    };
  },
  methods: {
   
    fetchUserProfile() {
      axios.get(`${apiUrl}/api/admin/profile`, { headers: { Authorization: `Bearer ${localStorage.getItem('token')}` } })
        .then(response => {
          this.user.nom = response.data.nom;
          this.user.prenom = response.data.prenom;
          this.user.telephone = response.data.telephone;
          this.user.email = response.data.email;
          this.user.role      = response.data.role; 
        })
        .catch(error => {
          console.error("Erreur lors du chargement du profil", error);
        });
    },
    

    updateProfile() {
  if (this.user.password && this.user.password !== this.user.password_confirmation) {
    alert("Les mots de passe ne correspondent pas !");
    return;
  }

  axios.put(`${apiUrl}/api/admin/profile`, this.user, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem('token')}`
    }
  })
  .then(response => {
    alert('Profil mis à jour avec succès!');
    this.fetchUserProfile();
  })
  .catch(error => {
    console.error("Erreur lors de la mise à jour du profil", error);
  });
},
navigateTo(route) {
      this.$router.push(route);
    },
}};
  



</script>

<style scoped>

.admin-profile {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  color: #2d3748;
  background: #ffffff;
  padding: 2.5rem;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  width: 90%;
  max-width: 640px;
  margin: 3rem auto;
  border: 1px solid #e2e8f0;
  position: relative;
}

.admin-profile::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background-color: #2c5282;
}
.dual-input {
  display: flex;
  gap: 5.1rem;
  align-items: center;
  position: relative;
}

.dual-input .icon {
  position: absolute;
  left: 10px;
  top: 50%;
  transform: translateY(-50%);
  z-index: 1;
}

.half-input {
  flex: 1;
  padding: 1rem 1rem 1rem 2.75rem;
  background-color: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  color: #1a202c;
  font-size: 0.95rem;
}
.profile-header {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 2rem;
}

.profile-form h3 {
  color: #1a365d;
  margin-bottom: 2rem;
  font-size: 1.5rem;
  font-weight: 600;
  text-align: center;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
}

.profile-form h3 i {
  font-size: 1.25rem;
  color: #2c5282;
}

.form-fields {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.input-group {
  position: relative;

}

.input-group .icon {
  position: absolute;
  left: 1rem;
  top: 50%;
  left: 10px;
  transform: translateY(-50%);
  color: #4a5568;
  font-size: 1rem;
}

.input-group input {
  width: 100%;
  padding: 1rem 1rem 1rem 2.75rem;
  background-color: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  color: #1a202c;
  font-size: 0.95rem;
  transition: all 0.2s ease;
}

.input-group input:focus {
  outline: none;
  border-color: #2c5282;
  box-shadow: 0 0 0 3px rgba(44, 82, 130, 0.1);
  background-color: #fff;
}

.button-group {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-top: 2rem;
}
.input-group .telephone {
  display: flex;
  align-items: center;
  margin-top: 20px;
  margin-bottom: 5px;
}
.save-button {
  background-color: #2c5282;
  color: white;
  border: none;
  padding: 1rem;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
  font-weight: 500;
  font-size: 1rem;
  display: flex;
  margin-left:250px;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.save-button i {
  font-size: 1rem;
}

.save-button:hover {
  background-color: #1a365d;
  transform: translateY(-1px);
}


.admin-actions {
  margin-top: 2.5rem;
  padding-top: 2rem;
  border-top: 1px solid #edf2f7;
}

.admin-actions h3 {
  color: #2d3748;
  margin-bottom: 1.5rem;
  font-size: 1.25rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 10px;
}

.admin-actions h3 i {
  font-size: 1.1rem;
  color: #4a5568;
}

.action-buttons {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 12px;
}

.action-btn {
  padding: 0.75rem 1rem;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  font-size: 0.9rem;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  border: 1px solid transparent;
}

.action-btn i {
  font-size: 0.95rem;
}


.action-btn.primary {
  background-color: #e6f2ff;
  color: #2c5282;
  border-color: #c3dafe;
}

.action-btn.primary:hover {
  background-color: #d6e6ff;
}

.action-btn.warning {
  background-color: #fff5f5;
  color: #c53030;
  border-color: #fed7d7;
}

.action-btn.warning:hover {
  background-color: #ffebeb;
}

.action-btn.default {
  background-color: #f8fafc;
  color: #4a5568;
  border-color: #e2e8f0;
}

.action-btn.default:hover {
  background-color: #edf2f7;
}

@media (max-width: 768px) {
  .admin-profile {
    padding: 2rem 1.5rem;
    width: 95%;
  }
  
  .action-buttons {
    grid-template-columns: 1fr;
  }
}
</style>