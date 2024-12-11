import { Typography, useTheme } from '@mui/material';
import { blue } from '@mui/material/colors';
import { FC, HTMLAttributeAnchorTarget } from 'react';
import { Link } from 'react-router-dom';

type CustomLinkProps = {
  text: string;
  to: string;
  target?: HTMLAttributeAnchorTarget;
};

const CustomLink: FC<CustomLinkProps> = ({ text, to, target }) => {
  const theme = useTheme();
  return (
    <Typography
      about="custom-link"
      variant="body1"
      component={Link}
      to={to}
      target={target}
      style={{
        color: theme.palette.mode === 'light' ? blue[600] : blue[300],
      }}>
      {text}
    </Typography>
  );
};

export default CustomLink;
