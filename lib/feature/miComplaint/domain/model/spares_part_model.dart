import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/uom_type_model.dart';

class SparesPartModel {
  SparesModel? sparesData;
  UomTypeModel? uomTypeData;
  TextEditingController? qtyController;
  TextEditingController? materialCodeController;

  SparesPartModel({this.qtyController, this.uomTypeData, this.sparesData, this.materialCodeController});

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['spareId'] = sparesData!.id != null ? sparesData!.id.toString() : "0";
    data['quantity'] = qtyController!.text.toString();
    data['material_code'] = materialCodeController!.text.toString();
    return data;
  }
}
