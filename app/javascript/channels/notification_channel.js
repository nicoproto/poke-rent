import consumer from "./consumer";

const initNotificationCable = () => {
  const notificationsContainer = document.getElementById('notifications');
  if (notificationsContainer) {
    consumer.subscriptions.create({
          channel: "NotificationsChannel"
        }, {
      received(data) {
        console.log(data); // called when data is broadcast in the cable
      },
    });
  }
}

export { initNotificationCable };