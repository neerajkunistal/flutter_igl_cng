List<PlannerModel> plannerListResponse(var json) {
  return List<PlannerModel>.from(json.map((x) => PlannerModel.fromJson(x)));
}

class PlannerModel {
  String? id;
  String? planningPlant;
  String? plannerGroup;
  String? pmPlannerGrpName;

  PlannerModel(
      {this.id, this.planningPlant, this.plannerGroup, this.pmPlannerGrpName});

  PlannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    planningPlant = json['planning_plant'] ?? "";
    plannerGroup = json['planner_group'] ?? "";
    pmPlannerGrpName = json['pm_planner_grp_name'] ?? "";
  }

}