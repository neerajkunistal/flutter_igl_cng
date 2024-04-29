import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/dashboard/domain/bloc/dashboard_bloc.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/widget/card_backgound.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/widget/phone_dashboard_widget.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/widget/profile_widget.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/widget/report_widget.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/widget/service_center_network_widget.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/widget/tablet_dashboard_widget.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/widget/wave_backgorund.dart';
import 'package:flutter_igl_cng/utils/commonClass/app_config.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/app_update_message_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  var platform = const MethodChannel('iglCng.flutter.dev/native');

  @override
  void initState() {
    BlocProvider.of<DashboardBloc>(context).add(
         DashboardPageLoadEvent(context: context));
    super.initState();
  }

  callMethodeChannel() async {
    try {
      if (Platform.isAndroid) {
        final dynamic result = await platform.invokeMethod('getAppUpdate');
        if(result.toString() == "success"){
          if(context.mounted){
            AppUpdateMessage.showAlertDialog(context: context);
          }
        }
      } else if (Platform.isIOS) {
        // iOS-specific code
      }
    } on PlatformException catch (e) {
      if(kDebugMode){
        print("Update Errorl  ------------${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if(state is FetchDashboardDataState){
          return AppConfig.getDeviceType(context: context) == DeviceType.phone
          ? const PhoneDashboardWidget()
          : const TabletDashboardWidget();
        } else {
          return const Center(child: CenterLoaderWidget());
        }
      },
    );
  }
}
