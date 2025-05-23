<template>
  <div class="login-container">
    <div class="background">
      <span v-for="i in 8" :key="i"></span>
    </div>
    <div class="form-container">
      <h2 class="title">Connexion Admin</h2>
      <form @submit.prevent="login" class="login-form">
        <div class="input-group">
  <i class="fas fa-envelope icon"></i>
  <input 
    v-model="email" 
    type="email" 
    id="email"
    required 
    class="input-field"
    placeholder=" "
  />
  <label class="input-label" for="email">Email Admin</label>
</div>

<div class="input-group">
  <i class="fas fa-lock icon"></i>
  <input 
    v-model="password" 
    type="password" 
    id="password"
    required 
    class="input-field"
    placeholder=" "
  />
  <label class="input-label" for="password">Mot de passe</label>
</div>
        <button type="submit" class="submit-btn">
          <span>Se connecter</span>
          <div class="fill-container"></div>
          <i class="fas fa-arrow-right icon-btn"></i>
        </button>
      </form>
    </div>
  </div>
</template>
  <script>
import axios from 'axios';
const apiUrl = import.meta.env.VITE_API_URL;

export default {
  data() {
    return {
      email: '',
      password: '',
    };
  },

  methods: {
    async login() {
  try {
    const response = await axios.post(`${apiUrl}/api/admin/login`, {
      email: this.email,
      password: this.password
    });

    if (!response.data || !response.data.token || !response.data.user) {
      throw new Error("Réponse API invalide !");
    }

    const { token, user } = response.data;

    localStorage.setItem('token', token);
    localStorage.setItem('user', JSON.stringify(user));

    if (user.role === 'superadmin') {
  this.$router.push('/dashboard-superadmin');
} else {
  this.$router.push('/dashboard-admin');
}

  } catch (error) {
    console.error("Erreur lors de la connexion :", error);
    alert("Email ou mot de passe incorrect");
  }
}

  }
};
  </script>
  
  <style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(45deg, #0f0c29, #302b63);
  position: relative;
  overflow: hidden;
}

.background span {
  position: absolute;
  background: rgba(255, 255, 255, 0.1);
  animation: animate 15s linear infinite;
  border-radius: 50%;
  pointer-events: none;
  transform: scale(0);
}

@keyframes animate {
  0% { transform: translateY(100vh) scale(0); }
  100% { transform: translateY(-20vh) scale(1); opacity: 0; }
}

.background span:nth-child(1) { left: 20%; animation-delay: 0s; width: 60px; height: 60px; }
.background span:nth-child(2) { left: 50%; animation-delay: 2s; width: 80px; height: 80px; }
.background span:nth-child(3) { left: 70%; animation-delay: 4s; width: 100px; height: 100px; }
.background span:nth-child(4) { left: 40%; animation-delay: 6s; width: 50px; height: 50px; }
.background span:nth-child(5) { left: 10%; animation-delay: 8s; width: 70px; height: 70px; }
.background span:nth-child(6) { left: 85%; animation-delay: 10s; width: 90px; height: 90px; }
.background span:nth-child(7) { left: 30%; animation-delay: 12s; width: 40px; height: 40px; }
.background span:nth-child(8) { left: 60%; animation-delay: 14s; width: 120px; height: 120px; }

.form-container {
  position: relative;
  background: rgb(255, 255, 255);
  padding: 40px 50px;
  border-radius: 20px;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
  width: 450px;
  backdrop-filter: blur(10px);
  animation: formEnter 0.8s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  border: 1px solid rgba(255, 255, 255, 0.3);
}

@keyframes formEnter {
  0% { opacity: 0; transform: translateY(50px) scale(0.95); }
  100% { opacity: 1; transform: translateY(0) scale(1); }
}

.title {
  color: #2c3e50;
  text-align: center;
  margin-bottom: 40px;
  font-size: 2.2em;
  font-weight: 700;
  letter-spacing: 1px;
  position: relative;
}

.title::after {
  content: '';
  position: absolute;
  bottom: -15px;
  left: 50%;
  transform: translateX(-50%);
  width: 60px;
  height: 3px;
  background: #2d79f3;
  border-radius: 2px;
  transition: all 0.3s ease;
}

.form-container:hover .title::after {
  width: 100px;
  background: #5ad085;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.input-group {
  position: relative;
  
}

.icon {
  position: absolute;
  left: 1rem;
  top: 50%;
  transform: translateY(-50%);
  color: #6b7280;
  transition: all 0.3s ease;
  z-index: 2;
}

.input-field {
  width: 100%;
  padding: 1rem 1rem 1rem 3rem;
  border: 2px solid #e5e7eb;

  border-radius: 0.9rem;
  font-size: 1rem;
  background: white;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

.input-field:focus {
  outline: none;
  border-color: #4f9bbe;
  box-shadow: 0 0 0 3px rgba(45, 154, 243, 0.15);
}

.input-field:focus ~ .icon {
  color: #2da0f3;
  transform: translateY(-50%) scale(1.1);
}

.input-label {
  position: absolute;
  left: 3rem;
  top: 50%;
  transform: translateY(-50%);
  color: #6b7280;
  pointer-events: none;
  transition: all 0.3s ease;
  background: white;
  padding: 0 0.25rem;
}

.input-field:focus ~ .input-label,
.input-field:not(:placeholder-shown) ~ .input-label {
  transform: translateY(-2.5rem) scale(0.9);
  color: #110d4a;
  left: 1.8rem;
  background-color: none;
}


.underline {
  display: none;
}


.input-group:hover .input-field {
  border-color: #67b2d5;
}

.input-group:hover .icon {
  color: #356098;
}
.submit-btn {
  position: relative;
  overflow: hidden;
  height: 50px;
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  border: none;
  margin-top: 2rem;
  border-radius: 12px;
  color: white;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  padding-right: 45px;
  box-shadow: 0 4px 6px -1px rgba(99, 102, 241, 0.2);
}

.submit-btn span {
  position: relative;
  z-index: 2;
}

.fill-container {
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    90deg, 
    transparent 0%, 
    rgba(255, 255, 255, 0.4) 50%, 
    transparent 100%
  );
  transition: left 0.6s ease-in-out;
}

.submit-btn:hover .fill-container {
  left: 100%;
}

.submit-btn:hover {
  box-shadow: 0 10px 15px -3px rgba(99, 102, 241, 0.3);
  transform: translateY(-2px) scale(1.02);
  background: linear-gradient(135deg, #818cf8 0%, #a78bfa 100%);
}

.submit-btn:active {
  transform: translateY(1px) scale(0.98);
  box-shadow: 0 2px 4px -1px rgba(99, 102, 241, 0.2);
}

.icon-btn {
  position: absolute;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  transition: all 0.3s ease;
  color: rgba(255, 255, 255, 0.9);
  filter: drop-shadow(0 1px 1px rgba(0, 0, 0, 0.1));
}

.submit-btn:hover .icon-btn {
  transform: translateY(-50%) translateX(3px);
  color: white;
}



@media (max-width: 480px) {
  .form-container {
    width: 90%;
    padding: 30px;
  }
  
  .title {
    font-size: 1.8em;
  }
  
  .input-group {
    padding-left: 25px;
  }
  
  .icon {
    font-size: 14px;
  }
  
  .submit-btn {
    padding-right: 35px;
  }
  
  .icon-btn {
    right: 15px;
  }
}
</style>