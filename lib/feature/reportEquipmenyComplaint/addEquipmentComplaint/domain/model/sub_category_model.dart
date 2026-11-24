List<SubCategoryModel> subCategoryTypeListResponse(var json) {
  return List<SubCategoryModel>.from(
      json.map((x) => SubCategoryModel.fromJson(x)));
}

class SubCategoryModel {
  String? id;
  String? categoryId;
  String? name;
  String? status;
  String? createdAt;

  SubCategoryModel({this.id, this.categoryId, this.name, this.status, this.createdAt});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}
