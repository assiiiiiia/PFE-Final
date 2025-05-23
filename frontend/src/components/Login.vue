<template>
  <div v-if="showModal" class="modal-overlay">
    <div class="modal">
      <button @click="$emit('close')" class="close">&times;</button>
      <h2>{{ $t("auth.title") }}</h2>
      <input type="email" :placeholder="$t('auth.emailPlaceholder')" v-model="email" />
      <input type="password" :placeholder="$t('auth.passwordPlaceholder')" v-model="password" />

  
      <div class="recaptcha-container">
        <RecaptchaV2
          ref="recaptchaRef"
          :sitekey="sitekey"
          @loadCallback="onVerify"
          @expiredCallback="onExpired"
        />
      </div>

      <button class="login" @click="login">{{ $t("auth.loginButton") }}</button>
  
      
      <p>
        <a href="/register">{{ $t("auth.notRegistered") }}</a>
      </p>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { RecaptchaV2 } from "vue3-recaptcha-v2"; 
const apiUrl = import.meta.env.VITE_API_URL;

export default {
  props: {
    showModal: Boolean,
  },
  components: {
    RecaptchaV2,
  },
  data() {
    return {
      email: "",
      password: "",
      recaptchaVerified: false,
      recaptchaResponse: null,
      sitekey: "6Lc76v8qAAAAAHRVfJwi-ROZh2EEgbKpQarOqZXJ",
      rememberMe: false, 
    };
  },
  methods: {
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
    async login() {
  if (!this.recaptchaVerified) {
    return alert("Veuillez confirmer que vous n'êtes pas un robot.");
  }
  try {
    const response = await axios.post(`${apiUrl}/api/login`, {
      email: this.email,
      password: this.password,
      recaptchaToken: this.recaptchaResponse,
    });

    console.log("Réponse du serveur :", response.data);

    if (response.data.success) {
      localStorage.setItem("token", response.data.token);
      localStorage.setItem("user", JSON.stringify(response.data.user));
      this.$emit("close");
      window.location.href = "/";
      console.log("Utilisateur connecté :", response.data.user);
    } else {
      alert("La connexion a échoué.");
    }
  } catch (error) {
    console.error("Erreur lors de la connexion:", error);
    if (error.response && error.response.status === 403) {
      alert(error.response.data.message || "Veuillez vérifier votre adresse e-mail avant de vous connecter.");
  
      this.$router.push("/email-verification-pending");
    } else {
      alert("Une erreur est survenue.");
    }
  }
},

  },
};
</script>

<style>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.377); 
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
  animation: fadeIn 0.3s ease-in-out;
}

.modal {
  background: linear-gradient(135deg, #ffffff, #ffffff);
  padding: 30px;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  position: relative;
  width: 90%;
  max-width: 400px;
  animation: slideIn 0.3s ease-out;
}


.recaptcha-container {
  margin: 20px auto;
  display: flex;
  justify-content: center;
  max-width: 1000px;
}


.close {
  position: absolute;
  top: 10px;
  right: 15px;
  background: none;
  border: none;
  font-size: 28px;
  color: #333;
  cursor: pointer;
}

h2 {
  margin-top: 0;
  text-align: center;
  font-family: 'Roboto', sans-serif;
  color: #1E3A8A;
}

input[type="email"],
input[type="password"] {
  width: 100%;
  padding: 12px 15px;
  margin: 10px 0;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-size: 16px;
  box-sizing: border-box;
  transition: border-color 0.3s ease;
}
input[type="email"]:focus,
input[type="password"]:focus {
  border-color: #007BFF;
  outline: none;
}

button.login {
  width: 100%;
  padding: 12px;
  background: linear-gradient(135deg, #1E3A8A, #15275a);
  border: none;
  color: #fff;
  font-size: 16px;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.5s ease, transform 0.2s ease;
}

button.login:hover {
  background: linear-gradient(135deg, #183b60, #10365f);
  transform: scale(1.02); 
}

p {
  margin: 10px 0;
  font-size: 14px;
  text-align: center;
}
p a {
  color: #1E3A8A;
  text-decoration: none;
  transition: text-decoration 0.3s ease;
}
p a:hover {
  text-decoration: underline;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
@keyframes slideIn {
  from { transform: translateY(-30px); }
  to { transform: translateY(0); }
}
</style>
