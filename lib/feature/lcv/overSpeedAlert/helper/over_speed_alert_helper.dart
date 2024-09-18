import 'package:flutter/widgets.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/overSpeedAlert/domain/bloc/over_speed_alert_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/overSpeedAlert/domain/model/over_speed_alert_model.dart';

import '../../../login/domain/models/login_model.dart';

class OverSpeedAlertHelper {

  static Future<dynamic> fetchOverSpeedData(
      {required BuildContext context }) async {
    try {
      String url = APIs.getOverSpeedApi;
      var res = await ServerRequest.getData(urlEndPoint: url,);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == true &&
            res['data'] != null) {
          return overSpeedListResponse(res['data']);
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<dynamic> markOverSpeedData(
      {required BuildContext context,
        required OverSpeedAlertModel overSpeedAlertData}) async {
    try {
      String url = APIs.markOverSpeedApi;
      var json = {
        "overspeeding_logs_id" : overSpeedAlertData.overSpeedingLogsId.toString()
      };
      var res = await ServerRequest.postDataWithFile(urlEndPoint: url, body: json, context: context);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == true ) {
          return res;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}