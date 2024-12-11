import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../utils/date_utils.dart';

class DatePickerFormField extends StatelessWidget {
  const DatePickerFormField({
    super.key,
    required this.controller,
    required this.label,
    this.marginBottom,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final double? marginBottom;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
      ),
      validator: validator,
      onTap: () async {
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          await iosDatePicker(context);
        } else {
          await androidDatePicker(context);
        }
      },
    );
  }

  Future<void> androidDatePicker(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty
          ? DateFormat(dateFormat).parse(controller.text)
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      controller.text = DateFormat(dateFormat).format(selectedDate);
    }
  }

  Future<void> iosDatePicker(BuildContext context) async {
    DateTime? pickedDate;
    final translations = AppLocalizations.of(context)!;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text(translations.cancelLabel),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: Text(translations.doneLabel),
                    onPressed: () {
                      if (pickedDate != null) {
                        controller.text =
                            DateFormat(dateFormat).format(pickedDate!);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: controller.text.isNotEmpty
                      ? DateFormat(dateFormat).parse(controller.text)
                      : DateTime.now(),
                  minimumYear: 1900,
                  maximumYear: DateTime.now().year,
                  onDateTimeChanged: (DateTime newDate) {
                    pickedDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
