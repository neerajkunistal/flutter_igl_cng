List<ComplaintModel> complaintListResponse(var json) {
  return List<ComplaintModel>.from(json.map((x) => ComplaintModel.fromJson(x)));
}

class ComplaintModel {
  dynamic id;
  dynamic complaintDescription;
  String? reportDateTime;
  String? complaintTypeId;
  String? equipmentId;

  ComplaintModel(
      { this.id,
        this.complaintDescription,
        this.reportDateTime,
        this.complaintTypeId,
        this.equipmentId});

  ComplaintModel.fromJson(Map<String, dynamic> json) {
    complaintDescription = json['complaint_description'] ?? "";
    id = json['id'] ?? "";
    reportDateTime = json['report_date_time'] ?? "";
    complaintTypeId = json['complaint_type_id'] ?? "";
    equipmentId = json['equipment_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['complaint_description'] = complaintDescription;
    data['report_date_time'] = reportDateTime;
    data['complaint_type_id'] = complaintTypeId;
    data['equipment_id'] = equipmentId;
    return data;
  }
}