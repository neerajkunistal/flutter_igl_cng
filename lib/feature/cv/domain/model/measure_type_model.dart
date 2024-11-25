import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

List<MeasureTypeModel> measureTypeListResponse(var json) {
  return List<MeasureTypeModel>.from(json.map((x) =>  MeasureTypeModel.fromJson(x)));
}

class MeasureTypeModel {
  dynamic id;
  String? name;
  DataType? dataType;
  String? unit;
  List<UnitName>? unitNameList;
  UnitName? unitData;

  MeasureTypeModel({
    this.id,
    this.name,
    this.dataType,
    this.unit,
    this.unitNameList,
    this.unitData,
 });


  factory MeasureTypeModel.fromJson(Map<String, dynamic> json) {

    List<UnitName> unitNameList = [];
    if(json['unit_names'] != null){
      var unitNames = json['unit_names'];
      unitNames.forEach((key, value){
        unitNameList.add(UnitName(
            name: value.toString(),
           isSelected: false
         ));
      });
    }
    return MeasureTypeModel(
       id: json['id'] ?? "",
       name: json['name'] ?? "",
       unit: json['unit'] ?? "",
       unitNameList: unitNameList,
       unitData: UnitName(),
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

class UnitName {
  dynamic name;
  bool? isSelected;

  UnitName({this.name, this.isSelected});

  factory UnitName.fromJson(Map<String, dynamic> json) {
    return UnitName(
      name: json['name']
    );
  }
}