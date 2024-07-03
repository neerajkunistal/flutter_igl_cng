import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/model/category_model.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/model/cr_stattion_model.dart';

class AddCngHelper {

  static Future<dynamic> fetchCategory() async {
    try{
        String url =  APIs.getCivilCategoryApi;
        var res =  await  ServerRequest.getData(urlEndPoint: url);
        if(res != null && res['status'] != null
            && res['status'] == true && res['data'] != null) {
           return categoryListResponse(res['data']);
        }
        return null;
    }catch(_){
      return null;
    }
  }

  static Future<dynamic> fetchCrStation() async {
    try{
      String url =  APIs.getCrStationApi;
      var res =  await  ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['status'] != null
          && res['status'] == true && res['data'] != null) {
        return crStationData(res['data']);
      }
      return null;
    }catch(_){
      return null;
    }
  }
}