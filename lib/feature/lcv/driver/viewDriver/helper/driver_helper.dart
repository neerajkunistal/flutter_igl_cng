import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/model/driver_model.dart';


class DriverHelper {
  static Future<dynamic> fetchDriverData(
      {required BuildContext context, required LoginDataModel userData}) async {
    try {
      String url = APIs.getDriverApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == true &&
            res['data'] != null) {
          return driverListResponse(res['data']);
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

  static Future<dynamic> deleteCngStationWithUser(
      {required BuildContext context,
      required LoginDataModel userData,
      required String roleTypeId,
      required String userId}) async {
    try {
      String url = APIs.deleteCngUserApi;
      var json = {
        "login_id": userData.userId.toString(),
        "user_type": roleTypeId,
        "user_id": userId,
        "deleted_at": DateTime.now().toString()
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == 200 &&
            res['response'] != null) {
          return res;
        } else {
          SnackBarErrorWidget(context)
              .show(message: res['messages'].toString());
          return null;
        }
      } else {
        SnackBarErrorWidget(context)
            .show(message: "Internal Server Error ${APIs.getCNFStationApi}");
        return null;
      }
    } catch (e) {
      SnackBarErrorWidget(context)
          .show(message: "Internal server error ${APIs.deleteCngUserApi}");
      return null;
    }
  }
}
