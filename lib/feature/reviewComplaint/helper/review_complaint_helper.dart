import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/sap_code_model.dart';
import 'package:flutter_igl_cng/feature/dashboard/domain/model/file_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/code_group_model.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scrap_model.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/model/part_%20model.dart';

class ReviewComplaintHelper {
  static Future<dynamic> fetchReviewComplaint(
      {String? fromDate, String? toDate}) async {
    try {
      String url = APIs.getReviewComplaintApi +
          "?sort=&order=&fromDate=$fromDate&toDate=$toDate";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return reviewComplaintListResponse(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchCodeGroupData() async {
    try {
      String url = APIs.getCodeGroupApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return codeGroupListResponse(res['data']);
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
      required String rectifyBy,
      required String closedDate,
      required String closedTime,
      required List<File> files,
      required bool isNoScrap,
      required List<ScrapModel> scrapList,
      required List<PartModel> partList,
        required List<ScrapModel> deletesScrapList,
        required List<PartModel> deletePartList,
      required SapCodeModel sapCodeData,
      required CodeGroupModel codeGroupData,
      }) async {
    try {
      String url = APIs.addReviewComplaintApi;
      var json = {
        "complaintId": complaintId.isNotEmpty
            ? complaintId
            : reviewComplaintData.id != null
                ? reviewComplaintData.id.toString()
                : "",
        "remarks": observation.toString(),
        "finalStatus": approvalValue,
        "rectifyPerson": approvalValue,
        "closeDateTime": "$closedDate $closedTime",
        "scrap" : scrapList.isEmpty ? "0" :"1",
        "sapCode" : sapCodeData.code != null ? sapCodeData.id.toString() : "",
        "codeGroup" : codeGroupData.code != null ? codeGroupData.id.toString() : "",
        "spares": partList.isNotEmpty
            ? jsonEncode(partList.map((e) => e.toJson()).toList())
            .toString()
            : "0",
        "deletedSpares": deletesScrapList.isNotEmpty
            ? jsonEncode(deletesScrapList.map((e) => e.toJson()).toList())
            .toString()
            : "0",
        "deletedParts": deletePartList.isNotEmpty
            ? jsonEncode(deletePartList.map((e) => e.toDeleteJson()).toList())
            .toString()
            : "0",
      };


      Map<String, String> scrapData = {};
      List<FileModel> filesList = [];
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
              if(scrapList[i].filesList![j].path.isNotEmpty){
                filesList.add(FileModel(
                    name: "file", file: scrapList[i].filesList![j], keyName: "scrapDetails[$i][attachFile][$j]"));
              }
            }
          }
          scrapData.addAll(jsonData);
     }

      scrapData.addAll(json);
      log(jsonEncode(scrapData).toString());

      if(files[0].path.isNotEmpty){
        filesList.add(FileModel(
            name: "file", file: files[0], keyName: "attachFile"));
      }

      if (!context.mounted) return null;
      var res = await ServerRequest.postDataWithFile(
          urlEndPoint: url,
          body: scrapData,
          context: context,
        fileList: filesList);
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
              .replaceAll("}]", ""));
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
      required String rectifyBy,
      required String closedDate,
      required String closedTime,
      required List<File> files,
        required bool isNoScrap,
        required List<ScrapModel> scrapList,
        required List<PartModel> partList,
        required List<ScrapModel> deletesScrapList,
        required List<PartModel> deletePartList,
      }) async {
    try {
      List<FileModel> fileList = [];
      int i = 0;
      for (var fileData in files) {
        if (fileData.path.isNotEmpty) {
          fileList.add(FileModel(
              name: "file", file: fileData, keyName: "attachFile[$i]"));
          i++;
        }
      }

      String url = APIs.getReviewComplaintApi;
      var json = {
        "complaintId": reviewComplaintData.id != null
            ? reviewComplaintData.id.toString()
            : "",
        "stationStatus": "1",
        "stationPerson": "",
        "stationRemarks": observation.toString(),
        "rectifyPerson": approvalValue,
        "closeDateTime": "$closedDate $closedTime",
        "scrap" : scrapList.isEmpty ? "0" : "1",
        "spares": partList.isNotEmpty
            ? jsonEncode(partList.map((e) => e.toJson()).toList())
            .toString()
            : "0",
        "deletedSpares": deletesScrapList.isNotEmpty
            ? jsonEncode(deletesScrapList.map((e) => e.toJson()).toList())
            .toString()
            : "0",
        "deletedParts": deletePartList.isNotEmpty
            ? jsonEncode(deletePartList.map((e) => e.toDeleteJson()).toList())
            .toString()
            : "0",
      };

      Map<String, String> scrapData = {};
      if(isNoScrap == false){
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
              if(scrapList[i].filesList![j].path.isNotEmpty){
                fileList.add(FileModel(
                    name: "file", file: scrapList[i].filesList![j], keyName: "scrapDetails[$i][attachFile][$j]"));
              }
            }
          }
          scrapData.addAll(jsonData);
        }
      }

      scrapData.addAll(json);
      log(jsonEncode(scrapData).toString());

      if (!context.mounted) return null;
      var res = await ServerRequest.postDataWithFile(
          urlEndPoint: url, body: scrapData, context: context, fileList: fileList);
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
    } catch (e) {
      return null;
    }
  }
}
