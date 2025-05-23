<template>
  <div class="tenders-container" :dir="currentDirection">
    <div class="tender-item">
      <div class="tender-details">
        <div class="entete-logo">
          <img 
            :src="getLogoUrl(tender.secteur?.logo)" 
            :alt="$t('tenders.logoAlt')" 
            class="tender-logo"
            @error="handleImageError($event, tender.secteur)"
          />
        </div>
        <div class="entete-infos">
          <h3 class="tender-number">{{ tender.numero_offre || $t('tenders.na') }}</h3>
          <p class="tender-title">{{ currentTitle || $t('tenders.titleNotAvailable') }}</p>

        </div>
        <div class="tender-location">
          <img src="/src/assets/broche-de-localisation.png" :alt="$t('tenders.locationIconAlt')" class="location-icon" />
          <p class="location">
  {{ $t(`wilayas.${tender.wilaya}`) || $t('tenders.locationNotSpecified') }}
</p>
        </div>
      </div>
      <div class="tender-content">
        <p class="tender-description">
  {{ currentDescription || $t('tenders.descriptionNotAvailable') }}
</p>
        <div class="button-container" :style="{ justifyContent: locale === 'ar' ? 'flex-end' : 'flex-start' }">
          <button 
            class="details-btn" 
            :style="getDetailsButtonStyle(tender)" 
            @click="viewDetails(tender.id)"
          >
            {{ $t('tenders.viewDetails') }}
          </button>
      
        <button 
          v-if="isLoggedIn" 
          class="submit-btn" 
          @click="openModal"
        >
          {{ $t('tenders.submit') }}
        </button>
        <button 
          v-if="isLoggedIn" 
          class="favorite-btn" 
          @click="toggleFavorite(tender)" 
          :class="{ 'is-favorite': tender.isFavorite }"
        >
          <svg class="star-icon" viewBox="0 0 24 24">
            <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
          </svg>
        </button>
        </div>
        <SubmissionModal 
          :show="showModal" 
          :tender="tender" 
          @close="closeModal"
          @submitted="closeModal" 
        />
        
   
    <Login 
      :showModal="showLoginModal" 
      @close="showLoginModal = false" 
      @login-success="handleLoginSuccess" 
      modal-class="custom-login-modal" 
      backdrop="true" 
    />
      </div>
    </div>
  </div>
</template>

  
<script setup>
import { ref, onMounted } from "vue";
import SubmissionModal from "./SubmissionModal.vue";
import { defineProps } from "vue";
import axios from "axios";
import Login from '@/components/Login.vue';
const token = localStorage.getItem('token');
const apiUrl = import.meta.env.VITE_API_URL;
const showLoginModal = ref(false);
const isLoggedIn = ref(!!localStorage.getItem('token'));
import { useI18n } from 'vue-i18n'
const { locale } = useI18n()
import { computed } from 'vue'
const currentDirection = computed(() => {
  return locale.value === 'ar' ? 'rtl' : 'ltr'
})
const currentTitle = computed(() => {
  return locale.value === 'ar'
    ? props.tender.titre_offre_ar
    : props.tender.titre_offre
})

