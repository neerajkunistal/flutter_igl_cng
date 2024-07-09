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
          !context.mounted ? context : context,
          MaterialPageRoute(builder: (_) => const LoginScreenPage()),
          (route) => false);
    } else {
      String password =
          await SharedPreferencesUtils.getString(key: PreferencesName.password);
      BlocProvider.of<LoginBloc>(!context.mounted ? context : context)
          .add(LoginSetPasswordEvent(password: password));
      BlocProvider.of<LoginBloc>(!context.mounted ? context : context)
          .add(LoginSetEmailEvent(emailId: userName));
      BlocProvider.of<LoginBloc>(!context.mounted ? context : context).add(
          LoginSubmitDataEvent(
              context: !context.mounted ? context : context,
              isLoginPage: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: appBackGround(
        isGradientChange: true,
        context: context,
        child: Stack(
          children: [
            Positioned(
              top: 20.0,
              left: MediaQuery.of(context).size.width * 0.18,
              right: 0.0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height/2.5,
                child: Image.asset(
                  AppIcon.pumpIcon,
                  opacity: const AlwaysStoppedAnimation(.9),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppConfig.instanceInit()!.client == Client.iglcng
                        ? AppIcon.appLogoIgl
                        : AppIcon.appLogoIgl,
                    height: MediaQuery.of(context).size.width * 0.40,
                    width: MediaQuery.of(context).size.width * 0.40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextWidget("CNG is a fossil fuel substitute for other auto fuels such as petrol, diesel, Auto LPG etc. For use in Automobiles as fuel, Natural Gas is compressed & dispensed to vehicles at high pressure of 200-250 Kg/cm² enhance the vehicle on board storage capacity.", color: AppColor.white,
                      textAlign: TextAlign.center,
                      fontSize: AppFont.font_13,),
                  ),
                ],
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
      ),
    );
  }
}
