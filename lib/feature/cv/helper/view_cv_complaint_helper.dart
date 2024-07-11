import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';

class ViewCvComplaintHelper {
  static Future<dynamic> addEstimateData({
    required CngModel cngData, required String amount,
    required BuildContext context, required File file}) async {
    try{
      String url =  APIs.addEstimateApi;
      var json =  {
        "complaintId" : cngData.id.toString(),
        "estimateCost" : amount.toString(),
      };
      var res =  await ServerRequest.postDataWithFile(
          urlEndPoint: url, body: json, filePath: file.path, keyWord: "estimateFile",
          context: context);
      if(res != null && res['status'] != null
          && res['status'] == true && res['message'] != null){
        if (!context.mounted) return res;
        SnackBarSuccessWidget(context).show(message:  res['message']);
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
              ..replaceAll("}]", ""));
        return null;
      } else {
        if (!context.mounted) return null;
        SnackBarErrorWidget(context).show(message: "Internal Server Error");
        return null;
      }
    }catch(_){
      return null;
    }
  }
}