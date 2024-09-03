List<CngScmModel> cngScmListResponse(var json) {
  return List<CngScmModel>.from(json.map((x) => CngScmModel.fromJson(x)));
}

class CngScmModel {
  dynamic id;
  String? stationId;
  String? currentScm;
  String? sellScm;
  String? remainScm;
  String? requiredScm;
  String? date;

  CngScmModel({
    this.currentScm,
    this.requiredScm,
    this.remainScm,
    this.sellScm,
    this.id,
    this.stationId,
    this.date,
  });

  factory CngScmModel.fromJson(Map<String, dynamic> json) {
    return CngScmModel(
      id: json['id'] ?? "",
      stationId: json['cng_station_id'] ?? "",
      currentScm: json['current_scm'] ?? "",
      sellScm: json['sell_scm'] ?? "",
      remainScm: json['remain_scm'] ?? "",
      requiredScm: json['required_scm'] ?? "",
      date: json['created_at'] ?? "",
    );
  }
}
