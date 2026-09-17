import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/dashboard/domain/model/file_model.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scrap_model.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/model/part_%20model.dart';
import 'package:flutter_igl_cng/services/firebase/notification_helper.dart';
import 'package:flutter_igl_cng/services/firebase/page_id.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

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
    required List<PartModel> partList,
    required String remark,
    required EquipmentComplaintType equipmentComplaintType,
  }) async {
    try{
        LoginDataModel userData = UserInfo.instanceInit()!.userData!;
         String url =  equipmentComplaintType == EquipmentComplaintType.normal
              ? APIs.closureComplaintApi
              : APIs.closureComplaintITApi;
         var json = {
           "complaintId" : reviewComplaintData.id.toString(),
           "stationRemarks" : remark.toString().isEmpty ? "remark" : remark,
           "closeDateTime" : "$date $time",
           "rectifyPerson" : rectifiedBy,
           "scrap" : scrapList.isNotEmpty ? "1" : "0",
           "spares": partList.isNotEmpty
               ? jsonEncode(partList.map((e) => e.toJson()).toList())
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
                 if(scrapList[i].filesList![j].path.isNotEmpty){
                   filesList.add(FileModel(
                       name: "file", file: scrapList[i].filesList![j], keyName: "scrapDetails[$i][attachFile][$j]"));
                 }
               }
             }
             scrapData.addAll(jsonData);
           }
         }
         scrapData.addAll(json);
         log(jsonEncode(scrapData).toString());

         var res = await ServerRequest.postDataWithFile(
           urlEndPoint: url,
           body: scrapData,
           context: context,
           fileList: filesList,);
         if (res != null &&
             res['status'] != null &&
             res['status'] == true &&
             res['message'] != null) {
           if (!context.mounted) return res;
           SnackBarSuccessWidget(context).show(message: res['message'].toString());
           NotificationHelper.sendNotification(
               firebaseDeviceList:
               BlocProvider.of<HomeBloc>(!context.mounted ? context : context)
                   .firebaseDeviceList,
               title: "Closing Request ${userData.stationName}",
               body: reviewComplaintData.complaintDescription.toString(),
               pageId: PageId.reviewComplaint,
               complaintId: "",
               dateTime: DateTime.now().toString());
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
