import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/dashboard/domain/model/file_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/cngFillingForm/domain/bloc/cng_filling_form_bloc.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/message_box_pop_button_widget.dart';

class CngFillingStationHelper {
  static Future<dynamic> textFieldValidation(
      {required BuildContext context,
      required String recievedScmQuantity,
      required String currentScmQuantity,
      required String drivingLicence,
      required String truckNumber,
      required String remark}) async {
    try {
      if (recievedScmQuantity.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter received quantity ");
        return false;
      } else if (currentScmQuantity.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter current quantity ");
        return false;
      } else if (drivingLicence.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter driving licence number ");
        return false;
      } else if (truckNumber.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter truck number ");
        return false;
      } else if (remark.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter remark");
        return false;
      }
      return true;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: e.toString());
      return false;
    }
  }

  static Future<dynamic> updateCngFillingStationList(
      {required BuildContext context,
      required LoginDataModel userDat,
      required AssignmentModel assignmentData,
      required String scmQuantity,
      required String receivedScmQuantity,
      required String drivingLicence,
      required String truckNumber,
      required String remark,
      required bool isMismatch,
      required String arrivalTime,
      required String lcvPointTime,
      required String flowMeterReadingOpen,
      required String flowMeterReadingClosed,
      required String inPressure,
      required String outPressure,
      required String filEndTime,
      required List<File> fileList,
      required String lcvCondition,
      required String driverUniform,
      }) async {
    try {
      LoginDataModel userData =  UserInfo.instance!.userData!;
      List<FileModel> files = [];
      int i = 0;
      for (var fileData in fileList) {
        if (fileData.path.isNotEmpty) {
          files.add(FileModel(
              name: "file", file: fileData, keyName: "attachFile[$i]"));
          i++;
        }
      }
      String url = APIs.updateScmApi;
      var json = {
        "id" : assignmentData.dbCngStationList!.isNotEmpty
            ? assignmentData.dbCngStationList![0].id.toString() : "",
        "mb_manager_entries_id" : assignmentData.id.toString(),
        "db_cng_station_id" : assignmentData.dbCngStationId.toString(),
        "arrival_time" : arrivalTime,
        "lcv_point_time" : lcvPointTime,
        "flow_meter_reading_opening" : flowMeterReadingOpen,
        "in_pressure" : inPressure,
        "flow_meter_reading_closing" : flowMeterReadingClosed,
        "out_pressure" : outPressure,
        "fill_end_time" : filEndTime,
        "lcv_number" : assignmentData.lcvNumber.toString(),
        "lcv_condition" : lcvCondition,
        "driver_not_wearing_uniform" : driverUniform,
        "lcv_condition_remarks" : remark,
        "lcv_id" : assignmentData.lcvId.toString(),
        "created_by" : userData.userId.toString(),
        "driver_id" : assignmentData.driverId.toString(),
      };
      var res = await ServerRequest.postDataWithFile(urlEndPoint: url, body: json,
          context: context, fileList: files);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == true &&
            res['message'] != null) {
          SnackBarSuccessWidget(context)
              .show(message: res['message'].toString());
          return res;
        } else if (res["status"] != null &&
            res['status'] == false &&
            res['errors'] != null) {
          SnackBarErrorWidget(context)
              .show(message: res['errors'].toString());
          return null;
        } else if (res["status"] != null &&
            res['status'] == false &&
            res['response'] != null) {
          SnackBarErrorWidget(context)
              .show(message: res['response'].toString());
          return null;
        } else {
          SnackBarErrorWidget(context)
              .show(message: res['response'].toString());
          return null;
        }
      } else {
        SnackBarErrorWidget(context)
            .show(message: "Internal Server Error ${APIs.registrationApi}");
        return null;
      }
    } catch (e) {
      SnackBarErrorWidget(context).show(message: "Internal server error");
      return null;
    }
  }
}
