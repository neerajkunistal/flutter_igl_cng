import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/db_cng_station_model.dart';

List<AssignmentModel> assignmentListResponse(var json) {
  return List<AssignmentModel>.from(
      json.map((x) => AssignmentModel.fromJson(x)));
}

class AssignmentModel {
  String? id;
  String? mbStationId;
  String? createdBy;
  String? lcvEntryTime;
  String? fillStartTime;
  String? flowMeterReadingOpening;
  String? flowMeterReadingClosing;
  String? fillEndTime;
  String? outPressure;
  String? lcvCondition;
  String? lcvConditionRemarks;
  String? lcvNumber;
  String? driverId;
  String? driverFitToDrive;
  String? improperLogbookCorrections;
  String? mobileAvailability;
  String? unscheduledMaintenancePenaltyHours;
  String? scheduledMaintenancePenaltyHours;
  String? createdAt;
  String? updatedAt;
  String? lcvId;
  String? dbCngStationId;
  String? status;
  String? mbStationName;
  String? dbStationName;
  dynamic vehicleName;
  dynamic driverName;
  String? attachmentPath;
  AssignmentStatus? assignmentStatus;
  Color? assignmentStatusColor;
  bool? isSelected;
  List<String>? motherStationAttachments;
  List<DbCngStationModel>? dbCngStationList;

  AssignmentModel(
      {this.id,
        this.mbStationId,
        this.createdBy,
        this.lcvEntryTime,
        this.fillStartTime,
        this.flowMeterReadingOpening,
        this.flowMeterReadingClosing,
        this.fillEndTime,
        this.outPressure,
        this.lcvCondition,
        this.lcvConditionRemarks,
        this.lcvNumber,
        this.driverId,
        this.driverFitToDrive,
        this.improperLogbookCorrections,
        this.mobileAvailability,
        this.unscheduledMaintenancePenaltyHours,
        this.scheduledMaintenancePenaltyHours,
        this.createdAt,
        this.updatedAt,
        this.lcvId,
        this.dbCngStationId,
        this.status,
        this.mbStationName,
        this.dbStationName,
        this.vehicleName,
        this.driverName,
        this.attachmentPath,
        this.assignmentStatus,
        this.assignmentStatusColor,
        this.isSelected,
        this.motherStationAttachments,
        this.dbCngStationList,
      });

  AssignmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ??  "";
    mbStationId = json['mb_station_id'] ??  "";
    createdBy = json['created_by'] ??  "";
    lcvEntryTime = json['lcv_entry_time'] ??  "";
    fillStartTime = json['fill_start_time'] ??  "";
    flowMeterReadingOpening = json['flow_meter_reading_opening'] ??  "";
    flowMeterReadingClosing = json['flow_meter_reading_closing'] ??  "";
    fillEndTime = json['fill_end_time'] ??  "";
    outPressure = json['out_pressure'] ??  "";
    lcvCondition = json['lcv_condition'] ??  "";
    lcvConditionRemarks = json['lcv_condition_remarks'] ??  "";
    lcvNumber = json['lcv_number'] ??  "";
    driverId = json['driver_id'] ??  "";
    driverFitToDrive = json['driver_fit_to_drive'] ??  "";
    improperLogbookCorrections = json['improper_logbook_corrections'] ??  "";
    mobileAvailability = json['mobile_availability'] ??  "";
    unscheduledMaintenancePenaltyHours =
    json['unscheduled_maintenance_penalty_hours'] ??  "";
    scheduledMaintenancePenaltyHours =
    json['scheduled_maintenance_penalty_hours'] ??  "";
    createdAt = json['created_at'] ??  "";
    updatedAt = json['updated_at'] ??  "";
    lcvId = json['lcv_id'] ??  "";
    dbCngStationId = json['db_cng_station_id'] ??  "";
    status = json['status'] ??  "";
    mbStationName = json['mb_station_name'] ??  "";
    dbStationName = json['db_station_name'] ??  "";
    vehicleName = json['vehicle_name'] ??  "";
    driverName = json['driver_name'] ??  "";
    attachmentPath = json['attachment_path'] ??  "";
    motherStationAttachments = json['mb_attachments'] != null ? json['mb_attachments'].cast<String>() : [];
    isSelected =  false;
    assignmentStatus =  json['status'] != null
        ? getAssignmentStatus(status: json['status'])
        : AssignmentStatus.pending;
    assignmentStatusColor = getAssignmentStatusColor(assignmentStatus: assignmentStatus!);
    dbCngStationList =  json['DbCngManagerEntries'] != null
        ? dbCngStationListResponse(json['DbCngManagerEntries']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mb_station_id'] = mbStationId;
    data['created_by'] = createdBy;
    data['lcv_entry_time'] = lcvEntryTime;
    data['fill_start_time'] = fillStartTime;
    data['flow_meter_reading_opening'] = flowMeterReadingOpening;
    data['flow_meter_reading_closing'] = flowMeterReadingClosing;
    data['fill_end_time'] = fillEndTime;
    data['out_pressure'] = outPressure;
    data['lcv_condition'] = lcvCondition;
    data['lcv_condition_remarks'] = lcvConditionRemarks;
    data['lcv_number'] = lcvNumber;
    data['driver_id'] = driverId;
    data['driver_fit_to_drive'] = driverFitToDrive;
    data['improper_logbook_corrections'] = improperLogbookCorrections;
    data['mobile_availability'] = mobileAvailability;
    data['unscheduled_maintenance_penalty_hours'] =
        unscheduledMaintenancePenaltyHours;
    data['scheduled_maintenance_penalty_hours'] =
        scheduledMaintenancePenaltyHours;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['lcv_id'] = lcvId;
    data['db_cng_station_id'] = dbCngStationId;
    data['status'] = status;
    data['mb_station_name'] = mbStationName;
    data['db_station_name'] = dbStationName;
    data['vehicle_name'] = vehicleName;
    data['driver_name'] = driverName;
    data['attachment_path'] = attachmentPath;
    return data;
  }

