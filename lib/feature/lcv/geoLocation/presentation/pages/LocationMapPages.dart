import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/presentation/widgest/locationMapWidgets.dart';

class LocationMapPages extends StatefulWidget {
  const LocationMapPages({Key? key}) : super(key: key);

  @override
  _LocationMapPages createState() => _LocationMapPages();
}

class _LocationMapPages extends State<LocationMapPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: TextWidget(
          "Search Location",
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
      ),
      body: const LocationMapWidgets(),
    );
  }
}
