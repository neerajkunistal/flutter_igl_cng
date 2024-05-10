import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      navigatorKey: locator<NavigationService>().navigatorKey,
      title: 'CNG',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: const SplashScreen(),
    ));
  }
}
