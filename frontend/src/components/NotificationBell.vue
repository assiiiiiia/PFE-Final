<template>
  <div class="relative notification-bell" ref="dropdownRef">
    <div class="relative">
      <i
        class="fas fa-bell text-gray-600 text-xl cursor-pointer hover:text-blue-500 transition duration-200 ease-in-out"
        :class="{ 'animate-ring': showDropdown, 'text-blue-500': unreadCount > 0 }"
        @click="toggleDropdown"
      ></i>
      <span v-if="unreadCount > 0" class="badge">
        {{ unreadCount > 9 ? '9+' : unreadCount }}
      </span>
    </div>

    <transition name="fade-slide">
      <div v-if="showDropdown" class="dropdown-menu">
        <div class="dropdown-header">
          <h3 class="text-gray-800 font-medium">Notifications</h3>
          <button 
            v-if="unreadCount > 0"
            class="text-blue-500 text-xs font-medium hover:underline"
            @click="markAllAsRead"
          >
            Tout marquer comme lu
          </button>
        </div>
        
        <div class="dropdown-content">
          <div 
            v-for="notif in sortedNotifications" 
            :key="notif.id" 
            class="notification-item"
            :class="{ 'unread': !notif.is_read, 'read': notif.is_read }"
          >
            <div class="notification-icon">
              <i :class="getNotificationIcon(notif.type)"></i>
            </div>
            <div class="notification-body">
              <p class="notification-message">{{ notif.message }}</p>
              <span class="notification-time">{{ formatTime(notif.created_at) }}</span>
            </div>
            <button 
              v-if="!notif.is_read" 
              class="notification-action"
              @click="markAsRead(notif.id)"
              title="Marquer comme lu"
            >
              <i class="fas fa-check-circle"></i>
            </button>
          </div>
          
          <div v-if="notifications.length === 0" class="empty-notifications">
            <i class="far fa-bell-slash text-gray-400 text-xl mb-2"></i>
            <p class="text-gray-500">Pas de nouvelles notifications</p>
          </div>
        </div>
        
        <div class="dropdown-footer">
         <router-link to="/notifications" class="view-all">Voir toutes les notifications</router-link>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import axios from 'axios';
const apiUrl = import.meta.env.VITE_API_URL;

export default {
  name: 'NotificationBell',
  data() {
    return {
      notifications: [],
      showDropdown: false,
      unreadCount: 0,
    };
  },
  computed: {
    sortedNotifications() {
    
      return [...this.notifications].sort((a, b) => {
        if (a.is_read !== b.is_read) return a.is_read ? 1 : -1;
        return new Date(b.created_at) - new Date(a.created_at);
      });
    }
  },
  methods: {
    toggleDropdown() {
      this.showDropdown = !this.showDropdown;
      if (this.showDropdown) {
        this.fetchNotifications();
      }
    },
    goToNotificationsPage() {
  this.$router.push('/notifications');
},
    fetchNotifications() {
      axios.get(`${apiUrl}/api/notifications`, {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
      })
      .then(({ data }) => {
        this.notifications = data;
        this.unreadCount = data.filter(n => !n.is_read).length;
      })
      .catch(err => console.error(err));
    },
    markAsRead(id) {
      axios.post(`${apiUrl}/api/notifications/${id}/read`, {}, {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
      }).then(() => {
   
        const index = this.notifications.findIndex(n => n.id === id);
        if (index !== -1) {
          this.notifications[index].is_read = true;
          this.unreadCount--;
        }
      });
    },
    markAllAsRead() {
      axios.post(`${apiUrl}/api/notifications/mark-all-read`, {}, {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
      }).then(() => {
        this.notifications = this.notifications.map(n => ({ ...n, is_read: true }));
        this.unreadCount = 0;
      });
    },
    getNotificationIcon(type) {
      const icons = {
        info: 'fas fa-info-circle text-blue-500',
        success: 'fas fa-check-circle text-green-500',
        warning: 'fas fa-exclamation-circle text-yellow-500',
        error: 'fas fa-times-circle text-red-500',
        default: 'fas fa-bell text-purple-500'
      };
      return icons[type] || icons.default;
    },
    formatTime(dateString) {
      const date = new Date(dateString);
      return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    }
  },
  mounted() {
    this.fetchNotifications();
   
    setInterval(this.fetchNotifications, 10000); 
  }
};
</script>

