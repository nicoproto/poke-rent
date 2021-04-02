import consumer from "./consumer";

const initNotificationCable = () => {
  const notificationsContainer = document.getElementById('notifications');
  if (notificationsContainer) {
    consumer.subscriptions.create({
          channel: "NotificationsChannel"
        }, {
      // called when data is broadcast in the cable
      received(data) {
        notificationsContainer.insertAdjacentHTML('beforeend', data.notification);
        const counterElement = document.getElementById('counter');
        counterElement.innerHTML = data.count;
      },
    });
  }
}

export { initNotificationCable };