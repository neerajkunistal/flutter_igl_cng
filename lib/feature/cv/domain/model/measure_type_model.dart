import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

List<MeasureTypeModel> measureTypeListResponse(var json) {
  return List<MeasureTypeModel>.from(json.map((x) =>  MeasureTypeModel.fromJson(x)));
}

class MeasureTypeModel {
  dynamic id;
  String? name;
  DataType? dataType;
  String? unit;

  MeasureTypeModel({
    this.id,
    this.name,
    this.dataType,
    this.unit,
 });


  factory MeasureTypeModel.fromJson(Map<String, dynamic> json) {
    return MeasureTypeModel(
       id: json['id'] ?? "",
       name: json['name'] ?? "",
       unit: json['unit'] ?? "",
      dataType:  json['datatype'] != null
          ? getType(dataType: json['datatype'])
          : DataType.string ,
    );
  }

  static getType({required String dataType}) {
      switch(dataType) {
        case "float" :
          return DataType.number;
        case "int" :
          return DataType.number;
        case "string" :
          return DataType.string;
      }
  }
}