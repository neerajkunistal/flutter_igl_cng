import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/model/mother_station_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/model/station_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/model/driver_model.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/viewLcvTrack/domain/model/lcv_model.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/model/cng_station_route_model.dart';

class AddAssignmentHelper {
  static Future<dynamic> textFieldValidation(
      {required BuildContext context,
      required DriverModel driverData,
      required LcvTruckModel lcvData,
      required List<StationModel> stationList,
      required String totalQuantity,
      required MotherStationModel motherStationData,
      required String scheduleDateTime,
      required CngStationRouteModel cngStationRouteData}) async {
    try {
      if (motherStationData.id == null) {
        SnackBarErrorWidget(context)
            .show(message: "Please select mother station name");
        return false;
      } else if (driverData.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select driver");
        return false;
      } else if (lcvData.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select Lcv Track");
        return false;
      } else if (stationList.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please add Cng Station");
        return false;
      } else if (cngStationRouteData.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select route");
        return false;
      } else if (scheduleDateTime.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter schedule date time");
        return false;
      } else if (totalQuantity.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter total quantity");
        return false;
      }
      return true;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: e.toString());
      return false;
    }
  }

  static Future<dynamic> addAssignment(
      {required BuildContext context,
      required DriverModel driverData,
      required LcvTruckModel lcvData,
      required List<StationModel> stationList,
      required String totalQuantity,
      required LoginDataModel userData,
      required MotherStationModel motherStationData,
      required String scheduleDateTime,
      required CngStationRouteModel cngStationRouteData}) async {
    try {
      var firebaseToken = await FirebaseMessaging.instance.getToken();
      List<StationModel> _stationList = [];
      int sequence = 0;
      for (var stationData in stationList) {
        _stationList.add(StationModel(
          cngStation: stationData.cngStation,
          quantity: stationData.quantity,
          sequences: sequence++,
          cngStationRouteData: cngStationRouteData,
        ));
      }
      var json = {
        "login_id": userData.userId,
        "mother_station_id": motherStationData.id.toString(),
        "lcv_driver_id": driverData.id,
        "vehicle_id": lcvData.id,
        "scm": totalQuantity.toString(),
        "cng_station": List<dynamic>.from(_stationList.map((x) => x.toJson())),
        "mother_station_firebase_id": firebaseToken.toString(),
        "scheduleDateTime": scheduleDateTime,
        "assign_type": userData.roleType == RoleType.cngStation ? "1" : "0"
      };
      String url = APIs.addAssignmentApi;
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == 200 &&
            res['response'] != null) {
          SnackBarSuccessWidget(!context.mounted ? context : context)
              .show(message: res['response'].toString());
          return res;
        } else if (res["status"] != null &&
            res['status'] == 500 &&
            res['response'] != null) {
          SnackBarErrorWidget(!context.mounted ? context : context)
              .show(message: res['response'].toString());
          return null;
        } else {
          SnackBarErrorWidget(!context.mounted ? context : context)
              .show(message: res['response'].toString());
          return null;
        }
      } else {
        SnackBarErrorWidget(!context.mounted ? context : context)
            .show(message: "Internal Server Error ${APIs.registrationApi}");
        return null;
      }
    } catch (e) {
      SnackBarErrorWidget(!context.mounted ? context : context).show(message: e.toString());
      return null;
    }
  }

  static Future<dynamic> updateStatus(
      {required BuildContext context,
      required String statusId,
      required String assignmentId,
      required AssignmentModel assignmentData,
      required LoginDataModel userData,
      required File uploadTruckImage,
      required File uploadPhotoImage,
      String? remarks,
      File? uploadSlip,
      String? scmQuantity,
      required AssignmentStatus assignmentStatus}) async {
    try {
      String truckBase64Image = "";
      if (uploadTruckImage.path.isNotEmpty) {
        List<int> imageBytes = uploadTruckImage.readAsBytesSync();
        truckBase64Image = base64Encode(imageBytes);
      }

      String selfBase64Image = "";
      if (uploadPhotoImage.path.isNotEmpty) {
        List<int> imageBytes = uploadPhotoImage.readAsBytesSync();
        selfBase64Image = base64Encode(imageBytes);
      }

      String slipBase64Image = "";
      if (uploadSlip != null && uploadSlip.path.isNotEmpty) {
        List<int> imageBytes = uploadSlip.readAsBytesSync();
        slipBase64Image = base64Encode(imageBytes);
      }

      var json = {
        "login_id": userData.userId,
        "status": statusId,
        "assignment_id": assignmentId,
        "truck_photo": truckBase64Image,
        "self_photo": selfBase64Image,
        "slip_photo": slipBase64Image,
        "remarks": remarks ?? "",
        "scm_quantity": scmQuantity ?? "",
      };
      String url = APIs.updateAssignmentStatus;
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == 200 &&
            res['response'] != null) {
          SnackBarSuccessWidget(!context.mounted ? context : context)
              .show(message: res['response'].toString());
          return res;
        } else if (res["status"] != null &&
            res['status'] == 400 &&
            res['error'] != null) {
          SnackBarErrorWidget(!context.mounted ? context : context).show(message: res['error'].toString());
          return null;
        } else if (res["status"] != null &&
            res['status'] == 500 &&
            res['error'] != null) {
          SnackBarErrorWidget(!context.mounted ? context : context).show(message: res['error'].toString());
          return null;
        } else {
          SnackBarErrorWidget(!context.mounted ? context : context)
              .show(message: res['response'].toString());
          return null;
        }
      } else {
        SnackBarErrorWidget(!context.mounted ? context : context)
            .show(message: "Internal Server Error ${APIs.registrationApi}");
        return null;
      }
    } catch (e) {
      SnackBarErrorWidget(!context.mounted ? context : context).show(message: e.toString());
      return null;
    }
  }

  static Future<dynamic> fetchMotherStationData(
      {required BuildContext context, required LoginDataModel userData}) async {
    try {
      String url = APIs.getMotherStationsApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == true &&
            res['data'] != null) {
          return motherStationListResponse(res['data']);
        } else {
          SnackBarErrorWidget(!context.mounted ? context : context)
              .show(message: res['messages'].toString());
          return null;
        }
      } else {
        SnackBarErrorWidget(!context.mounted ? context : context)
            .show(message: "Internal Server Error ${APIs.getDriverApi}");
        return null;
      }
    } catch (e) {
      SnackBarErrorWidget(!context.mounted ? context : context)
          .show(message: "Internal server error ${APIs.getDriverApi}");
      return null;
    }
  }
}
