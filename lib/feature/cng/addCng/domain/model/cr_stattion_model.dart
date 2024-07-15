CrStationModel crStationData(var json) {
  return CrStationModel.fromJson(json);
}

class CrStationModel {
  String? controlRoomId;
  String? controlRoomName;
  String? controlRoomCode;
  String? cngStationId;
  String? cngStationName;
  String? functionLocation;

  CrStationModel(
      {this.controlRoomId,
      this.controlRoomName,
      this.controlRoomCode,
      this.cngStationId,
      this.cngStationName,
      this.functionLocation});

  CrStationModel.fromJson(Map<String, dynamic> json) {
    controlRoomId = json['control_room_id'] ?? "";
    controlRoomName = json['control_room_name'] ?? "";
    controlRoomCode = json['control_room_code'] ?? "";
    cngStationId = json['cng_station_id'] ?? "";
    cngStationName = json['cng_station_name'] ?? "";
    functionLocation = json['function_location'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['control_room_id'] = controlRoomId;
    data['control_room_name'] = controlRoomName;
    data['control_room_code'] = controlRoomCode;
    data['cng_station_id'] = cngStationId;
    data['cng_station_name'] = cngStationName;
    data['function_location'] = functionLocation;
    return data;
  }
}
