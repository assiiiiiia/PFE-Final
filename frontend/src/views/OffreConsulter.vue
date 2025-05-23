<template>
  <div class="form-container" :dir="form.langue === 'arabe' ? 'rtl' : 'ltr'">
    <div class="tab-container">
      <div :class="{ active: form.langue === 'francais' }" @click="switchLanguage('francais')" class="tab">FR</div>
      <div :class="{ active: form.langue === 'arabe' }" @click="switchLanguage('arabe')" class="tab">AR</div>
    </div>
    <form @submit.prevent="submitForm" class="form-container">
      <h2><i class="fa-solid fa-info-circle"></i> {{ t('information_offre') }}</h2>
    
  
      <div v-if="Object.keys(formErrors).length" class="error-summary">
        <ul>
          <li v-for="(messages, field) in formErrors" :key="field">
            <strong>{{ field }} :</strong> {{ messages.join(', ') }}
          </li>
        </ul>
      </div>
    
      <div class="form-group">
        <div class="form-group">
          <label>{{ t('type_offre') }} :</label>
          <select v-model="form.type_offre" required>
            <option value="" disabled selected>{{ t('choisissez_type') }}</option>
            <option value="Appel d'offre">{{ t('appel_offre') }}</option>
            <option value="Avis de consultation">{{ t('avis_consultation') }}</option>
            <option value="Avis de manifestation">{{ t('avis_manifestation') }}</option>
          </select>
       
          <span class="error" v-if="formErrors.type_offre">{{ formErrors.type_offre.join(', ') }}</span>
        </div>
      </div>
    
      <div class="row">
        <div class="form-group">
          <label>{{ t('langue') }} :</label>
          <select v-model="form.langue" required>
            <option value="francais">{{ t('francais') }}</option>
            <option value="arabe">{{ t('arabe') }}</option>
          </select>
          <span class="error" v-if="formErrors.langue">{{ formErrors.langue.join(', ') }}</span>
        </div>
        <div class="form-group">
          <label>{{ t('etat_offre') }} :</label>
          <select v-model="form.etat_offre" required>
            <option value="En Cours">{{ t('en_cours') }}</option>
            <option value="Attribué">{{ t('valide') }}</option>
            <option value="Infructueux">{{ t('infructueux') }}</option>
            <option value="Annulé">{{ t('annule') }}</option>
          </select>
        </div>
        <div class="form-group">
          <label>{{ t('wilaya') }} :</label>
          <select v-model="form.wilaya" required>
            <option value="" disabled :selected="!form.wilaya">{{ t('choisissez_wilaya') }}</option>
            <option v-for="(wilaya, index) in getWilayas()" :key="index" :value="wilaya">
              {{ wilaya }}
            </option>
          </select>
          <span class="error" v-if="formErrors.wilaya">{{ formErrors.wilaya.join(', ') }}</span>
        </div>
      </div>
    
      <div class="row">
        <div class="form-group">
          <label>{{ t('numero_offre') }} :</label>
          <input v-model="form.numero_offre" type="text" required :placeholder="t('exemple_numero_offre')" />
          <span class="error" v-if="formErrors.numero_offre">{{ formErrors.numero_offre.join(', ') }}</span>
        </div>
      </div>
    
      <div class="form-group">
        <label>{{ t('titre_offre') }} :</label>
        <input v-model="titreModel" type="text" required :placeholder="t('exemple_titre_offre')" />
        <span class="error" v-if="formErrors.titre_offre">{{ formErrors.titre_offre.join(', ') }}</span>
      </div>
    
      <div class="row">
        <div class="form-group">
          <label>{{ t('niveau') }} :</label>
          <select v-model="form.niveau" required>
            <option value="National">{{ t('national') }}</option>
            <option  value="International">{{ t('international') }}</option>
          </select>
          <span class="error" v-if="formErrors.niveau">{{ formErrors.niveau.join(', ') }}</span>
        </div>
      </div>
    
      <div class="row">
        <div class="form-group">
          <label>{{ t('date_publication') }} :</label>
          <input v-model="form.date_publication" type="date" required />
          <span class="error" v-if="formErrors.date_publication">{{ formErrors.date_publication.join(', ') }}</span>
        </div>
        <div class="form-group">
          <label>{{ t('date_limite') }} :</label>
          <input v-model="form.date_limite" type="date" required />
          <span class="error" v-if="formErrors.date_limite">{{ formErrors.date_limite.join(', ') }}</span>
        </div>
      </div>
    
      <div class="form-group">
        <label>{{ t('date_prorogation') }} :</label>
        <input v-model="form.date_prorogation" type="date" />
      </div>
    
      <div class="form-group">
        <label>{{ t('description') }} :</label>
        <textarea v-model="descriptionModel" required :placeholder="t('detaillez_informations')"></textarea>
        <span class="error" v-if="formErrors.description">{{ formErrors.description.join(', ') }}</span>
      </div>
    
      <div class="form-group">
        <label>{{ t('etat') }} :</label>
        <select v-model="form.etat" required>
          <option value="En rédaction">{{ t('en_redaction') }}</option>
          <option value="Publiée">{{ t('publiee') }}</option>
          <option value="Supprimée">{{ t('supprimee') }}</option>
        </select>
        <span class="error" v-if="formErrors.etat">{{ formErrors.etat.join(', ') }}</span>
      </div>
    
      <!-- Checkbox pour ajouter des lots -->
      <div class="checkbox-group" @click="toggleLots">
        <input type="checkbox" v-model="ajouterLots" id="ajouterLots">
        <label for="ajouterLots">
          <i class="fas fa-cube"></i> {{ t('ajouter_lots') }}
        </label>
      </div>
    
      <div class="lot-section">
        <h3><i class="fas fa-boxes"></i> {{ t('liste_lots') }}</h3>
        <div v-for="(lot, index) in form.lots" :key="index" class="lot-container">
          <div class="row">
            <div class="form-group">
              <label>{{ t('numero_lot') }} :</label>
              <input v-model="lot.numero_lot" type="text" :placeholder="t('exemple_numero_lot')" />
            </div>
            <div class="form-group">
  <label>{{ t('description_lot') }} :</label>

  <!-- Français -->
  <textarea
    v-if="form.langue === 'francais'"
    v-model="lot.description"
    :placeholder="t('description_lot_placeholder')"
    required
  ></textarea>

  <!-- Arabe -->
  <textarea
    v-else
    v-model="lot.description_ar"
    :placeholder="t('description_lot_placeholder')"
    required
  ></textarea>
