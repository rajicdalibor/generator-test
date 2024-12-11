import { Link, useRouteError } from 'react-router-dom';
import { Box, Typography } from '@mui/material';

const AppErrorBoundary = () => {
  const error = useRouteError() as Error;

  console.error(error);

  return (
    <Box component="main" height="100vh" width="100%" pt={4} px={3}>
      <Typography gutterBottom variant="h5" fontWeight="bold">
        Something went wrong
      </Typography>
      <Link to={'/'}>Go back to the home page.</Link>
      {error?.message && <Typography color="error">{error.message}</Typography>}
    </Box>
  );
};

export default AppErrorBoundary;
