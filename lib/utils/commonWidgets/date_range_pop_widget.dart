import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePopWidget extends StatelessWidget {
  final Function(Object?) onSubmit;
  const DateRangePopWidget({super.key,
    required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Center(
          child: TextWidget(
            "Date Picker",
            fontSize: AppFont.font_16,
            color: AppColor.themeColor,)),
      content: SizedBox(
        height: MediaQuery.of(context).size.height/2,
        width: MediaQuery.of(context).size.width,
        child: SfDateRangePicker(
          onSubmit: onSubmit,
          onCancel: () {
            Navigator.pop(context);
          },
          showActionButtons: true,
          backgroundColor: AppColor.white,
          headerStyle: DateRangePickerHeaderStyle(
              backgroundColor: AppColor.themeNormalLightColor),
          selectionMode: DateRangePickerSelectionMode.range,
          initialSelectedRange: PickerDateRange(
              DateTime.now().subtract(const Duration(days: 4)),
              DateTime.now()),
        ),
      ),
    );
  }
}
