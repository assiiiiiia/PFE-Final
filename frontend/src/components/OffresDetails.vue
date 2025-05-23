<template>
  <div class="wrapper" :dir="locale === 'ar' ? 'rtl' : 'ltr'">
    <NavBar />
    <div class="tender-detail-container">
      <div v-if="tender"> 
        <div class="tender-item" :class="{ expired: isExpired }">
          <div class="tender-details">
            <div class="entete-logo">
          <img 
            :src="getLogoUrl(tender.secteur?.logo)" 
            :alt="$t('tenders.logoAlt')" 
            class="tender-logo"
            @error="handleImageError($event, tender.secteur)"
          />
        </div>
        
            <div class="entete-infos" >
              <h3 class="tender-number">
  {{ locale === 'ar' ? 'عرض رقم' : 'Offre N°' }} {{ tender.numero_offre || 'N/A' }}
</h3>
              <p class="tender-title">
                {{ locale === 'ar' ? tender.titre_offre_ar : tender.titre_offre || 'Titre non disponible' }}
              </p>
            </div>
            <div class="tender-location">
              <img src="/src/assets/broche-de-localisation.png" alt="Location Icon" class="location-icon" />
              <p class="location">
  {{ $t(`wilayas.${tender.wilaya}`) || $t('tenders.locationNotSpecified') }}
</p>
            </div>
          </div>
          <div class="tender-content" >
           <p class="tender-description" >
  {{ locale === 'ar' ? tender.description_ar : tender.description || 'Aucune description disponible.' }}
</p>
           <div class="detail-dates">
              <div class="detail-row">
                <p><strong>{{ t('date_publication') }} :</strong> {{ tender.date_publication || 'Non spécifiée' }}</p>
                <p><strong>{{ t('date_limite') }} :</strong> {{ tender.date_limite || 'Non spécifiée' }}</p>
                <p v-if="tender.date_prorogation"><strong>{{ t('date_prorogation') }} :</strong> {{ tender.date_prorogation }}</p>
                     <div :class="{ expired: isExpired, ongoing: !isExpired }">
            <p class="status-text">
              <strong>{{ $t('statut') }} :</strong>
              {{ isExpired ? $t('status.expired') : $t('status.ongoing') }}
            </p>
              </div>
                <p>
                  <strong>{{ $t('etat') }} :</strong>
                  {{ $t(`status.${tender.etat_offre}`) || $t('status.notSpecified') }}</p>
               
            
              </div>
            </div>
          </div>
         
          <div v-if="tender.lots && tender.lots.length" class="lot-details">
           
            <div v-for="lot in tender.lots" :key="lot.id" class="lot-item">
              <p><strong>{{ $t('lot.number') }} :</strong> {{ lot.numero_lot }}</p>
<p><strong>{{ $t('lot.description') }} :</strong> {{ locale === 'ar' ? lot.description_ar : lot.description }}</p>
<p><strong>{{ $t('lot.status') }} :</strong> <span :class="getStatusClass(lot.statut)">{{ $t(`lot.${lot.statut}`) || $t('lot.notSpecified') }}</span></p>
             
            </div>
          </div>
          <div class="documents" v-if="tender.documents">
  <button class="details-btn" @click="viewDocument(getCurrentLangDoc(tender.documents, 'document_pdf'))">
    {{ $t('tenders.viewDetails') }}
  </button>

  <!-- Document d'annulation -->
  <div v-if="getCurrentLangDoc(tender.documents, 'document_annulation')" class="button-container">
    <button class="annulation-btn" @click="viewDocument(getCurrentLangDoc(tender.documents, 'document_annulation'))">
      {{ $t('tenders.annulationDocument') }}
    </button>
  </div>

  <!-- Document infructueux -->
  <div v-if="getCurrentLangDoc(tender.documents, 'document_infructueux')" class="button-container">
    <button class="infructueux-btn" @click="viewDocument(getCurrentLangDoc(tender.documents, 'document_infructueux'))">
      {{ $t('tenders.infructueuxDocument') }}
    </button>
  </div>

  <!-- Document de prorogation -->
  <div v-if="getCurrentLangDoc(tender.documents, 'document_prorogation')" class="button-container">
    <button class="prorogation-btn" @click="viewDocument(getCurrentLangDoc(tender.documents, 'document_prorogation'))">
      {{ $t('tenders.prorogationDocument') }}
    </button>
  </div>
