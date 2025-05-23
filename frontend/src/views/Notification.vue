<template>
  <div class="notification-dropdown">
    <div class="dropdown-header">
      <span class="header-text">Notifications</span>
      <button 
        @click="markAllAsRead" 
        :disabled="unreadCount === 0"
        class="mark-all-btn"
      >
        Tout marquer comme lu
      </button>
    </div>

    <table class="notification-table">
   
      <tbody>
        <tr 
          v-for="notif in sortedNotifications" 
          :key="notif.id" 
          :class="{ 'unread': !notif.is_read, 'unread-row': !notif.is_read }"
        >
    
          <td class="notification-body-cell">
            <div class="notification-message">{{ notif.message }}</div>
          </td>
          <td class="notification-time">{{ formatTime(notif.created_at) }}</td>
          <td class="notification-action-cell">
            <button 
              v-if="!notif.is_read" 
              class="mark-as-read-btn" 
              @click="markAsRead(notif.id)" 
              title="Marquer comme lu"
            >
              <i class="fas fa-check-circle"></i>
            </button>
            <button 
              @click="deleteNotification(notif.id)" 
              class="delete-btn"
            >
              <i class="fas fa-trash"></i>
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <div v-if="sortedNotifications.length === 0" class="empty-state">
       <i class="far fa-bell-slash text-gray-400 text-xl mb-2"></i>   Aucune notification
    </div>
  </div>
</template>

<style scoped>

.notification-dropdown {
  max-width: 1400px;
  margin: 2rem auto;
  padding: 2rem;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 15px rgba(0, 0, 0, 0.08);
  font-family: 'Inter', system-ui, sans-serif;
}

.dropdown-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem 1rem;
  border-bottom: 1px solid #e5e7eb;
}

.header-text {
  color: #2c3e50;
  font-size: 1.8rem;
  font-weight: 600;
  padding-bottom: 1rem;

}

.mark-all-btn {
  color: #2563eb;
  background: none;
  border: none;
  font-size: 0.875rem;
  cursor: pointer;
  padding: 0.25rem 0.5rem;
  border-radius: 0.25rem;
  transition: all 0.2s ease;
}

.mark-all-btn:hover:not(:disabled) {
  color: #1e40af;
  background-color: #f8fafc;
}

.mark-all-btn:disabled {
  color: #9ca3af;
  cursor: not-allowed;
}

.notification-table {
  width: 100%;
  border-collapse: collapse;
  margin: 0 auto;
}

.notification-table td {
  padding: 2.5rem;
  text-align: left;
  border-bottom:  #cfcfcf 1px solid;
}

.notification-table th {
  background-color: #f9fafb;
  color: #374151;
  font-weight: 500;
  border-bottom: 2px solid #e5e7eb;
}

.notification-row {
  border-bottom: 1px solid #e5e7eb;
}

.notification-icon-cell,
.notification-action-cell {
  text-align: center;
  width: 90px;
}

.notification-body-cell {
  text-align: left;
}

.notification-message {
  color: #1f2937;
  font-size: 0.875rem;
  line-height: 1.25;
}

.notification-time {
  font-size: 0.75rem;
  color: #6b7280;
}

.notification-action-cell {
  justify-content: center;
}

.mark-read-btn {
  color: #9ca3af;
  background: none;
  border: none;
  height: 2rem;
  width: 2rem;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
}

.mark-read-btn:hover {
  color: #2563eb;
  background-color: #eff6ff;
}



.notification-icon-cell i {
  font-size: 1.25rem;
}

.notification-icon-cell .info-icon {
  color: #60a5fa;
}

.notification-icon-cell .success-icon {
  color: #34d399;
}

.notification-icon-cell .warning-icon {
  color: #fbbf24;
}

.notification-icon-cell .error-icon {
  color: #f87171;
}

.notification-icon-cell .default-icon {
  color: #a78bfa;
}


.empty-state {
  color: #6b7280;
  text-align: center;
  padding: 1.5rem 0;
  grid-column: 1 / -1;
}

.fade-slide-enter-active {
  transition: all 0.3s ease;
}

.fade-slide-leave-active {
  transition: all 0.3s cubic-bezier(1, 0.5, 0.8, 1);
}

.fade-slide-enter-from,
.fade-slide-leave-to {
  opacity: 0;
  transform: translateX(20px);
}

/* Hover effects */
.notification-row:hover > div {
  background-color: #f9fafb;
}

.unread.notification-row:hover > div {
  background-color: #e0f2fe;
}

