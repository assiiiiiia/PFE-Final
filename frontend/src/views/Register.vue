<template>
  <section class="form-container">
   

    <form id="msform" @submit.prevent="submitForm">
      <div class="progress-container">
  
  <ul id="progressbar">
    <li v-for="(stepItem, index) in 3" :key="index" 
        :class="{ active: step > index, current: step === index + 1 }"
        @click="handleStepClick(index + 1)"
      >
      <div class="step-number">
        <span class="number">{{ index + 1 }}</span>
        <svg v-if="step > index" class="checkmark" viewBox="0 0 24 24">
          <path fill="currentColor" d="M21,7L9,19L3.5,13.5L4.91,12.09L9,16.17L19.59,5.59L21,7Z"/>
        </svg>
      </div>
      
    </li>
  </ul>
</div>
      <transition name="transitionName" mode="out-in">
        <fieldset v-if="step === 1">
          <h2 class="fs-title">{{ $t("registration.accountInfo.title") }}</h2>

          <input
            type="email"
            v-model="email"
            required
            :placeholder="$t('registration.accountInfo.emailPlaceholder')"
          />

          <div class="password-container">
            <input
              :type="showPassword1 ? 'text' : 'password'"
              v-model="password"
              required
              :placeholder="$t('registration.accountInfo.passwordPlaceholder')"
            />
            <span class="eye-pass" @click="togglePassword(1)">
              <i :class="showPassword1 ? 'fa-solid fa-eye' : 'fa-solid fa-eye-slash'"></i>
            </span>
          </div>

          <div class="password-container">
            <input
              :type="showPassword2 ? 'text' : 'password'"
              v-model="password2"
              required
              :placeholder="$t('registration.accountInfo.confirmPasswordPlaceholder')"
            />
            <span class="eye-pass" @click="togglePassword(2)">
              <i :class="showPassword2 ? 'fa-solid fa-eye' : 'fa-solid fa-eye-slash'"></i>
            </span>
          </div>

          <button type="button" @click="nextStep">{{ $t("registration.accountInfo.nextButton") }}</button>
        </fieldset>
      </transition>

      <transition name="transitionName" mode="out-in">
        <fieldset v-if="step === 2">
          <h2 class="fs-title">{{ $t("registration.repContact.title") }}</h2>
          <!-- Representative Contact Fields -->
          <input type="text" v-model="nomEntreprise" required :placeholder="$t('registration.repContact.companyNamePlaceholder')" />
          <select v-model="civilite" required>
            <option value="">{{ $t("registration.repContact.selectCivility") }}</option>
            <option value="Monsieur">Monsieur</option>
            <option value="Madame">Madame</option>
          </select>
          <input type="text" v-model="nomRepresentant" required :placeholder="$t('registration.repContact.repLastNamePlaceholder')" />
          <input type="text" v-model="prenomRepresentant" required :placeholder="$t('registration.repContact.repFirstNamePlaceholder')" />
          <input type="text" v-model="fonction" required :placeholder="$t('registration.repContact.positionPlaceholder')" />
          <input type="text" v-model="numero" required :placeholder="$t('registration.repContact.phonePlaceholder')" />

          <select id="pays" name="pays" v-model="selectedCountry" @change="updateWilayaRequirement" required>
            <option value="">{{ $t("registration.repContact.selectCountry") }}</option>
            <option v-for="(name, key) in pays" :key="key" :value="name">
              {{ name }}
            </option>
          </select>

          <select
            v-if="selectedCountry === 'Algérie'"
            name="wilaya"
            id="wilaya"
            v-model="selectedWilaya"
            required
          >
            <option value="">{{ $t("registration.repContact.selectWilaya") }}</option>
            <option v-for="(name, key) in wilayas" :key="key" :value="name">
              {{ name }}
            </option>
          </select>

          <input type="text" v-model="adresse" required :placeholder="$t('registration.repContact.addressPlaceholder')" />
          <button type="button" @click="prevStep">{{ $t("registration.repContact.prevButton") }}</button>
          <button type="button" @click="nextStep">{{ $t("registration.repContact.nextButton") }}</button>
        </fieldset>
      </transition>

      <transition name="transitionName" mode="out-in">
        <fieldset v-if="step === 3">
          <h2 class="fs-title">{{ $t("registration.companyInfo.title") }}</h2>
          <!-- Company Info Fields -->
          <select name="activite" id="activite" v-model="activite" required>
            <option value="">{{ $t("registration.companyInfo.selectActivity") }}</option>
            <option v-for="(value, key) in activiteOptions" :key="key" :value="value">
              {{ value }}
            </option>
          </select>

          <select name="categorie" id="categorie" v-model="categorie" required @change="changeCategorie">
            <option value="">{{ $t("registration.companyInfo.selectCategory") }}</option>
            <option v-for="(value, key) in categorieOptions" :key="key" :value="value">
              {{ value }}
            </option>
          </select>
          <input type="text" v-model="codeCommerce" required :placeholder="$t('registration.companyInfo.tradeCodePlaceholder')" />
          <input type="text" v-model="nif" required :placeholder="$t('registration.companyInfo.nifPlaceholder')" />
          <input type="text" v-model="nis" required :placeholder="$t('registration.companyInfo.nisPlaceholder')" />
          <input type="text" v-model="nin"  required :placeholder="$t('registration.companyInfo.ninPlaceholder')"
            pattern="^[0-9]{18}$" maxlength="18" inputmode="numeric"/>

          <select name="nbr_employe" v-model="nombreEmployes" required>
            <option value="">{{ $t("registration.companyInfo.selectEmployeeCount") }}</option>
            <option value="-10">{{ $t("registration.companyInfo.employeeCount.lessThan10") }}</option>
            <option value="10-49">{{ $t("registration.companyInfo.employeeCount.from10to49") }}</option>
            <option value="50-249">{{ $t("registration.companyInfo.employeeCount.from50to249") }}</option>
            <option value="+250">{{ $t("registration.companyInfo.employeeCount.moreThan250") }}</option>
          </select>

          <div class="recaptcha-container">
            <RecaptchaV2
              ref="recaptchaRef"
              :sitekey="sitekey"
              @loadCallback="onVerify"
              @expiredCallback="onExpired"
            />
          </div>
          <button type="button" @click="prevStep">{{ $t("registration.companyInfo.prevButton") }}</button>
          <button type="submit">{{ $t("registration.companyInfo.submitButton") }}</button>
        </fieldset>
      </transition>
    </form>
  </section>
