import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Information about the app's current version, and the most recent version
/// available in the Apple App Store or Google Play Store.
class VersionStatus {
  /// True if the there is a more recent version of the app in the store.
  bool? canUpdate;

  /// The current version of the app.
  String localVersion;

  /// The most recent version of the app in the store.
  String? storeVersion;

  /// A link to the app store page where the app can be updated.
  String? appStoreLink;

  bool? isUpdateMandatory;

  VersionStatus(
      {this.canUpdate, required this.localVersion, this.storeVersion});
}

class NewVersion {
  /// This is required to check the user's platform and display alert dialogs.
  BuildContext context;

  /// An optional value that can override the default packageName when
  /// attempting to reach the Google Play Store. This is useful if your app has
  /// a different package name in the Play Store for some reason.
  String? androidId;

  /// An optional value that can override the default packageName when
  /// attempting to reach the Apple App Store. This is useful if your app has
  /// a different package name in the App Store for some reason.
  String? iOSId;

  NewVersion({this.androidId, this.iOSId, required this.context});

  /// This checks the version status, then displays a platform-specific alert
  /// with buttons to dismiss the update alert, or go to the app store.
  showAlertIfNecessary() async {
    VersionStatus versionStatus = await getVersionStatus();
    if (versionStatus.canUpdate!) {
      showUpdateDialog(versionStatus);
    }
  }

  /// This checks the version status and returns the information. This is useful
  /// if you want to display a custom alert, or use the information in a different
  /// way.
  Future<VersionStatus> getVersionStatus() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    VersionStatus versionStatus = VersionStatus(
      localVersion: packageInfo.version,
    );
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        final id = androidId ?? packageInfo.packageName;
        versionStatus = await _getAndroidStoreVersion(id, versionStatus);
        break;
      case TargetPlatform.iOS:
        final id = iOSId ?? packageInfo.packageName;
        versionStatus = await _getiOSStoreVersion(id, versionStatus);
        break;
      default:
        // debugPrint(AppString.thisTargetPlatformIsNotYetSupportedByThisPackage);
    }

    try {
      var storeAppVersion = versionStatus.storeVersion;
      var localAppVersion = versionStatus.localVersion;
      if (double.parse(localAppVersion.substring(2)) >
          double.parse(storeAppVersion!.substring(2))) {
        versionStatus.canUpdate = false;
      } else {
        versionStatus.canUpdate =
            versionStatus.storeVersion != versionStatus.localVersion;
      }
    } catch (_) {
      versionStatus.canUpdate =
          versionStatus.storeVersion != versionStatus.localVersion;
    }
    return versionStatus;
  }

  /// iOS info is fetched by using the iTunes lookup API, which returns a
  /// JSON document.
  _getiOSStoreVersion(String id, VersionStatus versionStatus) async {
    final url = Uri.parse('https://itunes.apple.com/lookup?bundleId=$id');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      debugPrint('Can\'t find an app in the App Store with the id: $id');
      return null;
    }
    final jsonObj = json.decode(response.body);
    versionStatus.storeVersion = jsonObj['results'][0]['version'];
    versionStatus.appStoreLink = jsonObj['results'][0]['trackViewUrl'];

    try {
      DateTime releaseDate = DateFormat('yyyy-MM-ddTHH:mm:ss')
          .parse(jsonObj['results'][0]['currentVersionReleaseDate']);
      if (DateTime.now().difference(releaseDate).inDays > 7) {
        versionStatus.isUpdateMandatory = true;
      } else {
        versionStatus.isUpdateMandatory = false;
      }
    } catch (_) {
      versionStatus.isUpdateMandatory = false;
    }
    return versionStatus;
  }

  /// Android info is fetched by parsing the html of the app store page.
  _getAndroidStoreVersion(String id, VersionStatus versionStatus) async {
    final url = Uri.parse('https://play.google.com/store/apps/details?id=$id');
    print(url);
    final response = await http.get(url);
    if (response.statusCode != 200) {
      debugPrint('Can\'t find an app in the Play Store with the id: $id');
      return null;
    }
    final document = parse(response.body);
    final elements = document.getElementsByClassName('hAyfc');

    print("get Upadete   ===== ${elements}");

    if (elements.isNotEmpty) {
      final versionElement = elements.firstWhere(
        (elm) =>
            elm.querySelector('.BgcNfc')!.text.toString() == "Current Version",
      );
      try {
        String data = response.body;
        String pat1 =
            'Updated</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb">';
        String pat2 = '</span>';
        int p1 = data.indexOf(pat1) + pat1.length;
        String f = data.substring(p1, data.length);
        int p2 = f.indexOf(pat2);
        String lastVersionReleaseDate = f.substring(0, p2);
        DateTime releaseDate =
            DateFormat('MMMM dd, yyyy').parse(lastVersionReleaseDate);
        if (DateTime.now().difference(releaseDate).inDays > 7) {
          versionStatus.isUpdateMandatory = true;
        } else {
          versionStatus.isUpdateMandatory = false;
        }
      } catch (_) {
        versionStatus.isUpdateMandatory = false;
      }

      versionStatus.storeVersion =
          versionElement.querySelector(".htlgb")!.text.toString();
      versionStatus.appStoreLink = url.toString();
      return versionStatus;
    }
  }

  /// Shows the user a platform-specific alert about the app update. The user
  /// can dismiss the alert or proceed to the app store.
  void showUpdateDialog(VersionStatus versionStatus) async {
    const title = Text("Update Available");
    final content = Text(
        'You can now update this app from ${versionStatus.localVersion} to ${versionStatus.storeVersion}');
    const dismissText = Text("Maybe Later");
    dismissAction() => Navigator.pop(context);
    const updateText = Text("Update");
    updateAction() {
      _launchAppStore(versionStatus.appStoreLink!);
      Navigator.pop(context);
    }
    final platform = Theme.of(context).platform;
    showDialog(
      context: context,
      barrierDismissible:
          versionStatus.isUpdateMandatory == false ? true : false,
      builder: (BuildContext context) {
        return platform == TargetPlatform.android
            ? WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  title: title,
                  content: content,
                  actions: <Widget>[
                    versionStatus.isUpdateMandatory == false
                        ? TextButton(
                            onPressed: dismissAction,
                            child: dismissText,
                          )
                        : const SizedBox.shrink(),
                    TextButton(
                      onPressed: updateAction,
                      child: updateText,
                    ),
                  ],
                ),
              )
            : versionStatus.isUpdateMandatory == false
                ? CupertinoAlertDialog(
                    title: title,
                    content: content,
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: dismissText,
                        onPressed: dismissAction,
                      ),
                      CupertinoDialogAction(
                        child: updateText,
                        onPressed: updateAction,
                      ),
                    ],
                  )
                : CupertinoAlertDialog(
                    title: title,
                    content: content,
                    actions: <Widget>[
                      TextButton(onPressed: updateAction, child: updateText)
                    ],
                  );
      },
    );
  }

  /// Launches the Apple App Store or Google Play Store page for the app.
  void _launchAppStore(String appStoreLink) async {
    if (await canLaunch(appStoreLink)) {
      await launch(appStoreLink, forceWebView: false);
    } else {
      throw "Could not launch appStoreLink";
    }
  }
}
