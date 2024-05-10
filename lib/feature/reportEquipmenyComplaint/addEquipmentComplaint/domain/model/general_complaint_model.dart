List<GeneralComplaintModel> generalComplaintListResponse(var json) {
  return List<GeneralComplaintModel>.from(
      json.map((x) => GeneralComplaintModel.fromJson(x)));
}

class GeneralComplaintModel {
  String? id;
  String? name;
  String? description;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? sortOrder;

  GeneralComplaintModel(
      {this.id,
      this.name,
      this.description,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.sortOrder});

  GeneralComplaintModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    status = json['status'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    sortOrder = json['sort_order'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['sort_order'] = sortOrder;
    return data;
  }
}
