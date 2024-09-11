import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/model/cng_stattion_model.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/model/driver_model.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/viewLcvTrack/domain/model/lcv_model.dart';

List<MotherStationModel> motherStationListResponse(var json) {
  return List<MotherStationModel>.from(
      json.map((x) => MotherStationModel.fromJson(x)));
}

class MotherStationModel {
  String? id;
  String? stationCode;
  String? stationName;
  String? address;
  String? createdBy;
  String? city;
  String? district;
  String? state;
  String? officerName;
  String? companyEmail;
  String? phoneNumber;
  String? createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  String? roleId;
  dynamic lat;
  dynamic long;
  String? status;
  String? controlRoomName;
  dynamic controlRoomId;

  MotherStationModel(
      {this.id,
      this.stationCode,
      this.stationName,
      this.address,
      this.createdBy,
      this.city,
      this.district,
      this.state,
      this.officerName,
      this.companyEmail,
      this.phoneNumber,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.roleId,
      this.lat,
      this.long,
      this.status,
      this.controlRoomName,
      this.controlRoomId,
      });

  factory MotherStationModel.fromJson(Map<String, dynamic> json) {
    return MotherStationModel(
      id: json['id'] ?? "",
      stationCode: json['station_code'] ?? "",
      stationName: json['name'] ?? "",
      address: json['address'] ?? "",
      createdBy: json['created_by'] ?? "",
      city: json['city'] ?? "",
      district: json['district'] ?? "",
      state: json['state'] ?? "",
      officerName: json['officer_name'] ?? "",
      companyEmail: json['company_email'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      deletedAt: json['deleted_at'] ?? "",
      roleId: json['role_id'] ?? "",
      lat: json['lat'] ?? "",
      long: json['long'] ?? "",
      status: json['status'] ?? "",
      controlRoomName: json['control_room'] ?? "",
      controlRoomId: json['control_room_id'] ?? "",
    );
  }

  Map<String, dynamic> postBodyParam({
    required String id,
    required MotherStationModel motherStationData,
    required CngStationModel cngStationData,
    required LcvTruckModel lcvTruckData,
    required DriverModel driverData,
    required String lcvEntryTime,
    required String fillStartTime,
    required String flowMeterReadingOpen,
    required String flowMeterReadingClosed,
    required String fillEndTime,
    required String outPressure,
    required String lcvCondition,
    required String lcvRemark,
    required String driverToFitDrive,
    required String lcvLogBookCorrection,
    required String availabilityOfMobileWithDriver,
    required String unscheduledMaintenancePenaltyHours,
    required String scheduledMaintenancePenaltyHours,
}) {
    Map<String, String> map = {
      "id" : id,
      "mb_station_id" : motherStationData.id.toString(),
      "db_cng_station_id" : cngStationData.id.toString(),
      "lcv_id" : lcvTruckData.id.toString(),
      "lcv_entry_time" : lcvEntryTime.toString(),
      "fill_start_time" : fillStartTime.toString(),
      "flow_meter_reading_opening" : flowMeterReadingOpen.toString(),
      "flow_meter_reading_closing" : flowMeterReadingClosed.toString(),
      "fill_end_time" : fillEndTime.toString(),
      "out_pressure" : outPressure.toString(),
      "lcv_condition" : lcvCondition.toString(),
      "lcv_condition_remarks" :  lcvRemark.toString(),
      "lcv_number" : lcvTruckData.vehicleNo.toString(),
      "driver_id" : driverData.id.toString(),
      "driver_fit_to_drive" : driverToFitDrive.toString(),
      "improper_logbook_corrections" : lcvLogBookCorrection.toString(),
      "mobile_availability" : availabilityOfMobileWithDriver.toString(),
      "unscheduled_maintenance_penalty_hours" : unscheduledMaintenancePenaltyHours.toString(),
      "scheduled_maintenance_penalty_hours" : scheduledMaintenancePenaltyHours.toString(),
    };
    return map;
  }
}