</template>
<script>
import axios from 'axios';
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { RecaptchaV2 } from "vue3-recaptcha-v2"; 

import wilayasFr from '@/data/wilayas_fr.json';
import wilayasAr from '@/data/wilayas_ar.json';

import paysFr from '@/data/pays_fr.json';
import paysAr from '@/data/pays_ar.json';

import categorieFr from '@/data/categorie_fr.json';
import categorieAr from '@/data/categorie_ar.json';

import activiteFr from '@/data/activite_fr.json';
import activiteAr from '@/data/activite_ar.json';

const apiUrl = import.meta.env.VITE_API_URL;

export default {
  name: 'InscripForm',
  data() {
    return {
      step: 1,
      email: '',
      password: '',
      password2: '',
      showPassword1: false,
      showPassword2: false,
      nomEntreprise: '',
      civilite: '',
      nomRepresentant: '',
      prenomRepresentant: '',
      fonction: '',
      numero: '',
      selectedCountry: '',
      selectedWilaya: '',
      wilayaRequired: false,
      adresse: '',
      activite: '',
      categorie: '',
      codeCommerce: '',
      nif: '',
      nis: '',
      nin: '',
      nombreEmployes: '',
      recaptchaVerified: false,
      recaptchaResponse: null,
      sitekey: "6Lc76v8qAAAAAHRVfJwi-ROZh2EEgbKpQarOqZXJ",
    };
  },
  components: {
    RecaptchaV2,
  },
  computed: {
   
    wilayas() {
      return this.$i18n.locale === 'fr' ? wilayasFr : wilayasAr;
    },
    pays() {
      return this.$i18n.locale === 'fr' ? paysFr : paysAr;
    },
    categorieOptions() {
      return this.$i18n.locale === 'fr' ? categorieFr : categorieAr;
    },
    activiteOptions() {
      return this.$i18n.locale === 'fr' ? activiteFr : activiteAr;
    },
    progressPercent() {
      return Math.round(((this.step - 1) / (this.totalSteps - 1)) * 100);
    },
    totalSteps() {
      return 3;
    }
  },
  methods: {
    nextStep() {
      if (this.step < this.totalSteps) {
        this.step++;
      }
    },
    prevStep() {
      if (this.step > 1) {
        this.step--;
      }
    },
    animateContainer() {
      const container = document.querySelector('.form-container');
      if (container) {
        container.classList.add('fade-scale');
        setTimeout(() => {
          container.classList.remove('fade-scale');
        }, 300);
      }
    },
    togglePassword(field) {
      if (field === 1) {
        this.showPassword1 = !this.showPassword1;
      } else {
        this.showPassword2 = !this.showPassword2;
      }
    },
    updateWilayaRequirement() {
  if (this.$i18n.locale === 'fr') {
    this.wilayaRequired = this.selectedCountry === 'Algérie';
  } else {
    this.wilayaRequired = this.selectedCountry === 'الجزائر';
  }
  if (!this.wilayaRequired) {
    this.selectedWilaya = "";
  }
},
onVerify(response) {
      this.recaptchaVerified = true;
      this.recaptchaResponse = response;
      console.log("reCAPTCHA token:", response);
    },
    onExpired() {
      this.recaptchaVerified = false;
      this.recaptchaResponse = null;
      this.$refs.recaptchaRef.reset();
    },

    resetForm() {
      this.email = '';
      this.password = '';
      this.password2 = '';
      this.nomEntreprise = '';
      this.civilite = '';
      this.nomRepresentant = '';
      this.prenomRepresentant = '';
      this.fonction = '';
      this.numero = '';
      this.selectedCountry = '';
      this.selectedWilaya = '';
      this.wilayaRequired = false;
      this.adresse = '';
      this.activite = '';
      this.categorie = '';
      this.codeCommerce = '';
      this.nif = '';
      this.nis = '';
      this.nin = '';
      this.nombreEmployes = '';
      this.captchaResponse = '';
    },
    changeCategorie(event) {
      this.categorie = event.target.value;
      console.log("Catégorie sélectionnée :", this.categorie);
    },
  
    handleCaptchaVerified(response) {
      this.captchaResponse = response;
    },
    async submitForm() {
      if (!this.email || !this.password || !this.password2 || !this.selectedCountry || !this.activite || !this.categorie) {
        alert("Tous les champs requis doivent être remplis.");
        return;
      }
      if (this.password !== this.password2) {
        alert("Les mots de passe ne correspondent pas.");
        return;
      }
      let formData = new FormData();
      formData.append('email', this.email);
      formData.append('password', this.password);
      formData.append('password_confirmation', this.password2);
      formData.append('civilite', this.civilite);
      formData.append('nom', this.nomRepresentant);
      formData.append('prenom', this.prenomRepresentant);
      formData.append('fonction', this.fonction);
      formData.append('telephone', this.numero);
      formData.append('pays', this.selectedCountry);
      formData.append('adresse', this.adresse);
      formData.append('nom_entreprise', this.nomEntreprise);
      formData.append('activite', this.activite);
      formData.append('categorie', this.categorie);
      formData.append('code_commerce', this.codeCommerce);
      formData.append('num_fiscal', this.nif);
      formData.append('num_statistique', this.nis);
      formData.append('num_national', this.nin);
      formData.append('nombre_employes', this.nombreEmployes);
      if (this.wilayaRequired) {
        formData.append('wilaya', this.selectedWilaya);
      }
      if (!this.recaptchaVerified) {
  alert("Veuillez vérifier que vous n'êtes pas un robot.");
  return;
}
const registerData = {
  email: this.email,
  password: this.password,
};
localStorage.setItem('registerData', JSON.stringify(registerData));

  console.log("Données envoyées :", [...formData.entries()]);
  try {
    const response = await axios.post(`${apiUrl}/api/register`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    });
    alert("Un email de vérification a été envoyé!");
    this.$router.push("/email-verification-pending");
  } catch (error) {
    console.error("Erreur lors de l'inscription :", error);
    if (error.response && error.response.status === 422) {
      const validationErrors = error.response.data.errors;
      alert("Erreur lors de l'inscription : " + JSON.stringify(validationErrors));
    } else {
      alert("Erreur lors de l'inscription.");
    }
  }

        this.resetForm();
      
    }
  },
  mounted() {
    if (!window.grecaptcha) {
      console.error("Le script reCAPTCHA n'est pas chargé. Assurez-vous d'avoir ajouté la balise.");
    }
  }
};
</script>

