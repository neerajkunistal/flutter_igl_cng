import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/action_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/review_complaint_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/snack_bar_success_widget.dart';

class MiComplaintHelper {

  static Future<dynamic> fetchSpareData() async {

    try{
      String url =  APIs.getSparesApi;
      var res   =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['status'] != null && res["status"] == true) {
        return sparesListResponse(res['data']);
      }
      return null;
    }catch(e){
      return null;
    }
  }

  static Future<dynamic> fetchMiComplaint() async {

    try{
      LoginDataModel userData =  UserInfo.instanceInit()!.userData!;
      String url =  APIs.getMiComplaintApi+"?userId=${userData.userId}";
      var res   =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['status'] != null && res["status"] == true) {
        return reviewComplaintListResponse(res['data']);
      }
      return null;
    }catch(e){
      return null;
    }
  }

  static Future<dynamic> submit({required BuildContext context,
    required ReviewComplaintModel reviewComplaintData, required String approvalValue,
    required SparesModel sparesData, required ActionModel action, required String description,
    required String observation, required File file}) async {

    try{
      String url =  APIs.addMiComplaintApi;
      var json = {
        "description" : description,
        "action" : action.id ?? "0",
        "amcStatus" : reviewComplaintData.amcStatus != null ? reviewComplaintData.amcStatus.toString() : "",
        "amcDate" : reviewComplaintData.amcDate !=null ? reviewComplaintData.amcDate.toString() : "",
        "complaintId" : reviewComplaintData.id != null ?  reviewComplaintData.id.toString() : "",
        "spareId" : sparesData.id.toString(),
        "seApproval" : approvalValue,
        "seObservation" : observation,
      };
      if(!context.mounted) return null;
      var res =  await ServerRequest.postDataWithFile(urlEndPoint: url, body: json, context: context,
          keyWord: "attachFile",
          filePath: file.path.toString());
      if(res != null && res['status'] != null
          && res['status'] == true && res['message'] != null) {
        if(!context.mounted) return res;
        SnackBarSuccessWidget(context).show(message: res['message'].toString());
        return res;
      } else  if(res != null && res['status'] != null
          && res['status'] == false && res['error'] != null) {
        if(!context.mounted) return null;
        SnackBarErrorWidget(context).show(message: res['error'].toString());
        return null;
      } else  if(res != null && res['status'] != null
          && res['status'] == false && res['errors'] != null) {
        String response = res['errors'].toString();
        if(!context.mounted) return null;
        SnackBarErrorWidget(context).show(message: response.replaceAll("[{", "").toString()..replaceAll("}]", ""));
        return null;
      }else{
        if(!context.mounted) return null;
        SnackBarErrorWidget(context).show(message: "Internal Server Error");
        return null;
      }
    }catch(e){
      return null;
    }
  }

}