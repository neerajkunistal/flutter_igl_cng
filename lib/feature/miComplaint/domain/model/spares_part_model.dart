import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/uom_type_model.dart';

class SparesPartModel {
  SparesModel? sparesData;
  UomTypeModel? uomTypeData;
  TextEditingController? qtyController;

  SparesPartModel({this.qtyController, this.uomTypeData, this.sparesData});
}
