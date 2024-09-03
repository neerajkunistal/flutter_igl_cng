import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/model/cng_stattion_model.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/model/cng_station_route_model.dart';

class StationModel {
  final CngStationModel cngStation;
  final String quantity;
  final int? sequences;
  final CngStationRouteModel cngStationRouteData;

  StationModel(
      {required this.cngStation,
      required this.quantity,
      this.sequences,
      required this.cngStationRouteData});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "quantity": quantity,
      "cng_station_id": cngStation.id.toString(),
      "order_id": sequences,
      "route_id": cngStationRouteData.id.toString(),
      "users": List<dynamic>.from(cngStation.userList!.map((x) => x.toJson())),
    };
    return map;
  }
}
