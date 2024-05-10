List<SparesModel> sparesListResponse(var json) {
  return List<SparesModel>.from(json.map((x) => SparesModel.fromJson(x)));
}

class SparesModel {
  String? id;
  String? spareName;
  String? spareUom;

  SparesModel({this.id, this.spareName, this.spareUom});

  SparesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    spareName = json['spare_name'] ?? "";
    spareUom = json['spare_uom'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['spare_name'] = spareName;
    data['spare_uom'] = spareUom;
    return data;
  }
}
