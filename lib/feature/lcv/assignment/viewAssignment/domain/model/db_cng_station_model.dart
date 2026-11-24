List<DbCngStationModel> dbCngStationListResponse(var json) {
  return List<DbCngStationModel>.from(json.map((x) => DbCngStationModel.fromJson(x)));
}

class DbCngStationModel {
  String? id;
  String? dbCngStationId;
  String? createdBy;
  String? arrivalTime;
  String? lcvPointTime;
  String? flowMeterReadingOpening;
  String? inPressure;
  String? flowMeterReadingClosing;
  String? outPressure;
  String? fillEndTime;
  String? lcvNumber;
  String? lcvCondition;
  String? lcvConditionRemarks;
  String? driverId;
  String? driverNotWearingUniform;
  String? createdAt;
  String? updatedAt;
  String? lcvId;
  String? status;
  String? mbManagerEntriesId;
  List<String>? dbCngAttachments;

  DbCngStationModel(
      {this.id,
        this.dbCngStationId,
        this.createdBy,
        this.arrivalTime,
        this.lcvPointTime,
        this.flowMeterReadingOpening,
        this.inPressure,
        this.flowMeterReadingClosing,
        this.outPressure,
        this.fillEndTime,
        this.lcvNumber,
        this.lcvCondition,
        this.lcvConditionRemarks,
        this.driverId,
        this.driverNotWearingUniform,
        this.createdAt,
        this.updatedAt,
        this.lcvId,
        this.status,
        this.mbManagerEntriesId,
        this.dbCngAttachments});

  DbCngStationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "" ;
    dbCngStationId = json['db_cng_station_id'] ?? "" ;
    createdBy = json['created_by'] ?? "" ;
    arrivalTime = json['arrival_time'] ?? "" ;
    lcvPointTime = json['lcv_point_time'] ?? "" ;
    flowMeterReadingOpening = json['flow_meter_reading_opening'] ?? "" ;
    inPressure = json['in_pressure'] ?? "" ;
    flowMeterReadingClosing = json['flow_meter_reading_closing'] ?? "" ;
    outPressure = json['out_pressure'] ?? "" ;
    fillEndTime = json['fill_end_time'] ?? "" ;
    lcvNumber = json['lcv_number'] ?? "" ;
    lcvCondition = json['lcv_condition'] ?? "" ;
    lcvConditionRemarks = json['lcv_condition_remarks'] ?? "" ;
    driverId = json['driver_id'] ?? "" ;
    driverNotWearingUniform = json['driver_not_wearing_uniform'] ?? "" ;
    createdAt = json['created_at'] ?? "" ;
    updatedAt = json['updated_at'] ?? "" ;
    lcvId = json['lcv_id'] ?? "" ;
    status = json['status'] ?? "" ;
    mbManagerEntriesId = json['mb_manager_entries_id'] ?? "" ;
    dbCngAttachments = json['db_cng_attachments'] != null ? json['db_cng_attachments'].cast<String>() : [];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['db_cng_station_id'] = dbCngStationId;
    data['created_by'] = createdBy;
    data['arrival_time'] = arrivalTime;
    data['lcv_point_time'] = lcvPointTime;
    data['flow_meter_reading_opening'] = flowMeterReadingOpening;
    data['in_pressure'] = inPressure;
    data['flow_meter_reading_closing'] = flowMeterReadingClosing;
    data['out_pressure'] = outPressure;
    data['fill_end_time'] = fillEndTime;
    data['lcv_number'] = lcvNumber;
    data['lcv_condition'] = lcvCondition;
    data['lcv_condition_remarks'] = lcvConditionRemarks;
    data['driver_id'] = driverId;
    data['driver_not_wearing_uniform'] = driverNotWearingUniform;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['lcv_id'] = lcvId;
    data['status'] = status;
    data['mb_manager_entries_id'] = mbManagerEntriesId;
    return data;
  }
}