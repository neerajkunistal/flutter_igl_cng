import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/root.dart';
import 'package:flutter_igl_cng/services/firebase/notification_service.dart';
import 'package:flutter_igl_cng/utils/res/environment_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.instance.initializeService();
/*  AppColor(themeColor: 0xFF165dA7, themeLightColor: 0xFF3688DD);*/
  var configuredApp = const EnvironmentConfig(
      flavours: EnvironmentFlavours.developmentIglCng,
      child: Root(
        client: Client.iglcng,
      ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(configuredApp);
}
