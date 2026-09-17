import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class AssignTypeModel {
  dynamic id;
  String? name;

  AssignTypeModel({this.name, this.id});

  fetchData(EquipmentComplaintType equipmentComplaintType) {
    List<AssignTypeModel> list = [];
    list.add(AssignTypeModel(
      id: "1",
      name: "Self",
    ));
    if(equipmentComplaintType == EquipmentComplaintType.normal){
      list.add(AssignTypeModel(
        id: "2",
        name: "MI",
      ));
    }
    list.add(AssignTypeModel(
      id: "3",
      name: "Vendors",
    ));
    return list;
  }
}
