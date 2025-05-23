<template>
  <div>
    <HeaderComponent />
    <WhyPortal id="why-portal" />
   
    <HowItWorks id="how-it-works" />
    <Partenaire id="partenaires" />
    <InteractiveSection id="interactive-section" />
  </div>
</template>

<script setup>
import HeaderComponent from '@/components/Landing page/HeaderComponent.vue'
import WhyPortal from '@/components/Landing page/WhyPortal.vue'

import HowItWorks from '@/components/Landing page/HowItWorks.vue'
import InteractiveSection from '@/components/Landing page/InteractiveSection.vue'
import Partenaire from '../components/Landing page/Partenaire.vue'
</script>
