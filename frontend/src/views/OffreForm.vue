<template>
  <div class="form-wrapper">
    <form @submit.prevent="submitForm" class="form-container">
      <h2><i class="fa-solid fa-plus"></i>Créer une Offre</h2>


      <div v-if="Object.keys(formErrors).length" class="error-summary">
        <ul>
          <li v-for="(messages, field) in formErrors" :key="field">
            <strong>{{ field }} :</strong> {{ messages.join(', ') }}
          </li>
        </ul>
      </div>

      <div class="form-group">
        <div class="form-group">
          <label>Type d'offre :</label>
          <select v-model="form.type_offre" required>
            <option value="" disabled selected>Choisissez un type</option>
            <option value="Appel d'offre">Appel d'offre</option>
            <option value="Avis de consultation">Avis de consultation</option>
            <option value="Avis de manifestation">Avis de manifestation</option>
          </select>

          <span class="error" v-if="formErrors.type_offre">{{ formErrors.type_offre.join(', ') }}</span>
        </div>
      </div>

      <div class="row">
        <div class="form-group">
          <label>Langue :</label>
          <select v-model="form.langue" required>
            <option value="francais">Français</option>
            <option value="arabe">Arabe</option>
          </select>
          <span class="error" v-if="formErrors.langue">{{ formErrors.langue.join(', ') }}</span>
        </div>
        <div class="form-group">
          <label>État de l'offre :</label>
          <select v-model="form.etat_offre" required>
            <option>En Cours</option>
            <option>Attribué</option>
            <option>Infructueux</option>
            <option>Annulé</option>
          </select>
          <span class="error" v-if="formErrors.etat_offre">{{ formErrors.etat_offre.join(', ') }}</span>
        </div>
        <div class="form-group">
          <label>Wilaya :</label>
          <select v-model="form.wilaya" required>
            <option value="" disabled :selected="!form.wilaya">Choisissez une wilaya</option>
            <option v-for="(wilaya, index) in wilayas" :key="index" :value="wilaya">
              {{ wilaya }}
            </option>
          </select>
          <span class="error" v-if="formErrors.wilaya">{{ formErrors.wilaya.join(', ') }}</span>
        </div>
      </div>

      <div class="row">
        <div class="form-group">
          <label>Numéro d'offre :</label>
          <input v-model="form.numero_offre" type="text" required placeholder="Ex: 2024-001" />
          <span class="error" v-if="formErrors.numero_offre">{{ formErrors.numero_offre.join(', ') }}</span>
        </div>
      </div>

      <div class="form-group">
        <label>Titre de l'offre :</label>
        <input v-model="form.titre_offre" type="text" required placeholder="Ex: Fourniture de matériel télécom" />
        <span class="error" v-if="formErrors.titre_offre">{{ formErrors.titre_offre.join(', ') }}</span>
      </div>

      <div class="row">
        <div class="form-group">
          <label>Niveau :</label>
          <select v-model="form.niveau" required>
            <option selected>National</option>
            <option>International</option>
          </select>
          <span class="error" v-if="formErrors.niveau">{{ formErrors.niveau.join(', ') }}</span>
        </div>
      </div>

      <div class="row">
        <div class="form-group">
          <label>Date de publication :</label>
          <input v-model="form.date_publication" type="date" required />
          <span class="error" v-if="formErrors.date_publication">{{ formErrors.date_publication.join(', ') }}</span>
        </div>
        <div class="form-group">
          <label>Date limite :</label>
          <input v-model="form.date_limite" type="date" required />
          <span class="error" v-if="formErrors.date_limite">{{ formErrors.date_limite.join(', ') }}</span>
        </div>
      </div>

      <div class="form-group">
        <label>Date de prorogation :</label>
        <input v-model="form.date_prorogation" type="date" />
      </div>

      <div class="form-group">
        <label>Description :</label>
        <textarea v-model="form.description" required placeholder="Détaillez ici les informations de l'appel d'offre"></textarea>
        <span class="error" v-if="formErrors.description">{{ formErrors.description.join(', ') }}</span>
      </div>

      <div class="form-group">
        <label>État :</label>
        <select v-model="form.etat" required>
          <option value="En rédaction">En rédaction</option>
          <option value="Publiée">Publiée</option>
          <option value="Supprimée">Supprimée</option>
        </select>
        <span class="error" v-if="formErrors.etat">{{ formErrors.etat.join(', ') }}</span>
      </div>

   
      <div class="checkbox-group" @click="toggleLots">
  <input type="checkbox" v-model="ajouterLots" id="ajouterLots">
  <label for="ajouterLots">
    <i class="fas fa-cube"></i> Ajouter des lots
  </label>
