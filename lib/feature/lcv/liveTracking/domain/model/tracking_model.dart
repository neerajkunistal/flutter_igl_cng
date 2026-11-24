List<TrackingModel> trackingListResponse(var json) {
  return List<TrackingModel>.from(json.map((x) => TrackingModel.fromJson(x)));
}

class TrackingModel {
  dynamic id;
  String? driverName;
  String? originLocationName;
  String? destinationLocationName;
  dynamic lat;
  dynamic long;
  dynamic distance;
  String? loginId;
  String? address;
  String? date;
  String? gps;
  String? network;
  String? battery;
  String? dt;
  String? status;
  String? flightMode;
  String? createdAt;
  String? routeId;

  TrackingModel({
    this.id,
    this.driverName,
    this.destinationLocationName,
    this.originLocationName,
    this.long,
    this.lat,
    this.distance,
    this.loginId,
    this.address,
    this.date,
    this.gps,
    this.network,
    this.battery,
    this.dt,
    this.status,
    this.flightMode,
    this.createdAt,
    this.routeId,
  });

  factory TrackingModel.fromJson(Map<String, dynamic> json) {
    return TrackingModel(
      id: json['id'] ?? "",
      loginId: json['login_id'] ?? "",
      lat: json['lat'] ?? "",
      long: json['log'] ?? "",
      address: json['address'] ?? "",
      date: json['date'] ?? "",
      gps: json['gps'] ?? "",
      network: json['network'] ?? "",
      battery: json['battery'] ?? "",
      dt: json['dt'] ?? "",
      status: json['status'] ?? "",
      flightMode: json['flight_mode'] ?? "",
      createdAt: json['created_at'] ?? "",
      driverName: json['driver_name'] ?? "",
      routeId: json['route_id'] ?? "",
    );
  }
}
