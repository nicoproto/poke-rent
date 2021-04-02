import Rails from '@rails/ujs'

const initNotifications = () => {
  const notifications = document.getElementById('notifications');
  const counter = document.getElementById('counter');

  console.log("initNotifications runned");

  const markAsRead = () => {
    fetch('/notifications/mark_as_read', {
        method: 'post',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': Rails.csrfToken()
        },
        credentials: 'same-origin'
      })
      .then(response => {
        if (response.status === 200) {
          refreshCounter(0);
        }
      })
  };

  const renderNotifications = (notifications) => {
    return notifications.map(notification => {
      return (
        `<div class="dropdown-item">
            <strong>${notification.actor}</strong>
            ${notification.action} ${notification.notifiable.type}
          </div>`
      )
    }).join('');
  };

  const refreshNotifications = (notificationsHTML) => {
    const notifications = document.getElementById('notifications');
    notifications.innerHTML = notificationsHTML;
  };

  const refreshCounter = (number) => {
    const counterElement = document.getElementById('counter');
    counterElement.innerHTML = number;
  };

  const loadNotifications = () => {
    fetch('/notifications', {
        method: 'get',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': Rails.csrfToken()
        },
        credentials: 'same-origin'
      })
      .then(response => response.json())
      .then(data => {
        refreshCounter(data.array.length);
        refreshNotifications(renderNotifications(data.array));
      })
  };

  if (notifications) {
    loadNotifications();
    setInterval(() => {
      loadNotifications();
    }, 5000);
  }

  if (counter) {
    counter.addEventListener('click', markAsRead)
  }
}

export { initNotifications };