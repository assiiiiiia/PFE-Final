import { createRouter, createWebHistory } from 'vue-router';
import Login from '../components/Login.vue';
import Register from '../views/Register.vue';
import DashboardAdmin from '../views/dashboard-admin.vue';

import DashboardSuperAdmin from '../views/dashboard-SuperAdmin.vue';
import OffreForm from '@/views/OffreForm.vue';
import Dashboard from "@/views/dashboard.vue";
import Users from "@/views/Users.vue";

import ProfileUp from '../components/ProfileUp.vue';
import Entreprise from '../views/Entreprise.vue';
import AdminLogin from "@/views/AdminLogin.vue";
import Admins from '../views/Admins.vue';
import Unauthorized from "@/views/Unauthorized.vue";
import OffresDetails from '../components/OffresDetails.vue';
import OffresListe from '../components/OffresListe.vue';
import Index from '../views/Index.vue';
import Home from '../views/LandingPage.vue';
import Favorites from '../views/Favorites.vue';
import GestionSoumission from '../views/GestionSoumission.vue';
import EtatSoumission from '../views/EtatSoumission.vue';
import Offres from '../views/Offres.vue';
import Profile from '../components/ProfilUser.vue';
import OffreConsulter from '../views/OffreConsulter.vue';
import EmailVerifiedSuccess from '@/views/EmailVerifiedSuccess.vue';
import EmailVerificationPending from '@/views/EmailVerificationPending.vue';
import SuggestionsList from '@/views/SuggestionsList.vue';
import Notification from '../views/Notification.vue';
const routes = [
  {
    path: '/',
    component: Index, 
    children: [
      { path: '', component: Home },
      { path: 'favorites', component: Favorites },
       { path: 'offres', component: OffresListe },
       { path: 'etat-soumission', component: EtatSoumission },
       { path: 'register', component: Register},
       { path: 'profile', component: Profile},
       {path:'notifications', component: Notification},
    ],
  },
  { path: '/email-verified-success',name: 'EmailVerifiedSuccess', component: EmailVerifiedSuccess,},
  {
    path: '/email-verification-pending',
    name: 'EmailVerificationPending',
    component: EmailVerificationPending,
  },
  { path: '/details/:id', component: OffresDetails },
  { path: '/login', component: Login },
  { path: '/adminlogin', component: AdminLogin },
  { path: '/unauthorized', component: Unauthorized },


  { 
    path: '/dashboard-admin',
    component: DashboardAdmin,  
    meta: { requiresAuth: true, role: 'admin' },
    children: [
      { path: '', component: Dashboard },  
      { path: 'users', component: Users },  
     
      { path: 'entreprise', component: Entreprise },
      { path: 'profile', component: ProfileUp },
      { path: 'offre-form', component: OffreForm },
      { path: 'offres', component: Offres },
      { path: 'consulter/:id', component: OffreConsulter },  
      { path: 'Soumission', component: GestionSoumission },  
    ]
  },

  // Dashboard Super Admin
  { 
    path: '/dashboard-superadmin',
    component: DashboardSuperAdmin,  
    meta: { requiresAuth: true, role: 'superadmin' },
    children: [
      { path: '', component: Dashboard },  
      { path: 'users', component: Users }, 
      { path: 'admins', component: Admins }, 
      { path: 'entreprise', component: Entreprise },
      { path: 'profile', component: ProfileUp },
      { path: 'consulter/:id', component: OffreConsulter },  
      { path: 'offre-form', component: OffreForm } ,
      { path: 'offres', component: Offres } ,
      { path: 'suggestions', component: SuggestionsList } 
    ]
  },


  { 
    path: '/offres',
    name: 'Offres',
    component: OffresListe,
    props: true, 
  },
  { 
    path: '/details/:id',
    name: 'OffresDetails',
    component: OffresDetails,
    props: true, 
  },
  {
    path: '/unauthorized',
    name: 'Unauthorized',
    component: Unauthorized,
    props: true, 
  }
  
];

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (to.hash) {
      const element = document.querySelector(to.hash);
      if (element) {
        return {
          el: to.hash,
          behavior: 'smooth',
        };
      }
    }
    return { top: 0 };
  },
});

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token');
  const user = JSON.parse(localStorage.getItem('user'));
  

  if (to.meta.requiresAuth) {
    if (!token || !user) {
      return next('/');
    }
    
    if (to.meta.role) {
      if (!user.role || to.meta.role !== user.role) {
        return next('/unauthorized');
      }
    }
  }

 if (user && !user.role) {
    if (
      to.path.startsWith('/dashboard-admin') || 
      to.path.startsWith('/dashboard-superadmin')
    ) {
      return next('/unauthorized');
    }
  }

 if (user && user.role) {
  
    if (user.role === 'admin' && to.path.startsWith('/dashboard-superadmin')) {
      return next('/unauthorized');
    }
    if (user.role === 'superadmin' && to.path.startsWith('/dashboard-admin')) {
      return next('/unauthorized');
    }
    
  
  } else {
 
    if (to.path === '/login') {
      return next('/');
    }
  }

  next();
});



export default router;


