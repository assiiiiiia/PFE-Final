<template>
    <div ref="recaptchaContainer"></div>
  </template>
  
  <script>
  export default {
    name: "Recaptcha",
    props: {
      sitekey: {
        type: String,
        required: true,
      },
    },
    data() {
      return {
        widgetId: null,
      };
    },
    mounted() {
   
      if (window.grecaptcha) {
        this.renderRecaptcha();
      } else {
        const interval = setInterval(() => {
          if (window.grecaptcha) {
            clearInterval(interval);
            this.renderRecaptcha();
          }
        }, 500);
      }
    },
    methods: {
      renderRecaptcha() {
        this.widgetId = window.grecaptcha.render(this.$refs.recaptchaContainer, {
          sitekey: this.sitekey,
          callback: (response) => {
            this.$emit("verify", response);
          },
          "expired-callback": () => {
            this.$emit("expired");
          },
        });
      },
      reset() {
        if (window.grecaptcha && this.widgetId !== null) {
          window.grecaptcha.reset(this.widgetId);
        }
      },
    },
  };
  </script>
  