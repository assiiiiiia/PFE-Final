<template>
    <div class="pagination">
    
      <button 
        :disabled="currentPage === 1" 
        @click="$emit('page-changed', currentPage - 1)">
        <i class="fas fa-chevron-left"></i>
      </button>
  
 
      <span v-for="page in totalPages" :key="page">
        <button 
          :class="{ active: currentPage === page }" 
          @click="$emit('page-changed', page)">
          {{ page }}
        </button>
      </span>
  
      <button 
        :disabled="currentPage === totalPages" 
        @click="$emit('page-changed', currentPage + 1)">
        <i class="fas fa-chevron-right"></i>
      </button>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      totalPages: Number,
      currentPage: Number
    }
  };
  </script>
  
  <style scoped>
  .pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    list-style: none;
    padding: 0;
    margin-top: 20px;
  }
  
  .pagination button {
    background: none;
    color: rgb(0, 0, 0);
    border: none;
    padding: 8px 12px;
    margin: 0 5px;
    border-radius: 5px;
    cursor: pointer;
    transition: background 0.3s;
    font-size: 16px;
  }
  
  .pagination button i {
    font-size: 18px;
  }
  
  .pagination button:hover {
    color: rgb(60, 73, 192);
  }
  
  .pagination button:disabled {
 
    visibility: hidden;
 
  }
  
  button.active {
    
    color: rgb(74, 106, 211);
  }
  </style>
  