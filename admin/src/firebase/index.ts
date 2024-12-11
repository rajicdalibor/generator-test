import { initializeApp } from 'firebase/app';

// Needed to declare global variable for app check debug token
// declare global {
//   interface Window {
//     FIREBASE_APPCHECK_DEBUG_TOKEN: boolean;
//   }
// }

const firebaseConfig = {
  "projectId": "tttttt-dev",
  "appId": "1:711056123344:web:4f6b4eeb995fd3207dc5d5",
  "storageBucket": "tttttt-dev.firebasestorage.app",
  "apiKey": "AIzaSyAw27e5mzfkTZQn2vrNm8QAPean0PtnhuE",
  "authDomain": "tttttt-dev.firebaseapp.com",
  "messagingSenderId": "711056123344"
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
