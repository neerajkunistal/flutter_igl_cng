List<StationPointModel> stationPointListResponse(var json) {
  return List<StationPointModel>.from(json.map((x) => StationPointModel.fromJson(x)));
}

class StationPointModel {
  String? id;
  String? name;
  dynamic email;
  dynamic phone;
  String? address;
  dynamic description;
  dynamic internalCode;
  String? externalCode;
  dynamic inchargeName;
  dynamic inchargeEmail;
  dynamic inchargePhone;
  String? controlRoomId;
  dynamic controlRoom;
  dynamic status;
  String? createdAt;
  String? updatedAt;
  String? lat;
  String? long;
  String? ownerName;
  String? pincode;
  String? stationStatus;
  String? wktPoint;

  StationPointModel(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.description,
        this.internalCode,
        this.externalCode,
        this.inchargeName,
        this.inchargeEmail,
        this.inchargePhone,
        this.controlRoomId,
        this.controlRoom,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.lat,
        this.long,
        this.ownerName,
        this.pincode,
        this.stationStatus,
        this.wktPoint});

  StationPointModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "" ;
    name = json['name'] ?? "" ;
    email = json['email'] ?? "" ;
    phone = json['phone'] ?? "" ;
    address = json['address'] ?? "" ;
    description = json['description'] ?? "" ;
    internalCode = json['internal_code'] ?? "" ;
    externalCode = json['external_code'] ?? "" ;
    inchargeName = json['incharge_name'] ?? "" ;
    inchargeEmail = json['incharge_email'] ?? "" ;
    inchargePhone = json['incharge_phone'] ?? "" ;
    controlRoomId = json['control_room_id'] ?? "" ;
    controlRoom = json['control_room'] ?? "" ;
    status = json['status'] ?? "" ;
    createdAt = json['created_at'] ?? "" ;
    updatedAt = json['updated_at'] ?? "" ;
    lat = json['lat'] ?? "" ;
    long = json['long'] ?? "" ;
    ownerName = json['owner_name'] ?? "" ;
    pincode = json['pincode'] ?? "" ;
    stationStatus = json['station_status'] ?? "" ;
    wktPoint = json['wkt_point'] ?? "" ;
  }
  
}