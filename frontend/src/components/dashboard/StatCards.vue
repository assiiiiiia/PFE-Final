<template>
  <div class="card" :class="colorScheme">
    <div class="card-header">
      <div class="header-content">
        <div class="icon-container">
          <i :class="['card-icon', iconClass, iconClassName]"></i>
        </div>
        <div class="header-text">
          <h2 class="card-title">{{ title }}</h2>
         
        </div>
      </div>
    </div>
    <div class="card-main">
      <p class="card-number">{{ value }}</p>
      <div class="language-tags">
        <span class="tag">
          FR <span class="small-tag">{{ tagFR }}</span>
        </span>
        <span class="tag">
          AR <span class="small-tag">{{ tagAR }}</span>
        </span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.card {
  padding: 1.8rem;
  background-color: #fff;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  border-radius: 12px;
  max-width: 100%;
  transition: all 0.2s ease;
}

.card-header {
  margin-bottom: 1rem;
}

.header-content {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.icon-container {
  width: 2rem;
  height: 2rem;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.card-icon {
  font-size: 1rem;
  color: white;
}

.header-text {
  flex-grow: 1;
}

.card-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: #12105a;
  margin: 0;
}


.trend-icon {
  font-size: 0.6rem;
}

.card-main {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.card-number {
  font-size: 1.9rem;
  font-weight: 700;
  margin: 0;
  color: #333334;
  transition: transform 0.3s ease, color 0.3s ease;
}

.card-number.animate {
  transform: scale(1.2);
  color: #3B82F6;
}

.language-tags {
  display: flex;
  gap: 0.5rem;
}

.tag {
  font-size: 0.7rem;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  background: #f8fafc;
}

.small-tag {
  font-weight: 600;
  margin-left: 0.25rem;
}


.blue .icon-container { background: #3B82F6; }
.green .icon-container { background: #10B981; }
.purple .icon-container { background: #8B5CF6; }
.red .icon-container { background: #EF4444; }

.blue .percentage { color: #3B82F6; }
.green .percentage { color: #10B981; }
.purple .percentage { color: #8B5CF6; }
.red .percentage { color: #EF4444; }

.blue .tag { background: #EFF6FF; }
.green .tag { background: #ECFDF5; }
.purple .tag { background: #F5F3FF; }
.red .tag { background: #FEF2F2; }
</style>
<script>
export default {
  name: 'StatCart',
  props: {
    title: { type: String, required: true },
    value: { type: [String, Number], required: true },
    tagFR: { type: [String, Number], required: true },
    tagAR: { type: [String, Number], required: true },
    iconClassName: { type: String, required: true },
    colorScheme: { type: String, default: 'blue' } ,
    iconClass: { type: String, required: true },
    
    last24hChange: { type: [String, Number], required: false, default: 0 }
  },
  computed: {
    
    trendPrefix() {
      return Number(this.last24hChange) > 0 ? '+' : '';
    },
 
    trendIcon() {
      const offers = Number(this.last24hChange);
      if (offers > 0) {
        return 'fas fa-arrow-up';
      } else if (offers === 0) {
        return 'fas fa-minus';
      }
      return 'fas fa-arrow-down';
    }
  },
  methods: {
    animateNumber() {
      const startValue = parseInt(this.$el.querySelector('.card-number').textContent, 10) || 0;
      const endValue = parseInt(this.value, 10);
      const duration = 400; 
      const frameRate = 60; 
      const totalFrames = Math.round((duration / 1000) * frameRate);
      let currentFrame = 0;

      const updateNumber = () => {
        currentFrame++;
        const progress = currentFrame / totalFrames;
        const currentValue = Math.round(startValue + (endValue - startValue) * progress);
        this.$el.querySelector('.card-number').textContent = currentValue;

        if (currentFrame < totalFrames) {
          requestAnimationFrame(updateNumber);
        }
      };

      requestAnimationFrame(updateNumber);
    }
  },
  watch: {
    value() {
      this.animateNumber();
    }
  }
}
</script>
