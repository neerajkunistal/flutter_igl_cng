List<AcknowledgeUserModel> acknowledgeUserListResponse(var json) {
  return List<AcknowledgeUserModel>.from(
      json.map((x) => AcknowledgeUserModel.fromJson(x)));
}

class AcknowledgeUserModel {
  String? id;
  String? name;

  AcknowledgeUserModel({this.id, this.name});

  AcknowledgeUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
