import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class ComplaintNumberHelper {

  static Future<dynamic> addComplaintNumber({
    required BuildContext context,
    required String assignType,
    required String complaintId,
    required String complaintNumber
  }) async {

    try
    {
      String url =  APIs.addComplaintNumberApi;
      var json = {
        "complaintId" : complaintId,
        "assignType" : assignType,
        "vendorComplaintNumber" : complaintNumber
      };
      var res =  await ServerRequest.postData(urlEndPoint: url, body:json);
      if(res != null && res ['status'] != null && res['status'] == true) {
        SnackBarSuccessWidget(!context.mounted ? context : context).show(message: res['message'].toString());
        return res;
      }  else if(res != null && res['message'] != null) {
        SnackBarErrorWidget(!context.mounted ? context : context).show(message: res['message'].toString());
      }
    }catch(_){}
    return null;
  }
}