class AssignTypeModel {
  dynamic id;
  String? name;

  AssignTypeModel({this.name, this.id});

  fetchData() {
    List<AssignTypeModel> list = [];
    list.add(AssignTypeModel(
      id: "1",
      name: "Self",
    ));
    list.add(AssignTypeModel(
      id: "2",
      name: "MI",
    ));
    list.add(AssignTypeModel(
      id: "3",
      name: "Vendors",
    ));
    return list;
  }
}