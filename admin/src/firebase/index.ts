import { initializeApp } from 'firebase/app';

// Needed to declare global variable for app check debug token
// declare global {
//   interface Window {
//     FIREBASE_APPCHECK_DEBUG_TOKEN: boolean;
//   }
// }

const firebaseConfig = {
  "projectId": "test-generator-new-dev",
  "appId": "1:658016341923:web:6b7479bf6693a85dd5d416",
  "storageBucket": "test-generator-new-dev.firebasestorage.app",
  "apiKey": "AIzaSyD8w1hx3qwMh4BCb3jOEN5I4au5t9LU9DU",
  "authDomain": "test-generator-new-dev.firebaseapp.com",
  "messagingSenderId": "658016341923"
};

// Initialize Firebase app
export const app = initializeApp(firebaseConfig);

// Initialize Firebase analytics
// export const analytics = getAnalytics(app);

// Debug token for app check
// self.FIREBASE_APPCHECK_DEBUG_TOKEN = process.env.NODE_ENV === 'development';
// Initialize Firebase app check
// export const appCheck = initializeAppCheck(app, {
//   provider: new ReCaptchaEnterpriseProvider(import.meta.env.VITE_RE_CAPTCHA_KEY ?? ''),
//   isTokenAutoRefreshEnabled: true, // Set to true to allow auto-refresh.
// });
