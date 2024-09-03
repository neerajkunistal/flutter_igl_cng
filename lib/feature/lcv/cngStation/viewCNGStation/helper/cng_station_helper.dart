import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/snack_bar_success_widget.dart';

import '../domain/model/cng_stattion_model.dart';

class CNGStationHelper {
  static Future<dynamic> fetchCNGStationData(
      {required BuildContext context, required LoginDataModel userData}) async {
    try {
      String url = APIs.getCNFStationApi;
      var json = {
        "role_id": userData.roleId.toString(),
        "login_id": userData.userId.toString(),
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == 200 &&
            res['response'] != null) {
          return cngStationListResponse(res['response']);
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
          .show(message: "Internal server error ${APIs.getCNFStationApi}");
      return null;
    }
  }

  static Future<dynamic> deleteCngStationWithLcvTruck(
      {required BuildContext context,
      required LoginDataModel userData,
      String? cngStationId,
      String? lcvTruckId}) async {
    try {
      String url = APIs.deleteCngStationTruckApi;
      var json = {
        "login_id": userData.userId,
        "is_del_cng_station_id": cngStationId ?? "",
        "is_del_lcv_id": lcvTruckId ?? "",
        "deleted_at": DateTime.now().toString()
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == 200 &&
            res['response'] != null) {
          SnackBarSuccessWidget(context).show(message: res['response']);
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
          .show(message: "Internal server error ${APIs.getCNFStationApi}");
      return null;
    }
  }
}
