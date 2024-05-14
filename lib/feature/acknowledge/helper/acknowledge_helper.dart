import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/aasign_type_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/vendor_model.dart';

class AcknowledgeHelper {

  static Future<dynamic> textFieldValidationCheck({
    required BuildContext context,
    required VendorModel vendorData,
    required AcknowledgeUserModel userData,
    required AssignTypeModel assignTypeData
}) async {

     try{
         if(assignTypeData.id == null){
           SnackBarErrorWidget(context).show(message: "Please select assign type");
           return false;
         } else if(assignTypeData.id.toString() == "2" && userData.id == null){
           SnackBarErrorWidget(context).show(message: "Please select user");
           return false;
         } else if(assignTypeData.id.toString() == "3" && vendorData.id == null){
           SnackBarErrorWidget(context).show(message: "Please select vendor");
           return false;
         }
         return true;
     }catch(_){}
  }

  static Future<dynamic> fetchVendorData() async {
    try{
        String url =  APIs.getVendorApi;
        var res =  await ServerRequest.getData(urlEndPoint: url);
        if(res != null && res['status'] != null && res['status'] == true){
           return vendorListResponse(res['data']);
        }
    }catch(_){}
    return null;
  }

  static Future<dynamic> assignUser({required BuildContext context,
  required AcknowledgeModel acknowledgeData,
   required AcknowledgeUserModel userModel,
   required VendorModel vendorData,
   required AssignTypeModel assignTypeData,
   required String remark
  }) async {

    try{
       String url = APIs.assignComplaintApi;
       var json = {
         "complaintId" : acknowledgeData.id.toString(),
         "assignType" : assignTypeData.id.toString(),
         "assignTo" : assignTypeData.id.toString() == "1"
             ? "1"
             : assignTypeData.id.toString() == "2"
             ? userModel.id.toString()
             : assignTypeData.id.toString() == "3"
             ? vendorData.id.toString() : "0",
         "shiftEngRemarks" : remark,
       };
        var res =  await ServerRequest.postData(urlEndPoint: url, body: json);
        if(res != null && res['status'] != null
             && res['status'] == true && res['message'] != null) {
          if(!context.mounted) return res;
          SnackBarSuccessWidget(context).show(message: res['message'].toString());
          return res;
        } else if (res != null &&  res['message'] != null) {
          if(!context.mounted) return false;
          SnackBarErrorWidget(context).show(message: res['message'].toString());
          return false;
        }
    }catch(_){
      if(!context.mounted) return false;
      SnackBarErrorWidget(context).show(message: "Internal server error");
    }
  }
}
