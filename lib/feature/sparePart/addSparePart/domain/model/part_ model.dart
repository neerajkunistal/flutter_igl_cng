import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/uom_type_model.dart';

class PartModel {
  SparesModel? sparesData;
  UomTypeModel? uomTypeData;
  String? qty;
  String? materialCode;
  String? remarkCode;

  PartModel({this.qty, this.uomTypeData, this.sparesData,
    this.materialCode, this.remarkCode});

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['spareId'] = sparesData!.id != null ? sparesData!.id.toString() : "0";
    data['quantity'] = qty.toString();
    data['materialCode'] = materialCode.toString();
    data['remark'] = remarkCode.toString();
    return data;
  }
}