import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

Widget topRightCircle(BuildContext context){
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;
  return Stack(
    children: [
      Positioned(
        top: -12,
        left: -13,
        child: Card(
          elevation: 5,
          shadowColor: AppColor.themeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          child: Container(
            height: height * 0.18,
            width: width * 0.36,
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[AppColor.themeColor, AppColor.themeLightColor]),
                // color: Colors.pink,
                borderRadius: const BorderRadius.all(Radius.circular(80))),
          ),
        ),
      ),
      Positioned(
        top: -7,
        left: -5,
        child: Container(
          height: height * 0.17,
          width: width * 0.33,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(80))),
        ),
      ),
      Positioned(
        top: -18,
        left: -15,
        child: Card(
          elevation: 5,
          shadowColor: AppColor.themeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          child: Container(
            height: height * 0.16,
            width: width * 0.32,
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[AppColor.themeColor, AppColor.themeLightColor]),
                // color: Colors.pink,
                borderRadius: const BorderRadius.all(Radius.circular(80))),
          ),
        ),
      ),
    ],
  );
}