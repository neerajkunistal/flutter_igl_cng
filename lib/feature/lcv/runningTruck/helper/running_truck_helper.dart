import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/runningTruck/domain/model/running_truck_model.dart';
import 'package:flutter_igl_cng/feature/lcv/runningTruck/domain/model/stations_point_model.dart';

class RunningTruckHelper {
  static Future<dynamic> updateScm(
      {required BuildContext context,
      required AssignmentModel assignmentData,
      required LoginDataModel userData,
      required String recievedScm,
      required String vehicleNo,
      required String driverLicence,
      required String remark}) async {
    try {} catch (e) {
      SnackBarErrorWidget(context).show(message: "Internal server error");
      return null;
    }
  }

  static Future<dynamic> fetchRunningTruck(
      {required BuildContext context}) async {
    try {
      var url = Uri.parse("https://www.ctyf.co.in/api/grouplevelvehiclelatestinfo?token=84F2A9BCF2&group=IndraprasthaGasLimited");
      var res = await ServerRequest.getGoogleData(url: url);
      if (res != null && res['Vehicle'] != null) {
        return runningTruckListResponse(res['Vehicle']);
      }
    } catch (e) {
      SnackBarErrorWidget(!context.mounted ? context : context).show(message: e.toString());
    }
    return null;
  }

  static Future<dynamic> fetchStationPointsData(
      {required BuildContext context}) async {
    try {
      var url = APIs.getMotherStationAndDougthStationPointsApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null) {
        return stationPointListResponse(res);
      }
    } catch (e) {
      SnackBarErrorWidget(!context.mounted ? context : context).show(message: e.toString());
    }
    return null;
  }
}
