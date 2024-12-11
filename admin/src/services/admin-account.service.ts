import { Firestore, doc, getDoc, getFirestore } from 'firebase/firestore';
import { app } from '../firebase';

class AdminAccountService {
  private readonly COLLECTION = 'admins';
  private readonly db: Firestore;

  constructor() {
    this.db = getFirestore(app);
  }

  async exists(id: string): Promise<boolean> {
    const docRef = doc(this.db, this.COLLECTION, id);
    const docSnapshot = await getDoc(docRef);

    return docSnapshot.exists();
  }
}

export default AdminAccountService;
