import { Stack, Typography } from '@mui/material';
import { FC } from 'react';
import CustomLink from './CustomLink';
import { UserAccount } from '../models/user-account';

interface UserEmailProps {
  user: UserAccount;
}

const UserEmail: FC<UserEmailProps> = ({ user }) => {
  return (
    <Stack direction={'row'} spacing={1} alignItems={'start'} marginBottom={1}>
      <Typography variant="body1" style={{ fontWeight: 'bold' }} marginTop={1}>
        Email:
      </Typography>
      {user.email ? (
        <CustomLink text={user.email} to={`mailto:${user.email}`} />
      ) : (
        <Typography variant="body1" marginTop={1}>
          -
        </Typography>
      )}
    </Stack>
  );
};

export default UserEmail;