</div>

      <div v-if="ajouterLots" class="lot-section">
        <h3><i class="fas fa-boxes"></i> Liste des lots</h3>
        <div v-for="(lot, index) in form.lots" :key="index" class="lot-container">
          <div class="row">
            <div class="form-group">
              <label>Numéro du lot :</label>
              <input v-model="lot.numero_lot" type="text" required placeholder="Ex: LOT-01" />
              <span class="error" v-if="formErrors[`lots.${index}.numero_lot`]"></span>
            </div>
            <div class="form-group">
              <label>Description du lot :</label>
              <textarea v-model="lot.description" required placeholder="Description détaillée du lot"></textarea>
              <span class="error" v-if="formErrors[`lots.${index}.description`]"></span>
            </div>
          </div>
          <button type="button" @click="supprimerLot(index)" class="delete-lot">
            <i class="fas fa-trash-alt"></i>
          </button>
        </div>
        <button type="button" @click="ajouterLot" class="add-lot">
          <i class="fas fa-plus-circle"></i>  Ajouter un lot
        </button>
      </div>

      <div class="form-group">
        <label>Document PDF :</label>
        <input type="file" @change="fileSelected" accept=".pdf" required />
        <span class="error" v-if="formErrors.document_pdf">{{ formErrors.document_pdf.join(', ') }}</span>
      </div>

      <button type="submit">Envoyer</button>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import axios from "axios";
const apiUrl = import.meta.env.VITE_API_URL;

const form = ref({
  langue: "francais",
  etat_offre: "En Cours",
  wilaya: "",
  numero_offre: "",
  titre_offre: "",
  type_offre: "",
  niveau: "National",
  date_publication: "",
  date_limite: "",
  date_prorogation: "",
  description: "",
  etat: "En rédaction",
  document_pdf: null,
  a_des_lots: false, 
  lots: [],
  secteur_id: null, 
});


const formErrors = ref({});

const ajouterLots = ref(false); 

const toggleLots = () => {
  ajouterLots.value = !ajouterLots.value;
  this.form.a_des_lots = this.ajouterLots;
};

const ajouterLot = () => {
  form.value.lots.push({ numero_lot: "", description: "", document_lot: null });
};

const supprimerLot = (index) => {
  form.value.lots.splice(index, 1);
};

const fileSelectedLot = (event, index) => {
  if (event.target.files.length > 0) {
    form.value.lots[index].document_lot = event.target.files[0];
  }
};

const fileSelected = (event) => {
  if (event.target.files.length > 0) {
    if (form.value.langue === "arabe") {
      form.value.document_pdf_ar = event.target.files[0];
    } else {
      form.value.document_pdf = event.target.files[0];
    }
  }
};

const user = ref({});
const entreprises = ref([]);
const wilayas = ref([
  "Adrar", "Chlef", "Laghouat", "Oum El Bouaghi", "Batna", "Bejaia",
  "Biskra", "Béchar", "Blida", "Bouira", "Tamanrasset", "Tébessa", "Tlemcen",
  "Tiaret", "Tizi Ouzou", "Alger", "Djelfa", "Jijel", "Sétif", "Saïda",
  "Skikda", "Sidi Bel Abbes", "Annaba", "Guelma", "Constantine", "Medea",
  "Mostaganem", "M'Sila", "Mascara", "Ouargla", "Oran", "El Bayadh", "Illizi",
  "Bordj Bou Arreridj", "Boumerdes", "El Tarf", "Tindouf", "Tissemsilt",
  "El Oued", "Khenchela", "Souk Ahras", "Tipaza", "Mila", "Aïn Defla",
  "Naama", "Aïn Temouchent", "Ghardaia", "Relizane", "Timimoun",
  "Bordj Badji Mokhtar", "Ouled Djellal", "Béni Abbès", "In Salah",
  "In Guezzam", "Touggourt", "Djanet", "El M'Ghair", "El Menia"
]);

