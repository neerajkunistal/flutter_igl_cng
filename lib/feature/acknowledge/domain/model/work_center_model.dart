List<WorkCenterModel> workCenterListResponse(var json) {
  return List<WorkCenterModel>.from(json.map((x) => WorkCenterModel.fromJson(x)));
}

class WorkCenterModel {
  String? id;
  String? workPlant;
  String? workCenter;
  String? description;

  WorkCenterModel({this.id, this.workPlant, this.workCenter, this.description});

  WorkCenterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    workPlant = json['work_plant'] ?? "";
    workCenter = json['work_center'] ?? "";
    description = json['description'] ?? "";
  }

}