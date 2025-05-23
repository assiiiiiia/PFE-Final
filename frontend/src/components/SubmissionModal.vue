<template>
  <teleport to="body">
    <transition name="modal">
      <div v-if="show" class="modal-backdrop" @click.self="$emit('close')">
        <div class="modal">
          <div class="modal-header">
            <h2 class="modal-title">{{ $t('submissionModal.title') }}</h2>
            <button class="close-btn" @click="$emit('close')">&times;</button>
          </div>
          <div class="modal-body">
        
            <div class="info-section">
              <h3 class="section-title">
                <i class="fas fa-user-circle"></i>
                {{ $t('submissionModal.userInfo') }}
                <i class="fa-solid fa-circle-chevron-down extra-toggle" 
                   :class="{ 'rotated': showUserExtra }" 
                   @click="showUserExtra = !showUserExtra"></i>
              </h3>
              <div class="info-grid">
                <div class="info-item">
                  <span class="info-label">{{ $t('submissionModal.name') }} :</span>
                  <span class="info-value">{{ user?.nom }} {{ user?.prenom }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">{{ $t('submissionModal.email') }} :</span>
                  <span class="info-value">{{ user?.email }}</span>
                </div>
              </div>
              <div v-if="showUserExtra" class="extra-info">
                <div class="info-item" v-if="user?.telephone">
                  <span class="info-label">{{ $t('submissionModal.phone') }} :</span>
                  <span class="info-value">{{ user?.telephone }}</span>
                </div>
                <div class="info-item" v-if="user?.civilite">
                  <span class="info-label">{{ $t('submissionModal.civility') }} :</span>
                  <span class="info-value">{{ user?.civilite }}</span>
                </div>
                <div class="info-item" v-if="user?.fonction">
                  <span class="info-label">{{ $t('submissionModal.function') }} :</span>
                  <span class="info-value">{{ user?.fonction }}</span>
                </div>
              </div>
            </div>

            <div class="info-section">
              <h3 class="section-title">
                <i class="fas fa-file-contract"></i>
                {{ $t('submissionModal.offerDetails') }}
                <i class="fa-solid fa-circle-chevron-down extra-toggle" 
                   :class="{ 'rotated': showTenderExtra }" 
                   @click="showTenderExtra = !showTenderExtra"></i>
              </h3>
              <div class="info-grid">
                <div class="info-item">
                  <span class="info-label">{{ $t('submissionModal.offerNumber') }} :</span>
                  <span class="info-value">{{ tender?.numero_offre }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">{{ $t('submissionModal.offerTitle') }} :</span>
                  <span class="info-value">{{ tender?.titre_offre }}</span>
                </div>
              </div>
              <div v-if="showTenderExtra" class="extra-info">
                <div class="info-item" v-if="tender?.description">
                  <span class="info-label">{{ $t('submissionModal.description') }} :</span>
                  <span class="info-value">{{ tender?.description }}</span>
                </div>
                <div class="info-item" v-if="tender?.date_publication">
                  <span class="info-label">{{ $t('submissionModal.publicationDate') }} :</span>
                  <span class="info-value">{{ tender?.date_publication }}</span>
                </div>
                <div class="info-item" v-if="tender?.date_limite">
                  <span class="info-label">{{ $t('submissionModal.deadline') }} :</span>
                  <span class="info-value">{{ tender?.date_limite }}</span>
                </div>
                <div class="info-item" v-if="tender?.date_prorogation">
                  <span class="info-label">{{ $t('submissionModal.extensionDate') }} :</span>
                  <span class="info-value">{{ tender?.date_prorogation }}</span>
                </div>
                <div class="info-item" v-if="tender?.type_offre">
                  <span class="info-label">{{ $t('submissionModal.offerType') }} :</span>
                  <span class="info-value">{{ tender?.type_offre }}</span>
                </div>
                <div class="info-item" v-if="tender?.wilaya">
                  <span class="info-label">{{ $t('submissionModal.wilaya') }} :</span>
                  <span class="info-value">{{ tender?.wilaya }}</span>
                </div>
                <div class="info-item" v-if="tender?.etat_offre">
                  <span class="info-label">{{ $t('submissionModal.offerStatus') }} :</span>
                  <span class="info-value">{{ tender?.etat_offre }}</span>
                </div>
                <div class="info-item" v-if="tender?.document_pdf">
                  <span class="info-label">{{ $t('submissionModal.document') }} :</span>
                  <a :href="tender.document_pdf" target="_blank" class="info-value">{{ $t('submissionModal.viewDocument') }}</a>
                </div>
              </div>
            </div>

            <div class="info-section">
              <h3 class="section-title">
                <i class="fas fa-info-circle"></i>
                {{ $t('submissionModal.additionalDetails') }}
              </h3>
              <textarea v-model="proposition" 
                        :placeholder="$t('submissionModal.enterDetails')"
                        rows="4"></textarea>
            </div>

            <div class="upload-section">
              <h3 class="section-title">
                <i class="fas fa-cloud-upload-alt"></i>
                {{ $t('submissionModal.submissionDocuments') }}
              </h3>
              <div v-for="(fileField, index) in filesWithTitles" :key="index" class="file-card">
                <input type="text" v-model="fileField.title" :placeholder="$t('submissionModal.documentTitle')" />
                <input type="file" @change="(event) => handleFileUpload(event, index)" />
                <button class="remove-btn" @click="removeFileField(index)" :title="$t('submissionModal.removeDocument')">
                  <i class="fas fa-trash"></i>
                </button>
              </div>
              <button class="add-btn" @click="addFileField">
                <i class="fas fa-plus-circle"></i> {{ $t('submissionModal.addDocument') }}
              </button>
            </div>

            <div class="modal-footer">
              <button class="btn cancel-btn" @click="$emit('close')">
                <i class="fas fa-times"></i>
                {{ $t('submissionModal.cancel') }}
              </button>
              <button class="btn submit-btn" @click="submit">
                <i class="fas fa-paper-plane"></i>
                {{ $t('submissionModal.submit') }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </teleport>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
const apiUrl = import.meta.env.VITE_API_URL;

const user = ref(null);
const props = defineProps({
  show: Boolean,
  tender: Object
});
const emit = defineEmits(["close", "submitted"]);


const showUserExtra = ref(false);
const showTenderExtra = ref(false);

const proposition = ref("");

const selectedLots = ref([]);
const selectAllLots = ref(false);


const selectAll = () => {
  if (selectAllLots.value) {
    selectedLots.value = props.tender.lots.map(lot => lot.id);
  } else {
    selectedLots.value = [];
  }
};

const filesWithTitles = ref([{ title: "", file: null }]);

const addFileField = () => {
  filesWithTitles.value.push({ title: '', file: null });
};

const removeFileField = (index) => {
  filesWithTitles.value.splice(index, 1);
};

const handleFileUpload = (event, index) => {
  const file = event.target.files[0];
  filesWithTitles.value[index].file = file;
};


const loading = ref(false);
const submit = async () => {

  if (filesWithTitles.value.every(field => !field.file)) {
    alert("Veuillez ajouter au moins un document.");
    return;
  }

  loading.value = true;
  const formData = new FormData();

  formData.append("offre_id", props.tender?.id);
  formData.append("user_id", user.value?.id);

  if (proposition.value) {
    formData.append("proposition", proposition.value);
  }

 
  filesWithTitles.value.forEach((field) => {
    if (field.file && field.title) {
      formData.append('documents[]', field.file);
      formData.append('documents_titles[]', field.title);
    }
  });

  try {
    const token = localStorage.getItem("token");
    const response = await axios.post(`${apiUrl}/api/soumissions`, formData, {
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "multipart/form-data",
      },
    });
    alert("Soumission envoyée avec succès !");
    emit("submitted");
  } catch (error) {
    console.error("Erreur lors de la soumission :", error);
    alert("Erreur lors de la soumission.");
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  const storedUser = localStorage.getItem('user');
  const token = localStorage.getItem('token');

  if (storedUser) {
    user.value = JSON.parse(storedUser);
  }

  if (token) {
    axios.get(`${apiUrl}/api/user`, {
      headers: { Authorization: `Bearer ${token}` }
    })
    .then(response => {
      user.value = response.data.user || response.data;
      localStorage.setItem('user', JSON.stringify(user.value));
    })
    .catch(err => {
      console.error("Erreur lors de la récupération de l'utilisateur:", err);
      if (err.response?.status === 401) {
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        user.value = null;
      }
    });
  } else {
    console.warn("Aucun token trouvé, utilisateur non connecté.");
  }
});
</script>


<style scoped>
.modal-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  transition: all 0.3s ease;
}

.modal {
  background: white;
  border-radius: 12px;
  width: 90%;
  max-width: 700px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
  transform: scale(0.95);
  animation: modalEnter 0.3s ease forwards;
}

@keyframes modalEnter {
  to {
    transform: scale(1);
  }
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  border-bottom: 1px solid #e2e8f0;
}

.modal-title {
  font-size: 1.4rem;
  color: #283b5b;

  margin: 0;
}

.close-btn {
  background: none;
  border: none;
  font-size: 1.5rem;
  color: #718096;
  cursor: pointer;
  transition: all 0.2s ease;
}

.close-btn:hover {
  color: #dc3545;
  transform: rotate(90deg);
}

.modal-body {
  padding: 1rem;
  max-height: 60vh;
  overflow-y: auto;
}

.info-section {
  margin-bottom: 1rem;
  background: #f8fafc;
  border-radius: 8px;
  padding: 0.75rem;
}

.section-title {
  font-size: 1rem;
 color: #11518f;
  margin-bottom: 0.5rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.extra-toggle {
  cursor: pointer;
  font-size: 0.9rem;
 color: #11518f;
  transition: transform 0.3s ease;
}

.extra-toggle.rotated {
  transform: rotate(180deg);
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 0.5rem;
}

.info-item {
  display: flex;
  flex-direction: column;
}

.info-label {
  font-weight: 600;
  color: #2d3748;
  margin-bottom: 0.25rem;
  font-size: 0.9rem;
}
.info-section textarea{
  width: 95%;
  min-height: 80px;
  padding: 0.75rem 1rem;
  border: 1.5px solid #cbd5e0;
  border-radius: 8px;
  font-size: 1rem;
  color: #2d3748;
  background: #ffffff;
  resize: vertical;
  transition: border-color 0.2s;
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
}

.info-section textarea:focus {
  border-color: #1563b2;
  outline: none;
  background: #f0f7ff;
}

.info-value {
  color: #718096;
  font-size: 0.9rem;
  word-break: break-word;
}

.extra-info {
  margin-top: 0.5rem;
  border-top: 1px solid #e2e8f0;
  padding-top: 0.5rem;
}

.upload-section {
  margin-top: 1rem;
  background: #f8fafc;
  border-radius: 10px;
  padding: 1.5rem 1rem;
  box-shadow: 0 2px 8px rgba(21, 99, 178, 0.06);
 
}

.upload-section h3.section-title {
  color: #11518f;
  font-size: 1.1rem;
  margin-bottom: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.file-card {
  background: #f9f9fb;
  border: 1px solid #e2e8f0;
  border-radius: 10px;
  padding: 1rem;
  margin-bottom: 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  position: relative;
  box-shadow: 0 1px 4px rgba(105, 105, 105, 0.333);
}

.file-card input[type="text"] {
  border: 1px solid #bcd0e5;
  border-radius: 6px;
  padding: 0.5rem 0.75rem;
  font-size: 0.95rem;
  margin-bottom: 0.5rem;
  background: #fff;
  transition: border-color 0.2s;
}

.file-card input[type="text"]:focus {
  border-color: #1563b2;
  outline: none;
}

.file-card input[type="file"] {
  border: 1px solid #bcd0e5;
  border-radius: 6px;
  padding: 0.5rem 0.75rem;
  font-size: 0.95rem;
  background: #ffffff;
  margin-bottom: 0.5rem;
 
}

.remove-btn {
  position: absolute;
  top: 0.5rem;
  right: 0.5rem;
  background: #fff;
  border: 1px solid #e53e3e;
  color: #e53e3e;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  font-size: 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: 0.3s ease;
}

.remove-btn:hover {
  background: #e53e3e;
  color: white;
}

.add-btn {
  margin-top: 0.5rem;
  background: #edf2f7;
  color: #1563b2;
  border: 1px dashed #1563b2;
  border-radius: 6px;
  padding: 0.5rem 1rem;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.add-btn:hover {
  background: #e0f0ff;
}
.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
  padding: 0.75rem;
  border-top: 1px solid #e2e8f0;
}

.btn {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.25rem;
  transition: all 0.2s ease;
  font-size: 0.9rem;
}

.submit-btn {
  background: #1563b2;
  color: white;
}

.submit-btn:hover {
  background: #11518f;
  transform: translateY(-1px);
}

.cancel-btn {
  background: none;
  color: #a71f2d;
  border: 1px solid #e2e8f0;
}

.cancel-btn:hover {
  background: #f8fafc;
  color: #dc3545;
  border-color: #dc3545;
}

@media (max-width: 480px) {
  .modal {
    width: 95%;
  }
  
  .modal-footer {
    flex-direction: column;
  }
  
  .btn {
    width: 100%;
    justify-content: center;
  }
}
</style>
