import { useState } from 'react';
import { createContainer } from 'unstated-next';
import UserAccountService from '../services/user-account.service';
import { User } from 'firebase/auth';
import AdminAccountService from '../services/admin-account.service';
import { UserAccount } from '../models/user-account';

const useUserAccountContainer = () => {
  const [userAccount, setUserAccount] = useState<UserAccount | null>(null);
  const [isAdmin, setIsAdmin] = useState<boolean>(false);

  const saveUserAccount = async (user: User | null) => {
    if (!user) {
      setUserAccount(null);
      setIsAdmin(false);
      return;
    }

    try {
      const userAccountService = new UserAccountService();
      const userAccount = await userAccountService.getUser(user.uid);
      setUserAccount(userAccount);

      const adminAccountService = new AdminAccountService();
      const exists = await adminAccountService.exists(user.uid);
      setIsAdmin(exists);
    } catch (error) {
      console.log('Error while fetching user account', error);
      setUserAccount(null);
      setIsAdmin(false);
    }
  };

  return {
    userAccount,
    isAdmin,
    saveUserAccount,
  };
};

export const UserAccountContainer = createContainer(useUserAccountContainer);
