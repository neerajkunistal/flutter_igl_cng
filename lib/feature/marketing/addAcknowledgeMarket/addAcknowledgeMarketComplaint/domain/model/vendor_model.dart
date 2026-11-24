List<VendorMarketModel> vendorMarketListResponse(var json) {
  return List<VendorMarketModel>.from(
      json.map((x) => VendorMarketModel.fromJson(x)));
}

class VendorMarketModel {
  String? id;
  String? vendorName;
  String? vendorCode;
  String? email;
  String? phoneNumber;

  VendorMarketModel(
      {this.id,
        this.vendorName,
        this.vendorCode,
        this.email,
        this.phoneNumber});

  VendorMarketModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorName = json['vendor_name'];
    vendorCode = json['vendor_code'];
    email = json['email'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_name'] = this.vendorName;
    data['vendor_code'] = this.vendorCode;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}
