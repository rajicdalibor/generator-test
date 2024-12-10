import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/upgrade_version.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateAppService {
  static const String upgradeAppCollection = 'appUpgrades';
  static const String upgradeAppDocument = 'upgrade';
  static const String upgradeAppField = 'version';
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> collectionCampaignsRef =
      FirebaseFirestore.instance.collection(upgradeAppCollection);

  static Future<UpgradeVersion> getLatestVersion() async {
    try {
      var versionDocument =
          await collectionCampaignsRef.doc(upgradeAppDocument).get();

      if (versionDocument.exists) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        final latestVersion =
            versionDocument.data()![upgradeAppField] as String;
        return UpgradeVersion(
          isUpgradeRequired:
              isUpgradeRequired(packageInfo.version, latestVersion),
          latestVersion: latestVersion,
        );
      } else {
        return UpgradeVersion(isUpgradeRequired: false, latestVersion: '');
      }
    } catch (e) {
      debugPrint('Error getting latest version: $e');
      return UpgradeVersion(isUpgradeRequired: false, latestVersion: '');
    }
  }

  static bool isUpgradeRequired(String version, String latestVersion) {
    List versionCells = version.split('.');
    List latestVersionCells = latestVersion.split('.');
    for (int i = 0; i < 3; i++) {
      if (int.parse(versionCells[i]) > int.parse(latestVersionCells[i])) {
        return false;
      } else if (int.parse(versionCells[i]) ==
          int.parse(latestVersionCells[i])) {
        continue;
      }
      return true;
    }
    return false;
  }
}
