import 'package:flutter/material.dart';

class DisplayData extends StatelessWidget {
  final String label;
  final String value;

  const DisplayData({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(":"),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        )
      ],
    );
  }
}
