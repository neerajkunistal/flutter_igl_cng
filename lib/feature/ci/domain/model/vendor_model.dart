List<VendorModel> vendorListResponse(var json) {
  return List<VendorModel>.from(json.map((x) => VendorModel.fromJson(x)));
}

class VendorModel {
  String? id;
  String? companyName;
  String? vendorCode;

  VendorModel({this.id, this.companyName, this.vendorCode});

  VendorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    companyName = json['company_name'] ?? "";
    vendorCode = json['vendor_code'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['vendor_code'] = vendorCode;
    return data;
  }
}
