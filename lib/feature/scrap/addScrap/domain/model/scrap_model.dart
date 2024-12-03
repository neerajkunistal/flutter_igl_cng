import 'dart:io';

import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scarp_unit_type_model.dart';

class ScrapModel {

  String? srNumber;
  String? description;
  ScrapUnitTypeModel? scrapUnitTypeData;
  List<File>? filesList;
  String? remark;
  String? destroyReusable;

  ScrapModel({
    this.srNumber,
    this.description,
    this.scrapUnitTypeData,
    this.filesList,
    this.remark,
    this.destroyReusable,
  });

}