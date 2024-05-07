import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

Widget bottomRightCircle(BuildContext context){
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;
  return Stack(
    children: [
      Positioned(
        bottom: -29,
        right: -30,
        child: Card(
          elevation: 5,
          shadowColor: AppColor.themeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          child: Container(
            height: height * 0.19,
            width: width * 0.38,
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomRight, end: Alignment.topLeft, colors: <Color>[AppColor.themeColor,
                  AppColor.themeLightColor]),
                // color: Colors.pink,
                borderRadius: const BorderRadius.all(Radius.circular(80))),
          ),
        ),
      ),
      Positioned(
        bottom: -12,
        right: -12,
        child: Container(
          height: height * 0.16,
          width: width * 0.32,
          decoration: const BoxDecoration(
            //  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[Color(0xFF4348bf), Color(0xFF7fd4f5)]),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(80))),
        ),
      ),
      Positioned(
        bottom: -20,
        right: -20,
        child: Card(
          elevation: 5,
          shadowColor: AppColor.themeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          child: Container(
            height: height * 0.15,
            width: width * 0.30,
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomRight, end: Alignment.topLeft, colors: <Color>[AppColor.themeColor, AppColor.themeLightColor]),
                // color: Colors.pink,
                borderRadius: const BorderRadius.all(Radius.circular(80))),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        left: -50,
        child: Card(
          elevation: 5,
          shadowColor: AppColor.themeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          child: Container(
            height: height * 0.13,
            width: width * 0.27,
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomRight, end: Alignment.topLeft, colors: <Color>[AppColor.themeColor, AppColor.themeLightColor]),
                // color: Colors.pink,
                borderRadius: const BorderRadius.all(Radius.circular(80))),
          ),
        ),
      ),
    ],
  );
}