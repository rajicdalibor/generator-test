import { UserAccount } from '../models/user-account';

export function isValidEmail(user: UserAccount | null): boolean {
  return user?.email?.endsWith('@3ap.ch') ?? false;
}
