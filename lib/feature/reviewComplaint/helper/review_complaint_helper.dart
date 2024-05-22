import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class ReviewComplaintHelper {
  static Future<dynamic> fetchReviewComplaint({
    String? fromDate, String? toDate}) async {
    try {
      String url = APIs.getReviewComplaintApi+"?sort=&order=&fromDate=$fromDate&toDate=$toDate";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return reviewComplaintListResponse(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> submit(
      {required BuildContext context,
      required ReviewComplaintModel reviewComplaintData,
      required String approvalValue,
      required String observation,
      required String complaintId,
      required File file}) async {
    try {
      String url = APIs.addReviewComplaintApi;
      var json = {
        "complaintId": complaintId.isNotEmpty
            ? complaintId
            : reviewComplaintData.id != null
            ? reviewComplaintData.id.toString()
            : "",
        "remarks":observation.toString(),
        "finalStatus": approvalValue,
      };
      if (!context.mounted) return null;
      var res = await ServerRequest.postDataWithFile(
          urlEndPoint: url,
          body: json,
          context: context,
          keyWord: "attachFile",
          filePath: file.path.toString());
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['message'] != null) {
/*        await NotificationHelper.sendNotification(
            firebaseDeviceList:  BlocProvider.of<HomeBloc>(!context.mounted ?  context :context).firebaseDeviceList,
            title: "Shift engineer ${approvalValue == "1" ? "Completed" : "Reject"} Complaint",
            body: observation,
            pageId: PageId.reviewComplaint,
            complaintId: reviewComplaintData.id.toString(),
            dateTime: DateTime.now().toString());*/
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
              ..replaceAll("}]", ""));
        return null;
      } else {
        if (!context.mounted) return null;
        SnackBarErrorWidget(context).show(message: "Internal Server Error");
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> reviewComplaint(
      {required BuildContext context,
        required ReviewComplaintModel reviewComplaintData,
        required String approvalValue,
        required String observation,
        required File file}) async {
    try {
      String url = APIs.getReviewComplaintApi;
      var json = {
        "complaintId": reviewComplaintData.id != null
            ? reviewComplaintData.id.toString()
            : "",
        "stationStatus": "1",
        "stationPerson" : "",
        "stationRemarks":observation.toString(),
      };
      if (!context.mounted) return null;
      var res = await ServerRequest.postDataWithFile(
          urlEndPoint: url,
          body: json,
          context: context,
          keyWord: "attachFile",
          filePath: file.path.toString());
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
              ..replaceAll("}]", ""));
        return null;
      } else {
        if (!context.mounted) return null;
        SnackBarErrorWidget(context).show(message: "Internal Server Error");
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
