import { FirebaseStorage, getDownloadURL, getStorage, ref } from 'firebase/storage';
import { app } from '../firebase';

class StorageService {
  private readonly storage: FirebaseStorage;

  constructor() {
    this.storage = getStorage(app);
  }

  async getDownloadUrl(path: string): Promise<string> {
    const itemRef = ref(this.storage, path);
    return getDownloadURL(itemRef);
  }
}

export default StorageService;
