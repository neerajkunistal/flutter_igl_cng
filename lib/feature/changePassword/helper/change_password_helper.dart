import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/password_validation.dart';

class ChangePasswordHelper {
  static Future<dynamic> textFieldValidationCheck(
      {required String oldPassword,
      required String newPassword,
      required String confirmPassword,
      required BuildContext context}) async {
    try {
      String password = await SharedPreferencesUtils.getString(key: PreferencesName.password);
      if (oldPassword.isEmpty) {
        SnackBarErrorWidget(!context.mounted ? context: context).show(message: "Please enter old password");
        return false;
      } else if (oldPassword.toString() != password.toString()) {
        SnackBarErrorWidget(!context.mounted ? context: context).show(message:"Old password not match");
        return false;
      } else if (newPassword.isEmpty) {
        SnackBarErrorWidget(!context.mounted ? context: context).show(message:"Please enter new password");
        return false;
      } else if (confirmPassword.isEmpty) {
        SnackBarErrorWidget(!context.mounted ? context: context).show(message:"Please enter confirm password");
        return false;
      } else if (confirmPassword.toString() != newPassword.toString()) {
        SnackBarErrorWidget(!context.mounted ? context: context).show(message:"new password and confirm password do not match");
        return false;
      } else if (await PasswordValidation.checkStrongPassword(
              password: confirmPassword) ==
          false) {
        SnackBarErrorWidget(!context.mounted ? context: context).show(message:"Please enter strong password (Test12@ At least 8 characters") ;
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<dynamic> passwordSaveOnServer(
      {required String newPassword,
      required BuildContext context}) async {

    try{
      LoginDataModel userData =  UserInfo.instanceInit()!.userData!;
       String url = APIs.changePassword;
       var json = {
         "userid" : userData.userId.toString(),
         "new_password" : newPassword,
      };
      var res =  await ServerRequest.postData(urlEndPoint: url, body: json);
      if(res != null && res['status'] != null
          && res['status'] == true && res['message'] != null){
        SnackBarSuccessWidget(!context.mounted ? context : context).show(message: res['message']);
        return res;
      } if(res != null && res['status'] != null
          && res['status'] == false && res['message'] != null) {
        SnackBarErrorWidget(!context.mounted ? context : context).show(
            message: res['message']);
      }
       return null;
    }catch(_){
      SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Internal server error");
      return null;
    }
  }
}
