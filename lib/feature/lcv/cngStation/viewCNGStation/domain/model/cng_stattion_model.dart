import 'package:flutter_igl_cng/feature/lcv/user/viewUser/domain/model/user_model.dart';

List<CngStationModel> cngStationListResponse(var json) {
  return List<CngStationModel>.from(
      json.map((x) => CngStationModel.fromJson(x)));
}

class CngStationModel {
  String? id;
  String? stationCode;
  String? stationName;
  String? address;
  String? createdBy;
  String? city;
  String? district;
  String? pincode;
  String? state;
  String? officerName;
  String? companyEmail;
  String? phoneNumber;
  String? createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  String? roleId;
  String? firebaseId;
  dynamic lat;
  dynamic long;
  List<UserModel>? userList;
  bool? isSelected;

  CngStationModel({
    this.id,
    this.stationCode,
    this.stationName,
    this.address,
    this.createdBy,
    this.city,
    this.district,
    this.pincode,
    this.state,
    this.officerName,
    this.companyEmail,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.roleId,
    this.firebaseId,
    this.userList,
    this.lat,
    this.long,
    this.isSelected,
  });

  factory CngStationModel.fromJson(Map<String, dynamic> json) {
    return CngStationModel(
      id: json['station_id'] ?? "",
      stationCode: json['station_code'] ?? "",
      stationName: json['station_name'] ?? "",
      address: json['address'] ?? "",
      createdBy: json['created_by'] ?? "",
      city: json['city'] ?? "",
      district: json['district'] ?? "",
      pincode: json['pincode'] ?? "",
      state: json['state'] ?? "",
      officerName: json['officer_name'] ?? "",
      companyEmail: json['company_email'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      deletedAt: json['deleted_at'] ?? "",
      roleId: json['role_id'] ?? "",
      firebaseId: json['firebase_id'] ?? "",
      lat: json['lat'] ?? "",
      long: json['long'] ?? "",
      isSelected: false,
      userList: json['users'] == null
          ? []
          : List<UserModel>.from(
              json['users'].map((x) => UserModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['station_code'] = this.stationCode;
    data['station_name'] = this.stationName;
    data['address'] = this.address;
    data['created_by'] = this.createdBy;
    data['city'] = this.city;
    data['district'] = this.district;
    data['state'] = this.state;
    data['officer_name'] = this.officerName;
    data['company_email'] = this.companyEmail;
    data['phone_number'] = this.phoneNumber;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['role_id'] = this.roleId;
    return data;
  }
}
