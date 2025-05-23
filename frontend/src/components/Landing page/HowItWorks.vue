<template>
    <section class="process-section">
      <div class="process-container">
        <div class="process-header">
          <h2 class="process-title">{{ t('howItWorks.processTitle') }}</h2>
        </div>
        
        <div class="process-steps">
          <div 
            v-for="(step, index) in steps"
            :key="index"
            class="process-step"
            :style="{ '--delay': index * 0.15 + 's' }"
          >
            <div class="step-content">
              <div class="step-header">
                <div class="step-icon-container">
                  <font-awesome-icon :icon="step.icon" class="step-icon" />
                  <span class="step-number">{{ t('howItWorks.step') }} {{ index + 1 }}</span>
                </div>
              </div>
              <div class="step-text">
                <h3 class="step-title">{{ step.title }}</h3>
                <p class="step-description">{{ step.desc }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </template>
  
  <script setup>
  import { computed } from 'vue'
  import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
  import { 
    faUserPlus, 
    faSearch, 
    faFileUpload, 
    faClipboardList 
  } from '@fortawesome/free-solid-svg-icons'
  import { useI18n } from 'vue-i18n';
  
  const { t } = useI18n();
  
  const steps = computed(() => [
    { 
      icon: faUserPlus,      
      title: t('howItWorks.createAccount.title'),     
      desc: t('howItWorks.createAccount.desc') 
    },
    { 
      icon: faSearch,        
      title: t('howItWorks.searchOffers.title'),   
      desc: t('howItWorks.searchOffers.desc') 
    },
    { 
      icon: faFileUpload,    
      title: t('howItWorks.submitDocuments.title'), 
      desc: t('howItWorks.submitDocuments.desc') 
    },
    { 
      icon: faClipboardList, 
      title: t('howItWorks.trackSubmission.title'), 
      desc: t('howItWorks.trackSubmission.desc') 
    }
  ])
  </script>
  
  <style scoped>
  .process-section {
    padding: 4rem 0;
  
  }
  
  .process-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 1rem;
      padding-bottom: 70px;
    border-bottom: 2px solid #e5e7eb;
  
  }
  
  .process-header {
    text-align: center;
    margin-bottom: 3rem;
  }
  
  .process-title {
    font-size: 2rem;
    font-weight: 700;
     font-size: 2.5rem;
    margin-bottom: 4rem;
    color: #1e3a8a;
    background: linear-gradient(to right, #2c387e, #2c387e);
    -webkit-background-clip: text;
    background-clip: text;
    color: transparent;
  }
  
  .process-steps {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 1.5rem;
  }
  
  .step-content {
    background: white;
    border-radius: 12px;
    padding: 1.5rem;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    transition: all 0.3s ease;
    border-top: 3px solid #2c387e;
    height: 80%;
  }
  
  .step-content:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 12px rgba(0,0,0,0.12);
  }
  
  .step-header {
    display: flex;
    margin-bottom: 1rem;
  }
  
  .step-icon-container {
    position: relative;
    width: 48px;
    height: 48px;
    background: linear-gradient(135deg, #1b925c, #139769);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
  }
  
  .step-icon {
    color: white;
    font-size: 1.25rem;
  }
  
  .step-number {
    position: absolute;
    top: 10px;
    right: -120px;
    background: #ffffff;
    color: #1b925c;
    font-size: 1rem;
    font-weight: 700;
    padding: 4px 8px;
    border-radius: 20px;
    border: 2px solid #1b925c;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  }
  
  .step-text {
    flex: 1;
  }
  
  .step-title {
    font-size: 1.1rem;
    color: #041f4e;
    margin-bottom: 0.5rem;
    font-weight: 600;
  }
  
  .step-description {
    font-size: 0.9rem;
    color: #36578f;
    line-height: 1.5;
  }
  
  @keyframes fadeInUp {
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  @media (max-width: 768px) {
    .process-section {
      padding: 3rem 0;
    }
    
    .process-steps {
      grid-template-columns: 1fr;
      gap: 1rem;
    }
  }
  </style>