import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/user/viewUser/domain/model/user_model.dart';

class ViewUserHelper {
  static Future<dynamic> fetchUserData(
      {required BuildContext context, required LoginDataModel userData}) async {
    try {
      String url = APIs.getUserApi;
      var json = {
        "login_id": userData.userId.toString(),
        "user_type": "4",
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == 200 &&
            res['response'] != null) {
          return userListResponse(res['response']);
        } else {
          SnackBarErrorWidget(context)
              .show(message: res['messages'].toString());
          return null;
        }
      } else {
        SnackBarErrorWidget(context)
            .show(message: "Internal Server Error ${APIs.getDriverApi}");
        return null;
      }
    } catch (e) {
      SnackBarErrorWidget(context)
          .show(message: "Internal server error ${APIs.getDriverApi}");
      return null;
    }
  }
}
