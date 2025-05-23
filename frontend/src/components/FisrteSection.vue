<template>  
    <section class="home-container">
        <div class="content-container">
            <header class="trust-header">
                <h1>Portail des appels d’offres<br>Poste & Télécoms</h1>
                <p class="subheading">Un accès équitable et transparent aux marchés du secteur</p>
            </header>                               
    
        <div class="buttons-container">
        
          <div class="security-badge">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-shield">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                </svg>
                <span>Bank-Level Encryption</span>
            </div>
            <div class="security-badge">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-shield">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                </svg>
                <span>Bank-Level Encryption</span>
            </div>
      </div>

        

     
    </div>
</section>
    </template>
               
<style>
.home-container {
  background: #f8faff;
  min-height: 100vh;
 
}

.finance-hero {
    padding: 8rem 2rem;
    min-height: 80vh;
    display: flex;
    align-items: center;
}

.content-container {
    max-width: 1200px;
    margin: 0 auto;
}
.button-container {
    display: flex;
    gap: 2rem;
    justify-content: center;
    margin-bottom: 4rem;

} 

.trust-header {
    text-align: center;
    margin-bottom: 4rem;
}

.security-badge {
    display: inline-flex;
    align-items: center;
    gap: 0.8rem;
    padding: 0.8rem 1.5rem;
    background: #f0f6ff;
    border-radius: 2rem;
    margin-bottom: 2rem;
}

.security-badge svg {
    color: #2563eb;
}

h1 {
    font-family: 'Inter', sans-serif;
    font-size: 3.5rem;
    color: #1f2937;
    line-height: 1.2;
    margin-bottom: 1.5rem;
}

.subheading {
    color: #4b5563;
    font-size: 1.25rem;
    max-width: 600px;
    margin: 0 auto;
}


@media (max-width: 768px) {
    h1 {
        font-size: 2.5rem;
    }
    
    .value-grid {
        grid-template-columns: 1fr;
    }
}</style>