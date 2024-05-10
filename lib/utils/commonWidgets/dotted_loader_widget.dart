import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DottedLoaderWidget extends StatelessWidget {
  const DottedLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double size = AppConfig.getDeviceType(context: context) == DeviceType.phone
        ? MediaQuery.of(context).size.width * 0.12
        : MediaQuery.of(context).size.width * 0.05;
    return SpinKitThreeInOut(
      color: AppColor.themeColor,
      size: size,
    );
  }
}
