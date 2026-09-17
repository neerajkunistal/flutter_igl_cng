List<FacilityModel> facilityTypeListResponse(var json) {
  return List<FacilityModel>.from(
      json.map((x) => FacilityModel.fromJson(x)));
}

class FacilityModel {
  String? id;
  String? name;
  String? code;
  String? requiresDescription;
  String? autoVendorEmail;
  String? defaultVendorId;
  String? sortOrder;
  String? status;
  String? createdBy;
  String? createdAt;
  String? updatedAt;

  FacilityModel(
      {this.id,
        this.name,
        this.code,
        this.requiresDescription,
        this.autoVendorEmail,
        this.defaultVendorId,
        this.sortOrder,
        this.status,
        this.createdBy,
        this.createdAt,
        this.updatedAt});

  FacilityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    requiresDescription = json['requires_description'];
    autoVendorEmail = json['auto_vendor_email'];
    defaultVendorId = json['default_vendor_id'];
    sortOrder = json['sort_order'];
    status = json['status'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['requires_description'] = this.requiresDescription;
    data['auto_vendor_email'] = this.autoVendorEmail;
    data['default_vendor_id'] = this.defaultVendorId;
    data['sort_order'] = this.sortOrder;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
