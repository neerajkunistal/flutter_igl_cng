class FuelTypeModel {
  String? type;
  String? id;

  FuelTypeModel({this.id, this.type});

  List<FuelTypeModel> getFuelTypeList() {
    List<FuelTypeModel> fuelTypeList = [];
    fuelTypeList.add(FuelTypeModel(id: "1", type: "Diesel"));
    fuelTypeList.add(FuelTypeModel(id: "2", type: "Petrol"));
    fuelTypeList.add(FuelTypeModel(id: "3", type: "CNG"));
    return fuelTypeList;
  }
}
