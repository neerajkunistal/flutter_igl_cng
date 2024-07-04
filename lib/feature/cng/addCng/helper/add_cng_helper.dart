import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/model/category_model.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/model/cr_stattion_model.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';

class AddCngHelper {

  static Future<dynamic> textFiledValidation({required BuildContext context,
    required CategoryModel categoryData,
    required String date,
    required String time,
    required String description,
    required String reportedBy,
    required List<File> fileList
  }) async {
    try{
         if(categoryData.name == null){
           SnackBarErrorWidget(context).show(message: "Please select category");
           return false;
         } else if(date.isEmpty){
           SnackBarErrorWidget(context).show(message: "Please select date");
           return false;
         } else if(time.isEmpty){
           SnackBarErrorWidget(context).show(message: "Please select time");
           return false;
         } else if(description.isEmpty){
           SnackBarErrorWidget(context).show(message: "Enter description");
           return false;
         } else if(reportedBy.isEmpty){
           SnackBarErrorWidget(context).show(message: "Enter reported by");
           return false;
         } else if(fileList.isEmpty){
           SnackBarErrorWidget(context).show(message: "select photo");
           return false;
         }
         return true;
    }catch(_){
      return false;
    }

  }

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

  static Future<dynamic> submitData({required BuildContext context,
    required CategoryModel categoryData,
    required String date,
    required String time,
    required String description,
    required String reportedBy,
    required List<File> fileList,
    required LoginDataModel userData,
  }) async {
    try{

      return null;
    }catch(e){
      SnackBarErrorWidget(context).show(message: e.toString());
      return null;
    }

  }

}