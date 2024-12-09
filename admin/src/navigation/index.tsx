import { createBrowserRouter } from 'react-router-dom';
import App from '../App';
import { ROUTES } from './routes';
import { WelcomePage } from '../pages/welcome';
import { HomePage } from '../pages/home';
import { UserDetailsPage, UsersPage } from '../pages/users';
import AppLayout from '../layouts/AppLayout';
import AppErrorBoundary from '../pages/AppErrorBoundary';
import ProtectedRoute from './ProtectedRoute';

export const router = createBrowserRouter([
  {
    element: <App />,
    errorElement: <AppErrorBoundary />,
    children: [
      {
        path: ROUTES.WELCOME,
        element: <WelcomePage />,
      },
      {
        element: (
          <ProtectedRoute>
            <AppLayout />
          </ProtectedRoute>
        ),
        children: [
          {
            path: ROUTES.HOME,
            element: <HomePage />,
          },
          {
            path: ROUTES.USERS,
            element: <UsersPage />,
          },
          {
            path: ROUTES.USERS_DETAILS,
            element: <UserDetailsPage />,
          },
        ],
      },
    ],
  },
]);
