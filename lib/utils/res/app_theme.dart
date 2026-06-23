import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

ThemeData appTheme({required BuildContext context}) {
  final primaryColor = EnvironmentConfig.of(context)!.primaryTheme;

  return ThemeData(
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      onPrimary: AppColor.white,
      onSurface: Colors.black,
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
            (states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.white;
        },
      ),
      checkColor: WidgetStateProperty.all<Color>(AppColor.white),
      side: const BorderSide(color: Color(0xff585858)),
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(AppColor.black),
      ),
    ),

    primaryColor: primaryColor,

    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: AppColor.white),
      backgroundColor: primaryColor,
    ),

    datePickerTheme: DatePickerThemeData(
      headerBackgroundColor: primaryColor,
      headerForegroundColor: Colors.white,
      backgroundColor: Colors.white,

      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(primaryColor),
      ),

      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(AppColor.grey),
      ),

      surfaceTintColor: Colors.white,

      dayStyle: TextStyle(color: primaryColor),

      weekdayStyle: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w700,
      ),
    ),

    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,

    cardTheme: const CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.white,
    ),

    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),

    bottomAppBarTheme: const BottomAppBarThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.white,
    ),

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),

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
              colors:  [
                EnvironmentConfig.of(context)!.primaryTheme.withValues(alpha: 0.8),
                EnvironmentConfig.of(context)!.secondaryTheme.withValues(alpha: 0.8),
                EnvironmentConfig.of(context)!.primaryTheme,
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
