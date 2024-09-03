import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/snack_bar_success_widget.dart';

class AddCngStationHelper {
  static Future<dynamic> textFieldValidation(
      {required BuildContext context,
      required String stationCode,
      required String stationName,
      required String address,
      required String city,
      required String state,
      required String district,
      required String pincode,
      required String officerName,
      required String phoneNumber,
      required String email}) async {
    try {
      if (stationCode.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter station code");
        return false;
      } else if (stationName.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter station name");
        return false;
      } else if (address.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter address");
        return false;
      } else if (city.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter city/town");
        return false;
      } else if (state.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter state");
        return false;
      } else if (district.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter district");
        return false;
      } else if (pincode.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter valid address");
        return false;
      } else if (officerName.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter officer name");
        return false;
      } else if (phoneNumber.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter phone number");
        return false;
      }
      return true;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: e.toString());
      return false;
    }
  }

  static Future<dynamic> cngStationRegistrationSubmit(
      {required BuildContext context,
      required String stationCode,
      required String stationName,
      required String address,
      required String city,
      required String state,
      required String district,
      required String pincode,
      required String officerName,
      required String phoneNumber,
      required String email,
      required dynamic lat,
      required dynamic long,
      required LoginDataModel userData,
      required bool isEdit,
      required String stationId}) async {
    try {
      String url = APIs.cngStationRegistrationApi;
      var json = {
        "id": stationId,
        "login_id": userData.userId,
        "station_code": stationCode,
        "station_name": stationName,
        "address": address,
        "city": city,
        "state": state,
        "district": district,
        "lat": lat,
        "long": long,
        "pincode": pincode,
        "officer_name": officerName,
        "company_email": email,
        "phone_number": phoneNumber,
        "password": phoneNumber,
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
            res['response'] != null) {
          SnackBarErrorWidget(context)
              .show(message: res['response'].toString());
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
      SnackBarErrorWidget(context).show(message: e.toString());
      return null;
    }
  }
}