</div>
        
        </div>
      </div>
      <p v-else class="loading">Chargement...</p>
    </div>
    <Footer />
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useI18n } from 'vue-i18n';
import NavBar from '@/components/NavBar.vue';
import Footer from '@/components/Footer.vue';
import axios from 'axios';
const apiUrl = import.meta.env.VITE_API_URL
const { locale } = useI18n();

const { t } = useI18n();

const route = useRoute();
const router = useRouter();
const tender = ref(null);
const getCurrentLangDoc = (docs, key) => {
  if (!docs) return null;


  if (locale.value === 'ar') {
    return docs[`${key}_ar`] || null;
  }
  return docs[key] || null;
};
const viewDetails = (tender) => {
  if (tender.document_pdf) {
    window.open(`${apiUrl}/${tender.documents.document_pdf}`, '_blank');
  } else {
    router.push({ name: "OffresDetails", params: { id: tender.id } });
  }
};

const viewDocument = (documentPath) => {
  if (documentPath) {
    window.open(`${apiUrl}/storage/documents/${documentPath.split('/').pop()}`, '_blank');
  }
};
const getLogoUrl = (logoPath) => {
  if (!logoPath || logoPath === "null") {
    return `${apiUrl}/storage/logo/default.png`;
  }
  return `${apiUrl}/storage/logo/` + logoPath.split("/").pop();
};

const handleImageError = (event) => {
  console.error("Erreur de chargement de l'image, utilisation du logo par défaut.");
  event.target.src = `${apiUrl}/storage/logo/default.png`;
};

const getStatusClass = (status) => {
  return {
    "status-open": status === "En Cours",
    "status-closed": status === "Clôturé",
  };
};

const isExpired = computed(() => {
  const deadline = new Date(tender.value?.date_limite);
  const publicationDate = new Date(tender.value?.date_publication);
  return deadline < new Date() && deadline > publicationDate;
});

onMounted(async () => {
  const id = route.params.id;
  try {
    const response = await axios.get( `${apiUrl}/api/offres-pub/${id}`);
    tender.value = response.data;
  } catch (error) {
    console.error("Erreur lors de la récupération du détail de l'appel d'offre:", error);
  }
});
</script>

<style scoped>
.wrapper {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  direction: var(--locale-direction, ltr);
}

.tender-detail-container {
  flex: 1;
  width: 70%;
  margin: 0 auto;
  padding: 10px;
  margin-top: 10px;
  border-radius: 8px;
  text-align: var(--locale-text-align, left);
}
[dir="rtl"] .tender-details {
  flex-direction: row-reverse;
}
[dir="rtl"] .documents {
  flex-direction: row-reverse;
}
footer {
  margin-top: auto; 
}

.tender-item {
  border: 1px solid #ddd;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s, background-color 0.2s;
}

.tender-item:hover {
  transform: translateY(-5px);
}

.tender-item.expired {
  background-color: #fee0e2;
}

.entete-infos {
  flex-grow: 1;
  text-align: var(--locale-text-align, left);
  margin-right: 20px;
  line-height: 1.2;
  color: #333;
}

.tender-details {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-bottom: 20px;
  border-bottom: solid 1px #ccc;
}  
[dir="ltr"] .entete-logo img {
  border-right: solid 1px #9a9a9a;
  border-left: none;
}


[dir="rtl"] .entete-logo img {
  border-left: solid 1px #9a9a9a;
  border-right: none;

padding-left: 10px;
  margin-right: 0;    
}


  .entete-logo img {
    width: 60px;
    height: 60px;
    object-fit: contain;
    border-right: solid 1px #9a9a9a;
    margin-right: 20px;
    padding-right: 20px;
    
  }


  .entete-infos {
    flex-grow: 1;
    text-align: left;
    margin-right: 20px;
    line-height: 0.9;
    color: #333;
  }
  
  [dir="rtl"] .entete-infos {
  text-align: right;
}
[dir="rtl"] .tender-number {
  text-align: right;
}
[dir="rtl"] .tender-title {
  text-align: right;
}

  .tender-number {
    font-size: 12px;
    font-weight: bold;
    text-align: left;
    text-transform: uppercase;
    color: #0bd365;
  }
  
  .tender-title {
    font-size: 16px;
    font-weight: 500;
    text-align: left;
    line-height: 1.5;
    text-transform: uppercase;
  }
  
  .location {
    font-size: 13px;
    color: #777;
    text-align: var(--locale-text-align, left);
  }
  
  .location-icon {
    width: 30px;
    height: auto;
  }
  
  .tender-location {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    line-height: 0.1;
    padding-right: 10px;
  }
  
  .tender-description {
  text-align: left;
  direction: ltr; 
  align-self: flex-start; 
}

