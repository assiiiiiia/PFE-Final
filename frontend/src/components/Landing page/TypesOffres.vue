
<template>
    <section class="types-offres">
      <h2 class="types-offres__title">Types d’offres disponibles</h2>
      <div class="types-offres__list">
        <div class="types-offres__item item--ao">
          <div class="content">
            <i class="fas fa-file-contract icon"></i>
            <span class="label">Appels d’offres</span>
            <span class="description">Publiés par les pouvoirs adjudicateurs</span>
            <span class="action">Consulter les appels</span>
          </div>
        </div>
        <div class="types-offres__item item--consult">
          <div class="content">
            <i class="fas fa-bullhorn icon"></i>
            <span class="label">Avis de consultation</span>
            <span class="description">Annonce des besoins préliminaires</span>
            <span class="action">Consulter les avis</span>
          </div>
        </div>
        <div class="types-offres__item item--manifest">
          <div class="content">
            <i class="fas fa-clipboard-list icon"></i>
            <span class="label">Manifestation d’intérêt</span>
            <span class="description">Exprimez votre volonté de participer</span>
            <span class="action">Soumettre votre intérêt</span>
          </div>
        </div>
      </div>
    </section>
  </template>
  
  <style scoped>
  .types-offres {
    padding: 4rem 1rem;
    text-align: center;
   
  }
  .types-offres__title {
    font-size: 2rem;
    margin-bottom: 2rem;
    color: #1E3A8A;
  }
  .types-offres__list {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 2rem;
  }

  .types-offres__item {
    width: 240px;
    border-radius: 0.75rem;
    overflow: hidden;
    cursor: pointer;
    transition: transform 0.3s, box-shadow 0.3s;
    animation: fadeInUp 0.5s ease-out forwards;
  }
  .types-offres__item:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 16px rgba(0,0,0,0.1);
  }
  

  .content {
    position: relative;
    padding: 2rem 1.5rem;
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  .icon {
    font-size: 2rem;
    margin-bottom: 1rem;
  }
  .label,
  .description,
  .action {
    display: block;
    text-align: center;
    transition: opacity 0.3s;
  }

  .action {
    opacity: 0;
    transform: translateY(10px);
  }

  .types-offres__item:hover .label,
  .types-offres__item:hover .description {
    opacity: 0;
  }
  .types-offres__item:hover .action {
    opacity: 1;
    transform: translateY(0);
  }
  

  .item--ao {
    background: rgba(30, 58, 138, 0.1); 
  }
  .item--ao .icon { color: #1E3A8A; }
  .item--ao .label,
  .item--ao .description,
  .item--ao .action { color: #1E3A8A; }
  
  .item--consult {
    background: rgba(16, 185, 129, 0.1); 
  }
  .item--consult .icon { color: #047857; }
  .item--consult .label,
  .item--consult .description,
  .item--consult .action { color: #047857; }
  
  .item--manifest {
    background: rgba(239, 68, 68, 0.1);
  }
  .item--manifest .icon { color: #B91C1C; }
  .item--manifest .label,
  .item--manifest .description,
  .item--manifest .action { color: #B91C1C; }

  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(20px); }
    to   { opacity: 1; transform: translateY(0); }
  }
  </style>
  