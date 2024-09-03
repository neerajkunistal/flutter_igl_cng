import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';

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
}
