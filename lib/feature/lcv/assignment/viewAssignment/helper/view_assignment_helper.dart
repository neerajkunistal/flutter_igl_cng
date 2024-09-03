import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';

class ViewAssignmentHelper {
  static Future<dynamic> textFieldValidationCheck({
    required BuildContext context,
    required String toDate,
    required String fromDate,
  }) async {
    try {
      if (fromDate.isEmpty) {
        SnackBarErrorWidget(context).show(message:"Please enter from date");
        return false;
      } else if (toDate.isEmpty) {
        SnackBarErrorWidget(context).show(message:"Please enter to date");
        return false;
      }
      return true;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: e.toString());
      return false;
    }
  }

  static Future<dynamic> fetchAssignment(
      {required BuildContext context,
      required LoginDataModel userData,
      String? fromDate,
      String? toDate}) async {
    try {
      String url = APIs.getAssignmentApi;
      var json = {
        "login_id": userData.userId.toString(),
        "role_id": userData.roleId.toString(),
        "from_date": fromDate ?? "",
        "to_date": toDate ?? "",
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == 200 &&
            res['response'] != null) {
          return assignmentListResponse(res['response']);
        } else {
          SnackBarErrorWidget(context).show(message: res['error'].toString());
          return null;
        }
      } else {
        SnackBarErrorWidget(context)
            .show(message: "Internal Server Error ${APIs.getAssignmentApi}");
        return null;
      }
    } catch (e) {
      SnackBarErrorWidget(context)
          .show(message: "Internal server error ${APIs.getAssignmentApi}");
      return null;
    }
  }
}
