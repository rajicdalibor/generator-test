import 'package:frontend/constants/google_place.dart';

class AddressSuggestion {
  final String placeId;
  final String description;
  final String? mainText;

  AddressSuggestion({
    required this.placeId,
    required this.description,
    this.mainText,
  });

  factory AddressSuggestion.fromJson(Map<String, dynamic> json) {
    return AddressSuggestion(
      placeId: json[GooglePlaceConstants.placeId],
      description: json[GooglePlaceConstants.description],
      mainText: json[GooglePlaceConstants.structuredFormatting]
          [GooglePlaceConstants.mainText],
    );
  }

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}
