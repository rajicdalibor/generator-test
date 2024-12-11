/// <reference types="vite/client" />
/// <reference types="vite-plugin-svgr/client" />

interface ImportMetaEnv {
  readonly VITE_FIREBASE_ENV: 'DEV' | 'PROD';
  // more env variables...
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
