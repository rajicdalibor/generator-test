import { FC, ReactNode } from 'react';
import { Navigate } from 'react-router-dom';
import { useContainer } from 'unstated-next';
import { ROUTES } from './routes';
import { UserAccountContainer } from '../store/user-account-container';
import { AuthContainer } from '../store/auth-container';
import { isValidEmail } from '../utils/user-utils';

interface ProtectedRouteParams {
  children: ReactNode;
}

const ProtectedRoute: FC<ProtectedRouteParams> = ({ children }) => {
  const auth = useContainer(AuthContainer);
  const userAccountStore = useContainer(UserAccountContainer);
  const { isAdmin, userAccount } = userAccountStore;

  if (auth.isSignedIn()) {
    return isAdmin && isValidEmail(userAccount) ? (
      <>{children}</>
    ) : (
      <Navigate replace to={ROUTES.WELCOME} />
    );
  }
};

export default ProtectedRoute;
