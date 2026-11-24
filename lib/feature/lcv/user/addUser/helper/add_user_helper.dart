import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/model/cng_stattion_model.dart';
import 'package:flutter_igl_cng/feature/lcv/user/viewUser/domain/model/user_model.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/email_validation.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/phone_validation.dart';

class AddUserHelper {
  static Future<dynamic> textFieldValidation(
      {required BuildContext context,
      required String fullName,
      required String phoneNumber,
      required String email,
      required String address,
      required String city,
      required String district,
      required String state,
      required CngStationModel cngStationData}) async {
    try {
      if (cngStationData.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select CNG Station");
        return false;
      } else if (fullName.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter full name");
        return false;
      } else if (await PhoneValidation.checkPhoneValidation(
              phone: phoneNumber) ==
          false) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter valid phone number");
        return false;
      } else if (await EmailValidation.checkEmailValidation(emailId: email) ==
          false) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter valid email id");
        return false;
      } else if (address.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter address");
        return false;
      } else if (city.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter city/town");
        return false;
      } else if (district.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter district");
        return false;
      } else if (state.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter state");
        return false;
      }
      return true;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: e.toString());
      return false;
    }
  }

  static Future<dynamic> registration(
      {required BuildContext context,
      required String fullName,
      required String phoneNumber,
      String? email,
      required String address,
      required String city,
      required String district,
      required String state,
      required LoginDataModel userData,
      required CngStationModel cngStationData,
      required bool isEdit,
      required UserModel userModelData}) async {
    try {
      String url = APIs.addCngStationUser;
      var json = {
        "login_id": "${userData.userId}",
        "user_name": fullName,
        "address": address,
        "city": city,
        "district": district,
        "state": state,
        "user_email": email.toString(),
        "phone_number": phoneNumber,
        "user_type": "4",
        "cng_station_id": cngStationData.id.toString(),
        "password": phoneNumber,
        "is_edit": isEdit == true ? "1" : "",
        "id": isEdit == true ? userModelData.id.toString() : "",
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == 200 &&
            res['response'] != null) {
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
      SnackBarErrorWidget(context)
          .show(message: "INternal server error ${APIs.registrationApi}");
      return null;
    }
  }
}