<style scoped>
.form-container {
  background-color: #ffffff;
  color: #1E3A8A;
  padding: 2rem;
  max-width: 600px;
  margin: 2rem auto;
  border: 1px solid #ccc;
  border-radius: 10px;
  font-family: 'Segoe UI', sans-serif;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
}
.progress-container {
  --primary-color: #1E3A8A;
  --secondary-color: #219e68;
  --step-active: #219e68;
  --step-inactive: #cbd5e1;
  --progress-bg: #e2e8f0;
  --text-color: #1E3A8A;
  perspective: 1000px;
  position: relative;
  margin: 2rem auto 3rem;
  width: 90%;
}

.progress-bar {
  height: 8px;
  background: linear-gradient(
    90deg,
    var(--primary-color) 0%,
    var(--secondary-color) 50%,
    var(--primary-color) 100%
  );
  border-radius: 4px;
  transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 8px rgba(79, 70, 229, 0.2);
 
  transform-style: preserve-3d;
  position: relative;
  overflow: hidden;
}
.progress-bar::after {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 50%;
  height: 100%;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.4),
    transparent
  );
  animation: shimmer 2s infinite;
}
@keyframes shimmer {
  100% {
    left: 200%;
  }
}


#progressbar li.current .step-number {
  transform: scale(1.15);
  box-shadow: 
    0 0 0 6px rgba(79, 70, 229, 0.15),
    0 4px 12px rgba(79, 70, 229, 0.25);
  transition: all 0.3s ease-out;
}


