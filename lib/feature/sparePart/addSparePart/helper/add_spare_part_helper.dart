import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/uom_type_model.dart';

class AddSparePartHelper {

  static Future<dynamic> textFiledValidation({
    required SparesModel sparesData,
    required UomTypeModel  uomTypeData,
    required String qty,
    required String materialCode,
    required String remarkCode,
    required BuildContext context,
    }) async {

       try
       {
         if(sparesData.id == null){
           SnackBarErrorWidget(context).show(message: "Please select spare name");
           return false;
         }
         else if(qty.isEmpty){
           SnackBarErrorWidget(context).show(message: "Please enter ${sparesData.spareUom}");
           return false;
         }
         else if(materialCode.isEmpty){
           SnackBarErrorWidget(context).show(message: "Please enter material code");
           return false;
         }
         return true;
       }catch(_){}
      return false;
  }
}