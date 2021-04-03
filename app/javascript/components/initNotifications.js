import Rails from '@rails/ujs'

const initNotifications = () => {
  const counter = document.querySelector('[data-trigger="updateCounter"]');

  const refreshCounter = (number) => {
    const counterElement = document.getElementById('counter');
    counterElement.innerHTML = number;
  };

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

  if (counter) counter.addEventListener('click', markAsRead);
}

export { initNotifications };