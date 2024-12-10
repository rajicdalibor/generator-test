# Admin Portal

Admin portal is a simple web app built using vitejs + react + typescript.
It will provide features necessary for admin users to manage the system and user generated content.

## Tech stack

- [Vitejs](https://vitejs.dev/) as build tool
- [React](https://react.dev/) as frontend library
- [Typescript](https://www.typescriptlang.org/) as language
- [Material UI](https://mui.com/) as UI library
- [unstated-next](https://github.com/jamiebuilds/unstated-next) as state management library
- [React Router](https://reactrouter.com/en/main) as routing library

## Prerequisites

Minimum node version is 18.
IDE that supports typescript, eslint, prettier, jsx syntax and react.

## Getting Started

Run the following command to install the dependencies:

```bash
npm install
```

To run locally, use the following command:

```bash
npm run dev
```

To check for linting errors, use the following command:

```bash
npm run lint
```

To deploy the project as a preview, use the following command:

```bash
npm run build
npm run deploy:preview
```

### Debug token for AppCheck

#### This is needed only if AppCheck was enabled in the Firebase

<https://firebase.google.com/docs/app-check/web/debug-provider>

After starting the web app, enter `Inspect` mode for your browser, go to **console** and read the value from the message:

```bash
App Check debug token: **TOKEN**. You will need to add it to your app's App Check settings in the Firebase console for it to work.
```

Copy the **TOKEN** value and add it in the **Firebase** AppCheck for web app.

### Local env

Create a file named `.env.local` and put these two env variables there

```bash
VITE_RE_CAPTCHA_KEY=
VITE_FIREBASE_ENV=DEV
```

## Features

The admin portal will have the following features:

- Login/Welcome screen
- Home
- Users overview
