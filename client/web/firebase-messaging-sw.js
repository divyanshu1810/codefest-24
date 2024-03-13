importScripts('https://www.gstatic.com/firebasejs/10.7.2/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.2/firebase-messaging.js');

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyA97VNgQbhr3PYw8bUwnZZNxmvGVH6u-Sc",
  authDomain: "clocktantra.firebaseapp.com",
  projectId: "clocktantra",
  storageBucket: "clocktantra.appspot.com",
  messagingSenderId: "1032804601038",
  appId: "1:1032804601038:web:e83f5f98beb230c0b5949f",
  measurementId: "G-Q24C2KPG9V"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

// Customize this part based on your requirements
messaging.setBackgroundMessageHandler((payload) => {
  const notificationTitle = 'Background Message Title';
  const notificationOptions = {
    body: payload.data.body,
    icon: 'your-icon-url.png',
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});
