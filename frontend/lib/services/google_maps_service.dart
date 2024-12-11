import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:frontend/constants/google_place.dart';
import 'package:frontend/models/address_suggestion.dart';
import 'package:frontend/models/place.dart';
import 'package:http/http.dart' as http;

class GoogleMapsService {
  final String sessionToken;
  static const String apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  GoogleMapsService({
    required this.sessionToken,
  });

  Future<List<AddressSuggestion>> fetchAddressSuggestions(
      String input, String lang) async {
    // limit search to Switzerland only -- &components=country:ch
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:ch&key=$apiKey&sessiontoken=$sessionToken';
    final response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body) as Map<String, dynamic>;
      if (result[GooglePlaceConstants.status] == GooglePlaceConstants.ok) {
        return (result[GooglePlaceConstants.predictions] as List)
            .map<AddressSuggestion>((p) => AddressSuggestion.fromJson(p))
            .toList();
      } else if (result[GooglePlaceConstants.status] ==
          GooglePlaceConstants.zeroResults) {
        return [];
      } else {
        throw Exception(result[GooglePlaceConstants.errorMessage]);
      }
    } else {
      throw Exception(
          'Error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId, String fullAddress) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$apiKey&sessiontoken=$sessionToken';
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint('getPlaceDetailFromId: $result');
      if (result[GooglePlaceConstants.status] == GooglePlaceConstants.ok) {
        return Place.fromJson(
          result[GooglePlaceConstants.result],
          placeId,
          fullAddress,
        );
      }
      throw Exception(result[GooglePlaceConstants.errorMessage]);
    } else {
      throw Exception(
          'Error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}
