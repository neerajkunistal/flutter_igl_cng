import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

List<EquipmentModel> equipmentListResponse(var json) {
  return List<EquipmentModel>.from(json.map((x) => EquipmentModel.fromJson(x)));
}

class EquipmentModel {
  dynamic id;
  String? name;
  String? status;
  dynamic createdAt;
  dynamic updatedAt;
  List<EquipmentTypeModel>? equipmentTypeList;

  EquipmentModel(
      {this.id, this.name, this.status, this.createdAt, this.updatedAt, this.equipmentTypeList});

  EquipmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    status = json['status'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    equipmentTypeList = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}