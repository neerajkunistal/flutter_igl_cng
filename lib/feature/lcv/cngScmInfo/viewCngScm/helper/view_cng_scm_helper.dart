import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/cngScmInfo/viewCngScm/domain/model/cng_scm_model.dart';

class ViewCngScmHelper {
  static Future<dynamic> fetchCngScmData(
      {required BuildContext context, required LoginDataModel userData}) async {
    try {
      String url = APIs.getCngScmInfoApi;
      var json = {
        "login_id": userData.userId,
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null &&
          res['status'] != null &&
          res['status'] == 200 &&
          res['response'] != null) {
        return cngScmListResponse(res['response']);
      }
      return null;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: "Internal server error");
      return null;
    }
  }
}
