import 'dart:io';

import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scarp_unit_type_model.dart';

List<ScrapModel> scrapListResponse(var json) {
  return List<ScrapModel>.from(json.map((x) => ScrapModel.fromJson(x)));
}

class ScrapModel {

  dynamic id;
  String? srNumber;
  String? description;
  ScrapUnitTypeModel? scrapUnitTypeData;
  List<File>? filesList;
  String? remark;
  String? destroyReusable;
  dynamic unit;

  ScrapModel({
    this.id,
    this.srNumber,
    this.description,
    this.scrapUnitTypeData,
    this.filesList,
    this.remark,
    this.destroyReusable,
    this.unit,
  });

  factory ScrapModel.fromJson(Map<String, dynamic> json) {
    return ScrapModel(
      id: json['id'] ?? "",
      srNumber: json['serial_number'] ?? "",
      description: json['description'] ?? "",
      remark: json['remark'] ?? "",
      unit: json['unit'] ?? "",
    );
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['spareId'] = srNumber != null ? srNumber.toString() : "0";
    return data;
  }

}