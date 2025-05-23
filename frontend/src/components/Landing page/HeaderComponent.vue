<template>
    <header class="header" :dir="locale === 'ar' ? 'rtl' : 'ltr'">
      <div class="header__container">
        <h1 class="header__title">
          <span class="header__main">{{ t('header.mainTitle') }}</span>
          <span class="header__sub">{{ t('header.subTitle') }}</span>
        </h1>
        <p class="header__tagline">{{ t('header.tagline') }}</p>
        <div class="header__cta">
          <button class="cta-button cta-button--primary" @click="goToOffers">
            <i class="fas fa-file-contract cta-icon"></i>
            {{ t('header.consultOffers') }}
          </button>
          <button class="cta-button cta-button--secondary" @click="goToRegister">
            <i class="fas fa-user-plus cta-icon"></i>
            {{ t('header.createAccount') }}
          </button>
        </div>
      </div>
    </header>
  </template>
  
  <script setup>
  import { useRouter } from 'vue-router';
  import { useI18n } from 'vue-i18n';

  const router = useRouter();
  const { t, locale } = useI18n();

  const goToOffers = () => router.push({ path: '/offres' });
  const goToRegister = () => router.push({ path: '/register' });
  </script>
  
  <style scoped>
  .header {
 
    position: relative;
    padding: 4rem 2rem;
    overflow: hidden;

  }
  
  .header__container {
    max-width: 1200px;
    margin: 0 auto;
    text-align: center;
    position: relative;
    z-index: 1;
  }
  
  .header__title {
    margin-bottom: 1rem;
    line-height: 1.2;
  }
  
  .header__main {
    display: block;
    font-size: 3rem;
    font-weight: 700;
    color: #1E3A8A;
  }
  
  .header__sub {
    display: block;
    font-size: 3rem;
    font-weight: 700;
    color: #1E3A8A;
  }
  
  .header__tagline {
    font-size: 1.2rem;
    color: #4B5563;
    max-width: 700px;
    margin: 1.5rem auto 2rem;
    line-height: 1.6;
  }
  
  .header__cta {
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
    justify-content: center;
    margin-bottom: 2rem;
  }
  
  .cta-button {
    padding: 1rem 2rem;
    font-size: 1rem;
    border-radius: 9999px;
    cursor: pointer;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    border: 2px solid transparent;
  }
  
  .cta-button--primary {
    background: #1E3A8A;
    color: #ffffff;
    font-weight: 700;
  }
  
  .cta-button--primary:hover {
    background: #3749b3;
    transform: translateY(-2px);
  }
  
  .cta-button--secondary {
    background: #ffffff;
    color: #1E3A8A;
    border-color: #1E3A8A;
  }
  
  .cta-button--secondary:hover {
    background: #f0f4ff;
    transform: translateY(-2px);
  }
  
  .cta-icon {
    margin-right: 0.5rem;
    font-size: 1.2rem;
  }
  
  .header__slogan {
    font-size: 1.1rem;
    color: #6B7280;
    font-style: italic;
    margin-top: 1rem;
  }
  
  @media (max-width: 768px) {
    .header {
      padding: 3rem 1rem;
    }
    .header__main {
      font-size: 2.2rem;
    }
    .header__sub {
      font-size: 1.6rem;
    }
    .header__cta {
      flex-direction: column;
    }
    .cta-button {
      width: 100%;
      justify-content: center;
    }
  }
  
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }
  
  .header__title { animation: fadeIn 0.8s ease-out; }
  .header__tagline { animation: fadeIn 0.8s ease-out 0.2s forwards; }
  .header__cta { animation: fadeIn 0.8s ease-out 0.4s forwards; }
  .header__slogan { animation: fadeIn 0.8s ease-out 0.6s forwards; }
  </style>
