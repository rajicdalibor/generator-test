import { initializeApp } from 'firebase/app';

// Needed to declare global variable for app check debug token
// declare global {
//   interface Window {
//     FIREBASE_APPCHECK_DEBUG_TOKEN: boolean;
//   }
// }

const firebaseConfig = {
  "projectId": "new-dalibor-test-dev",
  "appId": "1:840621458838:web:192d2cc48a7e04cfa949b7",
  "storageBucket": "new-dalibor-test-dev.firebasestorage.app",
  "apiKey": "AIzaSyAhhgIjGJQ4ydUqJ2nAC0nWnrO_4v9-2Rk",
  "authDomain": "new-dalibor-test-dev.firebaseapp.com",
  "messagingSenderId": "840621458838"
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
