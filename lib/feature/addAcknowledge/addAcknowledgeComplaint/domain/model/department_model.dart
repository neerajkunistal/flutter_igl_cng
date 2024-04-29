List<DepartmentModel> departmentListResponse(var json) {
  return List<DepartmentModel>.from(json.map((x) => DepartmentModel.fromJson(x)));
}

class DepartmentModel {
  String? id;
  String? name;

  DepartmentModel({this.id, this.name});

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}