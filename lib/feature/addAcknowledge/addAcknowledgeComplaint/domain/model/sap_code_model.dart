List<SapCodeModel> sapCodeListResponse(var json) {
  return List<SapCodeModel>.from(json.map((x) => SapCodeModel.fromJson(x)));
}

class SapCodeModel {
  dynamic id;
  String? name;
  String? code;

  SapCodeModel({this.id, this.name, this.code});

  factory SapCodeModel.fromJson(Map<String, dynamic> json) {
    return SapCodeModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      code: json['code'] ?? "",
    );
  }
}
