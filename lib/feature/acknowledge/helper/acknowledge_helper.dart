import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/aasign_type_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/planner_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/vendor_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/work_center_model.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/sap_code_model.dart';
import 'package:flutter_igl_cng/feature/dashboard/domain/model/file_model.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scrap_model.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/model/part_%20model.dart';
import 'package:flutter_igl_cng/services/firebase/notification_helper.dart';
import 'package:flutter_igl_cng/services/firebase/page_id.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class AcknowledgeHelper {
  static Future<dynamic> textFieldValidationCheck(
      {required BuildContext context,
      required VendorModel vendorData,
      required AcknowledgeUserModel userData,
      required SapCodeModel sapCodeModel,
      required AssignTypeModel assignTypeData,
      required PlannerModel plannerData,
      required WorkCenterModel workCenterData,
      required String time,
      }) async {
    try {
      if (assignTypeData.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select assign type");
        return false;
      } else if (assignTypeData.id.toString() == "2" && userData.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select user");
        return false;
      } else if (assignTypeData.id.toString() == "3" && vendorData.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select vendor");
        return false;
      } else if(time.isEmpty){
        SnackBarErrorWidget(context).show(message: "Please enter time");
        return false;
      }
/*      else if(plannerData.id == null){
        SnackBarErrorWidget(context).show(message: "Please select planner");
        return false;
      } else if(workCenterData.id == null){
        SnackBarErrorWidget(context).show(message: "Please select work center");
        return false;
      }*/
/*      else if (sapCodeModel.code == null) {
        SnackBarErrorWidget(context).show(message: "Please select sap code");
        return false;
      }*/
      return true;
    } catch (_) {}
  }

  static Future<dynamic> fetchVendorData() async {
    try {
      String url = APIs.getVendorApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res['status'] == true) {
        return vendorListResponse(res['data']);
      }
    } catch (_) {}
    return null;
  }

  static Future<dynamic> assignUser(
      {required BuildContext context,
      required AcknowledgeModel acknowledgeData,
      required AcknowledgeUserModel userModel,
      required VendorModel vendorData,
      required SapCodeModel sapCodeData,
      required DepartmentModel departmentData,
      required AssignTypeModel assignTypeData,
      required String closedDate,
      required String closedTime,
      required String personResponsible,
      required PlannerModel plannerData,
      required WorkCenterModel workCenterData,
      required List<PartModel> sparesPartList,
      required List<ScrapModel> scrapList,
      required String remark}) async {
    try {

      LoginDataModel loginData =  UserInfo.instanceInit()!.userData!;

      String url = APIs.assignComplaintApi;
      var json = {
        "complaintId": acknowledgeData.id.toString(),
        "assignType": assignTypeData.id.toString(),
/*        "sapCode": sapCodeData.id != null ? sapCodeData.id.toString() : "0",*/
/*        "departmentId":
            departmentData.id != null ? departmentData.id.toString() : "0",*/
        "assignTo": assignTypeData.id.toString() == "1"
            ? "1"
            : assignTypeData.id.toString() == "2"
                ? userModel.id.toString()
                : assignTypeData.id.toString() == "3"
                    ? vendorData.id.toString()
                    : "0",
        "shiftEngRemarks": remark,
/*        "planner_group": plannerData.plannerGroup.toString(),
        "main_work_center": workCenterData.workCenter.toString(),
        "person_responsible": personResponsible,*/
        "vendorAssignDatetime": "$closedDate $closedTime",
        "scrap" : scrapList.isNotEmpty ? "1" : "0",
        "spares": sparesPartList.isNotEmpty
            ? jsonEncode(sparesPartList.map((e) => e.toJson()).toList())
            .toString()
            : "0",
      };

      Map<String, String> scrapData = {};
      List<FileModel> filesList = [];
      if(scrapList.isNotEmpty){
        for(int i = 0;  i < scrapList.length; i++ ){
          var jsonData = {
            "scrapDetails[$i][serial]" : scrapList[i].srNumber.toString(),
            "scrapDetails[$i][description]" : scrapList[i].description.toString(),
            "scrapDetails[$i][unit]" : scrapList[i].scrapUnitTypeData!.unit.toString(),
            "scrapDetails[$i][unitType]" : scrapList[i].scrapUnitTypeData!.id.toString(),
            "scrapDetails[$i][remark]" : scrapList[i].remark.toString(),
            "scrapDetails[$i][destroy_reusable]" : scrapList[i].destroyReusable.toString(),
          };
          if(scrapList[i].filesList != null){
            for(int j = 0;  j < scrapList[i].filesList!.length; j++ ){
              filesList.add(FileModel(
                  name: "file", file: scrapList[i].filesList![j], keyName: "scrapDetails[$i][attachFile][$j]"));
            }
          }
          scrapData.addAll(jsonData);
        }
      }
      scrapData.addAll(json);

      var res = await ServerRequest.postData(urlEndPoint: url, body: scrapData);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['message'] != null) {
        NotificationHelper.sendNotification(
            firebaseDeviceList:
                BlocProvider.of<HomeBloc>(!context.mounted ? context : context)
                    .firebaseDeviceList,
            title: "Complaint Assign ${loginData.stationName}",
            body: acknowledgeData.complaintDescription,
            pageId: PageId.assignComplaint,
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
            message: response.replaceAll("[{", "").toString()
                .replaceAll("}]", ""));
        return null;
      } else if (res != null && res['message'] != null) {
        if (!context.mounted) return false;
        SnackBarErrorWidget(context).show(message: res['message'].toString());
        return false;
      }
    } catch (_) {
      if (!context.mounted) return false;
      SnackBarErrorWidget(context).show(message: "Internal server error");
    }
  }

  static Future<dynamic> fetchPlannerData() async {

    try{
       String url =  APIs.getPlannerGroupApi;
       var res =  await ServerRequest.getData(urlEndPoint: url);
       if(res != null && res['data'] != null){
         return plannerListResponse(res['data']);
       }

    }catch(_){}
    return null;
  }

  static Future<dynamic> fetchWorkCenterData() async {

    try{
      String url =  APIs.getWorkCenterApi;
      var res =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['data'] != null){
        return workCenterListResponse(res['data']);
      }
    }catch(_){}
    return null;
  }

  static Future<List<AssignTypeModel>?> fetchCNGComplainAssignData() async {
    try {
      String url = APIs.cngComplainAssign;
      var res = await ServerRequest.getData(urlEndPoint: url);

      if (res != null && res['data'] != null) {
        return assignTypeListResponse(res);
      }
    } catch (e) {
      debugPrint("fetchCNGComplainAssignData error: $e");
    }
    return null;
  }

}
