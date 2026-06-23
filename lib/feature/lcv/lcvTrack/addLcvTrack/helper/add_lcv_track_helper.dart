import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class AddLcvTrackHelper {
  static Future<dynamic> textFieldValidation(
      {required BuildContext context,
      required String vehicleCompany,
      required String vehicleName,
      required String vehicleNumber,
      required String engineNumber,
      required String chassisNumber,
      required String fuelType,
      required String average}) async {
    try {
      if (vehicleCompany.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter vehicle Company");
        return false;
      } else if (vehicleName.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter vehicle Name");
        return false;
      } else if (vehicleNumber.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter vehicle number");
        return false;
      } else if (engineNumber.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter engine number");
        return false;
      } else if (chassisNumber.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter chassis number");
        return false;
      } else if (average.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter vehicle average");
        return false;
      } else if (fuelType.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter select fuel type");
        return false;
      }
      return true;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: e.toString());
      return false;
    }
  }

  static Future<dynamic> submitVehicleData(
      {required BuildContext context,
      required String vehicleCompany,
      required String vehicleName,
      required String vehicleNumber,
      required String engineNumber,
      required String chassisNumber,
      required String fuelType,
      required String average,
      required LoginDataModel userData,
      required LcvTruckModel lcvTruckData,
      required bool isEdit}) async {
    try {
      String url = APIs.addLcvTruckApi;
      var json = {
        "id": isEdit == true ? lcvTruckData.id.toString() : "",
        "login_id": userData.userId,
        "vehicle_company": vehicleCompany,
        "vehicle_name": vehicleName,
        "vehicle_no": vehicleNumber,
        "engine_number": engineNumber,
        "chassis_number": chassisNumber,
        "fuel_type": fuelType,
        "average": average,
        "is_edit": isEdit == true ? "1" : "0"
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == 200 &&
            res['response'] != null) {
          SnackBarSuccessWidget(context)
              .show(message: res['response'].toString());
          return res;
        } else if (res["status"] != null &&
            res['status'] == 500 &&
            res['error'] != null) {
          SnackBarErrorWidget(context).show(message: res['error'].toString());
          return null;
        } else {
          SnackBarErrorWidget(context).show(message: res['error'].toString());
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
