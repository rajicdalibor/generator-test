import {
  collection,
  doc,
  DocumentData,
  DocumentSnapshot,
  Firestore,
  getDoc,
  getDocs,
  getFirestore,
  query,
} from 'firebase/firestore';
import { app } from '../firebase';
import { UserAccount, UserAccountFields } from '../models/user-account';
import { GooglePlace } from '../models/google-place';

class UserAccountService {
  private readonly COLLECTION = 'users';
  private readonly db: Firestore;

  constructor() {
    this.db = getFirestore(app);
  }

  private fromSnapshot(snapshot: DocumentSnapshot<DocumentData, DocumentData>): UserAccount | null {
    const data = snapshot.data();
    if (data === undefined) {
      return null;
    }

    return {
      id: snapshot.id,
      email: data[UserAccountFields.email],
      firstName: data[UserAccountFields.firstName],
      lastName: data[UserAccountFields.lastName],
      birthDate: data[UserAccountFields.birthDate],
      avatarImage: data[UserAccountFields.avatarImage],
      onboarded: data[UserAccountFields.onboarded] ?? false,
      disabled: data[UserAccountFields.disabled] ?? false,
      createdAt: data[UserAccountFields.createdAt],
      updatedAt: data[UserAccountFields.updatedAt] ? data[UserAccountFields.updatedAt] : undefined,
      installedAppVersion: data[UserAccountFields.installedAppVersion],
      lastKnownActivity: data[UserAccountFields.lastKnownActivity],
      googleAddress: data[UserAccountFields.googleAddress]
        ? (data[UserAccountFields.googleAddress] as GooglePlace)
        : undefined,
    };
  }

  async getUser(id: string): Promise<UserAccount | null> {
    const docRef = doc(this.db, this.COLLECTION, id);
    const docSnapshot = await getDoc(docRef);

    if (!docSnapshot.exists()) {
      return null;
    }

    return this.fromSnapshot(docSnapshot);
  }

  async getUsers(): Promise<UserAccount[]> {
    const q = query(collection(this.db, this.COLLECTION));
    const querySnapshot = await getDocs(q);

    return querySnapshot.docs.map((doc) => this.fromSnapshot(doc)).filter((user) => user !== null);
  }
}

export default UserAccountService;
