List<AssignTypeModel> assignTypeListResponse(Map<String, dynamic> json) {
  final Map<String, dynamic> data = json['data'];

  return data.entries.map((entry) {
    return AssignTypeModel(
      id: int.parse(entry.key),
      name: entry.value.toString(),
    );
  }).toList();
}

class AssignTypeModel {
  dynamic id;
  String? name;

  AssignTypeModel({this.name, this.id});


}



// class AssignTypeModel {
//   dynamic id;
//   String? name;
//
//   AssignTypeModel({this.name, this.id});
//
//   fetchData() {
//     List<AssignTypeModel> list = [];
//     list.add(AssignTypeModel(
//       id: "1",
//       name: "Self",
//     ));
//     list.add(AssignTypeModel(
//       id: "2",
//       name: "MI",
//     ));
//     list.add(AssignTypeModel(
//       id: "3",
//       name: "Vendors",
//     ));
//     return list;
//   }
// }
