List<DBStationModel> dbStationListResponse(var json) {
  return List<DBStationModel>.from(json.map((x) => DBStationModel.fromJson(x)));
}

class DBStationModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? description;
  String? internalCode;
  String? externalCode;
  String? inchargeName;
  String? inchargeEmail;
  String? inchargePhone;
  String? controlRoomId;
  String? controlRoom;
  String? status;
  String? createdAt;
  dynamic updatedAt;

  DBStationModel(
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
        this.updatedAt});

  DBStationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    phone = json['phone'] ?? "";
    address = json['address'] ?? "";
    description = json['description'] ?? "";
    internalCode = json['internal_code'] ?? "";
    externalCode = json['external_code'] ?? "";
    inchargeName = json['incharge_name'] ?? "";
    inchargeEmail = json['incharge_email'] ?? "";
    inchargePhone = json['incharge_phone'] ?? "";
    controlRoomId = json['control_room_id'] ?? "";
    controlRoom = json['control_room'] ?? "";
    status = json['status'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['description'] = description;
    data['internal_code'] = internalCode;
    data['external_code'] = externalCode;
    data['incharge_name'] = inchargeName;
    data['incharge_email'] = inchargeEmail;
    data['incharge_phone'] = inchargePhone;
    data['control_room_id'] = controlRoomId;
    data['control_room'] = controlRoom;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}