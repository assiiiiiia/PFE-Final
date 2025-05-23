<template>
  <div class="custom-modal-overlay">
    <div class="custom-modal">
      <div class="modal-header">
        <h3>{{ mode === 'addAdmin' ? 'Ajouter un administrateur' : 'Modifier un administrateur' }}</h3>
      </div>

      <div class="modal-content">
        <form @submit.prevent="submitForm">
          <label>Email :</label>
          <input type="email" v-model="formData.email" required />

          <div v-if="mode === 'addAdmin'" class="form-row">
            <div class="form-group">
              <label>Mot de passe :</label>
              <input type="password" v-model="formData.password" required />
            </div>
            <div class="form-group">
              <label>Confirmer le mot de passe :</label>
              <input type="password" v-model="formData.password_confirmation" required />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Nom :</label>
              <input type="text" v-model="formData.nom" required />
            </div>
            <div class="form-group">
              <label>Prénom :</label>
              <input type="text" v-model="formData.prenom" required />
            </div>
          </div>

          <label>Téléphone :</label>
          <input type="text" v-model="formData.telephone" required />

          <label for="fonction">Fonction</label>
          <input type="text" id="fonction" v-model="formData.fonction">

          <label>Statut :</label>
          <select v-model="formData.status" required>
            <option value="actif">Actif</option>
            <option value="inactif">Inactif</option>
          </select>

          <label>Secteur associé :</label>
          <select v-model="formData.secteur_id" required>
            <option value="" disabled>Choisissez un secteur</option>
            <option v-for="(secteur, index) in secteurs" :key="index" :value="secteur.id">
              {{ secteur.nom }}
            </option>
          </select>

          <div v-if="feedbackMessage" class="feedback-message feedback-success">
       
            <span>{{ feedbackMessage }}</span>
          </div>

          <div v-if="errorMessage" class="feedback-message feedback-error">
         
            <span>{{ errorMessage }}</span>
          </div>
        </form>
      </div>

      <div class="modal-footer">
        <div class="button-row">
          <button type="submit" @click="submitForm">{{ mode === 'addAdmin' ? 'Ajouter' : 'Modifier' }}</button>
          <button type="button" @click="handleCancel">Annuler</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, watch, onMounted } from 'vue';
import axios from 'axios';
const apiUrl = import.meta.env.VITE_API_URL;

export default {
  props: {
    user: Object,
    mode: String, 
  },
  emits: ['close', 'user-updated'],
  setup(props, { emit }) {
    const defaultFormData = () => ({
      nom: '',
      prenom: '',
      email: '',
      telephone: '',
      status: 'actif',
      fonction:'',
      password: '',
      password_confirmation: '',
      secteur_id: '', 
    });

    const formData = ref(defaultFormData());
    const feedbackMessage = ref('');
    const errorMessage = ref('');
    const secteurs = ref([]);

    const fetchSecteurs = async () => {
      try {
        const token = localStorage.getItem("token");
        const response = await axios.get(`${apiUrl}/api/secteurs`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        secteurs.value = response.data;
      } catch (error) {
        console.error("Erreur de chargement des secteurs :", error);
      }
    };

    watch(
      () => props.user,
      (newUser) => {
        if (props.mode === 'edit' && newUser) {
          formData.value = { ...newUser };
        } else {
          formData.value = defaultFormData();
        }
      },
      { immediate: true }
    );

    watch(
      () => props.mode,
      (newMode) => {
        if (newMode === 'addAdmin') {
          formData.value = defaultFormData();
        }
      }
    );
    onMounted(() => {
      fetchSecteurs(); 
    });
    const resetForm = () => {
      formData.value = defaultFormData();
      errorMessage.value = '';
      feedbackMessage.value = '';
    };

    const handleCancel = () => {
      resetForm();
      emit('close');
    };

    const submitForm = async () => {
      try {
        const token = localStorage.getItem("token");
        let url = '';
        let method = '';

        if (props.mode === 'edit') {
          url = `${apiUrl}/api/admin/${formData.value.id}`;
          method = 'put';
        } else {
          url = `${apiUrl}/api/admin/register`;
          method = 'post';
        }

        const response = await axios({
          method,
          url,
          data: formData.value,
          headers: { Authorization: `Bearer ${token}` },
        });

        feedbackMessage.value = props.mode === 'edit'
          ? "Administrateur mis à jour avec succès"
          : "Administrateur ajouté avec succès";
        errorMessage.value = '';

        emit('user-updated', response.data.user);

        setTimeout(() => {
          resetForm();
          emit('close');
        }, 3000);
      } catch (error) {
        console.error("Erreur lors de la soumission:", error.response.data);
        errorMessage.value = error.response.data.errors
          ? Object.values(error.response.data.errors).flat().join(' ')
          : "Une erreur est survenue lors de la soumission.";
        feedbackMessage.value = '';
      }
    };

    return {
      formData,
      submitForm,
      secteurs,
      handleCancel,
      feedbackMessage,
      errorMessage,
    };
  },
};
</script>

<style scoped>
.custom-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
 
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.custom-modal {
  background: white;
  padding: 3rem;
  border-radius: 8px;
  width: 640px;
   max-height:600px; ;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.16);
  display: flex;
  flex-direction: column;
  border: 1px solid #e0e0e0;
}

