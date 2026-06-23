import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:vibration/vibration.dart';

Future<DateTime?> showCupertinoDatePicker({
  required BuildContext context,
  required DateTime initialDateTime,
  CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime,
}) async {
  DateTime selectedDateTime = initialDateTime;

  return await showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 260,
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: TextWidget(
                    "Cancel",
                    color: Colors.red[900],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(selectedDateTime);
                  },
                  child: TextWidget(
                    "Done",
                    fontWeight: FontWeight.w700,
                    color: EnvironmentConfig.of(context)!.primaryTheme,
                  ),
                ),
              ],
            ),

            Flexible(
              child: CupertinoDatePicker(
                mode: mode,
                initialDateTime: initialDateTime,
                use24hFormat: true,
                minuteInterval: 1,
                showDayOfWeek: mode == CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime newDateTime) async {
                  selectedDateTime = newDateTime;

                  if (await Vibration.hasVibrator() ?? false) {
                    Vibration.vibrate(duration: 10);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
