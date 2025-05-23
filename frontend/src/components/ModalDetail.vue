<template>
    <div class="modal-overlay" @click.self="close">
      <div class="modal-content">
        <h3>{{ headerText }}</h3>
        <p><strong>Nom :</strong> {{ user.nom }}</p>
        <p><strong>Prénom :</strong> {{ user.prenom }}</p>
   
        <template v-if="isAdmin">
          <p><strong>Téléphone :</strong> {{ user.telephone }}</p>
          <p><strong>Email :</strong> {{ user.email }}</p>
        </template>

        <template v-else>
          <p><strong>Civilité :</strong> {{ user.civilite }}</p>
          <p><strong>Fonction :</strong> {{ user.fonction }}</p>
          <p><strong>Téléphone :</strong> {{ user.telephone }}</p>
          <p><strong>Email :</strong> {{ user.email }}</p>
        </template>
        <button @click="close">Fermer</button>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: "ModalDetail",
    props: {
      user: {
        type: Object,
        required: true
      }
    },
    computed: {
      isAdmin() {
        return this.user.role === "admin";
      },
      headerText() {
        return this.isAdmin ? "Détails de l'administrateur" : "Détails de l'utilisateur";
      }
    },
    methods: {
      close() {
        this.$emit("close");
      }
    }
  };
  </script>
  
  <style scoped>
  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
   
    
  }
  .modal-content {
    background: #fff;
    padding: 20px;
    border-radius: 8px;
    width: 90%;
    max-width: 400px;

    text-align: right;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  .modal-content h3 {
    text-align: center;
    margin-bottom: 20px;
  }
  .modal-content p {
    margin: 10px 0;
  }
  button {
    display: block;
    margin: 20px auto 0;
    padding: 8px 16px;
    background-color: #007BFF;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }
  button:hover {
    background-color: #0056b3;
  }
  </style>
  