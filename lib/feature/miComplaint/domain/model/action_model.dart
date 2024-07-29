class ActionModel {
  dynamic id;
  String? value;

  ActionModel({this.id, this.value});

  fetchData() {
    List<ActionModel> list = [];
    // list.add(ActionModel(id: "1", value: "Start"));
    list.add(ActionModel(id: "2", value: "Hold for Third party/Others"));
    list.add(ActionModel(id: "3", value: "Assign to Third party/Vendor"));
    list.add(ActionModel(id: "4", value: "Assign to INHouse"));
    return list;
  }
}
