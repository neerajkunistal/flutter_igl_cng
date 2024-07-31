import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scarp_unit_type_model.dart';

class ScrapHelper {

  static Future<dynamic> fetchUnitType() async {
    try{
      String url =  APIs.getUnitTypeApi;
      var res =  await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return scrapUnitListResponse(res['data']);
      }
    }catch(_){
      return null;
    }
  }
}