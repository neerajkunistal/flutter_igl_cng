List<LcvTruckModel> lcvListResponse(var json) {
  return List<LcvTruckModel>.from(json.map((x) => LcvTruckModel.fromJson(x)));
}

class LcvTruckModel {
  String? id;
  String? vehicleCompany;
  String? vehicleName;
  String? chassisNumber;
  String? engineNumber;
  String? state;
  String? phoneNumber;
  String? companyEmail;
  String? address;
  String? fuelType;
  String? average;
  String? createdBy;
  String? createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  String? vehicleNo;
  bool? isSelected;
  dynamic agencyId;

  LcvTruckModel(
      {this.id,
      this.vehicleCompany,
      this.vehicleName,
      this.chassisNumber,
      this.engineNumber,
      this.state,
      this.phoneNumber,
      this.companyEmail,
      this.address,
      this.fuelType,
      this.average,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.vehicleNo,
      this.isSelected,
      this.agencyId,
      });

  factory LcvTruckModel.fromJson(Map<String, dynamic> json) {
    return LcvTruckModel(
      id: json['id'] ?? "",
      vehicleCompany: json['vehicle_company'] ?? "",
      vehicleName: json['vehicle_name'] ?? "",
      chassisNumber: json['chassis_number'] ?? "",
      engineNumber: json['engine_number'] ?? "",
      state: json['state'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      companyEmail: json['company_email'] ?? "",
      address: json['address'] ?? "",
      fuelType: json['fuel_type'] ?? "",
      average: json['average'] ?? "",
      createdBy: json['created_by'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      deletedAt: json['deleted_at'] ?? "",
      vehicleNo: json['vehicle_no'] ?? "",
      agencyId: json['agency_id'] ?? "",
      isSelected: false,
    );
  }
}
