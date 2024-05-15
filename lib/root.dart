import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/services/firebase/notification_service.dart';
import 'package:flutter_igl_cng/testing_page.dart';

import 'ExportFile/app_export_file.dart';

class Root extends StatefulWidget {
  final Client client;

  const Root({super.key, required this.client});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Singleton.instanceInit()?.context = context;
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    AppConfig.instanceInit()!.setClient(client: widget.client);
    return blocMultiProvider(
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'CNG',
          debugShowCheckedModeBanner: false,
          theme: appTheme(),
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/second': (context) => const TestPage(),
          },
     /*     home: const SplashScreen(),*/
        ));
  }
}
