<template>
    <transition name="fade">
      <div v-if="visible" class="success-notification">
        {{ message }}
      </div>
    </transition>
  </template>
  
  <script>
  export default {
    name: 'SuccessNotification',
    props: {
      message: {
        type: String,
        required: true,
      },
      duration: {
        type: Number,
        default: 3000,
      },
    },
    data() {
      return {
        visible: true,
      };
    },
    mounted() {
      setTimeout(() => {
        this.visible = false;
        this.$emit('close');
      }, this.duration);
    },
  };
  </script>
  
  <style scoped>
  .success-notification {
    position: fixed;
    top: 20px;
    right: 20px;
    background-color: #4caf50;
    color: #fff;
    padding: 1rem 1.5rem;
    border-radius: 4px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
    z-index: 2000;
    font-size: 1em;
  }
  
  .fade-enter-active,
  .fade-leave-active {
    transition: opacity 0.5s;
  }
  .fade-enter,
  .fade-leave-to {
    opacity: 0;
  }
  </style>
  