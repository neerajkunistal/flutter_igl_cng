List<VendorModel> vendorListResponse(var json) {
  return List<VendorModel>.from(json.map((x) => VendorModel.fromJson(x)));
}

class VendorModel {
  dynamic id;
  String? name;
  String? code;
  dynamic poAmount;
  dynamic consumedValue;
  dynamic provisionalApproved;

  VendorModel({
    this.id,
    this.name,
    this.code,
    this.poAmount,
    this.consumedValue,
    this.provisionalApproved,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] ?? "",
      name: json['company_name'] ?? "",
      code: json['vendor_code'] ?? "",
      poAmount: json['po_amount'] ?? "0",
      consumedValue: json['consumed_value'] ?? "0",
      provisionalApproved: json['provisional_approved'] ?? "0",
    );
  }
}
