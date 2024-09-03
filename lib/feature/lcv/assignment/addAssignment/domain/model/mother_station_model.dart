List<MotherStationModel> motherStationListResponse(var json) {
  return List<MotherStationModel>.from(
      json.map((x) => MotherStationModel.fromJson(x)));
}

class MotherStationModel {
  String? id;
  String? stationCode;
  String? stationName;
  String? address;
  String? createdBy;
  String? city;
  String? district;
  String? state;
  String? officerName;
  String? companyEmail;
  String? phoneNumber;
  String? createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  String? roleId;
  dynamic lat;
  dynamic long;
  String? status;

  MotherStationModel(
      {this.id,
      this.stationCode,
      this.stationName,
      this.address,
      this.createdBy,
      this.city,
      this.district,
      this.state,
      this.officerName,
      this.companyEmail,
      this.phoneNumber,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.roleId,
      this.lat,
      this.long,
      this.status});

  factory MotherStationModel.fromJson(Map<String, dynamic> json) {
    return MotherStationModel(
      id: json['id'] ?? "",
      stationCode: json['station_code'] ?? "",
      stationName: json['station_name'] ?? "",
      address: json['address'] ?? "",
      createdBy: json['created_by'] ?? "",
      city: json['city'] ?? "",
      district: json['district'] ?? "",
      state: json['state'] ?? "",
      officerName: json['officer_name'] ?? "",
      companyEmail: json['company_email'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      deletedAt: json['deleted_at'] ?? "",
      roleId: json['role_id'] ?? "",
      lat: json['lat'] ?? "",
      long: json['long'] ?? "",
      status: json['status'] ?? "",
    );
  }
}