</div>
          </div>
          <button type="button" class="delete-lot" @click="supprimerLot(index)"><i class="fas fa-trash-alt"></i></button>
        </div>
        <button type="button" class="add-lot" @click="ajouterLot"><i class="fas fa-plus-circle" ></i> {{ t('ajouter_un_lot') }}</button>
      </div>
    
      <div class="form-group">
        <label>{{ t('document_pdf') }} :</label>
        <div v-if="form.langue === 'arabe' && form.document_pdf_ar">
          <p>
            {{ t('document') }} :
            <a :href="form.document_pdf_ar" target="_blank" rel="noopener noreferrer">
              {{ t('voir_document') }} (AR)
            </a>
          </p>
        </div>
        <div v-else-if="form.document_pdf">
          <p>
            {{ t('document') }} :
            <a :href="form.document_pdf" target="_blank" rel="noopener noreferrer">
              {{ t('voir_document') }} (FR)
            </a>
          </p>
         
        </div>
        <input type="file" @change="fileSelected" accept=".pdf"/>
      </div>

      <div class="form-group" v-if="form.etat_offre === 'Annulé'">
        <label>{{ t('document_annulation') }} :</label>
        <div v-if="form.langue === 'arabe' && form.document_annulation_ar">
          <p>
            {{ t('document') }} :
            <a :href="form.document_annulation_ar" target="_blank" rel="noopener noreferrer">
              {{ t('voir_document') }} (AR)
            </a>
          </p>
        </div>
        <div v-else-if="form.document_annulation">
          <p>
            {{ t('document') }} :
            <a :href="form.document_annulation" target="_blank" rel="noopener noreferrer">
              {{ t('voir_document') }} (FR)
            </a>
          </p>
        </div>
        <input type="file" @change="fileSelectedAnnulation" accept=".pdf"  />
      </div>

      <div class="form-group" v-if="form.etat_offre === 'Infructueux'">
        <label>{{ t('document_infructueux') }} :</label>
        <div v-if="form.langue === 'arabe' && form.document_infructueux_ar">
          <p>
            {{ t('document') }} :
            <a :href="form.document_infructueux_ar" target="_blank" rel="noopener noreferrer">
              {{ t('voir_document') }} (AR)
            </a>
          </p>
        </div>
        <div v-else-if="form.document_infructueux">
          <p>
            {{ t('document') }} :
            <a :href="form.document_infructueux" target="_blank" rel="noopener noreferrer">
              {{ t('voir_document') }} (FR)
            </a>
          </p>
        </div>
        <input type="file" @change="fileSelectedInfructueux" accept=".pdf"  />
      </div>

      <div class="form-group" v-if="form.date_prorogation">
        <label>{{ t('document_prorogation') }} :</label>
        <div v-if="form.langue === 'arabe' && form.document_prorogation_ar">
          <p>
            {{ t('document') }} :
            <a :href="form.document_prorogation_ar" target="_blank" rel="noopener noreferrer">
              {{ t('voir_document') }} (AR)
            </a>
          </p>
        </div>
        <div v-else-if="form.document_prorogation">
          <p>
            {{ t('document') }} :
            <a :href="form.document_prorogation" target="_blank" rel="noopener noreferrer">
              {{ t('voir_document') }} (FR)
            </a>
          </p>
        </div>
        <input type="file" @change="fileSelectedProrogation" accept=".pdf"  />
      </div>

      <div class="form-group">
 
        <label>{{ t('journal') }} :</label>
        <div v-if="form.langue === 'arabe' && form.journal_ar">
          <p>
            {{ t('document') }} :
            <a :href="form.journal_ar" target="_blank" rel="noopener noreferrer">
              {{ t('voir_document') }} (AR)
            </a>
          </p>
        </div>
        <div v-else-if="form.journal">
          <p>
            {{ t('document') }} :
            <a :href="form.journal" target="_blank" rel="noopener noreferrer">
              {{ t('voir_document') }} (FR)
            </a>
          </p>
        </div>
        <input type="file" @change="fileSelectedJournal" accept=".pdf" />
      </div>
    
      <button type="submit">{{ t('modifier') }}</button>
    </form>
  </div>
