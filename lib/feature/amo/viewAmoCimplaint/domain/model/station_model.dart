List<StationModel> stationListResponse(var json) {
  return List<StationModel>.from(json.map((x) => StationModel.fromJson(x)));
}

class StationModel {
  String? id;
  String? name;
  String? code;

  StationModel({this.id,
  this.name,
  this.code,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      code: json['code'] ?? "",
    );
  }
}