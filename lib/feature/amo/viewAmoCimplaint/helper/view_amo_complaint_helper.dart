import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/domain/model/station_model.dart';
import 'package:flutter_igl_cng/feature/ci/domain/model/complaint_status.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';

class ViewAmoComplaintHelper {
  static Future<dynamic> civilComplaintApprove(
      {required CngModel cngData,
      required ComplaintStatus complaintStatus,
      required BuildContext context}) async {
    try {
      String url = APIs.civilComplaintApproveApi;
      var json = {
        "complaintId": cngData.id.toString(),
        "statusType": complaintStatus.id.toString()
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['message'] != null) {
        if (!context.mounted) return res;
        SnackBarSuccessWidget(context).show(message: res['message']);
        return res;
      } else if (res != null &&
          res['status'] != null &&
          res['status'] == false &&
          res['error'] != null) {
        if (!context.mounted) return null;
        SnackBarErrorWidget(context).show(message: res['error'].toString());
        return null;
      } else if (res != null &&
          res['status'] != null &&
          res['status'] == false &&
          res['errors'] != null) {
        String response = res['errors'].toString();
        if (!context.mounted) return null;
        SnackBarErrorWidget(context).show(
            message: response.replaceAll("[{", "").toString()
              .replaceAll("}]", ""));
        return null;
      } else {
        if (!context.mounted) return null;
        SnackBarErrorWidget(context).show(message: "Internal Server Error");
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  static Future<dynamic> fetchStationData() async {
    try {
      String url = APIs.getCNGStationListApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['data'] != null) {
        return stationListResponse(res['data']);
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  static Future<dynamic> fetchControlRoomData() async {
    try {
      String url = APIs.getCNGStationListApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['data'] != null) {
        return stationListResponse(res['data']);
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

}
