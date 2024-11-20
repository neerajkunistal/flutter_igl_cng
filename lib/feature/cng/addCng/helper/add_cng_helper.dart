import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/model/category_model.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/model/cr_stattion_model.dart';
import 'package:flutter_igl_cng/feature/dashboard/domain/model/file_model.dart';

class AddCngHelper {
  static Future<dynamic> textFiledValidation(
      {required BuildContext context,
      required CategoryModel categoryData,
      required String date,
      required String time,
      required String description,
      required String reportedBy,
      required List<File> fileList}) async {
    try {
      if (categoryData.name == null) {
        SnackBarErrorWidget(context).show(message: "Please select category");
        return false;
      } else if (date.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please select date");
        return false;
      }
      // else if (time.isEmpty) {
      //   SnackBarErrorWidget(context).show(message: "Please select time");
      //   return false;
      // }
      else if (description.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Enter description");
        return false;
      } else if (reportedBy.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Enter reported by");
        return false;
      } else if (fileList[0].path.isEmpty && fileList[1].path.isEmpty
          && fileList[2].path.isEmpty && fileList[3].path.isEmpty) {
        SnackBarErrorWidget(context).show(message: "select photo");
        return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<dynamic> fetchCategory() async {
    try {
      String url = APIs.getCivilCategoryApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['data'] != null) {
        return categoryListResponse(res['data']);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<dynamic> fetchCrStation() async {
    try {
      String url = APIs.getCrStationApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['data'] != null) {
        return crStationData(res['data']);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<dynamic> submitData({
    required BuildContext context,
    required CategoryModel categoryData,
    required CrStationModel crStationData,
    required String date,
    required String time,
    required String description,
    required String reportedBy,
    required String reportedByPhone,
    required List<File> fileList,
    required LoginDataModel userData,
  }) async {
    try {
      String url = APIs.addCivilComplaintApi;
      List<FileModel> files = [];
      int i = 0;
      for (var fileData in fileList) {
        if (fileData.path.isNotEmpty) {
          files.add(FileModel(
              name: "file", file: fileData, keyName: "attachFile[$i]"));
          i++;
        }
      }
      var json = {
        "controlRoomId": crStationData.controlRoomId.toString(),
        "cngStationId": crStationData.cngStationId.toString(),
        "categoryId": categoryData.id.toString(),
        "description": description,
        "incidentDateTime": "$date $time",
        "reportBy": reportedBy,
        "reportByPhone": reportedByPhone,
      };
      var res = await ServerRequest.postDataWithFile(
          urlEndPoint: url, body: json, fileList: files, context: context);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['message'] != null) {
        if (!context.mounted) return res;
        SnackBarSuccessWidget(context).show(message: res['message']);
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
              .replaceAll("}]", ""));
        return null;
      } else {
        if (!context.mounted) return null;
        SnackBarErrorWidget(context).show(message: "Internal Server Error");
        return null;
      }
    } catch (e) {
      if (!context.mounted) return null;
      SnackBarErrorWidget(context).show(message: e.toString());
      return null;
    }
  }
}