<style scoped>
.notification-bell {
  position: relative;
  display: inline-block;
}

.badge {
  position: absolute;
  top: -6px;
  right: -6px;
  background: #ff4757;
  color: white;
  min-width: 18px;
  height: 18px;
  border-radius: 9999px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.7rem;
  font-weight: 600;
  padding: 0 4px;
  z-index: 10;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.dropdown-menu {
  position: absolute;
  right: 0;
  top: 100%;
  width: 600px;
  max-height: 400px;
  background: white;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  z-index: 50;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  margin-top: 8px;
}

.dropdown-header {
  padding: 12px 16px;
  border-bottom: 1px solid #f3f4f6;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #f9fafb;
}
.dropdown-header button {
  background: none;
  border: none;
  color: #37bc72;
  cursor: pointer;
  font-size: 16px;
  padding: 0;
  transition: color 0.2s;
}
.dropdown-content {
  overflow-y: auto;
  flex-grow: 1;
}

.notification-item {
  padding: 12px 16px;
  display: flex;
  align-items: flex-start;
  gap: 12px;
  border-bottom: 1px solid #f3f4f6;
  transition: background-color 0.2s;
}

.notification-item.unread {
  background-color: #f8fafc;
}

.notification-item.read {
  opacity: 0.8;
}

.notification-item:hover {
  background-color: #f3f4f6;
}

.notification-icon {
  font-size: 18px;
  margin-top: 2px;
  flex-shrink: 0;
}

.notification-body {
  flex-grow: 1;
  min-width: 0;
}

.notification-message {
  font-size: 14px;
  color: #1f2937;
  margin-bottom: 4px;
  line-height: 1.4;
  word-break: break-word;
}

.notification-time {
  font-size: 12px;
  color: #6b7280;
}

.notification-action {
  color: #3b82f6;
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px;
  font-size: 16px;
  opacity: 0;
  transition: opacity 0.2s;
}

.notification-item:hover .notification-action {
  opacity: 1;
}

.notification-action:hover {
  color: #2563eb;
}

.notification-item.unread {
  background-color: #ffffff;
  border-left: 3px solid #37bc72;
}

.notification-item.read {
  background-color: #f9fafb;
  opacity: 0.9;
}

.notification-item.unread .notification-message {
  color: #1f2937;
  font-weight: 500;
}

.notification-item.read .notification-message {
  color: #6b7280;
  font-weight: 400;
}

.notification-item.unread .notification-time {
  color: #4b5563;
}

.notification-item.read .notification-time {
  color: #9ca3af;
}

.mark-as-read-btn {
  color: #37bc72;
  background-color: #eff6ff;
  border: none;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  opacity: 0;
  margin-left: auto;
  flex-shrink: 0;
}

.notification-item:hover .mark-as-read-btn {
  opacity: 1;
}

.mark-as-read-btn:hover {
  background-color: #37bc72;
  color: white;
  transform: scale(1.1);
}

.mark-as-read-btn i {
  font-size: 12px;
}

.empty-notifications {
  padding: 24px 16px;
  text-align: center;
  color: #9ca3af;
  background-color: #f9fafb;
  font-size: 14px;
}
.dropdown-footer {
  padding: 12px 16px;
  border-top: 1px solid #f3f4f6;
  text-align: center;
  background-color: #f9fafb;
}

.view-all {
  color: #3b82f6;
  font-size: 13px;
  font-weight: 500;
  text-decoration: none;
}

.view-all:hover {
  text-decoration: underline;
}

.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.25s ease;
}
.fade-slide-enter-from {
  opacity: 0;
  transform: translateY(-8px);
}
.fade-slide-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}

@keyframes ring {
  0% { transform: rotate(0); }
  25% { transform: rotate(15deg); }
  50% { transform: rotate(-10deg); }
  75% { transform: rotate(5deg); }
  100% { transform: rotate(0); }
}

.animate-ring {
  animation: ring 0.8s linear infinite;
}
</style>