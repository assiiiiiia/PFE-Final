<template>
    <section class="feedback-container">
 
      <form class="feedback-card" @submit.prevent="soumettreSuggestion">
            <div class="feedback-hero">
        <div class="hero-content">
          <h2 class="hero-heading">
            <span class="heading-gradient">{{ $t('improve_portal') }}</span>
            <div class="sparkle">✨</div>
          </h2>
          <p class="hero-text">
            {{ $t('share_suggestions') }}
            <span class="text-highlight">{{ $t('every_contribution_counts') }}</span>
          </p>
        </div>
      </div> 
      <div class="input-field">
          <input
            type="email"
            v-model="email"
            required
            class="modern-input"
            placeholder=" "
          />
          <label class="input-label">{{ $t('email') }}</label>
        </div>
  
        <div class="input-field">
          <textarea
            v-model="suggestion"
            required
            class="modern-textarea"
            placeholder=" "
            rows="4"
          ></textarea>
          <label class="input-label">{{ $t('your_idea') }}</label>
        </div>
  
        <button type="submit" class="submit-btn">
          <span>{{ $t('submit_suggestion') }}</span>
          <svg class="arrow-icon" viewBox="0 0 24 24">
            <path d="M4 11h12.25l-5.3-5.3 1.4-1.4 7 7-7 7-1.4-1.4 5.3-5.3H4v-2z"/>
          </svg>
        </button>
      </form>
    </section>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue'
  import axios from 'axios'
  
  const apiUrl = import.meta.env.VITE_API_URL
  const email = ref('')
  const suggestion = ref('')
  
  onMounted(async () => {
    const token = localStorage.getItem('token')
    if (token) {
      try {
        axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
        const res = await axios.get(`${apiUrl}/api/user`)
        email.value = res.data.email
        localStorage.setItem('userId', res.data.id)
      } catch (error) {
        console.error('Erreur de récupération utilisateur:', error)
      }
    } else {
      email.value = '' 
    }
  })
  
  const soumettreSuggestion = async () => {
    if (!email.value.trim() || !suggestion.value.trim()) {
      return alert('Veuillez remplir tous les champs requis')
    }
  
    try {
      localStorage.setItem('userEmail', email.value)
      const payload = {
        email: email.value,
        content: suggestion.value.trim(),
        user_id: localStorage.getItem('userId')
      }
  
      const { data } = await axios.post(`${apiUrl}/api/suggestions`, payload)
      alert(data.message || 'Merci pour votre contribution !')
      suggestion.value = ''
    } catch (error) {
      const errorMessage = error.response?.data?.errors
        ? Object.values(error.response.data.errors).flat().join('\n')
        : 'Une erreur est survenue. Veuillez réessayer.'
      alert(errorMessage)
    }
  }
  </script>
  
<style scoped>
.feedback-container {
  max-width: 1100px;
  margin: 3rem auto;
  padding: 0 1.5rem;
}

.feedback-hero {
 
  border-radius: 1.5rem;
  padding: 0.4rem 0.4rem;
  margin-bottom: 2rem;
  position: relative;
  overflow: hidden;
}

.hero-content {
  max-width: 500px;
  margin: 0 auto;
  text-align: center;
  position: relative;
}

.heading-gradient {
  background: linear-gradient(45deg, #18135b 20%, #1656c4 100%);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  display: inline-block;
}

.hero-heading {
  font-size: 2.75rem;
  line-height: 1.1;
  color: #1E3A8A;

  position: relative;
}

.sparkle {
  position: absolute;
  right: -10px;
  top: -15px;
  font-size: 2rem;
  transform: rotate(25deg);
  opacity: 0.8;
}

.hero-text {
  color: rgba(68, 68, 68, 0.9);
  font-size: 1.125rem;

}

.text-highlight {
  display: inline-block;

  background: rgba(255, 255, 255, 0.15);
  border-radius: 0.375rem;
}

.feedback-card {
  background: white;
  border-radius: 1.5rem;
  padding: 2.5rem;
  max-width: 680px;
  margin: 0 auto;
  box-shadow: 0 25px 50px -12px rgba(30, 58, 138, 0.1);
}

.input-field {
  position: relative;
  margin-bottom: 1.1rem;
}

.modern-input,
.modern-textarea {
  width: 100%;
  padding: 1.25rem;
  border: 2px solid #E2E8F0;
  border-radius: 0.75rem;
  background: transparent;
  font-size: 1rem;
  transition: all 0.3s ease;
}
.modern-textarea {
max-width: 640px;
}

.input-label {
  position: absolute;
  left: 1rem;
  top: 1.8rem;
  bottom: 1rem;
  background: white;
  padding: 0 0.5rem;
  color: #64748B;
  transition: all 0.3s ease;
  pointer-events: none;
}

.modern-input:focus,
.modern-textarea:focus {
  border-color: #1E3A8A;
  box-shadow: 0 0 0 4px rgba(30, 58, 138, 0.1);
  outline: none;
}

.modern-input:focus + .input-label,
.modern-input:not(:placeholder-shown) + .input-label,
.modern-textarea:focus + .input-label,
.modern-textarea:not(:placeholder-shown) + .input-label {
  top: -0.6rem;
  font-size: 0.875rem;
  color: #1E3A8A;
}
.modern-input:focus + .input-label,
.modern-input:not(:placeholder-shown) + .input-label
 {
  top: -0.1rem;
  font-size: 0.875rem;
  color: #1E3A8A;
}
.submit-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
  background: #1E3A8A;
  color: white;
  padding: 1.125rem 2.5rem;
  border: none;
  border-radius: 0.75rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  width: 100%;
  justify-content: center;
}

.submit-btn:hover {
  background: #0F2A61;
  transform: translateY(-2px);
  box-shadow: 0 10px 15px -3px rgba(30, 58, 138, 0.2);
}

.arrow-icon {
  width: 1.25rem;
  height: 1.25rem;
  fill: currentColor;
  transition: transform 0.3s ease;
}

.submit-btn:hover .arrow-icon {
  transform: translateX(3px);
}

@media (max-width: 768px) {
  .hero-heading {
    font-size: 2rem;
  }
  
  .feedback-card {
    padding: 1.5rem;
  }
  
  .submit-btn {
    padding: 1rem 1.5rem;
  }
}
</style>