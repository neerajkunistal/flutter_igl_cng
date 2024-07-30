class ScrapUnitTypeModel {

  String? id;
  String? name;
  String? unit;

  ScrapUnitTypeModel({this.id, this.name, this.unit});

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