List<UomTypeModel> uomTypeLIstResponse(var json) {
  return List<UomTypeModel>.from(json.map((x) => UomTypeModel.fromJson(x)));
}

class UomTypeModel {
  String? id;
  String? uom;

  UomTypeModel({this.id, this.uom});

  UomTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    uom = json['uom'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uom'] = uom;
    return data;
  }
}
