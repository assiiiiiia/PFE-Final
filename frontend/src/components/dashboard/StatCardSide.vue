<template>
  <div :class="['stat-card', styleClass]">
    <div class="card-content">
     
      <i v-if="iconClassName" :class="['icon', iconClassName]"></i>
      <h3 class="stat-title">{{ title }}</h3>
      <p class="stat-value">{{ value }}</p>
      <p class="stat-tag" v-if="tag">{{ tag }}</p>
    </div>
  </div>
</template>

<script setup>
import { defineProps } from 'vue'

const props = defineProps({
  title: { type: String, required: true },
  value: { type: [Number, String], default: 0 },
  tag: { type: String, default: '' },
  styleClass: { type: String, default: 'style1' },
  iconClassName: { type: String, default: '' },
})
</script>

<style scoped>
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css');

.stat-card {
  border-radius: 16px;
  min-height: max-content;
  padding: 1.5rem;
  text-align: center;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.15);
  color: white;
  position: relative;
  overflow: hidden;
  cursor: pointer;
  animation: cardEntrance 0.6s ease-out;
}

.stat-card:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.2);
}

.stat-card:hover::after {
  transform: translateX(100%);
}


.stat-card::after {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 40%;
  height: 200%;
  background: linear-gradient(
    90deg,
    rgba(255, 255, 255, 0) 0%,
    rgba(255, 255, 255, 0.1) 50%,
    rgba(255, 255, 255, 0) 100%
  );
  transform: rotate(15deg);
  transition: transform 0.6s ease-in-out;
}

.icon {
  position: relative;
  top: -10px;
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
  color: rgba(255, 255, 255, 0.8);
  transition: all 0.3s ease;
}

.stat-title {
  margin-top: 0.5rem;
  font-size: 1.1rem;
  font-weight: 500;
  margin-bottom: 0.75rem;
  letter-spacing: 0.5px;
}

.stat-value {
  font-size: 2.4rem;
  font-weight: 700;
  margin: 1rem 0;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.stat-tag {
  font-size: 0.9rem;
  opacity: 0.9;
  margin-top: 1rem;
  font-weight: 300;
}


@keyframes cardEntrance {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}


.style1 { background: linear-gradient(135deg, #0c1d4d, #3b5998); }
.style2 { background: linear-gradient(135deg, #0c1d4d, #4e7094); }
.style3 { background: linear-gradient(135deg, #0c1d4d, #5fa8d3); }
.style4 { background: linear-gradient(135deg, #0c1d4d, #358f80); }
.style5 { background: linear-gradient(135deg, #0c1d4d, #6a82fb); }
.style6 { background: linear-gradient(135deg, #0c1d4d, #7cb9e8); }

.icon {
 
  font-size: 2rem;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.stat-card:hover .icon {
  opacity: 0.7;
  
}


.stat-card {
  border: 1px solid rgba(255, 255, 255, 0.1);
  background-blend-mode: soft-light;
}


@keyframes iconPulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.1); }
  100% { transform: scale(1); }
}

.stat-card:hover .icon {
  animation: iconPulse 1.2s ease-in-out;
}


.stat-title {
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1.2px;
  font-size: 0.95rem;
}

.stat-value {
  font-size: 2.6rem;

  position: relative;
  display: inline-block;
}

.stat-value::after {
  content: '';
  position: absolute;
  bottom: -8px;
  left: 50%;
  transform: translateX(-50%);
  width: 50%;
  height: 2px;
  background: rgba(255, 255, 255, 0.3);
}

</style>