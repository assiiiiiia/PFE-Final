<template>
  <div class="logos-carousel">
    <button class="nav-button left" @click="scrollLeft">
      <span class="chevron">&lt;</span>
    </button>
    
    <div class="logos-container" ref="logosContainer">
      <div v-for="(logo, index) in logos" :key="index" class="logo-wrapper">
        <img 
          :src="logo.src" 
          :alt="logo.alt" 
          class="logo"
          @mouseover="hoverLogo(index)"
          @mouseleave="resetLogo"
        >
      </div>
    </div>

    <button class="nav-button right" @click="scrollRight">
      <span class="chevron">&gt;</span>
    </button>
  </div>
</template>

<style scoped>
.logos-carousel {
  
  position: relative;
  max-width: 1500px;
  margin: 2rem auto;
  background: #f8f9ff;
}

.logos-container {
  display: flex;
  gap: 2.5rem;
  overflow-x: auto;
  scroll-behavior: smooth;
  background: #f8f9ff;
  padding: 1rem 0;
  -ms-overflow-style: none;  
  scrollbar-width: none;  
}

.logos-container::-webkit-scrollbar {
  display: none;
}

.logo-wrapper {
  flex: 0 0 auto;
  transition: transform 0.3s ease;
}

.logo {
  height: 45px;
  width: auto;
  opacity: 0.7;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  filter: brightness(0.9);
}

.logo:hover {
  opacity: 1;
  transform: scale(1.08);
  filter: brightness(1);
  cursor: pointer;
}

.nav-button {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  transition: all 0.2s ease;
  z-index: 10;
}

.nav-button:hover {
  border-color: #3b82f6;
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.1);
  transform: translateY(-50%) scale(1.05);
}

.nav-button:active {
  transform: translateY(-50%) scale(0.95);
}

.left {
  left: -1rem;
}

.right {
  right: -1rem;
}

.chevron {
  color: #64748b;
  font-weight: 300;
  font-size: 1.2rem;
  transition: color 0.2s ease;
}

.nav-button:hover .chevron {
  color: #3b82f6;
}

@media (max-width: 768px) {
  .logos-carousel {
    padding: 0 1rem;
  }
  
  .logo {
    height: 35px;
  }
  
  .nav-button {
    width: 35px;
    height: 35px;
  }
  
  .left {
    left: -0.5rem;
  }
  
  .right {
    right: -0.5rem;
  }
}
</style>


<script setup>
import { ref } from 'vue';



const logosContainer = ref(null);

const scrollLeft = () => {
  if (logosContainer.value) {
    logosContainer.value.scrollBy({ left: -200, behavior: 'smooth' });
  }
};

const scrollRight = () => {
  if (logosContainer.value) {
    logosContainer.value.scrollBy({ left: 200, behavior: 'smooth' });
  }
};

const logos = [
  { src: new URL('@/assets/logo-gta.png', import.meta.url).href, alt: 'GTA' },
  { src: new URL('@/assets/logo-at.png', import.meta.url).href, alt: 'Algérie Télécom' },
  { src: new URL('@/assets/logo-poste.png', import.meta.url).href, alt: 'Algérie Poste' },
  { src: new URL('@/assets/logo-mobilis.png', import.meta.url).href, alt: 'Mobilis' },
  { src: new URL('@/assets/logo-comintal.png', import.meta.url).href, alt: 'Comintal' },
  { src: new URL('@/assets/logo-saticom.png', import.meta.url).href, alt: 'Saticom' },
  { src: new URL('@/assets/logo-inttic.png', import.meta.url).href, alt: 'INTTIC' },
  { src: new URL('@/assets/logo-numirisation.png', import.meta.url).href, alt: 'Numérisation' },
  { src: new URL('@/assets/logo-anf.png', import.meta.url).href, alt: 'ANF' },
  { src: new URL('@/assets/logo-ats.png', import.meta.url).href, alt: 'ATS' },
  { src: new URL('@/assets/logo-natp.png', import.meta.url).href, alt: 'NATP' },
  { src: new URL('@/assets/logo-inptic.png', import.meta.url).href, alt: 'INPTIC' },
  { src: new URL('@/assets/logo-eci-tic.png', import.meta.url).href, alt: 'ECI-TIC' },
  { src: new URL('@/assets/logo-wb.png', import.meta.url).href, alt: 'WB' },
  { src: new URL('@/assets/logo-netbeopen.png', import.meta.url).href, alt: 'NetBeOpen' },
  { src: new URL('@/assets/logo-ems.png', import.meta.url).href, alt: 'EMS' }
];



</script>
  