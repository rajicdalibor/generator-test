import { createTheme, CssBaseline, ThemeProvider } from '@mui/material';
import { Outlet } from 'react-router-dom';
import { useContainer } from 'unstated-next';
import { MuiThemeContainer } from './store/mui-theme-container';
import { UserAccountContainer } from './store/user-account-container';
import { AuthContainer } from './store/auth-container';

function App() {
  const muiTheme = useContainer(MuiThemeContainer);
  const appTheme = createTheme({
    palette: {
      mode: muiTheme.mode,
    },
  });

  return (
    <UserAccountContainer.Provider>
      <AuthContainer.Provider>
        <ThemeProvider theme={appTheme}>
          <CssBaseline />
          <Outlet />
        </ThemeProvider>
      </AuthContainer.Provider>
    </UserAccountContainer.Provider>
  );
}

export default App;
