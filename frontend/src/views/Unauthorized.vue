<template>
  <div class="unauthorized">
    <div class="content">
      <div class="icon-container">
        <i class="fas fa-ban"></i>
        <div class="pulse-effect"></div>
      </div>
      <h1>Accès refusé</h1>
      <p>Vous n'avez pas la permission d'accéder à cette page.</p>
      <button @click="goBack" class="back-button">
        <i class="fas fa-arrow-left"></i>
        Retour à la page précédente
      </button>
    </div>
    <div class="background-pattern"></div>
  </div>
</template>

<script>
export default {
  name: "Unauthorized",
  methods: {
    goBack() {
      this.$router.go(-1);
    }
  }
};
</script>

<style scoped>
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css');

.unauthorized {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: #0c1d4d;
  padding: 20px;
  position: relative;
  overflow: hidden;
}

.background-pattern {
  position: absolute;
  width: 100%;
  height: 100%;
  background: 
    radial-gradient(circle at 10% 20%, rgba(255,255,255,0.05) 0%, transparent 50%),
    linear-gradient(45deg, transparent 70%, rgba(255,255,255,0.03) 100%);
  z-index: 0;
}

.content {
  text-align: center;
  background: rgba(255, 255, 255, 0.98);
  padding: 50px 70px;
  border-radius: 25px;
  box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
  transform: translateY(0);
  transition: transform 0.4s cubic-bezier(0.23, 1, 0.32, 1);
  max-width: 560px;
  width: 100%;
  position: relative;
  z-index: 1;
  border: 1px solid rgba(255,255,255,0.1);
}

.content:hover {
  transform: translateY(-5px);
}

.icon-container {
  position: relative;
  margin-bottom: 35px;
}

.fa-ban {
  font-size: 90px;
  color: #ff4d4d;
  position: relative;
  z-index: 2;
  animation: bounce 1.2s ease infinite;
  text-shadow: 0 4px 15px rgba(255, 77, 77, 0.3);
}

.pulse-effect {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 120px;
  height: 120px;
  background: rgba(255, 77, 77, 0.15);
  border-radius: 50%;
  animation: pulse 2s ease-out infinite;
}

h1 {
  color: #1a237e;
  font-size: 36px;
  margin-bottom: 20px;
  font-weight: 800;
  letter-spacing: -0.5px;
  text-transform: uppercase;
}

p {
  font-size: 18px;
  color: #424242;
  margin-bottom: 35px;
  line-height: 1.7;
  max-width: 400px;
  margin-left: auto;
  margin-right: auto;
}

.back-button {
  display: inline-flex;
  align-items: center;
  padding: 15px 35px;
  background: #1a237e;
  color: white;
  border-radius: 50px;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: none;
  cursor: pointer;
  box-shadow: 
    0 4px 20px rgba(26, 35, 126, 0.25),
    0 0 0 1px rgba(255,255,255,0.1) inset;
}

.back-button:hover {
  background: #303f9f;
  transform: translateY(-2px);
  box-shadow: 
    0 8px 25px rgba(26, 35, 126, 0.4),
    0 0 0 1px rgba(255,255,255,0.2) inset;
}

.back-button i {
  margin-right: 12px;
  transition: transform 0.3s ease;
}

.back-button:hover i {
  transform: translateX(-5px);
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-15px); }
}

@keyframes pulse {
  0% { transform: translate(-50%, -50%) scale(0.8); opacity: 0.8; }
  100% { transform: translate(-50%, -50%) scale(1.8); opacity: 0; }
}

@media (max-width: 600px) {
  .content {
    padding: 35px;
    border-radius: 20px;
  }
  
  h1 {
    font-size: 28px;
  }
  
  p {
    font-size: 16px;
  }
  
  .back-button {
    padding: 12px 25px;
    font-size: 14px;
  }
  
  .fa-ban {
    font-size: 70px;
  }
}
</style>