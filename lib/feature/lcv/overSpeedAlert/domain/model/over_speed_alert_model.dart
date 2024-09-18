List<OverSpeedAlertModel> overSpeedListResponse(var json) {
  return List<OverSpeedAlertModel>.from(json.map((x) => OverSpeedAlertModel.fromJson(x)));
}

class OverSpeedAlertModel {
  String? overSpeedingLogsId;
  String? vehicleNo;
  String? lcvId;
  String? speed;
  bool? isSelected;

  OverSpeedAlertModel(
      {this.overSpeedingLogsId,
        this.vehicleNo,
        this.lcvId,
        this.speed,
        this.isSelected,
      });

  OverSpeedAlertModel.fromJson(Map<String, dynamic> json) {
    overSpeedingLogsId = json['overspeeding_logs_id'] ?? "";
    vehicleNo = json['vehicle_no'] ?? "";
    lcvId = json['lcv_id'] ?? "";
    speed = json['speed'] ?? "";
    isSelected =  false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['overspeeding_logs_id'] = overSpeedingLogsId;
    data['vehicle_no'] = vehicleNo;
    data['lcv_id'] = lcvId;
    data['speed'] = speed;
    return data;
  }
}