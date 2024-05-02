import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/home/domain/bloc/home_bloc.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/phone_home_widget.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/tablet_home_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/message_box_two_button_pop.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(
        HomePageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final backNavigationAllowed = await _onWillPop();
        if (backNavigationAllowed) {
          SystemNavigator.pop();
        } else {
          // User is still on the same page, do whatever you want
        }
      },
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppConfig.getDeviceType(context: context) == DeviceType.phone
              ? const Expanded(child: PhoneHomeWidget())
              : const Expanded( child: TabletHomeWidget()),
          Container(
            color: AppColor.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Image.asset(AppIcon.appLogoUnistal,
                   height: MediaQuery.of(context).size.width * 0.05,
                   ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  TextWidget("Unistal Systems Pvt Ltd. Version - ${AppConfig.instanceInit()!.appVersion}",
                    fontSize: AppFont.font_12,
                    fontWeight: FontWeight.w700,),
                ],
              ),
            ),
          ),
      ],
    ));
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
            message: "Do you want to exit an App?",
            okButtonText: "Exit",
            onPressed: () =>  Navigator.of(context).pop(true)
       ))
    ) ?? false;
  }
}