  static getAssignmentStatus({required String status}) {
    switch (status) {
      case "0":
        return AssignmentStatus.pending;
      case "1":
        return AssignmentStatus.complete;
      case "2":
        return AssignmentStatus.cancel;
      case "3":
        return AssignmentStatus.confirm;
      case "4":
        return AssignmentStatus.startRoute;
      default:
        return AssignmentStatus.pending;
    }
  }

  static getAssignmentStatusId({required AssignmentStatus assignmentStatus}) {
    switch (assignmentStatus) {
      case AssignmentStatus.pending:
        return "0";
      case AssignmentStatus.confirm:
        return "1";
      case AssignmentStatus.startRoute:
        return "2";
      case AssignmentStatus.complete:
        return "3";
      case AssignmentStatus.cancel:
        return "4";
      default:
        return "1";
    }
  }

  static getAssignmentChangeStatusId(
      {required AssignmentStatus assignmentStatus}) {
    switch (assignmentStatus) {
      case AssignmentStatus.pending:
        return "1";
      case AssignmentStatus.confirm:
        return "2";
      case AssignmentStatus.startRoute:
        return "3";
      case AssignmentStatus.complete:
        return "4";
      default:
        return "1";
    }
  }

  static getAssignmentStatusColor(
      {required AssignmentStatus assignmentStatus}) {
    switch (assignmentStatus) {
      case AssignmentStatus.pending:
        return Colors.amber;
      case AssignmentStatus.confirm:
        return Colors.orange;
      case AssignmentStatus.startRoute:
        return Colors.teal;
      case AssignmentStatus.complete:
        return Colors.green[600] ??  "";
      case AssignmentStatus.cancel:
        return Colors.red[600] ??  "";
      default:
        return Colors.amber;
    }
  }
}

class FirebaseIdModel {
  String? id;
  String? assignmentId;
  String? firebaseId;
  String? email;
  String? createdAt;

  FirebaseIdModel(
      {this.id,
      this.assignmentId,
      this.firebaseId,
      this.email,
      this.createdAt});

  factory FirebaseIdModel.fromJson(Map<String, dynamic> json) {
    return FirebaseIdModel(
      id: json['id'] ?? "",
      assignmentId: json['assignment_id'] ?? "",
      firebaseId: json['firebase_id'] ?? "",
      email: json['email'] ?? "",
      createdAt: json['created_at'] ?? "",
    );
  }
}
