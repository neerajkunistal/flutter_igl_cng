List<MaterialDetailModel> materialDetailListResponse(var json) {
  return List<MaterialDetailModel>.from(json.map((x) => MaterialDetailModel.fromJson(x)));
}

class MaterialDetailModel {
  String? material;
  String? materialDescription;
  dynamic plant;
  String? plantName;
  String? storageLocation;
  String? storageLocationName;
  String? unrestrictedStock;
  String? baseUnitofMeasure;

  MaterialDetailModel(
      {this.material,
        this.materialDescription,
        this.plant,
        this.plantName,
        this.storageLocation,
        this.storageLocationName,
        this.unrestrictedStock,
        this.baseUnitofMeasure});

  MaterialDetailModel.fromJson(Map<String, dynamic> json) {
    material = json['Material'] ??  "";
    materialDescription = json['MaterialDescription'] ?? "";
    plant = json['Plant'] ?? "";
    plantName = json['PlantName'] ?? "";
    storageLocation = json['StorageLocation'] ?? "";
    storageLocationName = json['StorageLocationName'] ?? "";
    unrestrictedStock = json['UnrestrictedStock'] ?? "";
    baseUnitofMeasure = json['BaseUnitofMeasure']  ?? "";
  }

}