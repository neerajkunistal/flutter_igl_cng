List<AssignedListsModel> assignedListResponse(var json) {
  return List<AssignedListsModel>.from(
      json.map((x) => AssignedListsModel.fromJson(x)));
}



class AssignedListsModel {
  String? id;
  String? ticketNo;
  String? tokenNo;
  String? facilityId;
  String? facilityOtherDesc;
  String? categoryId;
  String? subcategoryId;
  String? complaintDescription;
  String? complainantName;
  String? complainantMobile;
  String? stationId;
  String? controlRoomId;
  String? reportBy;
  String? incidentDateTime;
  String? reportDateTime;
  String? complainDateTime;
  dynamic attachmentFile;
  dynamic videoFile;
  String? stationStatus;
  String? stationStatusCloseBy;
  dynamic stationPersonName;
  dynamic stationPersonSign;
  dynamic stationPersonDateTime;
  dynamic stationRemarks;
  dynamic stationAttachmentFile;
  String? ackRemarks;
  String? ackDate;
  String? ackBy;
  String? ackResponse;
  String? ackStatus;
  String? amoAssignType;
  String? amoAssignTo;
  String? amoAssignStatus;
  String? amoAssignBy;
  String? amoAssignDateTime;
  String? autoVendorId;
  String? autoVendorNotifyStatus;
  dynamic autoVendorNotifyDateTime;
  String? vendorId;
  String? vendorNotifyStatus;
  String? vendorNotifyDateTime;
  String? vendorAssignDatetime;
  String? action;
  String? complaintStatus;
  String? complaintStatusCloseBy;
  dynamic complaintClosedOn;
  dynamic startDateTime;
  dynamic closeDateTime;
  dynamic finalAttachFile;
  dynamic finalRemarks;
  String? reopenBy;
  dynamic reopenDateTime;
  dynamic reopenRemarks;
  String? source;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  String? rejectStatus;
  String? facilityName;
  String? categoryName;
  String? assignedVendorName;

  AssignedListsModel(
      {this.id,
        this.ticketNo,
        this.tokenNo,
        this.facilityId,
        this.facilityOtherDesc,
        this.categoryId,
        this.subcategoryId,
        this.complaintDescription,
        this.complainantName,
        this.complainantMobile,
        this.stationId,
        this.controlRoomId,
        this.reportBy,
        this.incidentDateTime,
        this.reportDateTime,
        this.complainDateTime,
        this.attachmentFile,
        this.videoFile,
        this.stationStatus,
        this.stationStatusCloseBy,
        this.stationPersonName,
        this.stationPersonSign,
        this.stationPersonDateTime,
        this.stationRemarks,
        this.stationAttachmentFile,
        this.ackRemarks,
        this.ackDate,
        this.ackBy,
        this.ackResponse,
        this.ackStatus,
        this.amoAssignType,
        this.amoAssignTo,
        this.amoAssignStatus,
        this.amoAssignBy,
        this.amoAssignDateTime,
        this.autoVendorId,
        this.autoVendorNotifyStatus,
        this.autoVendorNotifyDateTime,
        this.vendorId,
        this.vendorNotifyStatus,
        this.vendorNotifyDateTime,
        this.vendorAssignDatetime,
        this.action,
        this.complaintStatus,
        this.complaintStatusCloseBy,
        this.complaintClosedOn,
        this.startDateTime,
        this.closeDateTime,
        this.finalAttachFile,
        this.finalRemarks,
        this.reopenBy,
        this.reopenDateTime,
        this.reopenRemarks,
        this.source,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.rejectStatus,
        this.facilityName,
        this.categoryName,
        this.assignedVendorName});

  AssignedListsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    ticketNo = json['ticket_no'] ?? "";
    tokenNo = json['token_no'] ?? "";
    facilityId = json['facility_id'] ?? "";
    facilityOtherDesc = json['facility_other_desc'] ?? "";
    categoryId = json['category_id'] ?? "";
    subcategoryId = json['subcategory_id'] ?? "";
    complaintDescription = json['complaint_description'] ?? "";
    complainantName = json['complainant_name'] ?? "";
    complainantMobile = json['complainant_mobile'] ?? "";
    stationId = json['station_id'] ?? "";
    controlRoomId = json['control_room_id'] ?? "";
    reportBy = json['report_by'] ?? "";
    incidentDateTime = json['incident_date_time'] ?? "";
    reportDateTime = json['report_date_time'] ?? "";
    complainDateTime = json['complain_date_time'] ?? "";
    attachmentFile = json['attachment_file'] ?? "";
    videoFile = json['video_file'] ?? "";
    stationStatus = json['station_status'] ?? "";
    stationStatusCloseBy = json['station_status_close_by'] ?? "";
    stationPersonName = json['station_person_name'] ?? "";
    stationPersonSign = json['station_person_sign'] ?? "";
    stationPersonDateTime = json['station_person_date_time'] ?? "";
    stationRemarks = json['station_remarks'] ?? "";
    stationAttachmentFile = json['station_attachment_file'] ?? "";
    ackRemarks = json['ack_remarks'] ?? "";
    ackDate = json['ack_date'] ?? "";
    ackBy = json['ack_by'] ?? "";
    ackResponse = json['ack_response'] ?? "";
    ackStatus = json['ack_status'] ?? "";
    amoAssignType = json['amo_assign_type'] ?? "";
    amoAssignTo = json['amo_assign_to'] ?? "";
    amoAssignStatus = json['amo_assign_status'] ?? "";
    amoAssignBy = json['amo_assign_by'] ?? "";
    amoAssignDateTime = json['amo_assign_date_time'] ?? "";
    autoVendorId = json['auto_vendor_id'] ?? "";
    autoVendorNotifyStatus = json['auto_vendor_notify_status'] ?? "";
    autoVendorNotifyDateTime = json['auto_vendor_notify_date_time'] ?? "";
    vendorId = json['vendor_id'] ?? "";
    vendorNotifyStatus = json['vendor_notify_status'] ?? "";
    vendorNotifyDateTime = json['vendor_notify_date_time'] ?? "";
    vendorAssignDatetime = json['vendor_assign_datetime'] ?? "";
    action = json['action'] ?? "";
    complaintStatus = json['complaint_status'] ?? "";
    complaintStatusCloseBy = json['complaint_status_close_by'] ?? "";
    complaintClosedOn = json['complaint_closed_on'] ?? "";
    startDateTime = json['start_date_time'] ?? "";
    closeDateTime = json['close_date_time'] ?? "";
    finalAttachFile = json['final_attach_file'] ?? "";
    finalRemarks = json['final_remarks'] ?? "";
    reopenBy = json['reopen_by'] ?? "";
    reopenDateTime = json['reopen_date_time'] ?? "";
    reopenRemarks = json['reopen_remarks'] ?? "";
    source = json['source'] ?? "";
    createdBy = json['created_by'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    rejectStatus = json['reject_status'] ?? "";
    facilityName = json['facility_name'] ?? "";
    categoryName = json['category_name'] ?? "";
    assignedVendorName = json['assigned_vendor_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['ticket_no'] = ticketNo;
    data['token_no'] = tokenNo;
    data['facility_id'] = facilityId;
    data['facility_other_desc'] = facilityOtherDesc;
    data['category_id'] = categoryId;
    data['subcategory_id'] = subcategoryId;
    data['complaint_description'] = complaintDescription;
    data['complainant_name'] = complainantName;
    data['complainant_mobile'] = complainantMobile;
    data['station_id'] = stationId;
    data['control_room_id'] = controlRoomId;
    data['report_by'] = reportBy;
    data['incident_date_time'] = incidentDateTime;
    data['report_date_time'] = reportDateTime;
    data['complain_date_time'] = complainDateTime;
    data['attachment_file'] = attachmentFile;
    data['video_file'] = videoFile;
    data['station_status'] = stationStatus;
    data['station_status_close_by'] = stationStatusCloseBy;
    data['station_person_name'] = stationPersonName;
    data['station_person_sign'] = stationPersonSign;
    data['station_person_date_time'] = stationPersonDateTime;
    data['station_remarks'] = stationRemarks;
    data['station_attachment_file'] = stationAttachmentFile;
    data['ack_remarks'] = ackRemarks;
    data['ack_date'] = ackDate;
    data['ack_by'] = ackBy;
    data['ack_response'] = ackResponse;
    data['ack_status'] = ackStatus;
    data['amo_assign_type'] = amoAssignType;
    data['amo_assign_to'] = amoAssignTo;
    data['amo_assign_status'] = amoAssignStatus;
    data['amo_assign_by'] = amoAssignBy;
    data['amo_assign_date_time'] = amoAssignDateTime;
    data['auto_vendor_id'] = autoVendorId;
    data['auto_vendor_notify_status'] = autoVendorNotifyStatus;
    data['auto_vendor_notify_date_time'] = autoVendorNotifyDateTime;
    data['vendor_id'] = vendorId;
    data['vendor_notify_status'] = vendorNotifyStatus;
    data['vendor_notify_date_time'] = vendorNotifyDateTime;
    data['vendor_assign_datetime'] = vendorAssignDatetime;
    data['action'] = action;
    data['complaint_status'] = complaintStatus;
    data['complaint_status_close_by'] = complaintStatusCloseBy;
    data['complaint_closed_on'] = complaintClosedOn;
    data['start_date_time'] = startDateTime;
    data['close_date_time'] = closeDateTime;
    data['final_attach_file'] = finalAttachFile;
    data['final_remarks'] = finalRemarks;
    data['reopen_by'] = reopenBy;
    data['reopen_date_time'] = reopenDateTime;
    data['reopen_remarks'] = reopenRemarks;
    data['source'] = source;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['reject_status'] = rejectStatus;
    data['facility_name'] = facilityName;
    data['category_name'] = categoryName;
    data['assigned_vendor_name'] = assignedVendorName;
    return data;
  }
}