#progressbar li:not(:first-child):before {
  transition: background 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}
#progressbar {
  display: flex;
  justify-content: space-between;
  padding: 0;
  margin: 0;
  list-style: none;
  position: relative;
  z-index: 2;
}

#progressbar li {
  flex: 1;
  text-align: center;
  position: relative;
}

.step-number {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: white;
  color:rgb(255, 255, 255);
  border: 2px solid var(--step-inactive);
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 8px;
  transition: all 0.3s cubic-bezier(0.68, -0.55, 0.27, 1.55), 
              background-color 0.3s ease,
              border-color 0.3s ease;
  position: relative;
  font-weight: 500;
  color: var(--step-inactive);
}


#progressbar li.active .step-number {
  background: var(--step-active);
  border-color: var(--step-active);
  color: rgb(255, 255, 255);
}

#progressbar li.active .step-number .checkmark {
  opacity: 1;
  transform: scale(1);
}

#progressbar li.current .step-number {
  transform: scale(1.1);
  box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.2);
}

.step-text {
  display: block;
  font-size: 0.9rem;
  color: var(--step-inactive);
  transition: color 0.3s ease;
  padding: 0 5px;
}


#progressbar li.active .step-number {
  background: var(--secondary-color) !important;
  border-color: var(--secondary-color) !important;
  box-shadow: 0 4px 12px rgba(99, 102, 241, 0.25);
}