[dir="rtl"] .tender-description {
  text-align: right; 
  direction: rtl; 
  align-self: flex-end; 
}
  
  .tender-content {
    margin-top: 30px;
    color: #333;
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    text-align: var(--locale-text-align, left);
    direction: var(--locale-direction, ltr);
  }
  

 

.details-btn {
  background-color: #306093;
  color: white;
  padding: 8px 12px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  margin-top: 10px;
  align-self: flex-start;
  transition: background-color 0.3s ease;
}

.details-btn:hover {
  background-color: #1e4b7b;
}

.detail-dates p {
  font-size: 14px;
  color: #555;
}

.detail-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 30px;

  margin-top: 10px;

} 
[dir="rtl"] .detail-row {
  direction: rtl;
  text-align: right;
}

.detail-row p {
  white-space: nowrap;
}

.loading {
  text-align: center;
  font-size: 16px;
  color: #777;
}

.status-open {
  color: green;
  font-weight: bold;
}

.status-closed {
  color: red;
  font-weight: bold;
}

.status-text {
  font-size: 16px;
  font-weight: bold;
}
.lot-details {
  margin-top: 30px;
  padding: 24px;

  border-radius: 12px;
 
}


.lot-details > h3 {
  margin: 0 0 16px;
  font-size: 1.5rem;
  color: #1f2937;
  border-bottom: 2px solid #e5e7eb;
  padding-bottom: 8px;
}


.lot-details {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}


.lot-item {
  background: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.lot-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 6px 16px rgba(0,0,0,0.08);
}

.lot-item p {
  margin: 8px 0;
  font-size: 0.95rem;
  color: #374151;
  text-align: left;
  direction: ltr; 
}

[dir="rtl"] .lot-item p {
  text-align: right; 
  direction: rtl; 
}

.lot-item p strong {
  color: #111827;
}


.lot-item .badge {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 0.8rem;
  font-weight: 500;
  text-transform: capitalize;
  margin-left: 4px;
}


.badge--open       { background: #d1fae5; color: #065f46; }  
.badge--closed     { background: #fee2e2; color: #991b1b; } 
.badge--in-progress{ background: #e0f2fe; color: #0369a1; } 
.badge--notSpecified { background: #f3f4f6; color: #6b7280; } 


.lot-item a {
  color: #009fe3;
  text-decoration: none;
  font-weight: 500;
}

.lot-item a:hover {
  text-decoration: underline;
}


@media (max-width: 600px) {
  .lot-details {
    grid-template-columns: 1fr;
  }
}
.status-container {
  padding: 10px;
  border-radius: 5px;
  text-align: center;
  margin-top: 10px;
}

.status-container.expired {
  background-color: #f8d7da; 
  color: #721c24;
}

.status-container.ongoing {
  background-color: #d4edda; 
  color: #155724;
}

.status-text {
  font-size: 16px;
  font-weight: bold;
}
.documents {
  margin-top: 20px;
  display: flex;

  align-items: center; 
  justify-content: center; 
  gap: 15px; 
}   
.annulation-btn {
  background-color: #c01717;
  color: white;
  padding: 8px 12px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  margin-top: 10px;
  transition: background-color 0.3s ease;
}

.annulation-btn:hover {
  background-color: #cc0000;
}

.prorogation-btn {
  background-color: #4caf50;
  color: white;
  padding: 8px 12px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  margin-top: 10px;
  transition: background-color 0.3s ease;
}

.prorogation-btn:hover {
  background-color: #388e3c;
}

.infructueux-btn {
  background-color: #ff9800;
  color: white;
  padding: 8px 12px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  margin-top: 10px;
  transition: background-color 0.3s ease;
}

.infructueux-btn:hover {
  background-color: #e65100;
}

@media (max-width: 768px) {
  .tender-detail-container {
    width: 90%;
    padding: 5px;
  }

  .tender-content {
    margin-top: 20px;
  }

  .detail-row {
    grid-template-columns: repeat(2, 1fr);
  }

  .lot-details {
    grid-template-columns: 1fr;
  }
}

@media (min-width: 769px) and (max-width: 1024px) {
  .tender-detail-container {
    width: 80%;
    padding: 10px;
  }

  .detail-row {
    grid-template-columns: repeat(3, 1fr);
  }

  .lot-details {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 480px) {
  .tender-detail-container {
    width: 100%;
    padding: 5px;
  }

  .tender-description {
    font-size: 12px;
  }

  .detail-row {
    grid-template-columns: 1fr;
  }

  .lot-item {
    padding: 10px;
  }
}
</style>
