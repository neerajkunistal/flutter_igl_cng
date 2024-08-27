List<EstimateModel> estimateListResponse(var json) {
  return List<EstimateModel>.from(json.map((x) => EstimateModel.fromJson(x)));
}

class EstimateModel {
  dynamic id;
  dynamic status;
  dynamic statusType;
  dynamic createdBy;
  String? createdAt;
  String? updatedAt;
  dynamic estimateAmount;

  EstimateModel(
      {this.id,
        this.status,
        this.statusType,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.estimateAmount});

  EstimateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    status = json['status'] ?? "";
    statusType = json['status_type'] ?? "";
    createdBy = json['created_by'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at']  ?? "";
    estimateAmount = json['estimate_amount'] ?? "";
  }

}