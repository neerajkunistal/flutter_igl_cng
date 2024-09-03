import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class AddCngScmHelper {
  static Future<dynamic> textFieldValidation({
    required BuildContext context,
    required String currentScm,
    required String sellScm,
    required String remainScm,
    required String requiredScm,
  }) async {
    try {
      if (currentScm.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter current scm quantity");
        return false;
      } else if (sellScm.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter sell scm quantity");
        return false;
      } else if (remainScm.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter remain scm quantity");
        return false;
      } else if (requiredScm.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter required scm quantity");
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<dynamic> submitCngScmData({
    required BuildContext context,
    required String currentScm,
    required String sellScm,
    required String remainScm,
    required String requiredScm,
    required LoginDataModel userData,
  }) async {
    try {
      String url = APIs.addCngScmInfoApi;
      var json = {
        "login_id": userData.userId.toString(),
        "cng_station_id": userData.stationId.toString(),
        "current_scm": currentScm,
        "sell_scm": sellScm,
        "remain_scm": remainScm,
        "required_scm": requiredScm
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == 200 &&
            res['response'] != null) {
          SnackBarSuccessWidget(context)
              .show(message: res['response'].toString());
          return res;
        } else if (res["status"] != null &&
            res['status'] == 500 &&
            res['response'] != null) {
          SnackBarErrorWidget(context)
              .show(message: res['response'].toString());
          return null;
        } else {
          SnackBarErrorWidget(context)
              .show(message: res['response'].toString());
          return null;
        }
      } else {
        SnackBarErrorWidget(context)
            .show(message: "Internal Server Error ${APIs.addCngScmInfoApi}");
        return null;
      }
    } catch (e) {
      SnackBarErrorWidget(context).show(message: "Internal server error");
      return null;
    }
  }
}