</template>
  
<script setup>
import { ref, onMounted } from "vue";
import { computed } from 'vue';
import { useRoute } from "vue-router";
import { useI18n } from 'vue-i18n';
import axios from "axios";
import wilayasArData from '@/data/wilayas_ar.json';
import wilayasFrData from '@/data/wilayas_fr.json';
import arTranslations from '@/locales/ar.json';
import frTranslations from '@/locales/fr.json';

const wilayasAr = Array.isArray(wilayasArData) ? wilayasArData : Object.values(wilayasArData);
const wilayasFr = Array.isArray(wilayasFrData) ? wilayasFrData : Object.values(wilayasFrData);

const etatOffreFr = Object.keys(frTranslations.etat_offre).map(key => frTranslations.etat_offre[key]);
const etatOffreAr = Object.keys(arTranslations.etat_offre).map(key => arTranslations.etat_offre[key]);
const niveauFr = Object.keys(frTranslations.niveau).map(key => frTranslations.niveau[key]);
const niveauAr = Object.keys(arTranslations.niveau).map(key => arTranslations.niveau[key]);

const { t, locale } = useI18n();

const apiUrl = import.meta.env.VITE_API_URL;
const route = useRoute();
const form = ref({
  langue: "",
  etat_offre: "",
  wilaya: "",
  numero_offre: "",
  titre_offre: "",
  titre_offre_ar: "", 
  type_offre: "",
  niveau: "",
  date_publication: "",
  date_limite: "",
  date_prorogation: "",
  description: "",
  description_ar: "",
  etat: "",
  document_pdf: null,
  document_pdf_ar: null,
  document_annulation: null,
  document_annulation_ar: null, 
  document_infructueux: null,
  document_infructueux_ar: null, 
  document_prorogation: null,
  document_prorogation_ar: null, 
  journal_ar: null, 
  journal: null,
  lots: []
});

const initialData = ref({});

