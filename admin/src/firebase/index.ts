import { initializeApp } from 'firebase/app';

// Needed to declare global variable for app check debug token
// declare global {
//   interface Window {
//     FIREBASE_APPCHECK_DEBUG_TOKEN: boolean;
//   }
// }

const firebaseConfig = {
  "projectId": "uiuiuiuiu-dev",
  "appId": "1:888912707066:web:018ee258da70d2a077b843",
  "storageBucket": "uiuiuiuiu-dev.firebasestorage.app",
  "apiKey": "AIzaSyBxVX5267bt5AGHSZyelw4JZCp8NanpqCU",
  "authDomain": "uiuiuiuiu-dev.firebaseapp.com",
  "messagingSenderId": "888912707066"
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
