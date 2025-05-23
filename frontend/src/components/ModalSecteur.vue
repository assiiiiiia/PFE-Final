<template>
  <div v-if="show" class="modal-overlay">
    <div class="modal">
      <header class="modal-header">
        <h2 class="fs-title">
          {{ mode === 'add' ? 'Ajouter un secteur' : 'Modifier un secteur' }}
        </h2>
        <button class="close-btn" @click="closeModal">X</button>
      </header>
      <form @submit.prevent="submitForm">
        <div class="modal-body">
        
          <div class="form-row">
            <div class="form-group full-width">
              <label for="nom">Nom du secteur</label>
              <input
                type="text"
                id="nom"
                v-model="localSecteur.nom"
                required
              
              />
            </div>
          </div>
       
          <div class="form-row">
            <div class="form-group full-width">
              <label for="abreviation">Abréviation</label>
              <input
                type="text"
                id="abreviation"
                v-model="localSecteur.abreviation"
                required
               
              />
            </div>
          </div>
     >
          <div class="form-group">
            <label for="logo">Logo</label>
            <input type="file" id="logo" @change="handleFileUpload" accept="image/*" />
            <img
              v-if="logoPreview"
              :src="logoPreview"
              alt="Logo Preview"
              class="logo-preview"
            />
          </div>
        </div>
        <footer class="modal-footer">
          <button type="submit" class="btn submit">
            {{ mode === 'edit' ? 'Enregistrer' : 'Ajouter' }}
          </button>
          <button type="button" class="btn cancel" @click="closeModal">Annuler</button>
          
        </footer>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ModalSecteur',
  props: {
    show:       { type: Boolean, default: false },
    mode:       { type: String,  default: 'add' },

    apiUrl:     { type: String,  default: () => import.meta.env.VITE_API_URL },
    secteur:    { type: Object,  default: () => ({}) },
  },
  data() {
    const s = this.secteur || {};
    let preview = null;
    if (s.logo instanceof File) {
      preview = URL.createObjectURL(s.logo);
    } else if (typeof s.logo === 'string' && s.logo) {
      preview = this.getLogoUrl(s.logo);
    }
    return {
      logoPreview: preview,
      localSecteur: {
        id:          s.id || null,
        nom:         s.nom || '',
        abreviation: s.abreviation || '',
        logo:        s.logo || '',
      },
    };
  },
  watch: {
    secteur: {
      immediate: true,
      deep: true,
      handler(newS) {
 
        if (!newS) {
          this.logoPreview = null;
          return;
        }
        let preview = null;
        if (newS.logo instanceof File) {
          preview = URL.createObjectURL(newS.logo);
        } else if (typeof newS.logo === 'string' && newS.logo) {
          preview = this.getLogoUrl(newS.logo);
        }
        this.localSecteur = {
          id:          newS.id || null,
          nom:         newS.nom || '',
          abreviation: newS.abreviation || '',
          logo:        newS.logo || '',
        };
        this.logoPreview = preview;
      },
    },
  },

  methods: {
    closeModal() {
      this.$emit('close');
    },
    handleFileUpload(evt) {
      const file = evt.target.files[0];
      if (file) {
        this.localSecteur.logo = file;
        this.logoPreview = URL.createObjectURL(file);
      }
    },
    getLogoUrl(path) {
      if (!path || path === 'null') {
        return `${this.apiUrl}/storage/logo/default.png`;
      }
      const filename = path.split('/').pop();
      return `${this.apiUrl}/storage/logo/${filename}`;
    },
    submitForm() {
      if (!this.localSecteur.nom || !this.localSecteur.abreviation) {
        alert("Veuillez remplir le nom et l'abréviation du secteur.");
        return;
      }
      this.$emit('save', {
        mode:    this.mode,
        secteur: this.localSecteur,
      });
      this.closeModal();
    },
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
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal {
  background: #ffffff;
  padding: 3rem;
  border-radius: 8px;
  width: 800px;

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

.modal-header .fs-title {
  margin: 0;
  font-size: 1.4rem;
  color: #2c3e50;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.close-btn {
  position: absolute;
  top: 1.5rem;
  right: 1.5rem;
  background: none;
  border: none;
  font-size: 1.2rem;
  cursor: pointer;
  color: #4a5568;
}

.modal-body {
  padding: 1.5rem 0;
  overflow-y: auto;
  flex: 1;
}


.form-group {
  width: 100%;
}

label {
  font-weight: 500;
  margin-bottom: 4px;
  display: block;
  color: #4a5568;
  font-size: 0.95rem;
  letter-spacing: 0.2px;
}

input[type="text"],
input[type="file"] {
  width: 100%;
  padding: 8px 12px;
  border: 2px solid #e2e8f0;
  border-radius: 6px;
  font-size: 0.95rem;
  transition: all 0.2s ease;
  background-color: #f8fafc;
  box-sizing: border-box;
}

input:focus {
  border-color: #2c5282;
  box-shadow: 0 0 0 3px rgba(44, 82, 130, 0.1);
  outline: none;
  background-color: #ffffff;
}

.logo-preview {
  display: block;
  max-width: 150px;
  margin-top: 0.5rem;
  border: 1px solid #e2e8f0;
  border-radius: 4px;
}

.modal-footer {
  padding-top: 1.5rem;
  border-top: 1px solid #e0e0e0;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.btn {
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

.btn.submit {
  background: #2c5282;
  color: #ffffff;
}

.btn.submit:hover {
  background: #1a365d;
  transform: translateY(-1px);
}

.btn.cancel {
  background: #ffffff;
  color: #4a5568;
  border: 2px solid #e2e8f0;
}

.btn.cancel:hover {
  background: #f7fafc;
  border-color: #cbd5e0;
}
</style>
