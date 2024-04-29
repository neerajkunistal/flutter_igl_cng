List<ComplaintTypeModel> complaintTypeListResponse(var json) {
  return List<ComplaintTypeModel>.from(json.map((x) => ComplaintTypeModel.fromJson(x)));
}

class ComplaintTypeModel {
  String? id;
  String? name;

  ComplaintTypeModel({this.id, this.name});

  ComplaintTypeModel.fromJson(Map<String, dynamic> json) {
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
