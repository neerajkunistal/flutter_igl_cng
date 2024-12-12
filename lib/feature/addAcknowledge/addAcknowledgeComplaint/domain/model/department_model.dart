import 'package:flutter_igl_cng/feature/acknowledge/domain/model/planner_model.dart';

List<DepartmentModel> departmentListResponse(var json) {
  return List<DepartmentModel>.from(
      json.map((x) => DepartmentModel.fromJson(x)));
}

class DepartmentModel {
  String? id;
  String? name;
  List<PlannerModel>? plannerList;

  DepartmentModel({this.id, this.name, this.plannerList});

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    plannerList = json['planner_groups'] != null ? plannerListResponse(json['planner_groups']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
