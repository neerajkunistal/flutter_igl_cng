List<StationTypeModel> stationTypeListResponse(dynamic data) {
  if (data is List) {
    return data
        .map((e) => StationTypeModel.fromJson(e))
        .toList();
  }

  if (data is Map<String, dynamic>) {
    return [StationTypeModel.fromJson(data)];
  }

  return [];
}

class StationTypeModel {
  String? cngStationId;
  String? controlRoomId;
  String? controlRoomName;
  String? controlRoomCode;
  String? cngStationName;
  String? functionLocation;

  StationTypeModel(
      {this.cngStationId,
        this.controlRoomId,
        this.controlRoomName,
        this.controlRoomCode,
        this.cngStationName,
        this.functionLocation});

  StationTypeModel.fromJson(Map<String, dynamic> json) {
    cngStationId = json['cng_station_id'] ?? "";
    controlRoomId = json['control_room_id'] ?? "";
    controlRoomName = json['control_room_name'] ?? "";
    controlRoomCode = json['control_room_code'] ?? "";
    cngStationName = json['cng_station_name'] ?? "";
    functionLocation = json['function_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cng_station_id'] = this.cngStationId;
    data['control_room_id'] = this.controlRoomId;
    data['control_room_name'] = this.controlRoomName;
    data['control_room_code'] = this.controlRoomCode;
    data['cng_station_name'] = this.cngStationName;
    data['function_location'] = this.functionLocation;
    return data;
  }
}
