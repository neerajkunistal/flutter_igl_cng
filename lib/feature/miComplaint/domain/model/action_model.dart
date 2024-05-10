class ActionModel {
  dynamic id;
  String? value;

  ActionModel({this.id, this.value});

  fetchData() {
    List<ActionModel> list = [];
    list.add(ActionModel(id: "1", value: "Start"));
    list.add(ActionModel(id: "2", value: "Hold"));
    list.add(ActionModel(id: "3", value: "Closed"));
    return list;
  }
}
