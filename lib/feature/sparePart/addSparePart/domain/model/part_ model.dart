import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/uom_type_model.dart';

List<PartModel> partListResponse(var json) {
  return List<PartModel>.from(json.map((x) => PartModel.fromJson(x)));
}

class PartModel {
  dynamic id;
  dynamic partId;
  String? name;
  dynamic uomId;
  SparesModel? sparesData;
  UomTypeModel? uomTypeData;
  dynamic qty;
  dynamic otherSpares;
  dynamic materialCode;
  String? remarkCode;

  PartModel({
    this.otherSpares,
    this.qty,
      this.uomTypeData,
      this.sparesData,
      this.materialCode,
      this.remarkCode,
      this.id,
      this.partId,
      this.uomId,
      this.name});

  factory PartModel.fromJson(Map<String, dynamic> json) {
    return PartModel(
        id: json['id'] ?? "",
        partId: json['spare_id'] ?? "",
        name: json['spare_name'] ?? "",
        qty: json['qty'] ?? "",
     //   otherSpares: json['otherSpares'] ?? "",
        materialCode: json['material_code'] ?? "",
        remarkCode: json['remark_code'] ?? "");
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['spareId'] = sparesData!.id != null ? sparesData!.id.toString() : "0";
    data['quantity'] = qty.toString();
  //  data['otherSpares'] = otherSpares.toString();
    data['materialCode'] = materialCode.toString();
    data['remark'] = remarkCode.toString();
    return data;
  }

  Map<String, String> toDeleteJson() {
    final Map<String, String> data = <String, String>{};
    data['spareId'] = partId != null ? partId.toString() : "0";
    return data;
  }
}
