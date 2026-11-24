List<ComplaintTypeModel> complaintTypeListResponse(var json) {
  return List<ComplaintTypeModel>.from(
      json.map((x) => ComplaintTypeModel.fromJson(x)));
}

class ComplaintTypeModel {
  String? id;
  String? name;
  String? alias;

  ComplaintTypeModel({this.id, this.name, this.alias});

  ComplaintTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    alias = json['alias'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['alias'] = name;
    return data;
  }
}
