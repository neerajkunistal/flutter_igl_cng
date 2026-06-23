import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
class ViewCvComplaintHelper {

  static Future<dynamic> fetchMeasureTypeData() async {

    try{
      String url =  APIs.getMeasurementsApi;
      var res =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['status'] != null
          && res['status'] == true && res['data'] != null){
         return measureTypeListResponse(res['data']);
      }
      return null;
    }catch(_){
      return null;
    }
  }

  static Future<dynamic> addCivilVendorComplaintApi(
      {String? fromDate, String? toDate}) async {
    try {
      String url = APIs.addCivilVendorComplaintApi +
          "?fromDate=${fromDate ?? ""}&toDate=${toDate ?? ""}";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['data'] != null) {
        return cngListResponse(res['data']);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<dynamic> addEstimateData(
      {required CngModel cngData,
      required String amount,
      required BuildContext context,
      required MeasureTypeModel measureTypeData,
      required String particular,
      required String measurementValue,
      required List<ParticularModel> particularList,
      required List<File> file}) async {
    try {

      List<FileModel> files = [];
      Map<String, String> particularJson = {};

      int i = 0;
      int imageId = 0;
      for(var particularData in particularList){
        var jsonValue = {
          "particulars[$i]" : "${particularData.name}",
          "measurement_unit_id[$i]" : particularData.measureTypeData!.id != null
              ? particularData.measureTypeData!.id.toString() : "0",
          "measurement_value[$i]" : "${particularData.measurementValue}",
          "unit_names[$i]" : particularData.measureTypeData!.unitData!.name.toString(),
        };
        particularJson.addAll(jsonValue);
        for (var fileData in particularData.fileList!) {
          if (fileData.path.isNotEmpty) {
            files.add(FileModel(
                name: "file", file: fileData, keyName: "estimateFile[$imageId]"));
          }
          imageId++;
        }
        i++;
      }

      String url = APIs.addEstimateApi;
      var json = {
        "complaintId": cngData.id.toString(),
        "estimateCost": amount.toString(),
      };
      particularJson.addAll(json);
      var res = await ServerRequest.postDataWithFile(
          urlEndPoint: url,
          body: particularJson,
          fileList: files,
          context: context);
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
    } catch (_) {
      return null;
    }
  }


  static Future<dynamic> addMeasurementData(
      {required CngModel cngData,
        required String amount,
        required BuildContext context,
        required File measurementSheetFile,
        required List<File>  measurementFileList,
        required MeasurementType measurementType,
      }) async {
    try {
      String url = APIs.addMeasurementApi;

      List<FileModel> files = [];
      int i = 0;
      for (var fileData in measurementFileList) {
        if (fileData.path.isNotEmpty) {
          files.add(FileModel(
              name: "file", file: fileData, keyName: "measurementPhoto[$i]"));
          i++;
        }
      }

      if(measurementSheetFile.path.isNotEmpty){
        files.add(FileModel(
            name: "file", file: measurementSheetFile, keyName: "measurementSheet"));
      }
      var json = {
        "complaintId": cngData.id.toString(),
        "measurementSheetType" : measurementType == MeasurementType.pre ? "pre"
            : measurementType == MeasurementType.post ? "post" : "sheet"
      };
      var res = await ServerRequest.postDataWithFile(
          urlEndPoint: url,
          body: json,
          fileList: files,
          context: context);
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
    } catch (_) {
      return null;
    }
  }
}
