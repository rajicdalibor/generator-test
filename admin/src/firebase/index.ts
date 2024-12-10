import { initializeApp } from 'firebase/app';

// Needed to declare global variable for app check debug token
// declare global {
//   interface Window {
//     FIREBASE_APPCHECK_DEBUG_TOKEN: boolean;
//   }
// }

const firebaseConfig = {
  "projectId": "dalibor-new-test-dev",
  "appId": "1:789980816420:web:3ce1ac88057c9a0b5a24b1",
  "storageBucket": "dalibor-new-test-dev.firebasestorage.app",
  "apiKey": "AIzaSyBhgkSUhlzsnNoYu4ANim-0UPv9KxEhIt0",
  "authDomain": "dalibor-new-test-dev.firebaseapp.com",
  "messagingSenderId": "789980816420"
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
