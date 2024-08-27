import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/domain/model/station_model.dart';
import 'package:flutter_igl_cng/feature/ci/domain/model/control_room_model.dart';

class FilterModel {

  DateTime? startDate;
  DateTime? endDate;
  ControlRoomModel? controlRoomData;
  StationModel? stationData;

    FilterModel({
      this.startDate,
      this.endDate,
      this.controlRoomData,
      this.stationData,
  });

}