#progressbar li.active .checkmark {
  opacity: 1;
  transform: translate(-50%, -50%) scale(1.1);
  filter: drop-shadow(0 2px 4px rgba(255, 255, 255, 0.2));
}


.number {
  transition: opacity 0.2s ease, transform 0.3s ease;
}

#progressbar li.active .number {
  opacity: 0;
  transform: scale(0.8);
}


.checkmark path {
  fill: #ffffff;
  stroke: #ffffff;
  stroke-width: 0.5px;
  
}
#progressbar li.active .step-text {
  color: var(--step-active);
  font-weight: 500;
}


#progressbar li:not(:first-child):before {
  content: '';
  position: absolute;
  width: calc(100% - 40px);
  height: 4px;
  background: var(--step-inactive);
  left: calc(-50% + 20px);
  top: 15px;
  transition: background 0.4s ease;
}

#progressbar li.active:before {
  background: var(--step-active);
}


.checkmark {
  display: block;
  font-size: 0.1rem;
  color: var(--step-inactive);
  transition: color 0.3s ease;
  padding: 5px 5px;
}

#progressbar li.active .checkmark {
  transform: translate(-50%, -50%) scale(1);
}

#progressbar li.current .step-number {
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0% { box-shadow: 0 0 0 0 rgba(79, 70, 229, 0.2); }
  70% { box-shadow: 0 0 0 12px rgba(79, 70, 229, 0); }
  100% { box-shadow: 0 0 0 0 rgba(79, 70, 229, 0); }
}

#progressbar li:hover .step-number {
  transform: scale(1.05);
  cursor: pointer;
}

#progressbar li:hover .step-text {
  color: var(--secondary-color);
  transform: translateY(-2px);
}

.step-text {
  transition: all 0.2s ease;
}

.number {
  transition: opacity 0.3s ease;
}

#progressbar li.active .number {
  opacity: 0;
}


.slide-enter-active {
  transition: all 0.3s cubic-bezier(0.55, 0, 0.1, 1);
}
.slide-leave-active {
  transition: all 0.3s cubic-bezier(0.55, 0, 0.1, 1);
}
.slide-enter-from {
  opacity: 0;
  transform: translateX(40px);
}
.slide-leave-to {
  opacity: 0;
  transform: translateX(-40px);
}
fieldset {
  border: none;
  padding: 0;
  margin: 0;
}

.fs-title {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: #1E3A8A;
}
.form-container input, .form-container select {
  width: 100%;
  padding: 0.75rem;
  margin: 0.5rem 0;
  border-radius: 5px;
  border: 1px solid #ccc;
  font-size: 1rem;
  box-sizing: border-box;
}
.form-container input:focus, .form-container select:focus {
  outline: none;
  border-color: #001f3f;
  box-shadow: 0 0 5px #001f3f44;
}
.form-container .password-container {
  position: relative;
  width: 100%;
}
.form-container .password-container input {
  padding-right: 2.5rem; 
}
.form-container .eye-pass {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  font-size: 1.1rem;
  user-select: none;
}
.form-container button {
  background-color: #1E3A8A;
  color: white;
  padding: 0.75rem 1.5rem;
  margin: 1rem 0.5rem 0 0;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-weight: bold;
  transition: background-color 0.3s ease;
}
.form-container button:hover {
  background-color: #03274b;
}
.form-container .recaptcha-container {
  margin: 20px auto;
  display: flex;
  justify-content: center;
  max-width: 400px;
}

</style>
