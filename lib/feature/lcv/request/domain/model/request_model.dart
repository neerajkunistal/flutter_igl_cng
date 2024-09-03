List<RequestModel> requestResponseList(var json) {
  return List<RequestModel>.from(json.map((x) => RequestModel.fromJson(x)));
}

class RequestModel {
  dynamic id;
  String? stationName;
  dynamic lat;
  dynamic long;
  String? stationLocation;
  String? dateTime;
  String? status;
  String? distance;
  bool? isSelected = false;
  List<RoutesModel>? routesList;

/*  List<String>? polyLines = [
    "wfsmDmkiwMKtDvEVnFVrABN@?LSfGYtIQ|FfADfMVbKPrLVxILAgLR?\\@BvGAjCIpGC`D]AFaG",
    "ekpmDkwfwMsAAsACe@H}@D{@AmJOg@?EDMLK\\WzH@lBHx@R|@j@jBbAlBnF`IjJbN|CtEzA|B|H`L`CnD|G|JfErGpNfT~C|EVDTPrAjBhGbJt@bARb@LEZK~@u@fGsFtAsARCFBtAoApBgBnB{B|@o@\\M@?HBBJILOLSXCHy@j@_BtAgCrB_CrB{EfEuChCyJjJ}MhMQJgDxCiDzCeL~KhCpDhCtDdD~E|A|Bt@bAZr@f@x@d@t@|AzBlBlCpAzAp@dAhAtBjC~Df@z@tAnBpHzKbBdCQVcBiCyBaDwD{FwAmBkBmC"
  ];*/

  RequestModel({
    this.id,
    this.stationName,
    this.lat,
    this.long,
    this.stationLocation,
    this.dateTime,
    this.status,
    this.distance,
    this.isSelected,
    this.routesList,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json[''] ?? "",
      stationLocation: json[''] ?? "",
      lat: json[''] ?? 0.0,
      long: json[''] ?? 0.0,
      stationName: json[''] ?? "",
      dateTime: json[''] ?? DateTime.now().toString(),
      status: json[''] ?? "0",
      distance: json[''] ?? "0",
    );
  }
}

class RoutesModel {
  dynamic id;
  String? name;
  bool? isSelectedRoute = false;
  String? polyLines;

  RoutesModel({this.id, this.polyLines, this.name, this.isSelectedRoute});
}
