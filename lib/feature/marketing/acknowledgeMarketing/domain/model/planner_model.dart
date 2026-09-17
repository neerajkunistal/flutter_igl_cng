import 'package:flutter_igl_cng/feature/acknowledge/domain/model/work_center_model.dart';

List<PlannerModel> plannerListResponse(var json) {
  return List<PlannerModel>.from(json.map((x) => PlannerModel.fromJson(x)));
}

class PlannerModel {
  String? id;
  String? planningPlant;
  String? plannerGroup;
  String? pmPlannerGrpName;
  List<WorkCenterModel>? workCenterList;

  PlannerModel(
      {this.id, this.planningPlant, this.plannerGroup, this.pmPlannerGrpName, this.workCenterList});

  PlannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    planningPlant = json['planning_plant'] ?? "";
    plannerGroup = json['planner_group'] ?? "";
    pmPlannerGrpName = json['pm_planner_grp_name'] ?? "";
    workCenterList = json['work_center'] != null ? workCenterListResponse(json['work_center']) : [];
  }

}