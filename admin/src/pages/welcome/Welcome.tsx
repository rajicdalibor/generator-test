import {
  Box,
  Button,
  CircularProgress,
  Divider,
  IconButton,
  Paper,
  Stack,
  styled,
  TextField,
  Typography,
} from '@mui/material';
import { amber } from '@mui/material/colors';
import { FC, useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useContainer } from 'unstated-next';
import { ROUTES } from '../../navigation/routes';
import { AuthContainer, LOCAL_STORAGE_KEY } from '../../store/auth-container';
import { UserAccountContainer } from '../../store/user-account-container';
import { isValidEmail } from '../../utils/user-utils';
import { SubmitHandler, useForm } from 'react-hook-form';
import { VisibilityOffOutlined, VisibilityOutlined } from '@mui/icons-material';
import { FirebaseError } from 'firebase/app';

const firebaseEnv = import.meta.env.VITE_FIREBASE_ENV;

const Item = styled(Paper)(({ theme }) => ({
  backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
  ...theme.typography.body2,
  padding: theme.spacing(3),
  textAlign: 'center',
  minWidth: '500px',
}));

interface ILoginForm {
  email: string;
  password: string;
}

export const WelcomePage: FC = () => {
  const auth = useContainer(AuthContainer);
  const navigate = useNavigate();
  const userAccountStore = useContainer(UserAccountContainer);
  const [isValidUser, setIsValidUser] = useState<boolean>(false);
  const loggedIn = localStorage.getItem(LOCAL_STORAGE_KEY);
  const [isLoggedIn] = useState<boolean>(loggedIn === 'true');
  const [showPassword, setShowPassword] = useState<boolean>(false);
  const [loginProcessing, setLoginProcessing] = useState<boolean>(false);
  const [loginError, setLoginError] = useState<string | null>();
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<ILoginForm>();

  useEffect(() => {
    const { isAdmin, userAccount } = userAccountStore;
    if (userAccount) {
      setIsValidUser(isAdmin && isValidEmail(userAccount));
    }
  }, [userAccountStore]);

  useEffect(() => {
    if (isValidUser && auth.isSignedIn()) {
      setLoginProcessing(false);
      navigate(ROUTES.HOME, { replace: true });
    }
  }, [auth.user, auth.isLoaded, isValidUser]); // eslint-disable-line react-hooks/exhaustive-deps

  const onSubmit: SubmitHandler<ILoginForm> = async (data) => {
    try {
      setLoginProcessing(true);
      await auth.signIn(data.email, data.password);
      setLoginError(null);
    } catch (error) {
      setLoginProcessing(false);
      if (error instanceof FirebaseError) {
        if (error.code === 'auth/invalid-credential') {
          setLoginError('Invalid email or password');
        } else {
          setLoginError(error.message);
        }
      } else {
        console.log('Error: ', error);
        setLoginError(`${error}`);
      }
    }
  };

  if (auth.isSignedIn() && !isValidUser) {
    return (
      <Stack
        direction={'column'}
        spacing={4}
        justifyContent={'center'}
        alignItems={'center'}
        minHeight={'100vh'}>
        <Item>
          <Typography variant="h2" mb={2}>
            Welcome to AIAB Admin Portal211
          </Typography>
          {firebaseEnv === 'DEV' && (
            <Typography variant="h6" marginTop={1} marginBottom={1} bgcolor={amber[500]}>
              DEVELOPMENT ENVIRONMENT
            </Typography>
          )}
        </Item>
        <Divider />
        <Item>
          <Typography variant={'h4'}>Invalid user</Typography>
          <Typography variant="body1" marginBottom={2}>
            You are not authorized to access this portal. Please contact the administrator.
          </Typography>
          {auth.user !== null && (
            <Button variant={'contained'} onClick={auth.signOut}>
              Logout
            </Button>
          )}
        </Item>
      </Stack>
    );
  }

  return (
    <Stack
      direction={'column'}
      spacing={4}
      justifyContent={'center'}
      alignItems={'center'}
      minHeight={'100vh'}>
      <Item>
        <Typography variant="h2" mb={2}>
          Welcome to AIAB Admin Portal3
        </Typography>
        {firebaseEnv === 'DEV' && (
          <Typography variant="h6" marginTop={1} marginBottom={1} bgcolor={amber[500]}>
            DEVELOPMENT ENVIRONMENT
          </Typography>
        )}
      </Item>
      {isLoggedIn ? (
        <Typography variant="body1" marginTop={1} marginBottom={1}>
          Already logged in...
        </Typography>
      ) : (
        <form onSubmit={handleSubmit(onSubmit)}>
          <Stack direction={'column'} spacing={2} minWidth={'300px'}>
            <TextField
              label="Email"
              error={!!errors.email}
              aria-errormessage='{"required": "Email is required"}'
              helperText={errors.email ? 'Email is required' : ''}
              {...register('email', { required: true })}
            />
            <TextField
              label="Password"
              type={showPassword ? 'text' : 'password'}
              slotProps={{
                input: {
                  endAdornment: (
                    <IconButton onClick={() => setShowPassword(!showPassword)}>
                      {showPassword ? <VisibilityOffOutlined /> : <VisibilityOutlined />}
                    </IconButton>
                  ),
                },
              }}
              error={!!errors.password}
              aria-errormessage='{"required": "Password is required"}'
              helperText={errors.password ? 'Password is required' : ''}
              {...register('password', { required: true })}
            />
            {loginError && (
              <Box display={'flex'} justifyContent={'center'}>
                <Typography variant="body1" color={'error'}>
                  {loginError}
                </Typography>
              </Box>
            )}
            {loginProcessing ? (
              <Box display={'flex'} justifyContent={'center'}>
                <CircularProgress />
              </Box>
            ) : (
              <Button variant={'contained'} type="submit">
                Login
              </Button>
            )}
          </Stack>
        </form>
      )}
    </Stack>
  );
};
