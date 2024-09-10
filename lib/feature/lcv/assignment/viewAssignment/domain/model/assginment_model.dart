import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:hive/hive.dart';

part 'assginment_model.g.dart';

List<AssignmentModel> assignmentListResponse(var json) {
  return List<AssignmentModel>.from(
      json.map((x) => AssignmentModel.fromJson(x)));
}

class AssignmentModel {
  dynamic id;
  String? motherStation;
  dynamic motherStationId;
  String? cngStation;
  String? orderId;
  String? driverName;
  String? vehicleNo;
  String? scm;
  String? quantity;
  String? status;
  String? createdAt;
  String? createdFor;
  String? motherStationAddress;
  dynamic motherStationLat;
  dynamic motherStationLong;
  String? motherStationCity;
  String? motherStationDistrict;
  String? motherStationState;
  String? cngStationAddress;
  dynamic cngStationLat;
  dynamic cngStationLong;
  String? cngStationCity;
  String? cngStationDistrict;
  String? cngStationState;
  AssignmentStatus? assignmentStatus;
  Color? assignmentStatusColor;
  bool? isSelected;
  String? receivedScmQuantity;
  String? currentScmQuantity;
  String? remark;
  String? cngStationId;
  String? driverLicenseId;
  String? motherStationFirebaseId;
  String? routeId;
  String? startDateTime;
  String? delay;
  String? scheduleDateTime;
  String? slipPhoto;
  String? startSelfPhoto;
  String? endSelfPhoto;
  String? startTruckImage;
  String? endTruckImage;
  String? driverId;
  String? notificationDateTime;
  List<FirebaseIdModel>? firebaseIdList;