tbody tr {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
tbody tr:hover {
    background-color: #f3f4f6b5; 
 
  z-index: 10;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
}


/* Responsive styles */
@media (max-width: 768px) {
  .notification-dropdown {
    padding: 1rem;
  }

  .dropdown-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }

  .header-text {
    font-size: 1.5rem;
  }

  .mark-all-btn {
    font-size: 0.75rem;
    padding: 0.25rem 0.5rem;
  }

  .notification-table {
    grid-template-columns: 1fr;
  }

  .notification-row {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .notification-row > div {
    padding: 0.5rem 0;
  }

  .notification-icon-cell i {
    font-size: 1rem;
  }

  .notification-message {
    font-size: 0.875rem;
  }

  .notification-time {
    font-size: 0.75rem;
  }

  .mark-read-btn {
    height: 1.5rem;
    width: 1.5rem;
  }

  .empty-state {
    font-size: 0.875rem;
  }
}

/* Delete button styles */
.delete-btn {
  background-color: transparent;
  border: none;
  color: #ef4444; 
  cursor: pointer;
  font-size: 1rem;
  transition: color 0.2s ease;
}

.delete-btn:hover {
  color: #dc2626; 
}

.unread-row {
  background-color: #e0f2fe53;
}


.unread-row > td.notification-body-cell {
  position: relative;     
   

}


.unread-row > td.notification-body-cell::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 3px;
  background-color: #1e40af;
  border-top-left-radius: 4px;
  border-bottom-left-radius: 4px;
}

.mark-as-read-btn {
  color: #3761bc;
  background-color: #eff6ff;
  border: none;
  border-radius: 50%;
  width: 20px;
  height: 20px;

  cursor: pointer;
  transition: all 0.2s ease;
  margin-right: 10px;
  flex-shrink: 0;
}

.notification-row:hover .mark-as-read-btn {
  opacity: 1;
}

.mark-as-read-btn:hover {
  
  color: #233f7d;
  transform: scale(1.1);
}

.mark-as-read-btn i {
  font-size: 1rem;
}
</style>

<script>
import axios from 'axios';
const apiUrl = import.meta.env.VITE_API_URL;

export default {
  name: 'NotificationDropdown',
  data() {
    return {
      notifications: []
    };
  },
  computed: {
    sortedNotifications() {
      return [...this.notifications].sort((a, b) => {
        if (a.is_read !== b.is_read) return a.is_read ? 1 : -1;
        return new Date(b.created_at) - new Date(a.created_at);
      });
    },
    unreadCount() {
      return this.notifications.filter(n => !n.is_read).length;
    }
  },
  methods: {
    async fetchNotifications() {
      try {
        const { data } = await axios.get(`${apiUrl}/api/notifications`, {
          headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
        });
        this.notifications = data;
      } catch (error) {
        console.error('Error fetching notifications:', error);
      }
    },

    async markAsRead(id) {
      try {
        await axios.post(`${apiUrl}/api/notifications/${id}/read`, {}, {
          headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
        });
        this.notifications = this.notifications.map(n => 
          n.id === id ? { ...n, is_read: true } : n
        );
      } catch (error) {
        console.error('Error marking notification as read:', error);
      }
    },

    async markAllAsRead() {
      try {
        await axios.post(`${apiUrl}/api/notifications/mark-all-read`, {}, {
          headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
        });
        this.notifications = this.notifications.map(n => ({ ...n, is_read: true }));
      } catch (error) {
        console.error('Error marking all notifications as read:', error);
      }
    },

    async deleteNotification(id) {
      try {
        await axios.delete(`${apiUrl}/api/notifications/${id}`, {
          headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
        });
        this.notifications = this.notifications.filter(n => n.id !== id);
      } catch (error) {
        console.error('Error deleting notification:', error);
      }
    },

    getNotificationClass(type) {
      const iconClass = 'fas ' + {
        info: 'fa-info-circle info-icon',
        success: 'fa-check-circle success-icon',
        warning: 'fa-exclamation-triangle warning-icon',
        error: 'fa-times-circle error-icon',
        default: 'fa-bell default-icon'
      }[type] || 'fa-bell default-icon';
      
      return iconClass;
    },

    formatTime(dateString) {
      const date = new Date(dateString);
      return new Intl.DateTimeFormat('fr-FR', {
        dateStyle: 'short',
        timeStyle: 'short'
      }).format(date);
    }
  },
  mounted() {
    this.fetchNotifications();
    // Optional: Periodic refresh
    this.interval = setInterval(this.fetchNotifications, 30000);
  },
  beforeUnmount() {
    clearInterval(this.interval);
  }
};
</script>