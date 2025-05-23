<template>
  <div class="filter-bar">
  
    <input
      type="text"
      v-model="internalSearch"
      placeholder=" Recherche rapide..."
      @input="emitFilters"
    />

  
    <div class="filter-dropdown" v-if="filtersList.length">
      <button class="filter-toggle" @click="toggleFilters">
        <img src="@/assets/sort.png" alt="icon" height="12px" width="14px" />
        Filtres
      </button>

      
      <div class="filter-options" v-if="showFilters">
        <div
          class="filter-section"
          v-for="filter in filtersList"
          :key="filter.field"
        >
          <label>{{ filter.label }} :</label>
          <select
            v-model="internalFilters[filter.field]"
            @change="emitFilters"
          >
            <option :value="''">Tous les {{ filter.label.toLowerCase() }}</option>
            <option
              v-for="option in filter.options"
              :key="option"
              :value="option"
            >
              {{ option }}
            </option>
          </select>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    search: {
      type: String,
      default: ""
    },
    filtersList: {
      type: Array,
      default: () => [] 
    },
    initialFilters: {
      type: Object,
      default: () => ({})
    }
  },
  data() {
    return {
      internalSearch: this.search,
      internalFilters: { ...this.initialFilters },
      showFilters: false
    };
  },
  methods: {
    emitFilters() {
      this.$emit("filters-changed", {
        search: this.internalSearch,
        ...this.internalFilters 
      });
    },
    toggleFilters() {
      this.showFilters = !this.showFilters;
    }
  },
  watch: {
    search(newVal) {
      this.internalSearch = newVal;
    },
    initialFilters: {
      handler(newFilters) {
        this.internalFilters = { ...newFilters };
      },
      deep: true
    }
  }
};
</script>


<style scoped>
.filter-bar {
  display: flex;
  align-items: center;
  gap: 10px;
}


.filter-bar input {
  flex: 1;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 14px;
  width: 500px;
   transition: border-color 0.2s ease, box-shadow 0.2s ease;
 
}
.filter-bar input::placeholder {
  color: #aaa;
  font-style: italic;
}
.filter-bar input:focus {
  outline: none;
  border-color: #747474;
  box-shadow: 0 0 5px rgba(175, 175, 175, 0.5);
}
.filter-dropdown {
  position: relative;
}

.filter-toggle {
  background-color: #fcfcfc;
  border: 1px solid #e4e4e4;
  color: #909090;
  border-radius: 5px;
  padding: 8px 12px;
  cursor: pointer;
  font-size: 14px;
}

.filter-options {
  position: absolute;
  top: 110%;
  right: 0;
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 5px;
  padding: 10px;
  min-width: 200px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  z-index: 10;
   transition: all 0.3s ease-in-out;
}

.filter-section {
  margin-bottom: 10px;
}

.filter-section:last-child {
  margin-bottom: 0;
}

.filter-section label {
  display: block;
  margin-bottom: 4px;
  font-weight: bold;
  font-size: 13px;
}

.filter-section select {
  width: 100%;
  padding: 6px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 13px;
}


@media screen and (max-width: 768px) {
  .filter-bar {
    flex-direction: column;
    align-items: stretch;
    width: 100%;
    gap: 10px;
  }

  .filter-bar input {
    width: 80%;
    font-size: 14px;
  }

  .filter-dropdown {
    width: 100%;
  }

  .filter-toggle {
    width: 100%;
    text-align: left;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .filter-options {
    position: static;
    box-shadow: none;
    margin-top: 5px;
    width: 100%;
  }
}

</style>
