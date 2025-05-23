<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';

const user = ref({
    civilite: '',
    nom: '',
    prenom: '',
    email: '',
    fonction: '',
    telephone: '',
    entreprise: {}
});
const apiUrl = import.meta.env.VITE_API_URL;
const password = ref('');
const message = ref('');
const error = ref('');


const getLogoUrl = (logoPath) => {
  if (!logoPath || logoPath === "null") {
    return `${apiUrl}/storage/logo/default.png`;
  }
  return `${apiUrl}/storage/logo/` + logoPath.split("/").pop();
};


const handleImageError = (event) => {
  event.target.src = `${apiUrl}/storage/logo/default.png`;
};

const fetchUserData = async () => {
    try {
        const response = await axios.get(`${apiUrl}/api/profile`, {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`
          }
        });
        user.value = response.data;
    } catch (err) {
        error.value = 'Erreur lors du chargement des données.';
    }
};

const updateProfile = async () => {
    try {
        const formData = { ...user.value };
        if (password.value) {
            formData.password = password.value;
        }
        
        const response = await axios.put(`${apiUrl}/api/profile`, formData, {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`
          }
        });
        message.value = response.data.message;
        error.value = '';
        password.value = '';
    } catch (err) {
        error.value = 'Erreur lors de la mise à jour du profil.';
    }
};

onMounted(fetchUserData);
</script>

<template>
  <div class="profile-wrapper">
   

  
    <section id="profil-section-unique">
    
      <h2 class="section-title">
        <i class="fas fa-user-circle"></i> Mon Profil
      </h2>

      <div v-if="message" class="alert success">
        <i class="fas fa-check-circle"></i> {{ message }}
      </div>
      <div v-if="error" class="alert error">
        <i class="fas fa-exclamation-triangle"></i> {{ error }}
      </div>

      <div class="form-block">
        <div class="form-row">
          <i class="fas fa-user-tie"></i>
          <select v-model="user.civilite">
            <option value="Monsieur">Monsieur</option>
            <option value="Madame">Madame</option>
          </select>
        </div>

        <div class="form-row">
          <i class="fas fa-signature"></i>
          <input type="text" v-model="user.nom" placeholder="Nom" />
        </div>

        <div class="form-row">
          <i class="fas fa-signature"></i>
          <input type="text" v-model="user.prenom" placeholder="Prénom" />
        </div>

        <div class="form-row">
          <i class="fas fa-envelope"></i>
          <input type="email" v-model="user.email" placeholder="Email" />
        </div>

        <div class="form-row">
          <i class="fas fa-briefcase"></i>
          <input type="text" v-model="user.fonction" placeholder="Fonction" />
        </div>

        <div class="form-row">
          <i class="fas fa-phone"></i>
          <input type="text" v-model="user.telephone" placeholder="Téléphone" />
        </div>

        <div class="form-row">
          <i class="fas fa-lock"></i>
          <input type="password" v-model="password" placeholder="Mot de passe (laisser vide si inchangé)" />
        </div>

        <button @click="updateProfile">
          <i class="fas fa-save"></i> Enregistrer les modifications
        </button>
      </div>
    </section>
 
     <section id="entreprise-section-unique" class="enterprise-section">

    <h2 class="section-title">
      <i class="fas fa-building"></i> Entreprise Associée
    </h2>

      <div class="info-grid">
        <div v-for="(field, key) in {
          'Nom de l\'entreprise': 'nom_entreprise',
          'Activité': 'activite',
          'Catégorie': 'categorie',
          'Pays': 'pays',
          'Wilaya': 'wilaya',
          'Adresse': 'adresse',
          'Code Commerce': 'code_commerce',
          'Nombre d\'employés': 'nombre_employes'
        }" :key="key" class="info-block">
          <label>{{ key }}</label>
          <p>{{ user.entreprise[field] || '-' }}</p>
        </div>
      </div>

      <h3 class="sub-title">Identifiants Officiels</h3>
      <div class="info-grid triple">
        <div v-for="(field, key) in {
          'Numéro Fiscal': 'num_fiscal',
          'Numéro Statistique': 'num_statistique',
          'Numéro National': 'num_national'
        }" :key="key" class="info-block">
          <label>{{ key }}</label>
          <p>{{ user.entreprise[field] || '-' }}</p>
        </div>
      </div>

   
    </section>
  </div>
</template>


<style>
.profile-wrapper {
  display: flex;
  gap: 30px;
  padding: 2rem;
  max-width: 1200px;
  margin: auto;

  color: #002B5B;
  font-family: "Segoe UI", sans-serif;
}

#profil-section-unique,
#entreprise-section-unique {
  flex: 1;
  background: #ffffff;
  border-radius: 8px;
  padding: 1.5rem;
  box-shadow: 0 0 18px rgba(0, 0, 0, 0.055);
 
}

#profil-section-unique .section-title,
#entreprise-section-unique .section-title {

  border-bottom: 2px solid #a1a1a149;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #364d64;
  font-size: 1.5rem;

  margin-bottom: 2rem;
  padding-bottom: 1rem;

}


#entreprise-section-unique .info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
  margin-bottom: 1.5rem;
}

#entreprise-section-unique .info-block {
  background: #f8fafc;
  padding: 0.8rem;
  border-radius: 6px;
  border-left: 3px solid #34a5cb;
}

#entreprise-section-unique .info-block label {
  display: block;
  font-size: 0.8rem;
  color: #0a192f;
  font-weight: 600;
  margin-bottom: 0.3rem;
}

#entreprise-section-unique .info-block p {
  color: #0a192f;
  margin: 0;
  font-size: 0.95rem;
}


#entreprise-section-unique .sub-title {
  color: #0a192f;
  font-size: 1.1rem;
  margin: 1.5rem 0 1rem;
}

#entreprise-section-unique .logo-box {
  margin-top: 1.5rem;
  text-align: center;
}

#entreprise-section-unique .logo-box .label {
  color: #0a192f;
  font-weight: 600;
  margin-bottom: 0.8rem;
}

#entreprise-section-unique .logo-box img {
  max-width: 200px;
  max-height: 200px;
  border: 1px dashed #e2e8f0;
  padding: 1rem;
  border-radius: 8px;
  background: #f8fafc;
}


#profil-section-unique .alert {
  margin-bottom: 1rem;
  padding: 0.75rem 1rem;
  border-radius: 6px;
  display: flex;
  align-items: center;
  gap: 10px;
}

#profil-section-unique .alert.success {
  background-color: #e9f7ef;
  color: #1e7e34;
}

#profil-section-unique .alert.error {
  background-color: #fcebea;
  color: #c82333;
}

#profil-section-unique .form-block {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

#profil-section-unique .form-row {
  display: flex;
  align-items: center;
  gap: 10px;
}

#profil-section-unique .form-row input,
#profil-section-unique .form-row select {
  flex: 1;
  padding: 8px 10px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 14px;
}

#profil-section-unique button {
  background-color: #004080;
  color: white;
  padding: 10px 15px;
  font-weight: bold;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  margin-top: 10px;
}

#profil-section-unique button i {
  margin-right: 6px;
}


@media (max-width: 900px) {
  .profile-wrapper {
    flex-direction: column;
  }
}

@media (max-width: 768px) {
  #entreprise-section-unique .info-grid {
    grid-template-columns: 1fr;
  }
}
</style>