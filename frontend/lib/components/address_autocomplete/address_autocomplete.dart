import 'package:flutter/material.dart';
import 'package:frontend/components/address_autocomplete/address_search.dart';
import 'package:frontend/models/address_suggestion.dart';
import 'package:frontend/models/place.dart';
import 'package:frontend/providers/local_provider.dart';
import 'package:frontend/services/google_maps_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class AddressAutocomplete extends ConsumerWidget {
  final TextEditingController controller;
  final Function(AddressSuggestion? value) onAddressChanged;
  final Function(Place value)? onPlaceChanged;
  final AddressSuggestion? addressSuggestion;
  final String labelText;
  final String hintText;
  final String? searchHintTitle;
  final String? searchHintDescription;

  const AddressAutocomplete({
    super.key,
    required this.controller,
    required this.onAddressChanged,
    required this.labelText,
    required this.hintText,
    this.addressSuggestion,
    this.searchHintTitle,
    this.searchHintDescription,
    this.onPlaceChanged,
  });

  String? getInitialValue() {
    if (addressSuggestion != null) {
      return addressSuggestion!.mainText;
    }
    return controller.text.isEmpty ? null : controller.text;
  }

  @override
  Widget build(BuildContext context, ref) {
    final language = ref.watch(localeProvider);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      minLines: 1,
      maxLines: 2,
      readOnly: true,
      onTap: () async {
        final uuid = const Uuid().v4();
        var result = await showSearch(
          context: context,
          delegate: AddressSearch(
            sessionToken: uuid,
            languageCode: language.getLocale().toString(),
            searchHintTitle: searchHintTitle,
            searchHintDescription: searchHintDescription,
          ),
          query: getInitialValue(),
        );
        if (result != null) {
          controller.text = result.description;
          onAddressChanged(result);
          if (onPlaceChanged != null) {
            var place = await GoogleMapsService(sessionToken: uuid)
                .getPlaceDetailFromId(result.placeId, result.description);
            onPlaceChanged!(place);
          }
        }
      },
    );
  }
}
