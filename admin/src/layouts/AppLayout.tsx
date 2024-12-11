import MenuIcon from '@mui/icons-material/Menu';
import { AppBar, Avatar, Menu, MenuItem, Tooltip } from '@mui/material';
import Box from '@mui/material/Box';
import { amber } from '@mui/material/colors';
import IconButton from '@mui/material/IconButton';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import { FC, useEffect, useState } from 'react';
import { Link, Outlet, useNavigate } from 'react-router-dom';
import { useContainer } from 'unstated-next';
import appIconLight from '../assets/appIconLight.svg';
import MuiThemeButton from '../components/MuiThemeButton';
import { ROUTES } from '../navigation/routes';
import StorageService from '../services/storage.service';
import { AuthContainer } from '../store/auth-container';
import { MuiThemeContainer } from '../store/mui-theme-container';
import { UserAccountContainer } from '../store/user-account-container';

const firebaseEnv = import.meta.env.VITE_FIREBASE_ENV;

const pages = [
  {
    title: 'Users',
    path: ROUTES.USERS,
  },
];

const AppLayout: FC = () => {
  const authContainer = useContainer(AuthContainer);
  const muiTheme = useContainer(MuiThemeContainer);
  const userAccountContainer = useContainer(UserAccountContainer);
  const navigate = useNavigate();
  const [anchorElNav, setAnchorElNav] = useState<null | HTMLElement>(null);
  const [anchorElUser, setAnchorElUser] = useState<null | HTMLElement>(null);
  const [avatarUrl, setAvatarUrl] = useState<string>('');

  const handleOpenNavMenu = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorElNav(event.currentTarget);
  };
  const handleOpenUserMenu = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorElUser(event.currentTarget);
  };

  const handleCloseNavMenu = () => {
    setAnchorElNav(null);
  };
  const handleCloseUserMenu = () => {
    setAnchorElUser(null);
  };

  const createCustomLink = (path: string, title: string, navItem: boolean) => {
    let textColor = 'white';
    if (navItem) {
      textColor = muiTheme.mode === 'light' ? 'black' : 'white';
    }
    return (
      <Typography
        key={path}
        style={{
          color: textColor,
          textDecoration: 'none',
          marginLeft: '16px',
        }}
        variant={navItem ? 'body1' : 'h6'}
        noWrap
        component={Link}
        to={path}>
        {title}
      </Typography>
    );
  };

  useEffect(() => {
    const { userAccount } = userAccountContainer;

    if (userAccount && userAccount.avatarImage) {
      const storageService = new StorageService();
      storageService
        .getDownloadUrl(userAccount.avatarImage)
        .then((url) => {
          setAvatarUrl(url);
        })
        .catch((error) => {
          console.log('Error while fetching avatar', error);
          setAvatarUrl('');
        });
    }
  }, [userAccountContainer]);

  return (
    <Box sx={{ flexGrow: 1 }}>
      <AppBar position="static">
        <Toolbar disableGutters style={{ paddingLeft: 16, paddingRight: 16 }}>
          <Tooltip title="Go to home page">
            <IconButton onClick={() => navigate(ROUTES.HOME)}>
              <img width={'40px'} src={appIconLight} alt={'App in a box icon'} />
            </IconButton>
          </Tooltip>
          <Box sx={{ flexGrow: 1, display: { xs: 'flex', md: 'none' } }}>
            <IconButton
              size="large"
              aria-label="account of current user"
              aria-controls="menu-appbar"
              aria-haspopup="true"
              onClick={handleOpenNavMenu}
              color="inherit">
              <MenuIcon />
            </IconButton>
            <Menu
              id="menu-appbar"
              anchorEl={anchorElNav}
              anchorOrigin={{
                vertical: 'bottom',
                horizontal: 'left',
              }}
              keepMounted
              transformOrigin={{
                vertical: 'top',
                horizontal: 'left',
              }}
              open={Boolean(anchorElNav)}
              onClose={handleCloseNavMenu}
              sx={{
                display: { xs: 'block', md: 'none' },
              }}>
              {pages.map((item) => (
                <MenuItem key={item.title} onClick={handleCloseNavMenu}>
                  {createCustomLink(item.path, item.title, true)}
                </MenuItem>
              ))}
            </Menu>
          </Box>
          <Box
            sx={{
              flexGrow: 1,
              justifyContent: 'flex-start',
              display: { xs: 'none', md: 'flex' },
            }}>
            {pages.map((item) => {
              return createCustomLink(item.path, item.title, false);
            })}
          </Box>
          <MuiThemeButton onClick={muiTheme.switchTheme} checked={muiTheme.mode === 'dark'} />
          <Typography variant="h6" noWrap component="div" marginLeft={1} marginRight={1}>
            Admin
          </Typography>
          <Box sx={{ flexGrow: 0 }}>
            <Tooltip title="Open settings">
              <IconButton onClick={handleOpenUserMenu}>
                <Avatar src={avatarUrl} />
              </IconButton>
            </Tooltip>
            <Menu
              sx={{ mt: '45px' }}
              id="menu-appbar"
              anchorEl={anchorElUser}
              anchorOrigin={{
                vertical: 'top',
                horizontal: 'right',
              }}
              keepMounted
              transformOrigin={{
                vertical: 'top',
                horizontal: 'right',
              }}
              open={Boolean(anchorElUser)}
              onClose={handleCloseUserMenu}>
              <MenuItem
                key={'logout'}
                onClick={() => {
                  authContainer.signOut();
                }}>
                <Typography textAlign="center">Logout</Typography>
              </MenuItem>
            </Menu>
          </Box>
        </Toolbar>
      </AppBar>
      {firebaseEnv === 'DEV' && (
        <Box
          style={{
            backgroundColor: amber[500],
            color: 'white',
            fontWeight: 'bold',
            textAlign: 'center',
          }}>
          DEVELOPMENT ENVIRONMENT
        </Box>
      )}
      <Outlet />
    </Box>
  );
};

export default AppLayout;