const fetchOffreDetails = async () => {
  try {
    const id = route.params.id;
    const token = localStorage.getItem("token");
    const response = await axios.get(`${apiUrl}/api/offres/${id}`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    const data = response.data;

    
    form.value = {
      ...form.value,
      langue: 'francais',
      etat_offre: data.etat_offre || '',
      wilaya: data.wilaya || '',
      numero_offre: data.numero_offre || '',
      titre_offre: data.titre_offre || '',
      titre_offre_ar: data.titre_offre_ar || '',
      type_offre: data.type_offre || '',
      niveau: data.niveau || '',
      date_publication: data.date_publication || '',
      date_limite: data.date_limite || '',
      date_prorogation: data.date_prorogation || '',
      description: data.description || '',
      description_ar: data.description_ar || '',
      etat: data.etat || '',
      document_pdf: data.documents.document_pdf || null,
      document_pdf_ar: data.documents.document_pdf_ar || null, 
      journal_ar: data.documents.journal_ar || null, 
      journal: data.documents.journal || null,
      document_annulation: data.documents.document_annulation || null,
      document_annulation_ar: data.documents.document_annulation_ar || null, 
      document_infructueux: data.documents.document_infructueux || null,
      document_infructueux_ar: data.documents.document_infructueux_ar || null,
      document_prorogation: data.documents.document_prorogation || null,
      document_prorogation_ar: data.documents.document_prorogation_ar || null, 
      lots: data.lots || []
    };
    form.value.lots = data.lots.map(lot => ({
  ...lot,
  description: lot.description || '',
  description_ar: lot.description_ar || ''
}));

    initialData.value = { ...form.value };


    if (form.value.langue === 'arabe') {
      form.value.etat_offre = etatOffreAr[etatOffreFr.indexOf(data.etat_offre)] || data.etat_offre;
      form.value.niveau = niveauAr[niveauFr.indexOf(data.niveau)] || data.niveau;
      form.value.wilaya = wilayasAr[wilayasFr.indexOf(data.wilaya)] || data.wilaya;
      form.value.titre_offre_ar = data.titre_offre_ar || '';
      form.value.description_ar = data.description_ar || '';
 
      if (!data.description_ar) {
        form.value.description_ar = '';
      }
    }
  } catch (error) {
    console.error("Erreur lors de la récupération des détails de l'offre :", error);
  }
};
form.value.lots.push({
  id: null,
  numero_lot: "",
  description: "",
  description_ar: "",
  document_lot: null
});
onMounted(() => {
  fetchOffreDetails();
});

const formErrors = ref({});

const ajouterLots = ref(false); 

const toggleLots = () => {
  ajouterLots.value = !ajouterLots.value;
  form.value.a_des_lots = ajouterLots.value; 
};

const ajouterLot = () => {
  form.value.lots.push({ id: null, numero_lot: "", description: "", document_lot: null });
};

const supprimerLot = (index) => {
  const lot = form.value.lots[index];
  if (lot.id) {

    if (!form.value.lotsToDelete) form.value.lotsToDelete = [];
    form.value.lotsToDelete.push(lot.id);
  }
  form.value.lots.splice(index, 1);
};

const prepareLotsForSubmission = () => {
  const lots = form.value.lots.map((lot) => ({
    id: lot.id,
    numero_lot: lot.numero_lot,
    description: lot.description,
    description_ar: lot.description_ar
  }));
  return { lots, lotsToDelete: form.value.lotsToDelete || [] };
};
const makeFileHandler = (field) => (event) => {
  if (event.target.files.length > 0) {
    const file = event.target.files[0];

    const suffix = form.value.langue === 'arabe' ? '_ar' : '';

    form.value[`${field}${suffix}`] = file;
  }
};

const fileSelected = makeFileHandler('document_pdf');
const fileSelectedAnnulation = makeFileHandler('document_annulation');
const fileSelectedInfructueux = makeFileHandler('document_infructueux');
const fileSelectedProrogation = makeFileHandler('document_prorogation');
const fileSelectedJournal = makeFileHandler('journal');



const user = ref({});
const entreprises = ref([]);

const getWilayas = () => {
  return form.value.langue === 'arabe' ? wilayasAr : wilayasFr;
};

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

const updateFieldsForArabic = () => {
  if (form.value.langue === 'arabe') {
    form.value.wilaya = wilayasAr[wilayasFr.indexOf(form.value.wilaya)] || '';
    form.value.etat_offre = etatOffreAr[etatOffreFr.indexOf(form.value.etat_offre)] || form.value.etat_offre;
    form.value.niveau = niveauAr[niveauFr.indexOf(form.value.niveau)] || form.value.niveau;
  }
};

const switchLanguage = (lang) => {
  form.value.langue = lang;
  locale.value = lang === 'arabe' ? 'ar' : 'fr';

  if (lang === 'arabe') {
    form.value.wilaya = wilayasAr[wilayasFr.indexOf(initialData.value.wilaya)] || initialData.value.wilaya;
    form.value.etat_offre = etatOffreAr[etatOffreFr.indexOf(initialData.value.etat_offre)] || initialData.value.etat_offre;
    form.value.niveau = niveauAr[niveauFr.indexOf(initialData.value.niveau)] || initialData.value.niveau;
  } else {
    form.value.wilaya = wilayasFr[wilayasAr.indexOf(initialData.value.wilaya)] || initialData.value.wilaya;
    form.value.etat_offre = etatOffreFr[etatOffreAr.indexOf(initialData.value.etat_offre)] || initialData.value.etat_offre;
    form.value.niveau = niveauFr[niveauAr.indexOf(initialData.value.niveau)] || initialData.value.niveau;
  }
};
const submitForm = async () => {
  try {
    formErrors.value = {};
    
    if (form.value.langue === 'arabe') {
      const idx = wilayasAr.indexOf(form.value.wilaya)
      if (idx !== -1) {
        form.value.wilaya = wilayasFr[idx]
      }
    }
 
    const formData   = new FormData();
    const fileFields = [
      'document_pdf',
      'document_annulation',
      'document_infructueux',
      'document_prorogation',
      'journal',
      'document_pdf_ar',
      'document_annulation_ar',
      'document_infructueux_ar',
      'document_prorogation_ar',
      'journal_ar'
    ];

  
    Object.entries(form.value).forEach(([key, val]) => {
      if (!['lots','lotsToDelete', ...fileFields].includes(key) && val != null) {
        formData.append(key, val);
      }
    });


    form.value.lots.forEach((lot, i) => {
      if (lot.id) {
        formData.append(`lots[${i}][id]`, lot.id);
      }
      formData.append(`lots[${i}][numero_lot]`, lot.numero_lot);
      formData.append(`lots[${i}][description]`, lot.description);
      if (lot.description_ar) {
        formData.append(`lots[${i}][description_ar]`, lot.description_ar);
      }
    });

    (form.value.lotsToDelete || []).forEach((id, j) => {
      formData.append(`lotsToDelete[${j}]`, id);
    });


    fileFields.forEach(field => {
      const f = form.value[field];
      if (f instanceof File) {
        if (form.value.langue === 'arabe') {
          if (field.endsWith('_ar')) {
            formData.append(field, f);
          }
        } else {
          if (!field.endsWith('_ar')) {
            formData.append(field, f);
          }
        }
      }
    });


    console.log("File-specific fields:");
    fileFields.forEach(field => {
      if (form.value[field] instanceof File) {
        console.log(`${field}:`, form.value[field]);
      }
    });

 
    const token = localStorage.getItem("token");
    const id    = route.params.id;

 
    console.log("FormData content:");
    for (let pair of formData.entries()) {
      console.log(`${pair[0]}:`, pair[1]);
    }

    await axios.post(
      `${apiUrl}/api/offres/${id}?_method=PUT`,
      formData,
      { headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "multipart/form-data"
        }
      }
    );
    alert("Offre mise à jour avec succès !");
  } catch (error) {
    if (error.response?.data?.errors) {
      formErrors.value = error.response.data.errors;
    } else {
      formErrors.value = { general: ["Erreur inattendue."] };
    }
  }
};

