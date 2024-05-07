import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/action_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_part_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/uom_type_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

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

  static Future<dynamic> fetchUomData() async {

    try{
      String url =  APIs.getUomApi;
      var res   =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['status'] != null && res["status"] == true) {
        return uomTypeLIstResponse(res['data']);
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
    required String observation, required File file, required String date,
    required String time, required UomTypeModel uomTypeData, required String qty,
    required List<SparesPartModel>  sparesPartList,
  }) async {

    try{

       List<String> sparesId = [];
       List<String> uomTypeId = [];
       List<String> qty = [];

      for(var spartData in sparesPartList){
        if(spartData.sparesData!.id != null){
          sparesId.add(spartData.sparesData!.id.toString());
          uomTypeId.add(spartData.uomTypeData!.id != null ? spartData.uomTypeData!.id.toString() : "0");
          qty.add(spartData.qtyController!.text.toString().isNotEmpty ? spartData.qtyController!.text.toString() : "0");
        }
      }

      String url =  APIs.addMiComplaintApi;
      var json = {
        "description" : description,
        "action" : action.id != null ? action.id.toString() : "0",
        "amcStatus" : reviewComplaintData.amcStatus != null ? reviewComplaintData.amcStatus.toString() : "",
        "amcDate" : reviewComplaintData.amcDate !=null ? reviewComplaintData.amcDate.toString() : "",
        "complaintId" : reviewComplaintData.id != null ?  reviewComplaintData.id.toString() : "0",
        "spareId" :  sparesData.id != null ? sparesData.id.toString() : "0",
        "seApproval" : approvalValue.isEmpty ? "0" : approvalValue,
        "seObservation" : observation,
        "spares_arr" :  sparesId.isNotEmpty ? sparesId.toString().replaceAll("[", "").toString().replaceAll("]", "") : "0",
        "qty_arr" : qty.isNotEmpty ? qty.toString().replaceAll("[", "").toString().replaceAll("]", "") : "0",
        "uom_arr" : uomTypeId.isNotEmpty ?  uomTypeId.toString().replaceAll("[", "").toString().replaceAll("]", "") : "0",
        "maintenanceStartDateTime" : action.id.toString() == "1" ? "$date $time" : reviewComplaintData.maintenanceStartDate.toString(),
        "maintenanceEndtDateTime" : action.id.toString() == "3" ? "$date $time" : "",
        "maintenanceHoldDateTime" : action.id.toString() == "2" ? "$date $time" : "",
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