<template>
  <div class="action-buttons">
    <button 
      v-if="showEdit" 
      class="edit" 
      @click="onEdit"
    >
      <i class="fas fa-edit"></i> 
    </button>

    <button 
      v-if="showDelete" 
      class="delete" 
      @click="onDelete"
    >
      <i class="fas fa-trash"></i> 
    </button>

    <button 
      v-if="showDetails" 
      class="details" 
      @click="onDetails"
    >
      <i class="fas fa-info-circle"></i> 
    </button>
  </div>
</template>

<script>
export default {
  name: "ActionButtons",
  props: {
    item: {
      type: Object,
      required: true,
    },
    showEdit: {
      type: Boolean,
      default: true,
    },
    showDelete: {
      type: Boolean,
      default: true, 
    },
    showDetails: {
      type: Boolean,
      default: true, 
    },
  },
  methods: {
    onEdit() {
      this.$emit("edit", this.item);
    },
    onDelete() {
      this.$emit("delete", this.item.id);
    },
    onDetails() {
      this.$emit("details", this.item);
    },
  },
};
</script>
<style scoped>
.action-buttons button {
  padding: 6px 12px;
  border-radius: 5px;
  border: none;
  font-size: 12px;
 
  cursor: pointer;
  transition: background 0.3s;
}

.action-buttons button.edit {
  background: #17b847;
  color: white;
  margin-right: 10px;
}
.action-buttons button.edit:hover {
  background: #147414;
}

.action-buttons button.delete {
  background: #e3342f;
  color: white;
  margin-right: 10px;
}
.action-buttons button.delete:hover {
  background: #cc1f1a;
}

.action-buttons button.details {
  background: #1d0a56e0;
  color: white;
}
.action-buttons button.details:hover {
  background: #3b2a85;
}

.fas {
  margin-right: 4px;
}
</style>
