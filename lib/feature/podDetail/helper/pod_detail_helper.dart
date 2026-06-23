import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';


class PodDetailHelper {

  static Future<dynamic> fetchData({required BuildContext context,
    required String podNumber, required IglModel iglData}) async {

    try{
      var body = {
        "Row": {
          "PONumber": podNumber.toString()
        }
      };
      var res =  await ServerRequest.iglPost(
          url: iglData.url ?? "",
          userName: iglData.userName.toString(),
          password: iglData.password.toString(), body: body);
      if(res != null && res['MT_PODetails_Res'] != null
          && res['MT_PODetails_Res']['Row'] != null) {
        return podDetailListResponse(res['MT_PODetails_Res']['Row']);
      }
    }catch(_){}
    return null;
  }
}