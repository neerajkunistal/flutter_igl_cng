import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/home/domain/bloc/home_bloc.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/home_drawer_widget.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/phone_home_widget.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/tablet_home_widget.dart';
import 'package:flutter_igl_cng/utils/commonClass/app_config.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/message_box_two_button_pop.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
      child: AppConfig.getDeviceType(context: context) == DeviceType.phone
      ? const PhoneHomeWidget()
      : const TabletHomeWidget(),
    );
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
