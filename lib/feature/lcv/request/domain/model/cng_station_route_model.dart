List<CngStationRouteModel> cngStationRouteListResponse(var json) {
  return List<CngStationRouteModel>.from(
      json.map((x) => CngStationRouteModel.fromJson(x)));
}

class CngStationRouteModel {
  String? id;
  String? encodeRoute;
  String? routeGeoJson;
  String? sourceStation;
  String? destinationStation;
  dynamic routeFile;
  String? status;
  dynamic createdBy;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic routeName;

  CngStationRouteModel(
      {this.id,
      this.encodeRoute,
      this.routeGeoJson,
      this.sourceStation,
      this.destinationStation,
      this.routeFile,
      this.status,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.routeName});

  factory CngStationRouteModel.fromJson(Map<String, dynamic> json) {
    return CngStationRouteModel(
      id: json['id'] ?? "",
      encodeRoute: json['encoderoute'] ?? "",
      routeGeoJson: json['route_geojson'] ?? "",
      sourceStation: json['source_station'] ?? "",
      destinationStation: json['destination_station'] ?? "",
      routeFile: json['route_file'] ?? "",
      status: json['status'] ?? "",
      createdBy: json['created_by'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      routeName: json['route_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['encoderoute'] = encodeRoute;
    data['route_geojson'] = routeGeoJson;
    data['source_station'] = sourceStation;
    data['destination_station'] = destinationStation;
    data['route_file'] = routeFile;
    data['status'] = status;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['route_name'] = routeName;
    return data;
  }
}
