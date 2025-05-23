<template>
  <footer class="legal-footer">
    <div class="footer-left">
      <p>
        <i class="fas fa-handshake mr-1"></i>
        {{ $t("footer.text") }}
      </p>
    </div>

    <div class="footer-center">
     <router-link
        class="nav-item"
        :to="{ path: '/', hash: '#interactive-section' }"
        exact-active-class="active-hash"
      >
               <i class="fas fa-lightbulb mr-1"></i>
        {{ $t("footer.suggestionLink") }}
      </router-link>
      <a href="/cadre_legal.pdf" target="_blank" rel="noopener">
        <i class="fas fa-file-alt mr-1"></i>
        {{ $t("footer.legalLink") }}
      </a>
 
    </div>

    <div class="footer-right">
      <span class="year">
        <i class="fas fa-copyright"></i> {{ new Date().getFullYear() }}
      </span>
    </div>

   
  
  </footer>
</template>

<script>
import axios from 'axios';
const token = localStorage.getItem('token');
const headers = token ? { Authorization: `Bearer ${token}` } : {};


const apiUrl = import.meta.env.VITE_API_URL;
export default {
  name: "CombinedFooter",
  data() {
    return {
      showModal: false,
      email: "",
      suggestion: ""
    };
  },
  async mounted() {
    
    const token = localStorage.getItem('token');
    if (token) {
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
      await this.fetchCurrentUser();
    } else {
      
      const storedEmail = localStorage.getItem('userEmail');
      if (!this.email) {
  this.email = ""; 
      } else {
        this.email = storedEmail;
}
    
    }
  },
  
  methods: {
    openModal() {
      this.showModal = true;
    },
    closeModal() {
      this.showModal = false;
    },
    async fetchCurrentUser() {
  try {
    const response = await axios.get(`${apiUrl}/api/user`);
    this.email = response.data.email;
    localStorage.setItem('userEmail', this.email);
    localStorage.setItem('userId', response.data.id);  // Store user ID
  } catch (error) {
    console.warn('Impossible de récupérer l\'utilisateur:', error);
  }
},
    async submitSuggestion() {
  if (!this.email.trim() || !this.suggestion.trim()) {
    return alert(this.$t("footer.fillAllFields"));
  }

  try {
    const userId = localStorage.getItem('userId'); 
    const payload = {
      email: this.email,
      content: this.suggestion,
      user_id: userId,
    };
    const res = await axios.post(`${apiUrl}/api/suggestions`, payload);

    alert(res.data.message);
    this.suggestion = "";
    this.closeModal();
  } catch (err) {
    if (err.response && err.response.data.errors) {
      const messages = Object.values(err.response.data.errors)
        .flat()
        .join("\n");
      alert(messages);
    } else {
      alert(this.$t("footer.genericError"));
    }
  }
}
  }
};
</script> 
<style scoped>
/* === COMPACT FOOTER === */

.legal-footer {
  background: #172b63;
  color: #ffffff;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  padding: 1rem 2rem;
  font-size: 0.9rem;
  border-top: 3px solid #0a3d62;
  gap: 1rem;
}

.footer-left,
.footer-center,
.footer-right {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.footer-left i,
.footer-center i,
.footer-right i {
  color: #ffffff;
  margin-right: 0.2rem;
}

.footer-center a {
  color: #ffffff;
  text-decoration: none;
  position: relative;
  font-weight: 500;
  transition: color 0.3s ease;
}

.footer-center a::after {
  content: "";
  position: absolute;
  left: 0;
  bottom: -2px;
  width: 0%;
  height: 2px;
  background: #ffffff;
  transition: width 0.3s ease;
}

.footer-center a:hover {
  color: #ffffff;
}
.footer-center a:hover::after {
  width: 100%;
}

.legal-footer .modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 2000;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 15, 30, 0.596);
  backdrop-filter: blur(4px);
  display: flex;
  justify-content: center;
  align-items: center;
  animation: fadeIn 0.3s ease;
}

/* === MODAL CONTAINER === */
.legal-footer .modal {
  background: #ffffff;
  padding: 2rem;
  border-radius: 1rem;
  width: 90%;
  max-width: 480px;
  box-shadow: 0 8px 24px rgba(0, 47, 95, 0.2);
  position: relative;
  animation: slideUp 0.3s ease;
}

/* === CLOSE BUTTON === */
.legal-footer .close {
  position: absolute;
  top: 1rem;
  right: 1.2rem;
  font-size: 1.6rem;
  color: #888;
  cursor: pointer;
  transition: color 0.3s ease;
}
.legal-footer .close:hover {
  color: #002f5f;
}

/* === MODAL TITLE === */
.modal h2 {
  margin-bottom: 1.2rem;
  font-size: 1.4rem;
  text-align: center;
  color: #002f5f;
}

/* === INPUTS === */
.modal input,
.modal textarea {
  width: 90%;
  padding: 0.8rem 1rem;
  margin-bottom: 1rem;
  border: 1px solid #ccc;
  border-radius: 0.7rem;
  font-size: 0.95rem;
  background-color: #f7faff;
  transition: border-color 0.3s ease;
}
.modal textarea {
  height: 100px;
  width: 400px;
  resize: none;
}
.modal input:focus,
.modal textarea:focus {
  border-color: #002f5f;
  outline: none;
}

/* === BUTTON === */
.legal-footer .modal button {
  background-color: #002f5f;
  color: #ffffff;
  padding: 0.8rem 1.5rem;
  border: none;
  font-weight: 600;
  font-size: 1rem;
  border-radius: 0.65rem;
  cursor: pointer;
  transition: background-color 0.3s ease, transform 0.2s ease;
  display: block;
  margin: 0 auto;
}

.modal button:hover {
  background-color: #014080;
  transform: translateY(-2px);
}

/* === ANIMATIONS === */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>