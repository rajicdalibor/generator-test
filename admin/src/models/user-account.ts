import { Timestamp } from 'firebase/firestore';
import { GooglePlace } from './google-place';

export interface UserAccount {
  id: string;
  email?: string;
  firstName?: string;
  lastName?: string;
  birthDate?: string;
  avatarImage?: string;
  disabled: boolean;
  onboarded: boolean;
  createdAt: Timestamp;
  updatedAt?: Timestamp;
  lastKnownActivity?: Timestamp;
  installedAppVersion?: string;
  googleAddress?: GooglePlace;
}

export enum UserAccountFields {
  id = 'id',
  email = 'email',
  firstName = 'firstName',
  lastName = 'lastName',
  birthDate = 'birthDate',
  avatarImage = 'avatarImage',
  disabled = 'disabled',
  onboarded = 'onboarded',
  createdAt = 'createdAt',
  updatedAt = 'updatedAt',
  lastKnownActivity = 'lastKnownActivity',
  installedAppVersion = 'installedAppVersion',
  googleAddress = 'googleAddress',
}

export function displayUserName(user: UserAccount): string | undefined {
  let name = user.firstName;
  if (user.lastName) {
    name += ` ${user.lastName}`;
  }
  return name;
}
