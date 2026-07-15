import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

ThemeData appTheme() {
  return ThemeData(
    colorScheme: ColorScheme.light(
      primary: AppColor.themeColor,
      onPrimary: AppColor.white,
      onSurface: Colors.black,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return AppColor.themeColor; // the color when checkbox is selected;
          }
          return Colors.white; //the color when checkbox is unselected;
        },
      ),
      checkColor: WidgetStateProperty.all<Color>(AppColor.white),
      side: const BorderSide(color: Color(0xff585858)),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(AppColor.black))),
    primaryColor: AppColor.themeColor,
    appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: AppColor.white),
        color: AppColor.themeColor),
    datePickerTheme: DatePickerThemeData(
      headerBackgroundColor: AppColor.themeColor,
      headerForegroundColor: Colors.white,
      backgroundColor: Colors.white,
      confirmButtonStyle: ButtonStyle(
          foregroundColor:
              WidgetStateProperty.all<Color>(AppColor.themeColor)),
      cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(AppColor.grey)),
      surfaceTintColor: Colors.white,
      dayStyle: TextStyle(color: AppColor.themeColor),
      weekdayStyle:
          TextStyle(color: AppColor.themeColor, fontWeight: FontWeight.w700),
    ),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    cardTheme:
        const CardThemeData(color: Colors.white, surfaceTintColor: Colors.white),
    dialogBackgroundColor: AppColor.white,
    dialogTheme: DialogThemeData(
      backgroundColor: AppColor.white,
      surfaceTintColor: AppColor.white,
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(
        color: Colors.white, surfaceTintColor: Colors.white),
    navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white),
    primarySwatch: Colors.lightBlue,
    fontFamily: AppFont.rubik,
  );
}

Widget appBackGround(
    {required Widget child,
    required BuildContext context,
    bool? isGradientChange,
    bool? isRemoveBackground}) {
  return Container(
    decoration: BoxDecoration(
      gradient: isRemoveBackground == true
          ? null
          : LinearGradient(
              begin: isGradientChange == null
                  ? Alignment.topLeft
                  : Alignment.topRight,
              end: isGradientChange == null
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              colors: const [
                Color.fromRGBO(239, 190, 17, 1.0),
                Color.fromARGB(230, 131, 168, 30),
                Color.fromARGB(230, 87, 163, 37),
              ],
            ),
    ),
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Stack(
      children: [
        isRemoveBackground == true
            ? const SizedBox.shrink()
            : Positioned(
                top: 20.0,
                left: MediaQuery.of(context).size.width * 0.18,
                right: 0.0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: Image.asset(
                    AppIcon.pumpIcon,
                    opacity: const AlwaysStoppedAnimation(.9),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
        isRemoveBackground == true
            ? const SizedBox.shrink()
            : Image.asset(
                AppIcon.transperentBackground,
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
              ),
        child,
      ],
    ),
  );
}