  AssignmentModel({
    this.id,
    this.motherStation,
    this.motherStationId,
    this.cngStation,
    this.orderId,
    this.driverName,
    this.vehicleNo,
    this.scm,
    this.quantity,
    this.status,
    this.createdAt,
    this.createdFor,
    this.motherStationAddress,
    this.motherStationLat,
    this.motherStationLong,
    this.motherStationCity,
    this.motherStationDistrict,
    this.motherStationState,
    this.cngStationAddress,
    this.cngStationLat,
    this.cngStationLong,
    this.cngStationCity,
    this.cngStationDistrict,
    this.cngStationState,
    this.assignmentStatus,
    this.assignmentStatusColor,
    this.isSelected,
    this.receivedScmQuantity,
    this.currentScmQuantity,
    this.remark,
    this.cngStationId,
    this.driverLicenseId,
    this.motherStationFirebaseId,
    this.routeId,
    this.startDateTime,
    this.delay,
    this.scheduleDateTime,
    this.firebaseIdList,
    this.endSelfPhoto,
    this.endTruckImage,
    this.slipPhoto,
    this.startSelfPhoto,
    this.startTruckImage,
    this.driverId,
    this.notificationDateTime,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    AssignmentStatus assignmentStatus =
        getAssignmentStatus(status: json['status'] ?? "");
    String delay = "";
    if (json['scheduledatetime'] != null &&
        json['scheduledatetime'].toString().isNotEmpty &&
        json['start_time'] != null &&
        json['start_time'].toString().isNotEmpty) {
      DateTime scheduleDateTime =
          DateTime.parse(json['scheduledatetime'].toString());
      DateTime startDateTime = DateTime.parse(json['start_time'].toString());
      delay = startDateTime.difference(scheduleDateTime).inMinutes.toString();
    }

    String slipPhoto = "";
    String startSelfPhoto = "";
    String endSelfPhoto = "";
    String startTruckPhoto = "";
    String endTruckPhoto = "";

    if (json['slip_photo'] != null && json['driver_id'] != null) {
      slipPhoto =
          "${APIs.baseUrl}writable/uploads/slip_photo/${json['driver_id']}/${json['slip_photo']}";
    }

    if (json['start_self_photo'] != null && json['driver_id'] != null) {
      startSelfPhoto =
          "${APIs.baseUrl}writable/uploads/self_photo/${json['driver_id']}/${json['start_self_photo']}";
    }

    if (json['end_self_photo'] != null && json['driver_id'] != null) {
      endSelfPhoto =
          "${APIs.baseUrl}writable/uploads/self_photo/${json['driver_id']}/${json['end_self_photo']}";
    }

    if (json['start_truck_image'] != null && json['driver_id'] != null) {
      startTruckPhoto =
          "${APIs.baseUrl}writable/uploads/truck_photo/${json['driver_id']}/${json['start_truck_image']}";
    }

    if (json['end_truck_image'] != null && json['driver_id'] != null) {
      endTruckPhoto =
          "${APIs.baseUrl}writable/uploads/truck_photo/${json['driver_id']}/${json['end_truck_image']}";
    }

    return AssignmentModel(
      id: json['assignment_id'] ?? "",
      motherStation: json['mother_station'] ?? "",
      motherStationId: json['mother_station_id'] ?? "",
      cngStation: json['cng_station'] ?? "",
      orderId: json['order_id'] ?? "",
      driverName: json['driver_name'] ?? "",
      vehicleNo: json['vehicle_no'] ?? "",
      scm: json['scm'] ?? "",
      quantity: json['quantity'] ?? "",
      status: json['status'] ?? "",
      createdAt: json['created_at'] ?? "",
      createdFor: json['created_for'] ?? "",
      motherStationAddress: json['mother_station_address'] ?? "",
      motherStationLat: json['mother_station_lat'] ?? 0.0,
      motherStationLong: json['mother_station_long'] ?? 0.0,
      motherStationCity: json['mother_station_city'] ?? "",
      motherStationDistrict: json['mother_station_district'] ?? "",
      motherStationState: json['mother_station_state'] ?? "",
      cngStationAddress: json['cng_station_address'] ?? "",
      cngStationLat: json['cng_station_lat'] ?? 0.0,
      cngStationLong: json['cng_station_long'] ?? 0.0,
      cngStationCity: json['cng_station_city'] ?? "",
      cngStationDistrict: json['cng_station_district'] ?? "",
      cngStationState: json['cng_station_state'] ?? "",
      receivedScmQuantity: json['cng_station_current_scm'] ?? "",
      currentScmQuantity: json['cng_station_recieve_scm'] ?? "",
      remark: json['cng_station_recieve_scm'] ?? "",
      cngStationId: json['cng_station_id'] ?? "",
      driverLicenseId: json['driver_license_id'] ?? "",
      motherStationFirebaseId: json['mother_station_firebase_id'] ?? "",
      routeId: json['route_id'] ?? "",
      startDateTime: json['start_time'] ?? "",
      isSelected: false,
      delay: delay,
      scheduleDateTime: json['scheduledatetime'] ?? "",
      assignmentStatus: assignmentStatus,
      slipPhoto: slipPhoto,
      startSelfPhoto: startSelfPhoto,
      endSelfPhoto: endSelfPhoto,
      startTruckImage: startTruckPhoto,
      endTruckImage: endTruckPhoto,
      driverId: json['driver_id'] ?? "",
      firebaseIdList: json['cng_user_firebase_id'] == null
          ? []
          : List<FirebaseIdModel>.from(json['cng_user_firebase_id']
              .map((x) => FirebaseIdModel.fromJson(x))),
      assignmentStatusColor:
          getAssignmentStatusColor(assignmentStatus: assignmentStatus),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mother_station'] = motherStation;
    data['cng_station'] = cngStation;
    data['order_id'] = orderId;
    data['driver_name'] = driverName;
    data['vehicle_no'] = vehicleNo;
    data['scm'] = scm;
    data['quantity'] = quantity;
    data['created_at'] = createdAt;
    return data;
  }

  static getAssignmentStatus({required String status}) {
    switch (status) {
      case "0":
        return AssignmentStatus.pending;
      case "1":
        return AssignmentStatus.confirm;
      case "2":
        return AssignmentStatus.startRoute;
      case "3":
        return AssignmentStatus.complete;
      case "4":
        return AssignmentStatus.cancel;
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
        return Colors.green[600];
      case AssignmentStatus.cancel:
        return Colors.red[600];
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
