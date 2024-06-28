import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/vendor_model.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/action_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_part_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/uom_type_model.dart';
import 'package:flutter_igl_cng/services/firebase/notification_helper.dart';
import 'package:flutter_igl_cng/services/firebase/page_id.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class MiComplaintHelper {
  static Future<dynamic> fetchSpareData() async {
    try {
      String url = APIs.getSparesApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return sparesListResponse(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchUomData() async {
    try {
      String url = APIs.getUomApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return uomTypeLIstResponse(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchMiComplaint(
      {String? fromDate, String? toDate}) async {
    try {
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;
      String url = APIs.getMiComplaintApi +
          "?userId=${userData.userId}&sort=id&order=&fromDate=$fromDate&toDate=$toDate";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return reviewComplaintListResponse(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> submit({
    required BuildContext context,
    required ReviewComplaintModel reviewComplaintData,
    required String approvalValue,
    required SparesModel sparesData,
    required ActionModel action,
    required String description,
    required String observation,
    required File file,
    required String date,
    required String time,
    required UomTypeModel uomTypeData,
    required String qty,
    required List<SparesPartModel> sparesPartList,
    required VendorModel vendorData,
    required String rectifyBy,
  }) async {
    try {
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;

      String url = APIs.addMiComplaintApi;
      var json = {
        "complaintId": reviewComplaintData.id != null
            ? reviewComplaintData.id.toString()
            : "0",
        "action": action.id != null ? action.id.toString() : "0",
        "amcStatus": reviewComplaintData.amcStatus != null
            ? reviewComplaintData.amcStatus.toString()
            : "",
        "amcTillDate": reviewComplaintData.amcDate != null
            ? reviewComplaintData.amcDate.toString()
            : "",
        "assignTo": vendorData.id != null
            ? vendorData.id.toString()
            : reviewComplaintData.assignTo.toString(),
        "approval": approvalValue.isEmpty ? "0" : approvalValue,
        "observation": observation,
        "startDateTime": action.id.toString() == "1"
            ? "$date $time"
            : reviewComplaintData.maintenanceStartDate.toString(),
        "endDateTime": action.id.toString() == "3" ? "$date $time" : "",
        "maintenanceHoldDateTime":
            action.id.toString() == "2" ? "$date $time" : "",
        "remarks": description,
        "spares": sparesPartList.isNotEmpty
            ? jsonEncode(sparesPartList.map((e) => e.toJson()).toList())
                .toString()
            : "0",
        "vendorAssignDatetime" : action.id.toString() == "4"
            ? "$date $time" : "",
        "rectifyPerson" : rectifyBy,
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
        await NotificationHelper.sendNotification(
            firebaseDeviceList:
                BlocProvider.of<HomeBloc>(!context.mounted ? context : context)
                    .firebaseDeviceList,
            title:
                "Complain ${action.id == "1" ? "Start" : action.id == "2" ? "Hold" : action.id == "3" ? "Closed" : "Vendor"} ${userData.name}",
            body: description.isNotEmpty ? description : observation,
            pageId: PageId.miComplaint,
            complaintId: reviewComplaintData.id.toString(),
            dateTime: DateTime.now().toString());
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
