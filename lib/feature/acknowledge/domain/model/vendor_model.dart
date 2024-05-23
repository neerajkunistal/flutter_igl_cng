List<VendorModel> vendorListResponse(var json) {
  return List<VendorModel>.from(json.map((x) => VendorModel.fromJson(x)));
}

class VendorModel {
  dynamic id;
  String? name;
  String? code;

  VendorModel({this.id, this.name, this.code});

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] ?? "",
      name: json['company_name'] ?? "",
      code: json['vendor_code'] ?? "",
    );
  }
}
