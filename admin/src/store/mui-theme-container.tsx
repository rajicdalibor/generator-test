import { useState } from 'react';
import { createContainer } from 'unstated-next';

const MuiThemeModeValues = ['light', 'dark'] as const;
export type MuiThemeMode = (typeof MuiThemeModeValues)[number];
const THEME_MODE_STORAGE_KEY = 'aiab-themeMode';

const themeMode = localStorage.getItem(THEME_MODE_STORAGE_KEY) as MuiThemeMode | undefined;

const useMuiThemeContainer = () => {
  const [mode, setMode] = useState<MuiThemeMode>(themeMode ?? 'light');

  const switchTheme = () => {
    if (mode === 'light') {
      setMode('dark');
      localStorage.setItem(THEME_MODE_STORAGE_KEY, 'dark');
    } else {
      setMode('light');
      localStorage.setItem(THEME_MODE_STORAGE_KEY, 'light');
    }
  };

  return { mode, switchTheme };
};

export const MuiThemeContainer = createContainer(useMuiThemeContainer);
