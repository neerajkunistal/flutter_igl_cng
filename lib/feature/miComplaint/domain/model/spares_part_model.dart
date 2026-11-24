import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/uom_type_model.dart';

class SparesPartModel {
  SparesModel? sparesData;
  UomTypeModel? uomTypeData;
  TextEditingController? qtyController;
  TextEditingController? materialCodeController;
  TextEditingController? remarkCodeController;

  SparesPartModel({this.qtyController, this.uomTypeData, this.sparesData,
    this.materialCodeController, this.remarkCodeController});

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['spareId'] = sparesData!.id != null ? sparesData!.id.toString() : "0";
    data['quantity'] = qtyController!.text.toString();
    data['materialCode'] = materialCodeController!.text.toString();
    data['remark'] = remarkCodeController!.text.toString();
    return data;
  }
}
