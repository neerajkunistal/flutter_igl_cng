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
  String? controlRoomName;
  dynamic controlRoomId;

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
    this.controlRoomId,
    this.controlRoomName,
  });

  factory CngStationModel.fromJson(Map<String, dynamic> json) {
    return CngStationModel(
      id: json['id'] ?? "",
      stationCode: json['station_code'] ?? "",
      stationName: json['name'] ?? "",
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
      controlRoomId: json['control_room_id'] ?? "",
      controlRoomName: json['control_room'] ?? "",
      isSelected: false,
      userList: json['users'] == null
          ? []
          : List<UserModel>.from(
              json['users'].map((x) => UserModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['station_code'] = stationCode;
    data['station_name'] = stationName;
    data['address'] = address;
    data['created_by'] = createdBy;
    data['city'] = city;
    data['district'] = district;
    data['state'] = state;
    data['officer_name'] = officerName;
    data['company_email'] = companyEmail;
    data['phone_number'] = phoneNumber;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['role_id'] = roleId;
    return data;
  }
}
