import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/complaint_type_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/equipment_type_model.dart';
import 'package:flutter_igl_cng/services/location/location_helper.dart';
import 'package:flutter_igl_cng/services/location/location_model.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/snack_bar_success_widget.dart';

class AddEquipmentComplaintHelper {

  static Future<dynamic> fetchComplaintTypeData() async {

     try{
        String url =  APIs.getComplaintTypeApi;
        var res   =  await ServerRequest.getData(urlEndPoint: url);
        if(res != null && res['status'] != null && res["status"] == true) {
          return complaintTypeListResponse(res['data']);
        }
        return null;
     }catch(e){
       return null;
     }
  }


  static Future<dynamic> fetchEquipmentTypeData() async {

    try{
      String url =  APIs.getEquipmentApi;
      var res   =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['status'] != null && res["status"] == true) {
        return equipmentTypeListResponse(res['data']);
      }
      return null;
    }catch(e){
      return null;
    }
  }

  static Future<dynamic> submitData({required BuildContext context,
  required ComplaintTypeModel  complaintTypeData,
  required EquipmentTypeModel equipmentTypeData,
  required String description, required String name, required File file,
  required String date, required String time,
  }) async {

       try{
         String url =  APIs.addComplaintApi;
         var json = {
             "complaintTypeId":  complaintTypeData.id != null ?  complaintTypeData.id.toString() : "",
             "equipmentId" : equipmentTypeData.id != null ? equipmentTypeData.id.toString() : "",
             "description" : description,
             "reportBy" : name,
             "complaintDateTime" : "$date $time",
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