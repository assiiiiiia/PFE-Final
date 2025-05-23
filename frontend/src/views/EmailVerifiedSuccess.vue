<template>
  <div class="email-verified-success">
    <div class="checkmark">✅</div>
    <h2>Votre email a été vérifié avec succès !</h2>
    <p>Vous pouvez maintenant vous connecter à votre compte.</p>
    <button @click="loginAfterVerification">Se connecter</button>
  </div>
</template>
<script>
import axios from 'axios';

const apiUrl = import.meta.env.VITE_API_URL;

export default {
  name: 'EmailVerifiedSuccess',
  data() {
    return {
      email: '',
      password: '',
      recaptchaToken: ''
    };
  },
  created() {
    const registerData = JSON.parse(localStorage.getItem('registerData'));
    
    if (registerData) {
      this.email = registerData.email;
      this.password = registerData.password;
      this.recaptchaToken = registerData.recaptchaToken || ''; 
    } else {
      alert("Aucune donnée d'enregistrement trouvée.");
    }
  },
  methods: {
    async loginAfterVerification() {
      try {
        const loginData = {
          email: this.email,
          password: this.password
        };


        const loginResponse = await axios.post(`${apiUrl}/api/login`, loginData);

        if (loginResponse.data.success) {
          localStorage.setItem('token', loginResponse.data.token);
          localStorage.setItem('user', JSON.stringify(loginResponse.data.user));
          localStorage.removeItem('registerData'); 
          this.$router.push('/');
        } else {
          alert('Erreur de connexion : ' + loginResponse.data.message);
        }
      } catch (error) {
        console.error("Erreur de connexion :", error);
        alert("Erreur de connexion.");
      }
    }
  }
};
</script>

<style scoped>
.email-verified-success {
  max-width: 500px;
  margin: 100px auto 0;
  padding: 2rem;
  background: white;
  border-radius: 15px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.email-verified-success h2 {
  color: #2c3e50;
  font-size: 1.8rem;
  margin-bottom: 1rem;
  font-weight: 600;
}

.email-verified-success p {
  color: #7f8c8d;
  margin-bottom: 2rem;
  font-size: 1.1rem;
  line-height: 1.6;
}

.email-verified-success button {
  background: #4CAF50;
  color: white;
  border: none;
  padding: 12px 30px;
  font-size: 1rem;
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-weight: 500;
  letter-spacing: 0.5px;
  text-transform: uppercase;
  box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
}

.email-verified-success button:hover {
  background: #45a049;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4);
}

.email-verified-success button:active {
  transform: translateY(0);
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

.checkmark {
  font-size: 4rem;
  color: #4CAF50;
  margin-bottom: 1.5rem;
  display: inline-block;
  animation: bounce 1s ease-in-out;
}

/* Responsive Design */
@media (max-width: 600px) {
  .email-verified-success {
    margin: 50px 15px;
    padding: 1.5rem;
  }
  
  .email-verified-success h2 {
    font-size: 1.5rem;
  }
  
  .email-verified-success p {
    font-size: 1rem;
  }
}
</style>