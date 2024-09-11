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
      var res = await ServerRequest.getData(urlEndPoint: url,);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == true &&
            res['data'] != null) {
          return assignmentListResponse(res['data']);
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
    return null;
  }
}
