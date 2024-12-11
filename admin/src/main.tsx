import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { RouterProvider } from 'react-router-dom';
import { router } from './navigation/index.tsx';
import { MuiThemeContainer } from './store/mui-theme-container.tsx';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <MuiThemeContainer.Provider>
      <RouterProvider router={router} />
    </MuiThemeContainer.Provider>
  </StrictMode>,
);