const fetchUserData = async () => {
  try {
    const token = localStorage.getItem("token");
    if (!token) {
      alert("Utilisateur non authentifié.");
      return;
    }

    const response = await axios.get('/user', {
      headers: { Authorization: `Bearer ${token}` },
    });

    user.value = response.data;
    if (user.value.secteur_id) {
      form.value.secteur_id = user.value.secteur_id;
    } else {
      console.warn("L'utilisateur n'a pas de secteur associé !");
    }
  } catch (error) {
    console.error("Erreur lors de la récupération des données utilisateur :", error);
  }
};

const fetchEntreprises = async () => {
  try {
    const token = localStorage.getItem("token");
    const response = await axios.get(`${apiUrl}/api/entreprises`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    entreprises.value = response.data;
  } catch (error) {
    console.error("Erreur de chargement des entreprises :", error);
  }
};

onMounted(() => {
  fetchUserData();
  fetchEntreprises();
});

const submitForm = async () => {
  try {
   
    formErrors.value = {};

    if (!form.value.secteur_id) {
      alert("Erreur : l'identifiant du secteur est requis.");
      return;
    }

    const formData = new FormData();
    formData.append("langue", form.value.langue);
    formData.append("etat_offre", form.value.etat_offre);
    formData.append("wilaya", form.value.wilaya);
    formData.append("numero_offre", form.value.numero_offre);
    formData.append("titre_offre", form.value.titre_offre);
    formData.append("type_offre", form.value.type_offre);
    formData.append("niveau", form.value.niveau);
    formData.append("date_publication", form.value.date_publication);
    formData.append("date_limite", form.value.date_limite);
    if (form.value.date_prorogation) {
      formData.append("date_prorogation", form.value.date_prorogation);
    }
    formData.append("description", form.value.description);
    formData.append("etat", form.value.etat);
    formData.append("secteur_id", form.value.secteur_id);

    if (form.value.document_pdf) {
      formData.append("document_pdf", form.value.document_pdf);
    }
    form.value.lots.forEach((lot, index) => {
      formData.append(`lots[${index}][numero_lot]`, lot.numero_lot);
      formData.append(`lots[${index}][description]`, lot.description);
      if (lot.document_lot) {
        formData.append(`lots[${index}][document_lot]`, lot.document_lot);
      }
    });

    const token = localStorage.getItem("token");
    console.log("FormData envoyé :", Object.fromEntries(formData.entries()));

    await axios.post(`${apiUrl}/api/offres`, formData, {
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "multipart/form-data",
      },
    });
    alert("Appel d'offre créé avec succès !");
  } catch (error) {
    console.error("Erreur lors de la soumission :", error);

    if (error.response && error.response.data && error.response.data.errors) {
      formErrors.value = error.response.data.errors;
    } else {
    
      formErrors.value = { general: ["Une erreur est survenue lors de la soumission. Veuillez réessayer plus tard."] };
    }
  }
};
</script>

<style scoped>

* {
  box-sizing: border-box;
}

.form-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  padding: 2rem;

}

.form-container {
  width: 100%;
  max-width: 1300px;
  margin-top: 40px;
  padding: 2rem;
  background: #ffffff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  border-radius: 8px;
  
  color: #2c3e50;
}

h2 {
  font-family: 'Georgia', serif;
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  padding-bottom: 0.9rem;
  color: #0c1d4d;
  border-bottom: 1px solid #ccc;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.row {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 0.5rem;
}

.form-group {
  flex: 1;
  min-width: 250px;
  margin-bottom: 0.5rem;
}

