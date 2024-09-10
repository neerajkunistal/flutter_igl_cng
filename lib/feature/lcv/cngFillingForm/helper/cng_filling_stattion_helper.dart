import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/cngFillingForm/domain/bloc/cng_filling_form_bloc.dart';
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

  static Future<dynamic> fetchCngFillingStationList(
      {required BuildContext context,
      required LoginDataModel userDat,
      required AssignmentModel assignmentData,
      required String scmQuantity,
      required String receivedScmQuantity,
      required String drivingLicence,
      required String truckNumber,
      required String remark,
      required bool isMismatch}) async {
    try {
      String url = APIs.updateScmApi;
      var json = {
        "login_id": userDat.userId.toString(),
        "assignment_id": assignmentData.id.toString(),
        "scm_quantity": scmQuantity,
        "recieved_scm": receivedScmQuantity,
        "remarks": remark,
        "driving_licence": drivingLicence,
        "lcv_vehicle_number": truckNumber,
        "is_mismatch": isMismatch == true ? "1" : "0"
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
            res['status'] == 400 &&
            res['response'] != null) {
          showDialog(
              context: context,
              builder: (BuildContext mContext) => MessageBoxPopButtonWidget(
                    title: "Mismatch Detail",
                    message: res['response'],
                    onPressed: () {
                      Navigator.pop(mContext);
                      BlocProvider.of<CngFillingFormBloc>(context).add(
                          CngFillingFormSubmitEvent(
                              context: context, isMismatch: true));
                    },
                  ));
          return null;
        } else if (res["status"] != null &&
            res['status'] == 500 &&
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
