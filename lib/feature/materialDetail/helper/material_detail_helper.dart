import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class MaterialDetailHelper {

  static Future<dynamic> fetchIglApiData({required String apiType}) async {
    try {
      String url = APIs.getIglApi + "?api_type=$apiType";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return iglApiData(res['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchData({required BuildContext context,
    required String materialNo, required IglModel iglData}) async {

    try{
      var body = {
        "Row": {
          "MaterialNo": materialNo.toString()
        }
      };
      var res =  await ServerRequest.iglPost(
          url: iglData.url ?? "",
          userName: iglData.userName.toString(),
          password: iglData.password.toString(), body: body);
      if(res != null && res['MT_MaterialDetails_Res'] != null
          && res['MT_MaterialDetails_Res']['Row'] != null) {
        return materialDetailListResponse(res['MT_MaterialDetails_Res']['Row']);
      }
    }catch(_){}
    return null;
  }
}