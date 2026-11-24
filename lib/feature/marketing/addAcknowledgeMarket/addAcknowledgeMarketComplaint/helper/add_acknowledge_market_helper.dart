import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/planner_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/work_center_model.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/sap_code_model.dart';
import 'package:flutter_igl_cng/feature/marketing/acknowledgeMarketing/domain/model/complaint_market_list_model.dart';
import 'package:flutter_igl_cng/feature/marketing/addAcknowledgeMarket/addAcknowledgeMarketComplaint/domain/model/vendor_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/complaint_description_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/code_group_model.dart';
import 'package:flutter_igl_cng/services/firebase/notification_helper.dart';
import 'package:flutter_igl_cng/services/firebase/page_id.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class AddAcknowledgeMarketComplaintHelper {
  static Future<dynamic> fetchComplaintData(
      {required String reviewComplaintID}) async {
    try {
      String url = APIs.getComplaintApi + "?id=$reviewComplaintID";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return ComplaintModel.fromJson(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchUserList() async {
    try {
      String url = APIs.getAssignUserApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return acknowledgeUserListResponse(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchDepartmentData() async {
    try {
      String url = APIs.getDepartmentPGWCApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null) {
        return departmentListResponse(res);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchSapCodeData(
      {required CodeGroupModel codeGroupData}) async {
    try {
      String url = APIs.getSapCodeApi + "?code_group=${codeGroupData.code}";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return sapCodeListResponse(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchAcknowledgeData(
      {String? fromDate,
      String? toDate,
      required EquipmentComplaintType equipmentComplaintType}) async {
    try {
      String url = equipmentComplaintType == EquipmentComplaintType.normal
          ? APIs.getAcknolegeApi
          : APIs.getAcknolegeITApi +
              "?&sort=id&order=&fromDate=$fromDate&toDate=$toDate";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return acknowledgeListResponse(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchPendingAckData() async {
    try {
      String url = APIs.pendingAcknowledgeApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return complaintMarketListResponse(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchAssignedListData() async {
    try {
      String url = APIs.assignedListsApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return complaintMarketListResponse(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  static Future<dynamic> fetchPendingFinalClosureData() async {
    try {
      String url = APIs.pendingFinalClosureApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return complaintMarketListResponse(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchComplaintDetailData(
      {String? fromDate,
        String? toDate,}) async {
    try {
      String url = APIs.reportListApi +
          "?&sort=id&order=&fromDate=$fromDate&toDate=$toDate";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return complaintMarketListResponse(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  // static Future<dynamic> fetchComplaintDetailData({required String complaintID}) async {
  //   try {
  //     String url = APIs.complaintDetailApi + "?id=$complaintID";
  //     var res = await ServerRequest.getData(urlEndPoint: url);
  //     if (res != null && res['status'] != null && res["status"] == true) {
  //       return complaintMarketListResponse(res['data']);
  //     }
  //     return null;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  static Future<dynamic> submitData({
    required BuildContext context,
    required ComplaintTypeModel complaintTypeData,
    required EquipmentTypeModel equipmentTypeData,
    required String description,
    required String remark,
    required File file,
    required ComplaintModel complaintData,
    required DepartmentModel departmentData,
    required ComplaintMarketModel acknowledgeData,
    required String breakDownvalue,
    required AcknowledgeUserModel acknowledgeUserData,
    required String date,
    required String time,
    required String generalDescription,
    required String complaintStatus,
    required GeneralComplaintModel generalComplaintData,
    required PlannerModel plannerData,
    required WorkCenterModel workCenterData,
    required String personResponsible,
    required EquipmentComplaintType equipmentComplaintType,
    required ComplaintDescriptionModel complaintDescriptionData,
  }) async {
    try {
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;

      String url = equipmentComplaintType == EquipmentComplaintType.normal
          ? APIs.addAcknowlegeApi
          : APIs.addAcknowlegeITApi;
      var json = {
        "complaintId": acknowledgeData.id.toString(),
        "complaintTypeId": complaintTypeData.id != null
            ? complaintTypeData.id.toString()
            : "0",
        "generalComplaintId": generalComplaintData.id != null
            ? generalComplaintData.id.toString()
            : "0",
        "generalComplaintDesc": generalDescription,
        "equipmentId": equipmentTypeData.id != null
            ? equipmentTypeData.id.toString()
            : "0",
        "description": equipmentComplaintType == EquipmentComplaintType.normal
            ? description
            : complaintDescriptionData.id.toString(),
        "complaintDateTime": "$date $time",
        "departmentId":
            departmentData.id != null ? departmentData.id.toString() : "0",
        "breakdown": breakDownvalue,
        "isAcknowledge": complaintStatus,
        // "ackRemarks": remark,
        "ackRemarks": complaintDescriptionData.id.toString(),
        "planner_group":
            plannerData.id != null ? plannerData.plannerGroup.toString() : "",
        "main_work_center": workCenterData.id != null
            ? workCenterData.workCenter.toString()
            : "",
        "person_responsible": personResponsible,
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
        NotificationHelper.sendNotification(
            firebaseDeviceList:
                BlocProvider.of<HomeBloc>(!context.mounted ? context : context)
                    .firebaseDeviceList,
            title:
                "Complain ${breakDownvalue == "1" ? "Breakdown" : "NoBreakdown"} ${userData.name}",
            body: description,
            pageId: PageId.ackComplaint,
            complaintId: acknowledgeData.id.toString(),
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
            message:
                response.replaceAll("[{", "").toString().replaceAll("}]", ""));
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

  static Future<dynamic> submitAckAssignData({
    required BuildContext context,
    required ComplaintMarketModel acknowledgeData,
    required VendorMarketModel vendorId,
    required String ackRemarks,
    required String complaintStatus,
    required String breakDownvalue,
    required String date,
    required String time,
  }) async {
    try {
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;

      String url = APIs.ackAssignApi;
      var json = {
        "complaintId": acknowledgeData.id.toString(),
        "vendorId": vendorId.id == null ? "0" : vendorId.id.toString(),
        "ackRemarks": ackRemarks.toString(),
        "ackStatus": complaintStatus,
        "incident_date_time": "$date $time",
      };
      if (!context.mounted) return null;
      var res = await ServerRequest.postDataWithFile(
        urlEndPoint: url,
        body: json,
        context: context,
      );
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['message'] != null) {
        NotificationHelper.sendNotification(
            firebaseDeviceList:
                BlocProvider.of<HomeBloc>(!context.mounted ? context : context)
                    .firebaseDeviceList,
            title:
                "Complain ${breakDownvalue == "1" ? "Breakdown" : "NoBreakdown"} ${userData.name}",
            body: ackRemarks,
            pageId: PageId.ackComplaint,
            complaintId: acknowledgeData.id.toString(),
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
            message:
                response.replaceAll("[{", "").toString().replaceAll("}]", ""));
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

  static Future<dynamic> submitAmoFinalCloseData({
    required BuildContext context,
    required ComplaintMarketModel acknowledgeData,
    required String remarks,
  }) async {
    try {


      String url = APIs.amoFinalCloseApi;
      var json = {
        "complaintId": acknowledgeData.id.toString(),
        "action": "2",
        "remarks": remarks.toString(),
      };
      if (!context.mounted) return null;
      var res = await ServerRequest.postDataWithFile(
        urlEndPoint: url,
        body: json,
        context: context,
      );
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
            message:
            response.replaceAll("[{", "").toString().replaceAll("}]", ""));
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
