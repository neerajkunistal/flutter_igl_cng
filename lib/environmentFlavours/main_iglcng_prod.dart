import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/root.dart';
import 'package:flutter_igl_cng/utils/res/environment_config.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await NotificationService().initializePlatformNotifications();
/*  await HiveDataBase().init();*/
  AppColor(themeColor: 0xFF1269AC,
      themeLightColor: 0xFF278AD7);
  var configuredApp = const EnvironmentConfig(
      flavours: EnvironmentFlavours.productionIglCng,
      child: Root(client: Client.iglcng,)
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom
  ]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(configuredApp);
}
