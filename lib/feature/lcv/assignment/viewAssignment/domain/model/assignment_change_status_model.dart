

class AssignmentChangeStatusModel {
  String? id;
  String? status;

  AssignmentChangeStatusModel({this.id, this.status});

  static List<AssignmentChangeStatusModel> getStatus() {
    List<AssignmentChangeStatusModel> assignmentChangeStatusList = [];
    assignmentChangeStatusList.add(
        AssignmentChangeStatusModel(id: "1", status: "Driver not available "));
    assignmentChangeStatusList.add(
        AssignmentChangeStatusModel(id: "2", status: "Vehicle not working"));
    return assignmentChangeStatusList;
  }
}
