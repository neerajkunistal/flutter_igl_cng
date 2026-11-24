import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';

class ViewCngHelper {
  static Future<dynamic> fetchCngCivilData(
      {String? fromDate, String? toDate}) async {
    try {
      String url = APIs.addCivilComplaintApi +
          "?fromDate=${fromDate ?? ""}&toDate=${toDate ?? ""}";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['data'] != null) {
        return cngListResponse(res['data']);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static  Future<dynamic> closureComplaint({required BuildContext context,
    required CngModel cngData}) async {
    try{
      String url =  APIs.civilCloserComplaintApi;
      var json = {
        "complaintId" : cngData.id.toString(),
        "statusType" : "2",
      };
      var res =  await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['message'] != null) {
        if (!context.mounted) return res;
        SnackBarSuccessWidget(context).show(message: res['message'].toString());
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
    } catch(e) {
      return null;
    }
  }
}
