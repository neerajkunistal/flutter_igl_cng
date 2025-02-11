List<EquipmentTypeModel> equipmentTypeListResponse(var json) {
  return List<EquipmentTypeModel>.from(
      json.map((x) => EquipmentTypeModel.fromJson(x)));
}

class EquipmentTypeModel {
  dynamic id;
  String? equipmentCode;
  String? equipmentSerial;
  String? cngStationLocation;
  String? description;
  String? descriptionKva;
  String? manufactureSerialNo;
  String? modelNo;
  String? vendorId;
  String? companyName;
  String? vendorCode;
  dynamic equipmentId;

  EquipmentTypeModel({
    this.id,
    this.equipmentCode,
    this.equipmentSerial,
    this.cngStationLocation,
    this.description,
    this.descriptionKva,
    this.manufactureSerialNo,
    this.modelNo,
    this.vendorId,
    this.companyName,
    this.vendorCode,
    this.equipmentId,
  });

  EquipmentTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    equipmentCode = json['equipment_code'] ?? "";
    equipmentSerial = json['equipment_serial'] ?? "";
    cngStationLocation = json['cng_station_location'] ?? "";
    description = json['description'] ?? "";
    descriptionKva = json['description_kva'] ?? "";
    manufactureSerialNo = json['manufacture_serial_no'] ?? "";
    modelNo = json['model_no'] ?? "";
    vendorId = json['vendor_id'] ?? "";
    companyName = json['company_name'] ?? "";
    vendorCode = json['vendor_code'] ?? "";
    equipmentId = json['equipment_type'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['equipment_code'] = equipmentCode;
    data['equipment_serial'] = equipmentSerial;
    data['cng_station_location'] = cngStationLocation;
    data['description'] = description;
    data['manufacture_serial_no'] = manufactureSerialNo;
    data['model_no'] = modelNo;
    return data;
  }
}
