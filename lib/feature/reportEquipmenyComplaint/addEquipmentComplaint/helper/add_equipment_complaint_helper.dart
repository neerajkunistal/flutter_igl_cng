import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/dashboard/domain/model/file_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/equipment_model.dart';
import 'package:flutter_igl_cng/services/firebase/notification_helper.dart';
import 'package:flutter_igl_cng/services/firebase/page_id.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class AddEquipmentComplaintHelper {

  static Future<dynamic> textFieldValidation({
    required BuildContext context,
    required ComplaintTypeModel complaintTypeData,
    required EquipmentTypeModel equipmentTypeData,
    required String description,
    required String name,
    required List<File> file,
    required List<File> videoFiles,
    required String date,
    required String time,
    required String generalDescription,
    required GeneralComplaintModel generalComplaintData,
  }) async {

    try{
      if(complaintTypeData.id == null){
        SnackBarErrorWidget(context).show(message: "Please select complaint type");
        return false;
      }
      else if(complaintTypeData.id.toString() == "2" && equipmentTypeData.id == null){
        SnackBarErrorWidget(context).show(message: "Please select equipment");
        return false;
      }
      else if(complaintTypeData.id.toString() == "1" && generalComplaintData.id == null){
        SnackBarErrorWidget(context).show(message: "Please select general");
        return false;
      }
      else if(time.isEmpty){
        SnackBarErrorWidget(context).show(message: "Please enter time");
        return false;
      }
      else if(name.isEmpty){
        SnackBarErrorWidget(context).show(message: "Please enter reported by name");
        return false;
      }
      return true;
    }catch(_){}
    return false;
  }

  static Future<dynamic> fetchComplaintTypeData() async {
    try {
      String url = APIs.getComplaintTypeApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return complaintTypeListResponse(res['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("fetch complaint type data : - ---- ${e.toString()}");
      }
      return null;
    }
  }

  static Future<dynamic> fetchEquipmentTypeData({String? complaintId}) async {
    try {
      String url = APIs.getEquipmentApi +"/$complaintId";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true && res['EqpRecord']  != null) {
        List<EquipmentModel> equipmentList = equipmentListResponse(res['EqpRecord']);
        List<EquipmentTypeModel> equipmentTypeList = equipmentTypeListResponse(res['data']);
        for(var equipmentData in equipmentList)
        {
          equipmentData.equipmentTypeList!.addAll(equipmentTypeList);
        }
        return equipmentList;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("fetch equipment type data : - ---- ${e.toString()}");
      }
      return null;
    }
  }

  static Future<dynamic> fetchGeneralComplaintData() async {
    try {
      String url = APIs.getGeneralComplaintApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return generalComplaintListResponse(res['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("fetch general complaint type data : - ---- ${e.toString()}");
      }
      return null;
    }
  }

  static Future<dynamic> submitData({
    required BuildContext context,
    required ComplaintTypeModel complaintTypeData,
    required EquipmentTypeModel equipmentTypeData,
    required String description,
    required String name,
    required List<File> file,
    required List<File> videoFiles,
    required String date,
    required String time,
    required String generalDescription,
    required GeneralComplaintModel generalComplaintData,
  }) async {
    try {
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;
      String url = APIs.addComplaintApi;

      var json = {
        "complaintTypeId": complaintTypeData.id != null
            ? complaintTypeData.id.toString()
            : "0",
        "equipmentId": equipmentTypeData.id != null
            ? equipmentTypeData.id.toString()
            : "0",
        "description": description,
        "reportBy": name,
        "complaintDateTime": "$date $time",
        "generalComplaintDesc": generalDescription,
        "generalComplaintId": generalComplaintData.id != null
            ? generalComplaintData.id.toString()
            : "0",
      };

      List<FileModel> fileList = [];
      int i = 0;
      for (var fileData in file) {
        if (fileData.path.isNotEmpty) {
          print(fileData.path.toString());
          fileList.add(FileModel(
              name: "file", file: fileData, keyName: "attachFile[$i]"));
          i++;
        }
      }

      for (var fileData in videoFiles) {
        if (fileData.path.isNotEmpty) {
          fileList.add(
              FileModel(name: "file", file: fileData, keyName: "videoFile"));
        }
      }
      if (!context.mounted) return null;
      var res = await ServerRequest.postDataWithFile(
          urlEndPoint: url, body: json, fileList: fileList, context: context);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['message'] != null) {
        NotificationHelper.sendNotification(
            firebaseDeviceList:
                BlocProvider.of<HomeBloc>(!context.mounted ? context : context)
                    .firebaseDeviceList,
            title: "Complain new ${userData.stationName}",
            body: description,
            pageId: PageId.addComplaint,
            complaintId: "",
            dateTime: DateTime.now().toString());
        if (!context.mounted) return res;
        SnackBarSuccessWidget(context).show(message: res['message'].toString());
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
      if (kDebugMode) {
        print("submit complaint data : - ---- ${e.toString()}");
      }
      return null;
    }
  }
}
