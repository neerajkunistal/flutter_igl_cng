List<ScrapUnitTypeModel> scrapUnitListResponse(var json) {
  return List<ScrapUnitTypeModel>.from(json.map((x) => ScrapUnitTypeModel.fromJson(x)));
}

class ScrapUnitTypeModel {

  String? id;
  String? name;
  String? unit;

  ScrapUnitTypeModel({this.id, this.name, this.unit});

  factory ScrapUnitTypeModel.fromJson(Map<String, dynamic> json) {
    return ScrapUnitTypeModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
    );
  }

  static getScrapUnitType() {
    List<ScrapUnitTypeModel> list = [];
    list.add(ScrapUnitTypeModel(
      id: "1",
      name: "Lt",
      unit: "",
    ));
    list.add(ScrapUnitTypeModel(
        id: "2",
        name: "Count",
        unit: "",
    ));
    list.add(ScrapUnitTypeModel(
        id: "3",
        name: "Kg",
        unit: "",
    ));
    return list;
  }
}