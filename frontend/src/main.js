import { createApp, watch } from 'vue'
import './style.css'
import App from './App.vue'
import axios from 'axios';
import router from './router';
import { library } from '@fortawesome/fontawesome-svg-core';

import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

import { install as VueRecaptchaV2 } from "vue3-recaptcha-v2";
import {
  faUserPlus, faUserShield, faEdit, faTrash,
  faCircleChevronLeft, faCircleChevronRight,
  faLandmark, faLaptopCode, faCaretRight, faBalanceScale,
  faArrowRight, faCheckCircle, faHome, faUsers,
  faBuilding, faCog, faNewspaper, faTag, faPaperPlane
} from '@fortawesome/free-solid-svg-icons';
axios.defaults.baseURL = 'http://127.0.0.1:8000/api';
import proj4 from 'proj4';
window.proj4 = proj4;            


library.add(
  faUserPlus, faUserShield, faEdit, faTrash,
  faCircleChevronLeft, faCircleChevronRight,
  faLandmark, faLaptopCode, faCaretRight, faBalanceScale,
  faArrowRight, faCheckCircle, faHome, faUsers,
  faBuilding, faCog, faNewspaper, faTag, faPaperPlane
);

import { createI18n } from 'vue-i18n';
import fr from './locales/fr.json';
import ar from './locales/ar.json';


import HighchartsVue from 'highcharts-vue'

import Highcharts from 'highcharts'

import 'highcharts/modules/map'

const savedLocale = localStorage.getItem('locale') || 'fr';

const i18n = createI18n({
  legacy: false,
  locale: savedLocale,
  fallbackLocale: 'fr',
  messages: { fr, ar }
});

const app = createApp(App);
app.component('font-awesome-icon', FontAwesomeIcon);
app.use(router);
app.use(i18n);

app.use(HighchartsVue)
app.provide('Highcharts', Highcharts)
app.use(VueRecaptchaV2, { sitekey: "6Lc76v8qAAAAAHRVfJwi-ROZh2EEgbKpQarOqZXJ" });
app.mount('#app');


watch(
  () => i18n.global.locale,
  (newLocale) => {
    localStorage.setItem('locale', newLocale);
    document.documentElement.lang = newLocale;
  }
);
