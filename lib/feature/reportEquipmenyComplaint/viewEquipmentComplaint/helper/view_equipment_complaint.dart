import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/dashboard/domain/model/file_model.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scrap_model.dart';

class ViewEquipmentComplaintHelper {
  static Future<dynamic> fetchReviewAndSelfComplaint() async {
    try {
      String url = APIs.getReviewSelfComplaintApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['data'] != null) {
        return reviewComplaintListResponse(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> closureComplaintTextFiledValidation({required BuildContext context,
    required String date,
    required String time,
    required String rectifiedBy,
    required String remark})  async
  {
     try
     {
       if(date.isEmpty){
         SnackBarErrorWidget(context).show(message: "Please select date");
         return false;
       }
       else if(date.isEmpty){
         SnackBarErrorWidget(context).show(message: "Please select time");
         return false;
       }
       else if(rectifiedBy.isEmpty){
         SnackBarErrorWidget(context).show(message: "Please enter rectified By");
         return false;
       }
       else if(remark.isEmpty){
         SnackBarErrorWidget(context).show(message: "Please enter remark");
         return false;
       }
       return true;
     }catch(_){}
    return false;
  }

  static  Future<dynamic> closureComplaint({required BuildContext context,
     required ReviewComplaintModel reviewComplaintData,
    required String date,
    required String time,
    required String rectifiedBy,
    required List<ScrapModel> scrapList,
    required String remark}) async {
    try{
         String url =  APIs.closureComplaintApi;
         var json = {
           "complaintId" : reviewComplaintData.id.toString(),
           "stationRemarks" : remark.toString().isEmpty ? "remark" : remark,
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
         log(jsonEncode(scrapData).toString());
         var res =  await ServerRequest.postData(urlEndPoint: url, body: scrapData);
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
    } catch(e) {
      return null;
    }
  }
}
