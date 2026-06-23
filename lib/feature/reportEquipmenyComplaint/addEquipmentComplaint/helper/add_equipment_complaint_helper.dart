import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class AddEquipmentComplaintHelper {
// Helper for safe comparison
  static bool _isDryOut(GeneralComplaintModel generalComplaintData) =>
      generalComplaintData.name?.toString().trim().toLowerCase() == "dry out";
  static bool _hasRealFile(List<File> files) =>
      files.any((f) => f.path.isNotEmpty);
  static Future<bool> textFieldValidation({
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
    final String complaintId = complaintTypeData.id?.toString() ?? "";

    if (complaintTypeData.id == null) {
      return _showError(context, "Please select complaint type");
    }
    if (complaintId == "2" && equipmentTypeData.id == null) {
      return _showError(context, "Please select equipment");
    }
    if (complaintId == "1" && generalComplaintData.id == null) {
      return _showError(context, "Please select general");
    }
    if (date.isEmpty) {
      return _showError(context, "Please enter date");
    }
    if (time.isEmpty) {
      return _showError(context, "Please enter time");
    }
    if (name.isEmpty) {
      return _showError(context, "Please enter reported by name");
    }

    // ✅ Dry Out photo check
    if (_isDryOut(generalComplaintData) && !_hasRealFile(file)) {
      return _showError(context, "Please upload at least one photo for Dry Out complaint");
    }

    return true;
  }

// Helper to show snackbar and return false
  static bool _showError(BuildContext context, String message) {
    SnackBarErrorWidget(context).show(message: message);
    return false;
  }

  static Future<dynamic> fetchComplaintTypeData() async {
    try {
      String url = APIs.getComplaintTypeApi;
      print("url-->${url}");
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

  static Future<List<StationTypeModel>?> fetchCRStationData() async {
    try {
      String url = APIs.getCRStationApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] == true && res['data'] != null) {
        return stationTypeListResponse(res['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("fetchCRStationData : - ---- ${e.toString()}");
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
    required String lcvCascade,
    required List<File> file,
    required List<File> videoFiles,
    required String date,
    required String time,
    required String generalDescription,
    required GeneralComplaintModel generalComplaintData,
    required StationTypeModel controlRoomData,
    required StationTypeModel cngStationData,
  }) async {
    try {
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;
      String url = APIs.addComplaintApi;
      print("url-->${url}");
      Map<String, String> json = {
        "complaintTypeId": complaintTypeData.id != null ? complaintTypeData.id.toString() : "0",
        "equipmentId": equipmentTypeData.id != null ? equipmentTypeData.id.toString() : "0",
        "description": description,
        "reportBy": name,
        "lcv_cascade_pressure": lcvCascade,
        "complaintDateTime": "$date $time",
        "generalComplaintDesc": generalDescription,
        "generalComplaintId": generalComplaintData.id != null ? generalComplaintData.id.toString() : "0",
        // "control_room_id": controlRoomData.controlRoomId != null ? controlRoomData.controlRoomId.toString() : "0",
        // "cng_station_id": cngStationData.cngStationId != null ? cngStationData.cngStationId.toString() : "0",
      };
      if (userData.roleType == RoleType.stationUserManager) {
        json["control_room_id"] = controlRoomData.controlRoomId.toString();
      }
      if (userData.roleType == RoleType.stationUserManager) {
        json["cng_station_id"] = cngStationData.cngStationId.toString();
      }
      print("url-->${url}");
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
          fileList.add(FileModel(name: "file", file: fileData, keyName: "videoFile"));
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