const currentDescription = computed(() => {
  return locale.value === 'ar'
    ? props.tender.description_ar
    : props.tender.description
})
const toggleFavorite = async (tender) => {
  if (!isLoggedIn.value) {
    showLoginModal.value = true; 
    return;
  }

  try {
    if (!tender.isFavorite) {
      const response = await axios.post(
        `${apiUrl}/api/favorites`,
        { offre_id: tender.id },
        { headers: { Authorization: `Bearer ${token}` } }
      );
      tender.isFavorite = true;
      tender.favoriteId = response.data.id;
    } else {
      await axios.delete(
        `${apiUrl}/api/favorites/${tender.favoriteId}`,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      tender.isFavorite = false;
      tender.favoriteId = null;
    }
  } catch (error) {
    console.error('Error toggling favorite:', error);
  }
};

const props = defineProps({
  tender: {
    type: Object,
    required: true
  },
  getLogoUrl: {
    type: Function,
    required: true
  },
  handleImageError: {
    type: Function,
    required: true
  },
  user: {
    type: Object,
    required: true
  },
  viewDetails: {
    type: Function,
    required: true
  },
  toggleFavorite: {
    type: Function,
    required: true
  },
  getDetailsButtonStyle: {
    type: Function,
    required: true
  },
  isLoggedIn: {
    type: Boolean,
    required: true
  }
});

const showModal = ref(false);

const openModal = () => {
  showModal.value = true;
};

const closeModal = () => {
  showModal.value = false;
};

onMounted(async () => {
  try {
    const response = await axios.get(`${apiUrl}/api/favorites`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    const favoriteIds = response.data.map((favorite) => favorite.offre_id);

    if (favoriteIds.includes(props.tender.id)) {
      props.tender.isFavorite = true;
      props.tender.favoriteId = response.data.find((favorite) => favorite.offre_id === props.tender.id).id;
    } else {
      props.tender.isFavorite = false;
      props.tender.favoriteId = null;
    }
  } catch (error) {
    console.error('Error fetching favorites:', error);
  }
});

</script>

 <style scoped>
  .tenders-container {
    max-width: 1270px;
    margin: 0 auto;
    padding: 20px;
  }
  
  .tender.title {
    text-align: left;
    font-size: 24px;
    font-weight: bold;
    line-height: 1.9;
    margin-bottom: 20px;
    color: #333;
  }
  
  .tenders-list {
    display: flex;
    flex-direction: column;
    gap: 15px;
  }
  
  .tender-item {
    border: 1px solid #ddd;
    padding: 15px;
    background-color: #fff;
    border-radius: 5px;
    box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
    transition: transform 0.2s;
  }
  
  .tender-item:hover {
    transform: translateY(-5px);
  }
  
  .tender-details {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding-bottom: 20px;
    border-bottom: solid 1px #444;
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
  .entete-logo[dir="ltr"] img {
    margin-left: 20px;
    margin-right: 0;

        border-left: solid 1px #9a9a9a;
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
[dir="rtl"] .tender-description {
  text-align: right;
  direction: rtl;
  align-items: flex-start;
  justify-content: flex-start;
}

.tender-description {
  text-align: left; 
  direction: ltr; 
}

[dir="rtl"] .tender-description {
  text-align: right;
  direction: rtl; 
  align-self: flex-start;
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
    font-size: 14px;
    color: #444;
  }
  
  .tender-content {
    margin-top: 30px;
    color: #333;
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    text-align: left;
    direction: rtl;
  }
  
  .button-container {
    display: flex;
    gap: 12px;
    width: 100%;
    text-align: left;
    margin-top: 15px;
    justify-content: flex-start;
    align-items: center; 
  }

 

  .details-btn,
  .submit-btn,
  .favorite-btn {
    margin: 0 1px; 
  }
  
  .details-btn {
    padding: 8px 20px;
    border-radius: 20px;
    font-weight: 500;
    transition: all 0.3s ease;
    border: none;
    color: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  
  .submit-btn {
    background-color: #28a745;
    padding: 8px 20px;
    border-radius: 20px;
    font-weight: 500;
    transition: all 0.3s ease;
    border: none;
    color: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  
  .submit-btn:hover {
    background-color: #218838;
    transform: translateY(-1px);
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  }
  
  .favorite-btn {
  background: none;
  border: none;
  padding: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.star-icon {
  width: 24px;
  height: 24px;
  fill: none;
  stroke: #cccccc;
  stroke-width: 2px;
  transition: all 0.2s ease;
}

.favorite-btn:hover .star-icon {
  stroke: #FFD700;
}

.favorite-btn.is-favorite .star-icon {
  fill: #FFD700;
  stroke: #FFD700;
  transform: scale(1.1);
}


@keyframes starPop {
  0% { transform: scale(1); }
  50% { transform: scale(0.9); }
  100% { transform: scale(1); }
}

.favorite-btn.is-favorite {
  animation: starPop 0.3s ease;
}


/* Animations */
@keyframes pop {
  0% { transform: scale(1); }
  50% { transform: scale(0.95); }
  100% { transform: scale(1); }
}

/* Responsive */
@media (max-width: 768px) {
  .favorite-btn {
    padding: 6px 12px;
  }
  .action span {
    display: none;
  }
   .star-text {
    display: none;
  }
  .bookmark-icon {
    width: 18px;
    height: 22px;
  }
}


  @media (max-width: 768px) {
    .button-container {
      flex-direction: column;
      width: 100%;
    }
    
    .details-btn,
    .submit-btn {
      width: 100%;
      justify-content: center;
    }
    
    .favorite-btn {
      margin-left: 0;
      align-self: center;
    }
  }
  </style>
