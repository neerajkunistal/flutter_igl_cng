List<ReviewComplaintModel> reviewComplaintListResponse(var json) {
  return List<ReviewComplaintModel>.from(
      json.map((x) => ReviewComplaintModel.fromJson(x)));
}

class ReviewComplaintModel {
  String? id;
  dynamic serialNumber;
  String? complaintDescription;
  dynamic loggedBy;
  dynamic incidentDateTime;
  dynamic reportBy;
  String? reportDateTime;
  String? systemId;
  String? complaintTypeId;
  String? attachmentFile;
  dynamic stationPersonName;
  dynamic stationPersonSign;
  dynamic stationPersonDateTime;
  String? stationStatus;
  String? stationStatusCloseBy;
  String? crComplaintTypeId;
  String? crComplaintEquipmentId;
  String? crComplaintDescription;
  dynamic crComplaintDateTime;
  dynamic crPersonName;
  dynamic crPersonSign;
  String? crBreakdown;
  String? notificationNo;
  String? controlRoomId;
  String? cngStationId;
  dynamic shiftIncharge;
  String? departmentId;
  dynamic actionTakenDateTime;
  dynamic actionTakenWorks;
  dynamic actionTakenPersonName;
  dynamic actionTakenPersonSign;
  String? complaintStatus;
  String? complaintStatusCloseBy;
  String? source;
  String? createdAt;
  String? updatedAt;
  dynamic attachmentFileType;
  String? tokenNo;
  String? equipmentId;
  dynamic assignUser;
  String? action;
  dynamic miAttachFile;
  String? amcStatus;
  String? amcDate;
  dynamic remarks;
  String? startDateTime;
  String? closeDateTime;
  String? spareId;
  String? seApproval;
  String? seObservation;
  String? equipmentName;
  String? equipmentCode;
  String? complaintDateTime;
  String? maintenanceStartDate;
  String? maintenanceEndDate;
  String? maintenanceHoldDate;
  String? generalComplaintId;
  String? generalComplaintRemark;
  String? assignTo;
  String? assignType;
  String? createdByUser;
  String? generalComplaintName;
  String? vendorCode;
  String? miAssignType;
  String? miAssignToUser;
  String? ackStatus;

  ReviewComplaintModel({
    this.id,
    this.serialNumber,
    this.complaintDescription,
    this.loggedBy,
    this.incidentDateTime,
    this.reportBy,
    this.reportDateTime,
    this.systemId,
    this.complaintTypeId,
    this.attachmentFile,
    this.stationPersonName,
    this.stationPersonSign,
    this.stationPersonDateTime,
    this.stationStatus,
    this.stationStatusCloseBy,
    this.crComplaintTypeId,
    this.crComplaintEquipmentId,
    this.crComplaintDescription,
    this.crComplaintDateTime,
    this.crPersonName,
    this.crPersonSign,
    this.crBreakdown,
    this.notificationNo,
    this.controlRoomId,
    this.cngStationId,
    this.shiftIncharge,
    this.departmentId,
    this.actionTakenDateTime,
    this.actionTakenWorks,
    this.actionTakenPersonName,
    this.actionTakenPersonSign,
    this.complaintStatus,
    this.complaintStatusCloseBy,
    this.source,
    this.createdAt,
    this.updatedAt,
    this.attachmentFileType,
    this.tokenNo,
    this.equipmentId,
    this.assignUser,
    this.action,
    this.miAttachFile,
    this.amcStatus,
    this.amcDate,
    this.remarks,
    this.startDateTime,
    this.closeDateTime,
    this.spareId,
    this.seApproval,
    this.seObservation,
    this.equipmentName,
    this.equipmentCode,
    this.complaintDateTime,
    this.maintenanceEndDate,
    this.maintenanceStartDate,
    this.maintenanceHoldDate,
    this.generalComplaintId,
    this.generalComplaintRemark,
    this.assignTo,
    this.assignType,
    this.createdByUser,
    this.generalComplaintName,
    this.vendorCode,
    this.miAssignType,
    this.miAssignToUser,
    this.ackStatus,
  });

  ReviewComplaintModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    serialNumber = json['serial_number'] ?? "";
    complaintDescription = json['complaint_description'] ?? "";
    loggedBy = json['logged_by'] ?? "";
    incidentDateTime = json['incident_date_time'] ?? "";
    reportBy = json['report_by'] ?? "";
    reportDateTime = json['report_date_time'] ?? "";
    systemId = json['system_id'] ?? "";
    complaintTypeId = json['complaint_type_id'] ?? "";
    attachmentFile = json['attachment_file'] ?? "";
    stationPersonName = json['station_person_name'] ?? "";
    stationPersonSign = json['station_person_sign'] ?? "";
    stationPersonDateTime = json['station_person_date_time'] ?? "";
    stationStatus = json['station_status'] ?? "";
    stationStatusCloseBy = json['station_status_close_by'] ?? "";
    crComplaintTypeId = json['cr_complaint_type_id'] ?? "";
    crComplaintEquipmentId = json['cr_complaint_equipment_id'] ?? "";
    crComplaintDescription = json['cr_complaint_description'] ?? "";
    crComplaintDateTime = json['cr_complaint_date_time'] ?? "";
    crPersonName = json['cr_person_name'] ?? "";
    crPersonSign = json['cr_person_sign'] ?? "";
    crBreakdown = json['cr_breakdown'] ?? "";
    notificationNo = json['notification_no'] ?? "";
    controlRoomId = json['control_room_id'] ?? "";
    cngStationId = json['cng_station_id'] ?? "";
    shiftIncharge = json['shift_incharge'] ?? "";
    departmentId = json['department_id'] ?? "";
    actionTakenDateTime = json['action_taken_date_time'] ?? "";
    actionTakenWorks = json['action_taken_works'] ?? "";
    actionTakenPersonName = json['action_taken_person_name'] ?? "";
    actionTakenPersonSign = json['action_taken_person_sign'] ?? "";
    complaintStatus = json['complaint_status'] ?? "";
    complaintStatusCloseBy = json['complaint_status_close_by'] ?? "";
    source = json['source'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    attachmentFileType = json['attachment_file_type'] ?? "";
    tokenNo = json['token_no'] ?? "";
    equipmentId = json['equipment_id'] ?? "";
    assignUser = json['assign_user'] ?? "";
    action = json['action'] ?? "";
    miAttachFile = json['mi_attach_file'] ?? "";
    amcStatus = json['amc_status'] ?? "";
    amcDate = json['amc_date'] ?? "";
    remarks = json['remarks'] ?? "";
    startDateTime = json['start_date_time'] ?? "";
    closeDateTime = json['close_date_time'] ?? "";
    spareId = json['spare_id'] ?? "";
    seApproval = json['se_approval'] ?? "";
    seObservation = json['se_observation'] ?? "";
    equipmentName = json['equipment_name'] ?? "";
    equipmentCode = json['equipment_code'] ?? "";
    complaintDateTime = json['complain_date_time'] ?? "";
    maintenanceEndDate = json['maintenance_end_date'] ?? "";
    maintenanceStartDate = json['maintenance_start_date'] ?? "";
    maintenanceHoldDate = json['maintenance_hold_date'] ?? "";
    generalComplaintId = json['general_complain_id'] ?? "";
    generalComplaintRemark = json['general_complain_remarks'] ?? "";
    assignTo = json['se_assign_to'] ?? "";
    assignType = json['se_assign_type'] ?? "";
    createdByUser = json['created_by_user'] ?? "";
    generalComplaintName = json['general_complain_name'] ?? "";
    vendorCode = json['vendor_code'] ?? "";
    miAssignType = json['mi_assign_type'] ?? "";
    miAssignToUser = json['assigned_vendor_name'] ?? "";
    ackStatus = json['ack_status'] ?? "";

    if (vendorCode.toString().isEmpty) {
      vendorCode = json['mi_assign_to_vendor_code'] ?? "";
    }

    if (miAssignToUser.toString().isEmpty) {
      miAssignToUser = json['mi_assign_to_vendor_name'] ?? "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['serial_number'] = serialNumber;
    data['complaint_description'] = complaintDescription;
    data['logged_by'] = loggedBy;
    data['incident_date_time'] = incidentDateTime;
    data['report_by'] = reportBy;
    data['report_date_time'] = reportDateTime;
    data['system_id'] = systemId;
    data['complaint_type_id'] = complaintTypeId;
    data['attachment_file'] = attachmentFile;
    data['station_person_name'] = stationPersonName;
    data['station_person_sign'] = stationPersonSign;
    data['station_person_date_time'] = stationPersonDateTime;
    data['station_status'] = stationStatus;
    data['station_status_close_by'] = stationStatusCloseBy;
    data['cr_complaint_type_id'] = crComplaintTypeId;
    data['cr_complaint_equipment_id'] = crComplaintEquipmentId;
    data['cr_complaint_description'] = crComplaintDescription;
    data['cr_complaint_date_time'] = crComplaintDateTime;
    data['cr_person_name'] = crPersonName;
    data['cr_person_sign'] = crPersonSign;
    data['cr_breakdown'] = crBreakdown;
    data['notification_no'] = notificationNo;
    data['control_room_id'] = controlRoomId;
    data['cng_station_id'] = cngStationId;
    data['shift_incharge'] = shiftIncharge;
    data['department_id'] = departmentId;
    data['action_taken_date_time'] = actionTakenDateTime;
    data['action_taken_works'] = actionTakenWorks;
    data['action_taken_person_name'] = actionTakenPersonName;
    data['action_taken_person_sign'] = actionTakenPersonSign;
    data['complaint_status'] = complaintStatus;
    data['complaint_status_close_by'] = complaintStatusCloseBy;
    data['source'] = source;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['attachment_file_type'] = attachmentFileType;
    data['token_no'] = tokenNo;
    data['equipment_id'] = equipmentId;
    data['assign_user'] = assignUser;
    data['action'] = action;
    data['mi_attach_file'] = miAttachFile;
    data['amc_status'] = amcStatus;
    data['amc_date'] = amcDate;
    data['remarks'] = remarks;
    data['start_date_time'] = startDateTime;
    data['close_date_time'] = closeDateTime;
    data['spare_id'] = spareId;
    data['se_approval'] = seApproval;
    data['se_observation'] = seObservation;
    return data;
  }
}
