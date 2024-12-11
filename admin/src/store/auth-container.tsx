import { User, getAuth, signInWithEmailAndPassword } from 'firebase/auth';
import { useEffect, useState } from 'react';
import { createContainer, useContainer } from 'unstated-next';
import { app } from '../firebase';
import { UserAccountContainer } from '../store/user-account-container';

export const LOCAL_STORAGE_KEY = 'aiab-loggedIn';

const useAuthContainer = () => {
  const auth = getAuth(app);
  const userAccount = useContainer(UserAccountContainer);
  const [user, setUser] = useState<User | null>(null);
  const [isLoaded, setIsLoaded] = useState<boolean>(false);

  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged(async (user) => {
      setUser(user);
      await userAccount.saveUserAccount(user);
      if (user) {
        setIsLoaded(true);
      }
    });

    return () => unsubscribe();
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  // sign in with google code
  //   const signInWithGoogle = async () => {
  //     const provider = new GoogleAuthProvider();
  //     provider.setCustomParameters({ prompt: 'select_account', hd: '3ap.ch' });
  //     const result = await signInWithPopup(auth, provider);

  //     if (result.user) {
  //       localStorage.setItem(LOCAL_STORAGE_KEY, 'true');
  //     }

  //     return result;
  //   };

  const signIn = async (email: string, password: string) => {
    const result = await signInWithEmailAndPassword(auth, email, password);
    if (result.user) {
      localStorage.setItem(LOCAL_STORAGE_KEY, 'true');
    }

    return result;
  };

  const signOut = async () => {
    localStorage.setItem(LOCAL_STORAGE_KEY, 'false');
    await userAccount.saveUserAccount(null);
    await auth.signOut();
    setIsLoaded(false);
  };

  const isSignedIn = (): boolean => {
    return user !== null && isLoaded;
  };

  return { user, isLoaded, signIn, signOut, isSignedIn };
};

export const AuthContainer = createContainer(useAuthContainer);
