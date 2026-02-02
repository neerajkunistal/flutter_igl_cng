import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/res/version_status.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const MethodChannel platform =
  MethodChannel('igl/cng');

  @override
  void initState() {
    BlocProvider.of<DashboardBloc>(context)
        .add(DashboardPageLoadEvent(context: context));
    callMethodeChannel();
    super.initState();
  }

  callMethodeChannel() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String applicationId = packageInfo.packageName.toString();
      print("applicationId--${applicationId}");
      String androidPlayStoreUrl =
          "https://play.google.com/store/apps/details?id=$applicationId&hl=en&gl=US";
      if (Platform.isAndroid) {
        final dynamic result = await platform.invokeMethod('getAppUpdate');
        if (kDebugMode) {
          print("Upadet Mesagae ============== $result");
        }
        if (result.toString() == "success") {
          AppUpdateMessage.showAlertDialog(
              context: context, url: androidPlayStoreUrl);
        }
      } else if (Platform.isIOS) {
        // iOS-specific code
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        VersionStatus versionStatus =
        VersionStatus(localVersion: packageInfo.version);
        final id = packageInfo.packageName;
        VersionStatus versionStatus0 =
        await getIosStoreVersion(id: id, versionStatus: versionStatus);
        if (versionStatus0.storeVersion != null &&
            versionStatus0.storeVersion != versionStatus0.localVersion) {
          AppUpdateMessage.showAlertDialog(
              context: context, url: versionStatus0.appStoreLink.toString());
        }
      }
    } on PlatformException catch (_) {}
  }

  getIosStoreVersion(
      {required String id, required VersionStatus versionStatus}) async {
    try {
      final url = "https://itunes.apple.com/lookup?bundleId=$id";
      var response = await get(Uri.parse(url));
      if (response.statusCode != 200) {
        return null;
      } else {
        final jsonObj = json.decode(response.body);
        versionStatus.storeVersion = jsonObj['results'][0]['version'];
        versionStatus.appStoreLink = jsonObj['results'][0]['trackViewUrl'];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return versionStatus;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is FetchDashboardDataState) {
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
