import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';

class ViewCngHelper {

  static Future<dynamic> fetchCngCivilData() async {

    try{
       String url =  APIs.addCivilComplaintApi;
       var res =  await ServerRequest.getData(urlEndPoint: url);
       if(res !=  null && res['status'] != null
            && res['status'] == true && res['data'] != null) {
          return cngListResponse(res['data']);
       }
       return null;
    }catch(_){
      return null;
    }
  }
}