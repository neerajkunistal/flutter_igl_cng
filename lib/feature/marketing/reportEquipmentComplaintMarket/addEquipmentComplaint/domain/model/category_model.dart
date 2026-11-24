List<MarketCategoryModel> marketCategoryTypeListResponse(var json) {
  return List<MarketCategoryModel>.from(
      json.map((x) => MarketCategoryModel.fromJson(x)));
}

class MarketCategoryModel {
  String? id;
  String? facilityId;
  String? vendorId;
  String? name;
  String? sortOrder;
  String? status;
  String? createdAt;
  String? updatedAt;

  MarketCategoryModel(
      {this.id,
        this.facilityId,
        this.vendorId,
        this.name,
        this.sortOrder,
        this.status,
        this.createdAt,
        this.updatedAt});

  MarketCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    facilityId = json['facility_id'];
    vendorId = json['vendor_id'];
    name = json['name'];
    sortOrder = json['sort_order'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['facility_id'] = this.facilityId;
    data['vendor_id'] = this.vendorId;
    data['name'] = this.name;
    data['sort_order'] = this.sortOrder;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
