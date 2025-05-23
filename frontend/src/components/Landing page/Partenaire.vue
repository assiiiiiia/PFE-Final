<template>
  
    <section class="partners-section">
      <div class="container">
        <h2 class="partners-title">{{ $t("home.partners.title") }}</h2>
        <div class="logos-container">
          <div
            v-for="(logo, idx) in logos"
            :key="idx"
            class="logo-item"
            @mouseover="hoverLogo(idx)"
            @mouseleave="unhoverLogo(idx)"
          >
            <a :href="logo.url" target="_blank" rel="noopener noreferrer">
              <img
                :src="logo.src"
                :alt="logo.alt"
                :class="['logo-image', { hovered: logo.hover }]"
              />
            </a>
          </div>
        </div>
      </div>
    </section>
  </template>
  
  <script setup>
  import { ref } from 'vue'
  
  // logos data initialization
  const logos = ref([
    { src: new URL('@/assets/logo-gta.png', import.meta.url).href,        alt: 'GTA', url: 'https://www.facebook.com/GroupeTelecomAlg/' },
    { src: new URL('@/assets/logo-at.png', import.meta.url).href,         alt: 'Algérie Télécom', url: 'https://www.algerietelecom.dz/' },
    { src: new URL('@/assets/logo-poste.png', import.meta.url).href,      alt: 'Algérie Poste', url: 'https://www.poste.dz/' },
    { src: new URL('@/assets/logo-mobilis.png', import.meta.url).href,    alt: 'Mobilis', url: 'https://mobilis.dz/' },
    { src: new URL('@/assets/logo-comintal.png', import.meta.url).href,   alt: 'Comintal', url: 'https://www.comintal.dz/' },
    { src: new URL('@/assets/logo-saticom.png', import.meta.url).href,    alt: 'Saticom', url: 'https://www.saticom.dz/' },
    { src: new URL('@/assets/logo-inttic.png', import.meta.url).href,     alt: 'INTTIC', url: 'https://www.facebook.com/INTTIC.ORAN/' },
    { src: new URL('@/assets/logo-numirisation.png', import.meta.url).href, alt: 'Numérisation', url: 'https://www.eadn.dz/' },
    { src: new URL('@/assets/logo-anf.png', import.meta.url).href,       alt: 'ANF', url: 'https://www.anf.dz/' },
    { src: new URL('@/assets/logo-ats.png', import.meta.url).href,       alt: 'ATS', url: 'https://www.ats.dz/' },
    { src: new URL('@/assets/logo-natp.png', import.meta.url).href,      alt: 'NATP', url: 'https://www.natp.dz/' },
    { src: new URL('@/assets/logo-inptic.png', import.meta.url).href,    alt: 'INPTIC', url: 'https://inptic.edu.dz/' },
    { src: new URL('@/assets/logo-eci-tic.png', import.meta.url).href,   alt: 'ECI-TIC', url: 'https://emploitic.com/entreprises/ecitic-epe-spa/presentation' },
    { src: new URL('@/assets/logo-wb.png', import.meta.url).href,        alt: 'WB', url: 'https://whitebay.limited/' },
    { src: new URL('@/assets/logo-netbeopen.png', import.meta.url).href, alt: 'NetBeOpen', url: 'https://www.netbeopen.com/' },
    { src: new URL('@/assets/logo-ems.png', import.meta.url).href,       alt: 'EMS', url: 'https://www.ems.dz/' }
  ].map(logo => ({ ...logo, hover: false })))
  
  /**
   * Toggle hover state for a logo
   */
  function hoverLogo(index) {
    logos.value[index].hover = true
  }
  
  function unhoverLogo(index) {
    logos.value[index].hover = false
  }
  </script>
  
  <style scoped>
  /* Container */
  .container {
    max-width: 1300px;
    margin: 0 auto;
    padding: 0 0rem;
    padding-bottom: 100px;
    border-bottom: 2px solid #e5e7eb;
  }
  
  /* Section Styles */
  .partners-section {
    padding: 4rem 0;
   
  }
  .partners-title {
    text-align: center;
    font-size: 2.5rem;
    margin-bottom: 4rem;
    color: #1e3a8a;

    font-weight: 600;
  }
  
  /* Logos Grid */
  .logos-container {
    display: grid;
    grid-template-columns: repeat(8, 1fr);
    gap: 2rem;
  }
  
  .logo-item {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 1.9rem;
    background-color: rgb(255, 255, 255);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    border-radius: 12px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  .logo-item:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
  }
  
  /* Logo Image */
  .logo-image {
    max-width: 100%;
    max-height: 80px;
  
    opacity: 0.8;
    transition: filter 0.3s ease, opacity 0.3s ease, transform 0.3s ease;
  }
  .logo-image.hovered {
    filter: none;
    opacity: 1;
    transform: scale(1.1);
  }
  
  /* Responsive */
@media (max-width: 768px) {
  .partners-section {
    padding: 2rem 0;
  }
  .logos-container {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (min-width: 769px) and (max-width: 1024px) {
    .logos-container {
      grid-template-columns: repeat(4, 1fr);
    }
  }
  </style>
