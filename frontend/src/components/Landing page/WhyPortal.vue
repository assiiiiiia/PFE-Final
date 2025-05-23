
<template>
    <section class="why-portal " >
      <div class="info-grid">
        <article class="info-card">
          <div class="card-icon">
            <font-awesome-icon :icon="['fas', 'landmark']" />
          </div>
          <h3>{{ $t("home.infoCard1.title") }}</h3>
          <p>{{ $t("home.infoCard1.text") }}</p>
        </article>
  
        <article class="info-card highlight">
          <div class="card-icon">
            <font-awesome-icon :icon="['fas', 'laptop-code']" />
          </div>
          <h3>{{ $t("home.infoCard2.title") }}</h3>
          <ul class="feature-list">
            <li>
              <font-awesome-icon :icon="['fas', 'caret-right']" />
              {{ $t("home.infoCard2.features.0") }}
            </li>
            <li>
              <font-awesome-icon :icon="['fas', 'caret-right']" />
              {{ $t("home.infoCard2.features.1") }}
            </li>
            <li>
              <font-awesome-icon :icon="['fas', 'caret-right']" />
              {{ $t("home.infoCard2.features.2") }}
            </li>
          </ul>
        </article>
  
        <article class="info-card legal-notice">
          <div class="card-icon">
            <font-awesome-icon :icon="['fas', 'balance-scale']" />
          </div>
          <h3>{{ $t("home.infoCard3.title") }}</h3>
          <p>{{ $t("home.infoCard3.text") }}</p>
        </article>
      </div>
    </section>
  </template>
  
  <style scoped>
  .why-portal {

    text-align: center;
  
  }
  
  .info-grid {
    display: grid;
    gap: 2rem;
    margin: auto;
    max-width: 80%;
   padding-bottom: 100px;
    border-bottom: 2px solid #e5e7eb;
  
    grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  }
  
  .info-card {
    position: relative;
    overflow: hidden;
    padding: 2rem;
    border-radius: 15px;
    transition: all 0.3s ease;
    min-height: 280px;
    color: #4b3d3d6c;
     opacity: 0;
  animation: fadeUp 0.8s ease forwards;
  }
  

  .info-card:nth-child(1) {
    background: rgba(16, 185, 129, 0.1); 
    color: #154b37c3;
  }
  .info-card:nth-child(2) {
    background: rgba(16, 25, 196, 0.176);
    color: #292983c9; 
  }
  .info-card:nth-child(3) {
   color: #9065249a;
    background: rgba(228, 212, 119, 0.272);
  }
  .info-card:nth-child(1) {
  animation-delay: 0.1s;
}
.info-card:nth-child(2) {
  animation-delay: 0.3s;
}
.info-card:nth-child(3) {
  animation-delay: 0.5s;
}

  .info-card::before {
    content: "";
    height: 100px;
    width: 100px;
    position: absolute;
    top: -40%;
    left: -20%;
    border-radius: 50%;
    border: 35px solid rgba(255, 255, 255, 0.15);
    transition: all 0.8s ease;
    filter: blur(.5rem);
  }
  .info-card:hover::before {
    width: 140px;
    height: 140px;
    top: -30%;
    left: 50%;
    filter: blur(0);
    border-color: rgba(255, 255, 255, 0.25);
  }
  

  .info-card:nth-child(1):hover {
    background: rgba(16, 185, 129, 0.2);
  }
  .info-card:nth-child(2):hover {
   background: rgba(79, 68, 239, 0.2);
  }
  .info-card:nth-child(3):hover {
     background: rgba(241, 246, 92, 0.2);
  }
  
  .card-icon {
    font-size: 2.5rem;
    margin-bottom: 1.5rem;
    z-index: 2;
    position: relative;
  }
  

  .info-card:nth-child(1) .card-icon {
    color: #047857; 
            padding-bottom: 10px;
    border-bottom: 1.5px solid #1e694970;
 
  }
  .info-card:nth-child(2) .card-icon {
     color: #292983;
         padding-bottom: 10px;
    border-bottom: 1.5px solid #23257f70;
 
  }
  .info-card:nth-child(3) .card-icon {
    color: #8b652bbb;
    padding-bottom: 10px;
    border-bottom: 1.5px solid #7f5a2370;
  }
  
  .info-card h3 {
    font-size: 1.4em;
    margin-bottom: 1rem;
    z-index: 2;
  }
  .info-card p {
    font-size: 0.95em;
    line-height: 1.6;
    z-index: 2;
  }
  

  .feature-list li {
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }
  .feature-list li svg {
    color: #1E3A8A;
  }
  @keyframes fadeUp {
  0% {
    opacity: 0;
    transform: translateY(30px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}
  </style>
  