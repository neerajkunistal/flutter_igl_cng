import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cv/domain/model/measure_type_model.dart';

List<ParticularModel> particularModelListResponse(var json) {
  return List<ParticularModel>.from(json.map((x) => ParticularModel.fromJson(x)));
}

class ParticularModel {

  dynamic id;
  String? name;
  MeasureTypeModel? measureTypeData;
  dynamic measurementValue;
  String? measurementName;
  dynamic measurementUnit;
  List<File>? fileList;

  ParticularModel({
   this.id,
   this.name,
   this.measurementValue,
   this.measureTypeData,
   this.measurementUnit,
   this.measurementName,
   this.fileList,
  });

  factory ParticularModel.fromJson(Map<String, dynamic> json ){
    return ParticularModel(
      id: json['id'] ?? "",
      name: json['particulars'] ?? "",
      measurementValue: json['measurement_value'] ?? "",
      measurementName: json['measurement_name'] ?? "",
      measurementUnit: json['measurement_unit'] ?? "",
    );
  }

}