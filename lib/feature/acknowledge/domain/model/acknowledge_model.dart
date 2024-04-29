List<AcknowledgeModel> acknowledgeListResponse(var json) {
  return List<AcknowledgeModel>.from(json.map((x) => AcknowledgeModel.fromJson(x)));
}

class AcknowledgeModel {
  String? id;
  dynamic serialNumber;
  dynamic complaintDescription;
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
  dynamic crComplaintDescription;
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

  AcknowledgeModel(
      {this.id,
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
        this.assignUser});

  AcknowledgeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ??  ""  ;
    serialNumber = json['serial_number'] ??  ""  ;
    complaintDescription = json['complaint_description'] ??  ""  ;
    loggedBy = json['logged_by'] ??  ""  ;
    incidentDateTime = json['incident_date_time'] ??  ""  ;
    reportBy = json['report_by'] ??  ""  ;
    reportDateTime = json['report_date_time'] ??  ""  ;
    systemId = json['system_id'] ??  ""  ;
    complaintTypeId = json['complaint_type_id'] ??  ""  ;
    attachmentFile = json['attachment_file'] ??  ""  ;
    stationPersonName = json['station_person_name'] ??  ""  ;
    stationPersonSign = json['station_person_sign'] ??  ""  ;
    stationPersonDateTime = json['station_person_date_time'] ??  ""  ;
    stationStatus = json['station_status'] ??  ""  ;
    stationStatusCloseBy = json['station_status_close_by'] ??  ""  ;
    crComplaintTypeId = json['cr_complaint_type_id'] ??  ""  ;
    crComplaintEquipmentId = json['cr_complaint_equipment_id'] ??  ""  ;
    crComplaintDescription = json['cr_complaint_description'] ??  ""  ;
    crComplaintDateTime = json['cr_complaint_date_time'] ??  ""  ;
    crPersonName = json['cr_person_name'] ??  ""  ;
    crPersonSign = json['cr_person_sign'] ??  ""  ;
    crBreakdown = json['cr_breakdown'] ??  ""  ;
    notificationNo = json['notification_no'] ??  ""  ;
    controlRoomId = json['control_room_id'] ??  ""  ;
    cngStationId = json['cng_station_id'] ??  ""  ;
    shiftIncharge = json['shift_incharge'] ??  ""  ;
    departmentId = json['department_id'] ??  ""  ;
    actionTakenDateTime = json['action_taken_date_time'] ??  ""  ;
    actionTakenWorks = json['action_taken_works'] ??  ""  ;
    actionTakenPersonName = json['action_taken_person_name'] ??  ""  ;
    actionTakenPersonSign = json['action_taken_person_sign'] ??  ""  ;
    complaintStatus = json['complaint_status'] ??  ""  ;
    complaintStatusCloseBy = json['complaint_status_close_by'] ??  ""  ;
    source = json['source'] ??  ""  ;
    createdAt = json['created_at'] ??  ""  ;
    updatedAt = json['updated_at'] ??  ""  ;
    attachmentFileType = json['attachment_file_type'] ??  ""  ;
    tokenNo = json['token_no'] ??  ""  ;
    equipmentId = json['equipment_id'] ??  ""  ;
    assignUser = json['assign_user'] ??  ""  ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serial_number'] = this.serialNumber;
    data['complaint_description'] = this.complaintDescription;
    data['logged_by'] = this.loggedBy;
    data['incident_date_time'] = this.incidentDateTime;
    data['report_by'] = this.reportBy;
    data['report_date_time'] = this.reportDateTime;
    data['system_id'] = this.systemId;
    data['complaint_type_id'] = this.complaintTypeId;
    data['attachment_file'] = this.attachmentFile;
    data['station_person_name'] = this.stationPersonName;
    data['station_person_sign'] = this.stationPersonSign;
    data['station_person_date_time'] = this.stationPersonDateTime;
    data['station_status'] = this.stationStatus;
    data['station_status_close_by'] = this.stationStatusCloseBy;
    data['cr_complaint_type_id'] = this.crComplaintTypeId;
    data['cr_complaint_equipment_id'] = this.crComplaintEquipmentId;
    data['cr_complaint_description'] = this.crComplaintDescription;
    data['cr_complaint_date_time'] = this.crComplaintDateTime;
    data['cr_person_name'] = this.crPersonName;
    data['cr_person_sign'] = this.crPersonSign;
    data['cr_breakdown'] = this.crBreakdown;
    data['notification_no'] = this.notificationNo;
    data['control_room_id'] = this.controlRoomId;
    data['cng_station_id'] = this.cngStationId;
    data['shift_incharge'] = this.shiftIncharge;
    data['department_id'] = this.departmentId;
    data['action_taken_date_time'] = this.actionTakenDateTime;
    data['action_taken_works'] = this.actionTakenWorks;
    data['action_taken_person_name'] = this.actionTakenPersonName;
    data['action_taken_person_sign'] = this.actionTakenPersonSign;
    data['complaint_status'] = this.complaintStatus;
    data['complaint_status_close_by'] = this.complaintStatusCloseBy;
    data['source'] = this.source;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['attachment_file_type'] = this.attachmentFileType;
    data['token_no'] = this.tokenNo;
    data['equipment_id'] = this.equipmentId;
    data['assign_user'] = this.assignUser;
    return data;
  }
}