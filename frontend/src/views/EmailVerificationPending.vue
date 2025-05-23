<template>
    <div class="verification-pending">
      <div class="email-icon">📨</div>
      <h2>Vérification de votre adresse email en cours...</h2>
      <p>
        Un email a été envoyé à votre adresse. Veuillez vérifier votre boîte de réception 
        (et le dossier Spam) pour confirmer votre adresse.
      </p>
      
      <div v-if="successMessage" class="message success-message">{{ successMessage }}</div>
      <div v-if="errorMessage" class="message error-message">{{ errorMessage }}</div>
  
      <p>
        Si vous ne recevez pas l'email, <a class="resend-link" @click="resendVerificationEmail">
        cliquez ici pour renvoyer l'email de vérification.</a>
      </p>
    </div>
  </template>
  <script>
  import axios from 'axios';  
  
  const apiUrl = import.meta.env.VITE_API_URL;
  
  export default {
    data() {
      return {
        userEmail: localStorage.getItem('userEmail') || '', 
        successMessage: '',
        errorMessage: '',
        isEmailVerified: false 
      };
    },
    watch: {
      isEmailVerified(newValue) {
        if (newValue) {
          this.$router.push('/email-verified-success');
        }
      }
    },
    methods: {
      checkEmailVerificationStatus() {
        axios.get(`${apiUrl}/api/email/verification-status`, {
          params: { email: this.userEmail }
        })
        .then(response => {
          this.isEmailVerified = response.data.isVerified;
        })
        .catch(error => {
          console.error('Error checking email verification status:', error);
        });
      },
      resendVerificationEmail() {

        if (!this.userEmail) {
          alert("Impossible de renvoyer l'email de vérification. Email non trouvé.");
          return;
        }
  
        axios.post(`${apiUrl}/api/email/custom-resend`, {
          email: this.userEmail,
        })
        .then(response => {
          this.successMessage = response.data.message;
          alert(this.successMessage); 
        })
        .catch(error => {
          this.errorMessage = error.response.data.message || 'Erreur lors de l’envoi de l’e-mail.';
          alert(this.errorMessage); 
        });
      },
    },
    mounted() {
      this.checkEmailVerificationStatus();
    }
  };
  </script>
  <style scoped>
  .verification-pending {
    max-width: 500px;
    margin: 100px auto 0;
    padding: 2.5rem;
    background: white;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    text-align: center;
  }
  
  .verification-pending h2 {
    color: #2c3e50;
    font-size: 1.8rem;
    margin-bottom: 1.5rem;
    font-weight: 600;
    line-height: 1.3;
  }
  
  .verification-pending p {
    color: #7f8c8d;
    margin-bottom: 1.5rem;
    font-size: 1.1rem;
    line-height: 1.6;
    padding: 0 1rem;
  }
  
  .email-icon {
    font-size: 4rem;
    margin-bottom: 2rem;
    display: inline-block;
    animation: float 3s ease-in-out infinite;
  }
  
  .resend-link {
    color: #2196F3;
    cursor: pointer;
    text-decoration: none;
    font-weight: 500;
    transition: all 0.3s ease;
    border-bottom: 2px solid transparent;
  }
  
  .resend-link:hover {
    color: #1976D2;
    border-bottom-color: #2196F3;
  }
  
  .message {
    padding: 1rem;
    border-radius: 8px;
    margin: 1.5rem 0;
    font-weight: 500;
  }
  
  .success-message {
    background: #e8f5e9;
    color: #43a047;
  }
  
  .error-message {
    background: #ffebee;
    color: #e53935;
  }
  
  @keyframes float {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-10px); }
  }
  
  @media (max-width: 600px) {
    .verification-pending {
      margin: 50px 15px;
      padding: 1.5rem;
    }
    
    .verification-pending h2 {
      font-size: 1.5rem;
    }
    
    .verification-pending p {
      font-size: 1rem;
      padding: 0;
    }
    
    .email-icon {
      font-size: 3rem;
    }
  }
  </style>