List<CodeGroupModel> codeGroupListResponse(var json) {
  return List<CodeGroupModel>.from(json.map((x) => CodeGroupModel.fromJson(x)));
}

class CodeGroupModel {

  dynamic id;
  String? name;
  String? code;

  CodeGroupModel({
   this.id,
   this.name,
   this.code,
 });

  factory CodeGroupModel.fromJson(Map<String, dynamic> json) {
    return CodeGroupModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      code: json['code'] ?? "",
    );
  }
}