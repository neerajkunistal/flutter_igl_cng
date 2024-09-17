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
      String url = APIs.getAssignmentApi+"?from_date=$fromDate&to_date=$toDate";
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

  static Future<dynamic> cancelAssignment(
      {required BuildContext context,
        required AssignmentModel assignmentData,
        required String remark,
      }) async {
    try {
      String url = APIs.cancelAssignmentApi;
      var json = {
        "id" : assignmentData.id.toString(),
         "status" : "2",
          "cancel_remark" : remark,
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body:  json);
        if (res != null && res["status"] != null &&
            res['status'] == true &&
            res['message'] != null) {
          SnackBarErrorWidget(!context.mounted ? context : context)
              .show(message: "${res['message']}");
          return res;
        } else if (res != null && res["status"] != null &&
            res['status'] == false &&
            res['errors'] != null) {
          String response = res['errors'].toString();
          if (!context.mounted) return null;
          SnackBarErrorWidget(context).show(
              message: response.replaceAll("[{", "").toString()
                  .replaceAll("}]", ""));
          return null;
        } else {
        SnackBarErrorWidget(!context.mounted ? context : context)
            .show(message: "Internal Server Error ${APIs.getAssignmentApi}");
        return null;
      }
    } catch (e) {
      SnackBarErrorWidget(!context.mounted ? context : context)
          .show(message: "Internal server error ${APIs.getAssignmentApi}");
      return null;
    }
    return null;
  }

}
