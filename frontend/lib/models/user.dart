import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/place.dart';
import 'package:intl/intl.dart';

import '../utils/date_utils.dart';

class AppUser {
  final String? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? avatarImage;
  final bool disabled;
  final bool onboarded;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final Timestamp? lastKnownActivity;
  final String? installedAppVersion;
  final Place? googleAddress;

  // do not save this field in Firestore
  final String? avatarImageUrl;

  AppUser({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.avatarImage,
    this.disabled = false,
    this.onboarded = false,
    this.lastKnownActivity,
    this.installedAppVersion,
    this.googleAddress,
    this.avatarImageUrl,
  })  : createdAt = Timestamp.now(),
        updatedAt = Timestamp.now();

  Map<String, dynamic> toJson() {
    return {
      AppUserConstants.id: id,
      if (email != null) AppUserConstants.email: email,
      if (firstName != null) AppUserConstants.firstName: firstName!.trim(),
      if (lastName != null) AppUserConstants.lastName: lastName!.trim(),
      if (birthDate != null)
        AppUserConstants.birthDate: formatDateToIso(birthDate!, dateFormat),
      if (avatarImage != null) AppUserConstants.avatarImage: avatarImage,
      AppUserConstants.onboarded: onboarded,
      AppUserConstants.createdAt: createdAt,
      AppUserConstants.updatedAt: updatedAt,
      if (lastKnownActivity != null)
        AppUserConstants.lastKnownActivity: lastKnownActivity!,
      AppUserConstants.installedAppVersion: installedAppVersion,
      if (googleAddress != null)
        AppUserConstants.googleAddress: googleAddress!.toJson(),
    };
  }

  AppUser copyWith({
    String? firstName,
    String? lastName,
    String? birthDate,
    String? address,
    bool? onboarded,
    String? avatarImage,
    String? phoneNumber,
    int? successfulLoops,
    Timestamp? lastKnownActivity,
    String? installedAppVersion,
    Place? googleAddress,
    String? avatarImageUrl,
  }) {
    return AppUser(
      id: id,
      email: email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      onboarded: onboarded ?? this.onboarded,
      avatarImage: avatarImage ?? this.avatarImage,
      lastKnownActivity: lastKnownActivity,
      installedAppVersion: this.installedAppVersion,
      googleAddress: googleAddress ?? this.googleAddress,
      avatarImageUrl: avatarImageUrl ?? this.avatarImageUrl,
    );
  }

  static Map<String, dynamic> getDeletedUserFields() {
    return {
      AppUserConstants.firstName: AppUserConstants.deletedUserFirstName,
      AppUserConstants.lastName: AppUserConstants.deletedUserFirstName,
      AppUserConstants.birthDate: '',
      AppUserConstants.email: '',
      AppUserConstants.avatarImage: '',
      AppUserConstants.onboarded: false,
      AppUserConstants.disabled: true,
      AppUserConstants.createdAt: Timestamp.now(),
      AppUserConstants.updatedAt: Timestamp.now(),
      AppUserConstants.googleAddress: '',
    };
  }

  static AppUser? fromJson(DocumentSnapshot snapshot) {
    try {
      if (snapshot.data() == null) {
        return null;
      }
      final data = snapshot.data() as Map<String, dynamic>;

      String? birthDate;
      if (data[AppUserConstants.birthDate] != null) {
        DateTime parsedBirthDate =
            DateTime.parse(data[AppUserConstants.birthDate]);
        birthDate = DateFormat(dateFormat).format(parsedBirthDate);
      }

      return AppUser(
        id: data[AppUserConstants.id],
        email: data[AppUserConstants.email],
        firstName: data[AppUserConstants.firstName],
        lastName: data[AppUserConstants.lastName],
        birthDate: birthDate,
        onboarded: data[AppUserConstants.onboarded] ?? false,
        avatarImage: data[AppUserConstants.avatarImage],
        lastKnownActivity: data[AppUserConstants.lastKnownActivity],
        installedAppVersion: data[AppUserConstants.installedAppVersion],
        googleAddress: data[AppUserConstants.googleAddress] != null
            ? Place.fromSnapshot(data[AppUserConstants.googleAddress])
            : null,
      );
    } catch (e) {
      debugPrint("Error mapping AppUser from snapshot: $e");
      return null;
    }
  }

  String displayName() {
    return '${firstName ?? ''} ${lastName ?? ''}';
  }
}

class AppUserConstants {
  static const String id = 'id';
  static const String kids = 'kids';
  static const String email = 'email';
  static const String name = 'name';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String birthDate = 'birthDate';
  static const String address = 'address';
  static const String phoneNumber = 'phoneNumber';
  static const String avatarImage = 'avatarImage';
  static const String onboarded = 'onboarded';
  static const String updatedAt = 'updatedAt';
  static const String deletedUserFirstName = 'unknown-user';
  static const String createdAt = 'createdAt';
  static const String tokens = 'tokens';
  static const String disabled = 'disabled';
  static const String lastKnownActivity = 'lastKnownActivity';
  static const String installedAppVersion = 'installedAppVersion';
  static const String googleAddress = 'googleAddress';
}
