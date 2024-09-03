import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

List<DriverModel> driverListResponse(var json) {
  return List<DriverModel>.from(json.map((x) => DriverModel.fromJson(x)));
}

class DriverModel {
  String? id;
  String? driverName;
  String? driverLicenseId;
  String? address;
  String? city;
  String? district;
  String? state;
  String? companyEmail;
  String? phoneNumber;
  String? createdBy;
  String? createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  String? roleId;
  String? status;
  String? firebaseId;
  String? certificatePhoto;
  String? licencePhoto;
  String? driverPhoto;
  bool? isSelected = false;

  DriverModel({
    this.id,
    this.driverName,
    this.driverLicenseId,
    this.address,
    this.city,
    this.district,
    this.state,
    this.companyEmail,
    this.phoneNumber,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.roleId,
    this.status,
    this.firebaseId,
    this.certificatePhoto,
    this.licencePhoto,
    this.isSelected,
    this.driverPhoto,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    String driverPhoto = "";
    String licencePhoto = "";
    String uploadCertificate = "";

    if (json['uploadDriverPhoto'] != null) {
      driverPhoto =
          "${APIs.baseUrl}writable/uploads/driver_photo/${json['driver_license_id']}/${json['uploadDriverPhoto']}";
    }
    if (json['uploadCertificate'] != null) {
      uploadCertificate =
          "${APIs.baseUrl}writable/uploads/certificate/${json['driver_license_id']}/${json['uploadCertificate']}";
    }

    if (json['uploadLicence'] != null) {
      licencePhoto =
          "${APIs.baseUrl}writable/uploads/license/${json['driver_license_id']}/${json['uploadLicence']}";
    }

    return DriverModel(
      id: json['id'] ?? "",
      driverName: json['driver_name'] ?? "",
      driverLicenseId: json['driver_license_id'] ?? "",
      address: json['address'] ?? "",
      city: json['city'] ?? "",
      district: json['district'] ?? "",
      state: json['state'] ?? "",
      companyEmail: json['company_email'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      createdBy: json['created_by'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      deletedAt: json['deleted_at'] ?? "",
      roleId: json['role_id'] ?? "",
      status: json['status'] ?? "",
      firebaseId: json['firebase_id'] ?? "",
      certificatePhoto: uploadCertificate,
      licencePhoto: licencePhoto,
      driverPhoto: driverPhoto,
      isSelected: false,
    );
  }
}
