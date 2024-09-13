List<RunningTruckModel> runningTruckListResponse(var json) {
  return List<RunningTruckModel>.from(json.map((x) => RunningTruckModel.fromJson(x)));
}

class RunningTruckModel {
  String? vehicleNo;
  String? imei;
  String? location;
  String? date;
  String? tempr;
  String? ignition;
  String? lat;
  String? long;
  String? speed;
  String? angle;

  RunningTruckModel(
      {this.vehicleNo,
        this.imei,
        this.location,
        this.date,
        this.tempr,
        this.ignition,
        this.lat,
        this.long,
        this.speed,
        this.angle});

  RunningTruckModel.fromJson(Map<String, dynamic> json) {
    vehicleNo = json['VehicleNo'] ?? "";
    imei = json['Imei'] ?? "";
    location = json['Location'] ?? "";
    date = json['Date'] ?? "";
    tempr = json['Tempr'] ?? "";
    ignition = json['Ignition'] ?? "";
    lat = json['Lat'] ?? "";
    long = json['Long'] ?? "";
    speed = json['Speed'] ?? "";
    angle = json['Angle'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VehicleNo'] = vehicleNo;
    data['Imei'] = imei;
    data['Location'] = location;
    data['Date'] = date;
    data['Tempr'] = tempr;
    data['Ignition'] = ignition;
    data['Lat'] = lat;
    data['Long'] = long;
    data['Speed'] = speed;
    data['Angle'] = angle;
    return data;
  }
}