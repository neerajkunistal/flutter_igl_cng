import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/vendor_model.dart';
import 'package:flutter_igl_cng/feature/ci/domain/model/complaint_status.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';

class ViewCiComplaintHelper {

  static Future<dynamic> fetchCivilData(
      {String? fromDate, String? toDate}) async {
    try {
      String url = APIs.getCivilApproveApi +
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

  static Future<dynamic> fetchVendor() async {
    try {
      String url = APIs.getVendorListApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null &&
          res['status'] &&
          res['status'] == true &&
          res['data'] != null) {
        return vendorListResponse(res['data']);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<dynamic> assignVendor(
      {required CngModel cngData,
      required VendorModel vendorData,
      required BuildContext context}) async {
    try {
      String url = APIs.assignVendorApi;
      var json = {
        "complaintId": cngData.id.toString(),
        "assignTo": vendorData.id.toString()
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
              ..replaceAll("}]", ""));
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
      var res = await ServerRequest.putData(urlEndPoint: url, body: json);
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
              ..replaceAll("}]", ""));
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

  static Future<dynamic> estimateApprove(
      {required CngModel cngData,
      required ComplaintStatus complaintStatus,
      required BuildContext context}) async {
    try {
      String url = APIs.estimateComplaintApproveApi;
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
              ..replaceAll("}]", ""));
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

  static Future<dynamic> finalApproveComplaint(
      {required CngModel cngData,
      required ComplaintStatus complaintStatus,
      required String remark,
      required BuildContext context}) async {
    try {
      String url = APIs.civilFinalComplaintApproveApi;
      var json = {
        "complaintId": cngData.id.toString(),
        "statusType": complaintStatus.id.toString(),
        "remarks": remark,
      };
      var res = await ServerRequest.putData(urlEndPoint: url, body: json);
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
              ..replaceAll("}]", ""));
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
}
