import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/viewLcvTrack/domain/model/lcv_model.dart';


class ViewLcvTrackHelper {
  static Future<dynamic> fetchLCVData(
      {required BuildContext context, required LoginDataModel userData}) async {
    try {
      String url = APIs.getLCVDetailApi;
      var json = {
        "role_id": userData.roleId.toString(),
        "login_id": userData.userId.toString(),
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == 200 &&
            res['response'] != null) {
          return lcvListResponse(res['response']);
        } else {
          SnackBarErrorWidget(context)
              .show(message: res['messages'].toString());
          return null;
        }
      } else {
        SnackBarErrorWidget(context)
            .show(message: "Internal Server Error ${APIs.getLCVDetailApi}");
        return null;
      }
    } catch (e) {
      SnackBarErrorWidget(context)
          .show(message: "Internal server error ${APIs.getLCVDetailApi}");
      return null;
    }
  }
}
