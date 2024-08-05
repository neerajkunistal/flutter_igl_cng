List<CngModel> cngListResponse(var json) {
  return List<CngModel>.from(json.map((x) => CngModel.fromJson(x)));
}

class CngModel {
  String? id;
  String? controlRoomId;
  String? cngStationId;
  String? categoryId;
  String? complaintDescription;
  String? incidentDateTime;
  String? reportDateTime;
  String? reportByName;
  String? reportByPhone;
  String? approveBy;
  String? approveStatus;
  dynamic approveDataTime;
  dynamic complaintNumber;
  String? assignBy;
  String? assignTo;
  dynamic assignDataTime;
  dynamic estimateCost;
  dynamic estimateAttachment;
  dynamic estimateCostDataTime;
  String? estimateApproveBy;
  String? estimateStatus;
  dynamic estimateApproveDataTime;
  String? measurementSheetBy;
  dynamic measurementSheetDataTime;
  String? complaintStatus;
  String? complaintCloseBy;
  dynamic complaintClosedOn;
  dynamic anyRemarks;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  String? assignToVendor;
  String? categoryName;
  String? cngStation;
  String? controlRoom;
  List<dynamic>? createdComplaintImagesList;

  CngModel(
      {this.id,
      this.controlRoomId,
      this.cngStationId,
      this.categoryId,
      this.complaintDescription,
      this.incidentDateTime,
      this.reportDateTime,
      this.reportByName,
      this.reportByPhone,
      this.approveBy,
      this.approveStatus,
      this.approveDataTime,
      this.complaintNumber,
      this.assignBy,
      this.assignTo,
      this.assignDataTime,
      this.estimateCost,
      this.estimateAttachment,
      this.estimateCostDataTime,
      this.estimateApproveBy,
      this.estimateStatus,
      this.estimateApproveDataTime,
      this.measurementSheetBy,
      this.measurementSheetDataTime,
      this.complaintStatus,
      this.complaintCloseBy,
      this.complaintClosedOn,
      this.anyRemarks,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.assignToVendor,
      this.categoryName,
      this.cngStation,
      this.controlRoom,
      this.createdComplaintImagesList,
      });

  CngModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    controlRoomId = json['control_room_id'] ?? "";
    cngStationId = json['cng_station_id'] ?? "";
    categoryId = json['category_id'] ?? "";
    complaintDescription = json['complaint_description'] ?? "";
    incidentDateTime = json['incident_date_time'] ?? "";
    reportDateTime = json['report_date_time'] ?? "";
    reportByName = json['report_by'] ?? "";
    reportByPhone = json['report_by_phone'] ?? "";
    approveBy = json['approve_by'] ?? "";
    approveStatus = json['approve_status'] ?? "";
    approveDataTime = json['approve_data_time'] ?? "";
    complaintNumber = json['complaint_number'] ?? "";
    assignBy = json['assign_by'] ?? "";
    assignTo = json['assign_to'] ?? "";
    assignDataTime = json['assign_data_time'] ?? "";
    estimateCost = json['estimate_cost'] ?? "0";
    estimateAttachment = json['estimate_attachment'] ?? "";
    estimateCostDataTime = json['estimate_cost_data_time'] ?? "";
    estimateApproveBy = json['estimate_approve_by'] ?? "";
    estimateStatus = json['estimate_status'] ?? "";
    estimateApproveDataTime = json['estimate_approve_data_time'] ?? "";
    measurementSheetBy = json['measurement_sheet_by'] ?? "";
    measurementSheetDataTime = json['measurement_sheet_data_time'] ?? "";
    complaintStatus = json['complaint_status'] ?? "";
    complaintCloseBy = json['complaint_close_by'] ?? "";
    complaintClosedOn = json['complaint_closed_on'] ?? "";
    anyRemarks = json['any_remarks'] ?? "";
    createdBy = json['created_by'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    assignToVendor = json['assign_to_vendor'] ?? "";
    categoryName = json['category_name'] ?? "";
    cngStation = json['cng_station'] ?? "";
    controlRoom = json['control_room'] ?? "";
    createdComplaintImagesList = json['created_time_images'] !=  null
        ? json['created_time_images'].cast<dynamic>() : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['control_room_id'] = controlRoomId;
    data['cng_station_id'] = cngStationId;
    data['category_id'] = categoryId;
    data['complaint_description'] = complaintDescription;
    data['incident_date_time'] = incidentDateTime;
    data['report_date_time'] = reportDateTime;
    data['report_by'] = reportByName;
    data['approve_by'] = approveBy;
    data['approve_status'] = approveStatus;
    data['approve_data_time'] = approveDataTime;
    data['complaint_number'] = complaintNumber;
    data['assign_by'] = assignBy;
    data['assign_to'] = assignTo;
    data['assign_data_time'] = assignDataTime;
    data['estimate_cost'] = estimateCost;
    data['estimate_attachment'] = estimateAttachment;
    data['estimate_cost_data_time'] = estimateCostDataTime;
    data['estimate_approve_by'] = estimateApproveBy;
    data['estimate_status'] = estimateStatus;
    data['estimate_approve_data_time'] = estimateApproveDataTime;
    data['measurement_sheet_by'] = measurementSheetBy;
    data['measurement_sheet_data_time'] = measurementSheetDataTime;
    data['complaint_status'] = complaintStatus;
    data['complaint_close_by'] = complaintCloseBy;
    data['complaint_closed_on'] = complaintClosedOn;
    data['any_remarks'] = anyRemarks;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