label {
  display: block;
  margin-bottom: 0.6rem;
  display: flex;
  color: #636363bf;;
  font-weight: bold;
  font-size: 0.95rem;
}

input,
select,
textarea {
  width: 100%;
  padding: 0.9rem;
  height: 50px;
  border: 1px solid #e3e2e2b6;
  border-radius: 4px;
  font-size: 0.95rem;
  background: #ffffff;
}

input:focus,
select:focus,
textarea:focus {
  border-color:#0c1d4d;
  outline: none;
  background: #fff;
}

button[type="submit"] {
  background: #162e6e;
  color: #fff;
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.3s ease;
  margin-top: 1rem;
}

button[type="submit"]:hover {
  background: #2e3b9c;
}

.checkbox-group {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin: 1.5rem 0;
  padding: 0.55rem;
  background: #f9f9f9;
  border: 1px solid #ccc;
  border-radius: 4px;
  cursor: pointer;
}

.checkbox-group input[type="checkbox"] {
  width: 16px;
  height: 18px;
}
i.fas.fa-cube {
  margin-right: 10px;
}

.checkbox-group label {
  display: inline-flex; 
  align-items: center;
  margin: 0;
}
.lot-section {
  margin-top: 1.5rem;
  padding-top: 1rem;
  border-top: 1px solid #ccc;
}

.lot-container {
  background: #f9f9f9;
  border: 1px solid #ccc;
  border-radius: 4px;
  padding: 1rem;
  margin-bottom: 1rem;
  position: relative;
}

.delete-lot {
  position: absolute;
  top: 5px;
  right: 5px;
  background: #c71c1c;
  color: #fff;
  border: none;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  cursor: pointer;
}

.delete-lot:hover {
  background: #a93226;
}

.add-lot {
  background: #27ae60;
  color: #fff;
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
  font-size: 0.95rem;
  cursor: pointer;
  transition: background 0.3s ease;
  margin-top: 1rem;
}

.add-lot:hover {
  background: #1e8449;
}

input[type="file"] {
  border: 1px solid #ccc;
  padding: 0.5rem;
  background: #fafafa;
  border-radius: 4px;
  cursor: pointer;
}

input[type="file"]:hover {
  background: #f0f0f0;
}

input[type="file"]::file-selector-button {
  background: #162e6e;
  color: #fff;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  transition: background 0.3s ease;
}

input[type="file"]::file-selector-button:hover {
  background: rgb(60, 90, 122);
}

@media (max-width: 768px) {
  .form-container {
    padding: 1.5rem;
    max-width: 100%;
  }
  
  .row {
    flex-direction: column;
  }
}

.lot-section {
  margin-top: 2rem;
  border-top: 3px solid #e2e8f0;
  padding-top: 2.5rem;
}

.lot-container {
  background: #f8fafc;
  border-radius: 12px;
  padding: 2rem;
  margin-bottom: 1.8rem;
  position: relative;
  border: 2px solid #e2e8f0;
  animation: slideIn 0.3s ease-out;
  transition: all 0.3s ease;
}

.lot-container:hover {
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
}

.delete-lot {
  position: absolute;
  top: -12px;
  right: -12px;
  background: #fc8181;
  color: white;
  border: none;
  border-radius: 50%;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
}

.delete-lot:hover {
  background: #f56565;
  transform: scale(1.1);
}

.add-lot {
  background: #48bb78;
  color: white;
  padding: 0.9rem 1.5rem;
  border-radius: 8px;
  font-size: 1rem;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.8rem;
  margin: 1.5rem auto 0;
}

.add-lot:hover {
  background: #38a169;
  transform: translateY(-2px);
}
.error-summary {
  background: #ffebeb;
  border: 1px solid #ff5c5c;
  color: #ff1c1c;
  padding: 1rem;
  margin-bottom: 1rem;
  border-radius: 4px;
}

.error {
  color: #ff1c1c;
  font-size: 0.9rem;
  margin-top: 0.3rem;
  display: block;
}
</style>
