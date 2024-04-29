
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/bloc/acknowledge_bloc.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/bloc/add_acknowledge_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/dashboard/domain/bloc/dashboard_bloc.dart';
import 'package:flutter_igl_cng/feature/home/domain/bloc/home_bloc.dart';
import 'package:flutter_igl_cng/feature/login/domain/bloc/login_bloc.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/bloc/mi_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/bloc/add_equipment_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/domain/bloc/view_equipment_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/bloc/review_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/splashScreen/page/splash_screen.dart';
import 'package:provider/provider.dart';
import 'ExportFile/app_export_file.dart';


class Root extends StatefulWidget {
  final Client client;
  const Root({super.key, required this.client});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

   MaterialColor primaryColor =  MaterialColor(
     AppColor.theme_Color,
     <int, Color>{
       50: AppColor.themeColor,
       100: AppColor.themeColor,
       200: AppColor.themeColor,
       300: AppColor.themeColor,
       400: AppColor.themeColor,
       500: AppColor.themeColor,
       600: AppColor.themeColor,
       700: AppColor.themeColor,
       800: AppColor.themeColor,
       900: AppColor.themeColor,
    },
  );

  MaterialColor primarySwatch =  MaterialColor(
    AppColor.theme_LightColor,
    <int, Color>{
      50: AppColor.themeLightColor,
      100: AppColor.themeLightColor,
      200: AppColor.themeLightColor,
      300: AppColor.themeLightColor,
      400: AppColor.themeLightColor,
      500: AppColor.themeLightColor,
      600: AppColor.themeLightColor,
      700: AppColor.themeLightColor,
      800: AppColor.themeLightColor,
      900: AppColor.themeLightColor,
    },
  );

  @override
  Widget build(BuildContext context) {
    Singleton.instanceInit()?.context =  context;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    AppConfig.instanceInit()!.setClient(client: widget.client);
    return MultiProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => LoginBloc()),
        BlocProvider(create: (BuildContext context) => DashboardBloc()),
        BlocProvider(create: (BuildContext context) => HomeBloc()),
        BlocProvider(create: (BuildContext context) => AddEquipmentComplaintBloc()),
        BlocProvider(create: (BuildContext context) => AcknowledgeBloc()),
        BlocProvider(create: (BuildContext context) => ReviewComplaintBloc()),
        BlocProvider(create: (BuildContext context) => MiComplaintBloc()),
        BlocProvider(create: (BuildContext context) => ViewEquipmentComplaintBloc()),
        BlocProvider(create: (BuildContext context) => AddAcknowledgeComplaintBloc()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'CNG',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
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
        ),
        home: const SplashScreen(),
      ),
    );
  }

}
