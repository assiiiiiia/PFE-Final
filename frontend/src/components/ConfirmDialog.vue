<template>
  <div class="confirm-overlay">
    <div class="confirm-content">
      <div class="icon-container">
        <font-awesome-icon :icon="['fas', 'exclamation-triangle']" class="warning-icon" />
      </div>
      <p class="confirm-message">{{ message }}</p>
      <div class="confirm-buttons">
        <button class="confirm-button" @click="confirm">
          <font-awesome-icon :icon="['fas', 'check-circle']" class="button-icon" />
          Confirmer
        </button>
        <button class="cancel-button" @click="cancel">
          <font-awesome-icon :icon="['fas', 'times-circle']" class="button-icon" />
          Annuler
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { faExclamationTriangle, faCheckCircle, faTimesCircle } from '@fortawesome/free-solid-svg-icons'

export default {
  name: "ConfirmDialog",
  components: {
    FontAwesomeIcon
  },
  props: {
    message: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      icons: {
        faExclamationTriangle,
        faCheckCircle,
        faTimesCircle
      }
    }
  },
  methods: {
    confirm() {
      this.$emit("confirm");
    },
    cancel() {
      this.$emit("cancel");
    },
  },
};
</script>

<style scoped>
.confirm-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.425);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  opacity: 0;
  animation: overlayFade 0.4s cubic-bezier(0.4, 0, 0.2, 1) forwards;
  backdrop-filter: blur(4px);
}

@keyframes overlayFade {
  from { opacity: 0; backdrop-filter: blur(0); }
  to { opacity: 1; backdrop-filter: blur(4px); }
}

.confirm-content {
  background: linear-gradient(145deg, #ffffff, #f8f9fa);
  padding: 2.5rem;
  border-radius: 16px;
  max-width: 450px;
  width: 90%;
  text-align: center;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
  transform: scale(0.95);
  animation: contentPop 0.4s cubic-bezier(0.68, -0.55, 0.27, 1.55) forwards;
  position: relative;
  overflow: hidden;
}

.confirm-content::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(45deg, transparent, rgba(255,255,255,0.2), transparent);
  transform: rotate(45deg);
  animation: shine 3s infinite;
}

@keyframes shine {
  0% { transform: rotate(45deg) translateX(-150%); }
  100% { transform: rotate(45deg) translateX(150%); }
}

@keyframes contentPop {
  from {
    transform: scale(0.95) translateY(20px);
    opacity: 0;
  }
  to {
    transform: scale(1) translateY(0);
    opacity: 1;
  }
}

.confirm-message {
  margin-bottom: 2rem;
  font-size: 1.25rem;
  color: #2d3436;
  line-height: 1.6;
  font-weight: 500;
  position: relative;
  z-index: 1;
}

.confirm-buttons {
  display: flex;
  gap: 1rem;
  justify-content: center;
}

.confirm-buttons button {
  padding: 1rem 2rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1rem;
  font-weight: 600;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
  transform: translateZ(0);
  min-width: 120px;
}

.confirm-buttons button::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255,255,255,0.1);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.confirm-buttons button:hover::before {
  opacity: 1;
}

.confirm-button {
  background: #ff4757;
  color: white;
  box-shadow: 0 4px 6px rgba(46, 213, 115, 0.2);
}

.cancel-button {
  background: #2ed573;
  color: white;  box-shadow: 0 4px 6px rgba(255, 71, 87, 0.2);

}

.confirm-button:hover {
  transform: translateY(-2px);
   box-shadow: 0 6px 12px rgba(46, 213, 115, 0.3);

}

.cancel-button:hover {
  transform: translateY(-2px);
   box-shadow: 0 6px 12px rgba(255, 71, 87, 0.3);
}

.confirm-buttons button:active {
  transform: translateY(1px);
}

@media (max-width: 480px) {
  .confirm-content {
    padding: 1.5rem;
  }
  
  .confirm-buttons {
    flex-direction: column;
  }
  
  .confirm-buttons button {
    width: 100%;
    padding: 1rem;
  }
}
.icon-container {
  margin-bottom: 1.5rem;
  animation: iconPulse 1.5s infinite;
}

.warning-icon {
  font-size: 2.5rem;
  color: #ffa502;
  filter: drop-shadow(0 2px 4px rgba(255, 165, 2, 0.3));
}

.button-icon {
  margin-right: 0.8rem;
  transition: transform 0.3s ease;
}

.confirm-button:hover .button-icon {
  transform: scale(1.1) rotate(-5deg);
  color: #fff;
}

.cancel-button:hover .button-icon {
  transform: scale(1.1) rotate(5deg);
  color: #fff;
}

@keyframes iconPulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.1); }
  100% { transform: scale(1); }
}


.confirm-button {
  background-color: #2ed573; 
}

.cancel-button {
  background-color: #ff4757; 
}


.confirm-button {
  background: linear-gradient(135deg, #2ed573, #27ae60);
}

.cancel-button {
  background: linear-gradient(135deg, #ff4757, #e84118);
}

.confirm-button:hover {
  background: linear-gradient(135deg, #27ae60, #219a52);
}

.cancel-button:hover {
  background: linear-gradient(135deg, #e84118, #c23616);
}
</style>