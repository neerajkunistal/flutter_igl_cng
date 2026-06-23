import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/planner_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/work_center_model.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/sap_code_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/code_group_model.dart';
import 'package:flutter_igl_cng/services/firebase/notification_helper.dart';
import 'package:flutter_igl_cng/services/firebase/page_id.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class AddAcknowledgeComplaintHelper {
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

  static Future<dynamic> fetchCngVendorList() async {
    try {
      String url = APIs.getCngVendorListApi;
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
      {String? fromDate, String? toDate}) async {
    try {
      String url = APIs.getAcknolegeApi +
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

  static Future<dynamic> submitData({
    required BuildContext context,
    required ComplaintTypeModel complaintTypeData,
    required EquipmentTypeModel equipmentTypeData,
    required String description,
    required String remark,
    required File file,
    required ComplaintModel complaintData,
    required DepartmentModel departmentData,
    required AcknowledgeModel acknowledgeData,
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
  }) async {
    try {
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;

      String url = APIs.addAcknowlegeApi;
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
        "description": description,
        "complaintDateTime": "$date $time",
        "departmentId": departmentData.id != null ? departmentData.id.toString() : "0",
        "breakdown": breakDownvalue,
        "isAcknowledge": complaintStatus,
        "ackRemarks": remark,
        "planner_group": plannerData.id != null ? plannerData.plannerGroup.toString() : "0",
        "main_work_center": workCenterData.id != null
            ? workCenterData.workCenter.toString()
            : "0",
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
}
