List<SparesModel> sparesListResponse(var json) {
  return List<SparesModel>.from(json.map((x) => SparesModel.fromJson(x)));
}

class SparesModel {
  String? id;
  String? spareName;

  SparesModel({this.id, this.spareName});

  SparesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    spareName = json['spare_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['spare_name'] = spareName;
    return data;
  }
}