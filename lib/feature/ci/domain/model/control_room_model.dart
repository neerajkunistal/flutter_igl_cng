List<ControlRoomModel> controlRoomListResponse(var json) {
  return List<ControlRoomModel>.from(json.map((x) => ControlRoomModel.fromJson(x)));
}

class ControlRoomModel {
  String? id;
  String? userId;
  String? controlRoomId;
  String? sapId;
  String? assoType;
  String? status;
  String? source;
  String? createdBy;
  String? controlRoomName;

  ControlRoomModel(
      {this.id,
        this.userId,
        this.controlRoomId,
        this.sapId,
        this.assoType,
        this.status,
        this.source,
        this.createdBy,
        this.controlRoomName});

  ControlRoomModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    userId = json['user_id'] ?? "";
    controlRoomId = json['control_room_id'] ?? "";
    sapId = json['sap_id'] ?? "";
    assoType = json['asso_type'] ?? "";
    status = json['status'] ?? "";
    source = json['source'] ?? "";
    controlRoomName = json['control_room_name'] ?? "";
  }

}