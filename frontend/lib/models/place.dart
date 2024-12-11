import 'package:frontend/constants/google_place.dart';

class Place {
  String placeId;
  String fullAddress;
  String longitude;
  String latitude;

  Place({
    required this.placeId,
    required this.fullAddress,
    required this.longitude,
    required this.latitude,
  });

  factory Place.fromJson(
    Map<String, dynamic> json,
    String placeId,
    String fullAddress,
  ) {
    return Place(
      placeId: placeId,
      fullAddress: fullAddress,
      longitude: json[GooglePlaceConstants.geometry]
              [GooglePlaceConstants.location][GooglePlaceConstants.lng]
          .toString(),
      latitude: json[GooglePlaceConstants.geometry]
              [GooglePlaceConstants.location][GooglePlaceConstants.lat]
          .toString(),
    );
  }

  factory Place.fromSnapshot(Map<String, dynamic> snapshot) {
    return Place(
      placeId: snapshot[PlaceConstants.placeId],
      fullAddress: snapshot[PlaceConstants.fullAddress],
      longitude: snapshot[PlaceConstants.longitude],
      latitude: snapshot[PlaceConstants.latitude],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      PlaceConstants.placeId: placeId,
      PlaceConstants.fullAddress: fullAddress,
      PlaceConstants.longitude: longitude,
      PlaceConstants.latitude: latitude,
    };
  }
}

class PlaceConstants {
  static const String placeId = 'placeId';
  static const String fullAddress = 'fullAddress';
  static const String longitude = 'longitude';
  static const String latitude = 'latitude';
}
