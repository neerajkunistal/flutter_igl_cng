import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scarp_unit_type_model.dart';

class ScrapHelper {

  static Future<dynamic> textFiledValidation({
    required BuildContext context,
    required String srNumber,
    required String description,
    required ScrapUnitTypeModel scrapUnitTypeData,
    required String unit,
  }) async {
    try
    {
        if(srNumber.isEmpty){
          SnackBarErrorWidget(context).show(message: "Please enter sr number");
          return false;
        }
        else if(description.isEmpty){
          SnackBarErrorWidget(context).show(message: "Please enter description");
          return false;
        }
        else if(scrapUnitTypeData.id == null){
          SnackBarErrorWidget(context).show(message: "Please select unit type");
          return false;
        }
        else if(unit.isEmpty){
          SnackBarErrorWidget(context).show(message: "Please enter unit");
          return false;
        }
        return true;
    }catch(_){}
    return false;
  }

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