.modal-header {
  padding: 1.5rem;
  border-bottom: 1px solid #e0e0e0;
  text-align: center;
  position: relative;
}

.modal-header h3 {
  margin: 0;
  font-size: 1.4rem;
  color: #2c3e50;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.modal-content {
  padding: 1.5rem 0;
  overflow-y: auto;
  max-height: 60vh;
}

.modal-footer {
  padding: 1.5rem 0 0 0;
  border-top: 1px solid #e0e0e0;
  text-align: right;
}

.feedback-message {
  display: flex;
  align-items: center;
  padding: 12px;
  margin: 20px 0;
  border-radius: 6px;
  font-size: 0.95rem;
}

.feedback-success {
  background-color: #f0faf5;
  color: #1b7051;
  border: 1px solid #c5e6d6;
}

.feedback-error {
  background-color: #fdf0f0;
  color: #c23d3d;
  border: 1px solid #f5d7d7;
}

.feedback-message::before {
  content: '';
  display: inline-block;
  width: 20px;
  height: 20px;
  margin-right: 12px;
  background-size: contain;
}

.feedback-success::before {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%231b7051'%3E%3Cpath d='M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z'/%3E%3C/svg%3E");
}

.feedback-error::before {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23c23d3d'%3E%3Cpath d='M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z'/%3E%3C/svg%3E");
}

label {
  font-weight: 500;
  margin-bottom: 3px;
  display: block;
  color: #4a5568;
  font-size: 0.95rem;
  letter-spacing: 0.2px;
}

input, select {
  width: 100%; 
  padding: 8px 12px;
  border: 2px solid #e2e8f0;
  border-radius: 6px;
  font-size: 0.95rem;
  transition: all 0.2s ease;
  background-color: #f8fafc;
  box-sizing: border-box;
}

input:focus, select:focus {
  border-color: #2c5282;
  box-shadow: 0 0 0 3px rgba(44, 82, 130, 0.1);
  outline: none;
  background-color: white;
}

.form-row {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
  width: 100%;
  margin-bottom: 1rem;
}

.form-group {
  width: 100%;
  position: relative;
}

.button-row {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
}

button {
  padding: 10px 24px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s ease;
  font-weight: 500;
  letter-spacing: 0.5px;
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

button:first-of-type {
  background: #2c5282;
  color: white;
}

button:first-of-type:hover {
  background: #1a365d;
  transform: translateY(-1px);
}

button:last-of-type {
  background: #ffffff;
  color: #4a5568;
  border: 2px solid #e2e8f0;
}

button:last-of-type:hover {
  background: #f7fafc;
  border-color: #cbd5e0;
}

button::before {
  content: '';
  display: inline-block;
  width: 18px;
  height: 18px;
  background-size: contain;
}

button:first-of-type::before {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23fff'%3E%3Cpath d='M17 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V7l-4-4zm-5 16c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3zm3-10H5V5h10v4z'/%3E%3C/svg%3E");
}

button:last-of-type::before {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%234a5568'%3E%3Cpath d='M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z'/%3E%3C/svg%3E");
}
</style>