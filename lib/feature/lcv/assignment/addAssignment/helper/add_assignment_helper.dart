import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/model/station_model.dart';

class AddAssignmentHelper {
  static Future<dynamic> textFieldValidation(
      {required BuildContext context,
      required DriverModel driverData,
      required LcvTruckModel lcvData,
      required List<StationModel> stationList,
      required String totalQuantity,
      required MotherStationModel motherStationData,
      required String scheduleDateTime,
      required CngStationRouteModel cngStationRouteData,
      required String lcvEntryTime,
      required CngStationModel cngStation,
      }) async {
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
      } else if (cngStation.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select CNG station");
        return false;
      } else if (lcvEntryTime.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter lcv entry time");
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
      required CngStationRouteModel cngStationRouteData,
      required CngStationModel cngStationData,
      required String lcvEntryTime,
      required String fillStartTime,
      required String flowMeterReadingOpen,
      required String flowMeterReadingClosed,
      required String fillEndTime,
      required String outPressure,
      required String lcvCondition,
      required String lcvRemark,
      required String driverToFitDrive,
      required String lcvLogBookCorrection,
      required String availabilityOfMobileWithDriver,
      required String unscheduledMaintenancePenaltyHours,
      required String scheduledMaintenancePenaltyHours,
      required List<File> fileList,
      required AssignmentModel assignmentData
      }) async {
    try {
     // var firebaseToken = await FirebaseMessaging.instance.getToken();
/*      List<StationModel> _stationList = [];
      int sequence = 0;
      for (var stationData in stationList) {
        _stationList.add(StationModel(
          cngStation: stationData.cngStation,
          quantity: stationData.quantity,
          sequences: sequence++,
          cngStationRouteData: cngStationRouteData,
        ));
      }*/
      Map<String, dynamic> json = MotherStationModel().postBodyParam(
        id: assignmentData.id != null ? assignmentData.id.toString() : "",
        lcvEntryTime: lcvEntryTime,
        availabilityOfMobileWithDriver: availabilityOfMobileWithDriver,
        cngStationData: cngStationData,
        driverData: driverData,
        driverToFitDrive: driverToFitDrive,
        fillEndTime: fillEndTime,
        fillStartTime: fillStartTime,
        flowMeterReadingClosed: flowMeterReadingClosed,
        flowMeterReadingOpen: flowMeterReadingOpen,
        lcvCondition: lcvCondition,
        lcvLogBookCorrection: lcvLogBookCorrection,
        lcvRemark: lcvRemark,
        lcvTruckData: lcvData,
        motherStationData: motherStationData,
        outPressure: outPressure,
        scheduledMaintenancePenaltyHours: scheduledMaintenancePenaltyHours,
        unscheduledMaintenancePenaltyHours: unscheduledMaintenancePenaltyHours
      );

      List<FileModel> files = [];
      int i = 0;
      for (var fileData in fileList) {
        if (fileData.path.isNotEmpty) {
          files.add(FileModel(
              name: "file", file: fileData, keyName: "attachFile[$i]"));
          i++;
        }
      }
      String url = APIs.addAssignmentApi;
      var res = await ServerRequest.postDataWithFile(urlEndPoint: url, body: json,
          fileList: files,
          context: !context.mounted ? context :context);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == true &&
            res['message'] != null) {
          SnackBarSuccessWidget(!context.mounted ? context : context)
              .show(message: res['message'].toString());
          return res;
        } else if (res["status"] != null &&
            res['status'] == false &&
            res['errors'] != null) {
          SnackBarErrorWidget(!context.mounted ? context : context)
              .show(message: res['errors'].toString());
          return null;
        } else {
          SnackBarErrorWidget(!context.mounted ? context : context)
              .show(message: res['errors'].toString());
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
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
