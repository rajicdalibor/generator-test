import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/models/user.dart';
import 'package:package_info_plus/package_info_plus.dart';

const String collectionUsers = 'users';

class UserService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection(collectionUsers);

  static DocumentReference get userRef =>
      collection.doc(FirebaseAuth.instance.currentUser?.uid);

  static Stream<AppUser?> currentAppUserStream() =>
      userRef.snapshots().map<AppUser?>((snap) => AppUser.fromJson(snap));

  static Stream<AppUser?> getUserStream(String? uid) {
    return collection
        .doc(uid)
        .snapshots()
        .map((snap) => AppUser.fromJson(snap));
  }

  Future<void> create(AppUser user) async {
    collection.doc(user.id).set(user.toJson()).onError((error, stackTrace) {
      throw Exception('An unknown exception occurred while adding user.');
    });
  }

  static Future<AppUser?> getCurrentUser() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return null;
    }
    return await collection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot doc) => AppUser.fromJson(doc));
  }

  static Future<void> updateUser(AppUser user) async {
    await collection.doc(user.id).update(user.toJson());
  }

  static Future<void> updateLastKnownActivity(String id) {
    return collection
        .doc(id)
        .update({AppUserConstants.lastKnownActivity: Timestamp.now()});
  }

  static Future<void> updateInstalledAppVersion(AppUser user) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var installedAppVersion = user.installedAppVersion;
    if (installedAppVersion == null ||
        installedAppVersion != packageInfo.version) {
      return collection
          .doc(user.id)
          .update({AppUserConstants.installedAppVersion: packageInfo.version});
    }
  }

  static Future<void> updateToken(String token) {
    // Assume user is logged in for this example
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return collection.doc(userId).update({
      AppUserConstants.tokens: FieldValue.arrayUnion([token]),
    });
  }

  static Future<void> removeToken(String token) {
    return userRef.update({
      AppUserConstants.tokens: FieldValue.arrayRemove([token]),
    });
  }

  static Future<void> updateAvatarImage(String avatarImage) {
    return userRef.update({
      AppUserConstants.avatarImage: avatarImage,
    });
  }
}
