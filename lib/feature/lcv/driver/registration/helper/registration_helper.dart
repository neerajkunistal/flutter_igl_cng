import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class RegistrationHelper {
  static Future<dynamic> textFieldValidation(
      {required BuildContext context,
      required String fullName,
      required String drivingLicence,
      required String phoneNumber,
      required String email,
      required String address,
      required String city,
      required String district,
      required String state,
      required File uploadCertificateImage,
      required File uploadLicenceImage,
      required File uploadPhotoImage,
      required bool isEdit}) async {
    try {
      if (fullName.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter full name");
        return false;
      } else if (drivingLicence.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter driving licence number");
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
      } else if (uploadCertificateImage.path.isEmpty && isEdit == false) {
        SnackBarErrorWidget(context).show(message: "Please upload certificate");
        return false;
      } else if (uploadLicenceImage.path.isEmpty && isEdit == false) {
        SnackBarErrorWidget(context).show(message: "Please upload licence");
        return false;
      } else if (uploadPhotoImage.path.isEmpty && isEdit == false) {
        SnackBarErrorWidget(context)
            .show(message: "Please upload driver photo");
        return false;
      }
      return true;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: e.toString());
      return false;
    }
  }

  static Future<dynamic> imagePiker(
      {required BuildContext context, ImageSource? isCamera}) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? photo = await _picker.pickImage(
          source: isCamera ?? ImageSource.gallery,
          imageQuality: 60,
          maxHeight: 1200,
          maxWidth: 950,
          preferredCameraDevice: CameraDevice.rear);
      if (photo != null) {
        return File(photo.path);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchUserRoleData(
      {required BuildContext context, required LoginDataModel userData}) async {
    try {
      String url = APIs.getUserRolesApi;
      var json = {
        "role_id": userData.roleId.toString(),
        "login_id": userData.userId.toString(),
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == 200 &&
            res['response'] != null) {
          return registrationListResponse(res['response']);
        } else {
          return null;
        }
      }
      return null;
    } catch (e) {
      SnackBarErrorWidget(context)
          .show(message: "Internal server error ${APIs.getDriverApi}");
      return null;
    }
  }

  static Future<dynamic> registration({
    required BuildContext context,
    required String fullName,
    required String drivingLicence,
    required String phoneNumber,
    String? email,
    required String address,
    required String city,
    required String district,
    required String state,
    required LoginDataModel userData,
    required RegistrationModel registrationData,
    required DriverModel driverModel,
    required bool isEdit,
    String? deletedAt,
    required File uploadCertificateImage,
    required File uploadLicenceImage,
    required File uploadPhotoImage,
  }) async {
    String baseCertificate64Image = "";
    if (uploadCertificateImage.path.isNotEmpty) {
      log(uploadCertificateImage.path.toString());
      List<int> imageBytes = uploadCertificateImage.readAsBytesSync();
      baseCertificate64Image = base64Encode(imageBytes);
    }

    String baseLicence64Image = "";
    if (uploadLicenceImage.path.isNotEmpty) {
      log(uploadLicenceImage.path.toString());
      List<int> imageBytes = uploadLicenceImage.readAsBytesSync();
      baseLicence64Image = base64Encode(imageBytes);
    }

    String basePhoto64Image = "";
    if (uploadPhotoImage.path.isNotEmpty) {
      log(uploadPhotoImage.path.toString());
      List<int> imageBytes = uploadPhotoImage.readAsBytesSync();
      basePhoto64Image = base64Encode(imageBytes);
    }

    if (isEdit == true &&
        driverModel.certificatePhoto != null &&
        driverModel.certificatePhoto.toString().isNotEmpty &&
        uploadCertificateImage.path.isEmpty) {
      baseCertificate64Image = await ServerRequest.imageUrlConvertToByte64(
          url: driverModel.certificatePhoto.toString());
    }

    if (isEdit == true &&
        driverModel.licencePhoto != null &&
        driverModel.licencePhoto.toString().isNotEmpty &&
        uploadLicenceImage.path.isEmpty) {
      baseLicence64Image = await ServerRequest.imageUrlConvertToByte64(
          url: driverModel.licencePhoto.toString());
    }

    if (isEdit == true &&
        driverModel.driverPhoto != null &&
        driverModel.driverPhoto.toString().isNotEmpty &&
        uploadPhotoImage.path.isEmpty) {
      basePhoto64Image = await ServerRequest.imageUrlConvertToByte64(
          url: driverModel.driverPhoto.toString());
    }

    try {
      String url = APIs.registrationApi;
      var json = {
        "id": isEdit == true ? driverModel.id.toString() : "",
        "login_id": "${userData.userId}",
        "role_id": "5",
        "driver_name": fullName,
        "driver_license_id": drivingLicence,
        "address": address,
        "city": city,
        "district": district,
        "state": state,
        "company_email": email.toString(),
        "phone_number": phoneNumber,
        "password": phoneNumber,
        "is_edit": isEdit == true ? "1" : "0",
        "uploadCertificate": baseCertificate64Image,
        "uploadLicence": baseLicence64Image,
        "uploadPhoto": basePhoto64Image,
        "deleted_at": deletedAt ?? "",
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
