import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(HomePageLoadEvent(context: context));
    callMethodeChannel();
    super.initState();
  }

  static const MethodChannel platform = MethodChannel('igl/cng');

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppConfig.getDeviceType(context: context) == DeviceType.phone
                ? const Expanded(child: PhoneHomeWidget())
                : const Expanded(child: TabletHomeWidget()),
          ],
        ));
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
                message: "Do you want to exit an App?",
                okButtonText: "Exit",
                onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }
}
