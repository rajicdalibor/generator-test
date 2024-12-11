import { initializeApp } from 'firebase/app';

// Needed to declare global variable for app check debug token
// declare global {
//   interface Window {
//     FIREBASE_APPCHECK_DEBUG_TOKEN: boolean;
//   }
// }

const firebaseConfig = {
  "projectId": "test-project-daliborr-dev",
  "appId": "1:963477389097:web:45903bd42fa1f65ab7c138",
  "storageBucket": "test-project-daliborr-dev.firebasestorage.app",
  "apiKey": "AIzaSyCEV9e4oKYVw1ufP0CrACd2shsvI7u73Zs",
  "authDomain": "test-project-daliborr-dev.firebaseapp.com",
  "messagingSenderId": "963477389097"
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
