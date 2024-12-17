import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:vibration/vibration.dart';

Future<DateTime?> showCupertinoDatePicker({
  required BuildContext context,
  required DateTime initialDateTime,
}) async {
  DateTime selectDateTime = initialDateTime;
  return await showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 230,
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
                    onPressed: () {
                  Navigator.of(context).pop();
                }, child: TextWidget("Cancel", color: Colors.red[900],)),

                TextButton( onPressed: () {
                  Navigator.of(context).pop(selectDateTime);
                }, child: TextWidget("Done",
                  fontWeight: FontWeight.w700,
                  color: AppColor.themeColor,)),
              ],
            ),
            Flexible(
              child: CupertinoDatePicker(
                initialDateTime: initialDateTime,
                onDateTimeChanged: (DateTime newDateTime) async {
                  selectDateTime =  newDateTime;
                  if (await Vibration.hasAmplitudeControl() != null) {
                  Vibration.vibrate(duration: 2);
                  }
                },
                mode: CupertinoDatePickerMode.time,
                showDayOfWeek: true,
                use24hFormat: true,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

