import 'package:flutter/material.dart';
import 'package:frontend/models/address_suggestion.dart';
import 'package:frontend/services/google_maps_service.dart';

class AddressSearch extends SearchDelegate<AddressSuggestion?> {
  final String sessionToken;
  final String languageCode;
  final String? searchHintTitle;
  final String? searchHintDescription;
  GoogleMapsService service;

  AddressSearch({
    required this.sessionToken,
    required this.languageCode,
    this.searchHintTitle,
    this.searchHintDescription,
  }) : service = GoogleMapsService(sessionToken: sessionToken);

  // You can override the ThemeData for the search bar
  // @override
  // ThemeData appBarTheme(BuildContext context) {
  //   final theme = Theme.of(context);
  //   return ThemeData(
  //     colorScheme: theme.colorScheme,
  //     appBarTheme: AppBarTheme(
  //       backgroundColor: theme.colorScheme.primary,
  //       iconTheme: IconThemeData(
  //         color: theme.colorScheme.onPrimary,
  //       ),
  //     ),
  //     inputDecorationTheme: InputDecorationTheme(
  //       border: InputBorder.none,
  //       // Use this change the placeholder's text style
  //       hintStyle: theme.textTheme.bodyLarge?.copyWith(
  //         color: theme.colorScheme.onPrimary,
  //       ),
  //     ),
  //     textTheme: TextTheme(
  //       titleLarge: TextStyle(fontSize: 25, color: theme.colorScheme.onPrimary),
  //     ),
  //   );
  // }

  @override
  PreferredSizeWidget? buildBottom(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchResult(context, true);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildSearchResult(context, false);
  }

  Widget buildSearchResult(BuildContext context, bool isResult) {
    final theme = Theme.of(context);

    if (query.isNotEmpty && query.length > 3) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: FutureBuilder(
          future: service.fetchAddressSuggestions(query, languageCode),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.hasData) {
              final suggestions = snapshot.data as List<AddressSuggestion>;
              return ListView.separated(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      suggestions[index].description,
                      style: theme.textTheme.bodyMedium,
                    ),
                    onTap: () {
                      query = suggestions[index].mainText ??
                          suggestions[index].description;
                      close(context, suggestions[index]);
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 5,
                    child: Divider(
                      color: Theme.of(context).colorScheme.brightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      height: 2,
                      indent: 16,
                      endIndent: 16,
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              searchHintTitle ?? '',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              searchHintDescription ?? '',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }
}
