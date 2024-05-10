import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/login/domain/bloc/login_event.dart';
import 'package:flutter_igl_cng/feature/login/presentations/pages/login_screen_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    pageOpen();
    super.initState();
  }

  pageOpen() async {
    await AppConfig.instanceInit()!.getPackageInfo();
    String userName =
        await SharedPreferencesUtils.getString(key: PreferencesName.userName);
    if (userName.isEmpty) {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreenPage()),
          (route) => false);
    } else {
      String password =
          await SharedPreferencesUtils.getString(key: PreferencesName.password);
      BlocProvider.of<LoginBloc>(context)
          .add(LoginSetPasswordEvent(password: password));
      BlocProvider.of<LoginBloc>(context)
          .add(LoginSetEmailEvent(emailId: userName));
      BlocProvider.of<LoginBloc>(context)
          .add(LoginSubmitDataEvent(context: context, isLoginPage: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              AppConfig.instanceInit()!.client == Client.iglcng
                  ? AppIcon.appLogoIgl
                  : AppIcon.appLogoIgl,
              height: MediaQuery.of(context).size.width * 0.30,
              width: MediaQuery.of(context).size.width * 0.30,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.10,
            left: 0.0,
            right: 0.0,
            child: const CenterLoaderWidget(),
          )
        ],
      ),
    );
  }
}
