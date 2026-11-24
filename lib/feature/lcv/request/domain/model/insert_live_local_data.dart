import 'package:flutter_igl_cng/utils/hive/hive_dataTypes.dart';
import 'package:hive/hive.dart';

part 'insert_live_local_data.g.dart';

@HiveType(typeId: HiveTypeId.insertLiveLocalData)
class InsertLiveLocalData {
  @HiveField(0)
  String? loginId;
  @HiveField(1)
  String? lat;
  @HiveField(2)
  String? log;
  @HiveField(3)
  String? address;
  @HiveField(4)
  dynamic markerCondition;
  @HiveField(5)
  dynamic date;
  @HiveField(6)
  dynamic isGps;
  @HiveField(7)
  dynamic isNetwork;
  @HiveField(8)
  dynamic batteryStatus;
  @HiveField(9)
  dynamic dateTime;
  @HiveField(10)
  dynamic status;
  @HiveField(11)
  dynamic flightMode;
  @HiveField(12)
  dynamic driverName;
  @HiveField(13)
  dynamic cngStationId;
  @HiveField(14)
  dynamic inOut;
  @HiveField(15)
  dynamic routeId;

  InsertLiveLocalData({
    this.loginId,
    this.address,
    this.lat,
    this.log,
    this.markerCondition,
    this.date,
    this.isGps,
    this.isNetwork,
    this.batteryStatus,
    this.dateTime,
    this.status,
    this.flightMode,
    this.driverName,
    this.cngStationId,
    this.inOut,
    this.routeId,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "login_id": loginId,
      "lat": lat,
      "log": log,
      "address": address,
      "date": date,
      "gps": isGps,
      "network": isNetwork,
      "battery": batteryStatus,
      "dt": dateTime,
      "status": status,
      "flight_mode": flightMode,
      "driver_name": driverName,
      "cng_station_id": cngStationId,
      "in_out": inOut,
      "route_id": routeId
    };
    return map;
  }
}