const descriptionModel = computed({
  get: () => form.value.langue === 'arabe' ? form.value.description_ar : form.value.description,
  set: (value) => {
    if (form.value.langue === 'arabe') {
      form.value.description_ar = value;
    } else {
      form.value.description = value;
    }
  }
});
const titreModel = computed({
  get: () => form.value.langue === 'arabe' ? form.value.titre_offre_ar : form.value.titre_offre,
  set: (value) => {
    if (form.value.langue === 'arabe') {
      form.value.titre_offre_ar = value;
    } else {
      form.value.titre_offre = value;
    }
  }
});

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
}

.form-container {
  position: relative;
  width: 100%;
  max-width: 1300px;
  margin-left: 20px;
  margin-top: 40px;
  padding: 2rem;
  border-radius: 4px;
  color: #2c3e50;
}
.form-container form{
  background: #ffffff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); 
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
/* Lots Section */
.lot-section {
  margin-top: 2rem;
  border-top: 3px solid #e2e8f0;
  padding-top: 2.5rem;
}
.lot-section h3 {
  font-size: 1.2rem;
 
  color: #0c1d4d;
  display: flex;
  align-items: center !important;
  gap: 0.5rem;
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

.tab-container {
  position: absolute;
  display: flex;
  gap: 0.5rem;
  margin-left: 30px;
  margin-right: 10px;
  margin-top: 5px;
}

.tab {
  padding: 0.5rem 1rem;
  background: #ffffff;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.221);
  border-radius: 8px 8px 0 0;
  color: #a0a0a0;
  cursor: pointer;
  transition: background 0.3s ease;
}


.tab.active {
  background: #162e6e;
  color: white;
  border-color: #162e6e;
}

.tab:hover {
  background: #e0e0e0;
}

[dir="rtl"] {
  text-align: right;
  font-family: 'Cairo', sans-serif;
}

[dir="ltr"] {
  text-align: left;
}
</style>
