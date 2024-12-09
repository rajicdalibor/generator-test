import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/upload_file.dart';
import 'package:mime_type/mime_type.dart';

class StorageService {
  static FirebaseStorage storage = FirebaseStorage.instance;

  static Future<String?> uploadProfilePicture(
      String userId, UploadFile file) async {
    final path = "users/$userId/avatar/${file.fileName}";
    return uploadData(path, file.bytes);
  }

  static Future<String?> uploadData(String path, Uint8List data) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(path);
      final metadata = SettableMetadata(
        contentType: mime(path),
        customMetadata: {
          'uploaded_at': DateTime.now().toString(),
        },
      );
      TaskSnapshot result = await storageRef.putData(data, metadata);
      return result.state == TaskState.success ? result.ref.fullPath : null;
    } catch (err) {
      debugPrint("ERROR uploading file to storage: $err");
      return null;
    }
  }

  static Future<String?> getFileDownloadUrl(String filePath) async {
    try {
      final ref = storage.ref().child(filePath);
      return await ref.getDownloadURL();
    } catch (err) {
      debugPrint("ERROR getting download URL: $err");
      return null;
    }
  }

  static Future<void> deleteFile(String filePath) async {
    final ref = storage.ref().child(filePath);
    ref.delete();
  }
}
