import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

ThemeData appTheme() {
    return ThemeData(
      colorScheme:  ColorScheme.light(
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
        checkColor: MaterialStateProperty.all<Color>(AppColor.white),
        side: const BorderSide(color: Color(0xff585858)),
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(AppColor.black))),
      primaryColor: AppColor.themeColor,
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
              color: AppColor.white
          ),
          color: AppColor.themeColor
      ),
      datePickerTheme: DatePickerThemeData(
        headerBackgroundColor: AppColor.themeColor,
        headerForegroundColor: Colors.white,
        backgroundColor: Colors.white,
        confirmButtonStyle: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(AppColor.themeColor)),
        cancelButtonStyle: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(AppColor.grey)),
        surfaceTintColor: Colors.white,
        dayStyle:  TextStyle(color: AppColor.themeColor),
        weekdayStyle:  TextStyle(color: AppColor.themeColor, fontWeight: FontWeight.w700),
      ),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      cardTheme: const CardTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white
      ),
      dialogBackgroundColor: AppColor.white,
      dialogTheme:  DialogTheme(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
      ),
      bottomAppBarTheme : const BottomAppBarTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white
      ),
      navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white
      ),
      primarySwatch: Colors.lightBlue,
      fontFamily: AppFont.rubik,
    );
}