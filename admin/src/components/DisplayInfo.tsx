import { Stack, Typography } from '@mui/material';
import { FC, ReactNode } from 'react';

interface DisplayInfoProps {
  info: string;
  value?: string | number;
  element?: ReactNode;
}

const DisplayInfo: FC<DisplayInfoProps> = ({ info: key, value, element }) => {
  return (
    <Stack direction={'row'} spacing={1} alignItems={'start'} marginBottom={1}>
      <Typography variant="body1" style={{ fontWeight: 'bold' }} marginTop={1}>
        {key}:
      </Typography>
      {value && (
        <Typography variant="body1" marginTop={1}>
          {value}
        </Typography>
      )}
      {element && element}
    </Stack>
  );
};

export default DisplayInfo;
