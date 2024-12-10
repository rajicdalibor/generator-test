import ArrowBackIosNewOutlinedIcon from '@mui/icons-material/ArrowBackIosNewOutlined';
import InfoOutlinedIcon from '@mui/icons-material/InfoOutlined';
import { FC, useCallback, useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { displayUserName, UserAccount } from '../../models/user-account';
import UserAccountService from '../../services/user-account.service';
import {
  Avatar,
  Box,
  Card,
  Chip,
  Container,
  Divider,
  Grid2,
  IconButton,
  Stack,
  styled,
  Typography,
} from '@mui/material';
import DisplayInfo from '../../components/DisplayInfo';
import UserEmail from '../../components/UserEmail';
import { format } from 'date-fns';
import { standardDateFormat, standardDateTimeFormat } from '../../utils/date-time.utils';
import StorageService from '../../services/storage.service';

const UserCard = styled(Card)(({ theme }) => ({
  backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
  padding: theme.spacing(3),
  textAlign: 'left',
}));

export const UserDetailsPage: FC = () => {
  const params = useParams();
  const navigate = useNavigate();
  const [user, setUser] = useState<UserAccount | null>(null);
  const [avatarUrl, setAvatarUrl] = useState<string>('');

  const fetchUser = useCallback(async () => {
    try {
      const userAccountService = new UserAccountService();
      if (params?.id) {
        const result = await userAccountService.getUser(params.id);
        setUser(result);
        if (result?.avatarImage) {
          const storageService = new StorageService();
          const url = await storageService.getDownloadUrl(result.avatarImage);
          setAvatarUrl(url);
        }
      }
    } catch (error) {
      console.log('Error fetching user: ', error);
    }
  }, [params]);

  useEffect(() => {
    fetchUser();
  }, [fetchUser]);

  return (
    <Box
      sx={{
        padding: 2,
      }}>
      <Stack direction={'row'} spacing={1} alignItems={'center'} marginBottom={2}>
        <IconButton onClick={() => navigate(-1)}>
          <ArrowBackIosNewOutlinedIcon />
        </IconButton>
        <Typography variant="h5">User Details</Typography>
      </Stack>
      {user && (
        <Container maxWidth="lg">
          <UserCard>
            <Stack
              direction={'row'}
              spacing={1}
              alignItems={'center'}
              justifyContent={'center'}
              marginBottom={1}>
              <InfoOutlinedIcon />
              <Typography variant="h6">User Information</Typography>
              <Avatar
                sx={{
                  width: '64px',
                  height: '64px',
                }}
                src={avatarUrl}
                alt={displayUserName(user)}
              />
            </Stack>

            <Grid2 container spacing={2}>
              <Grid2 size={{ xs: 12, md: 6 }}>
                <Divider
                  style={{
                    marginBottom: '16px',
                  }}>
                  <Chip label="User" size="small" />
                </Divider>
                <DisplayInfo info="ID" value={user.id} />
                <DisplayInfo info="Name" value={displayUserName(user)} />
                <UserEmail user={user} />
                <DisplayInfo
                  info="Birth Date"
                  value={user.birthDate ? format(user.birthDate, standardDateFormat) : ''}
                />
                <DisplayInfo info="Address" value={user.googleAddress?.fullAddress} />
                <DisplayInfo info="Onboarded" value={user.onboarded ? 'Yes' : 'No'} />
              </Grid2>
              <Grid2 size={{ xs: 12, md: 6 }}>
                <Divider
                  style={{
                    marginBottom: '16px',
                  }}>
                  <Chip label="System" size="small" />
                </Divider>
                <DisplayInfo info="Disabled" value={user.disabled ? 'Yes' : 'No'} />
                <DisplayInfo
                  info="Last known activity"
                  value={
                    user.lastKnownActivity
                      ? format(user.lastKnownActivity.toDate(), standardDateTimeFormat)
                      : ''
                  }
                />
                <DisplayInfo info="Installed app version" value={user.installedAppVersion} />
                <DisplayInfo
                  info="Created at"
                  value={format(user.createdAt.toDate(), standardDateTimeFormat)}
                />
                <DisplayInfo
                  info="Updated at"
                  value={
                    user.updatedAt ? format(user.updatedAt.toDate(), standardDateTimeFormat) : ''
                  }
                />
              </Grid2>
            </Grid2>
          </UserCard>
        </Container>
      )}
    </Box>
  );
};
