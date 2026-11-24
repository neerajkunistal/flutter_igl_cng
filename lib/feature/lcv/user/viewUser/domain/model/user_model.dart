List<UserModel> userListResponse(var json) {
  return List<UserModel>.from(json.map((x) => UserModel.fromJson(x)));
}

class UserModel {
  String? id;
  String? fullName;
  String? address;
  String? city;
  String? district;
  String? state;
  String? email;
  String? phoneNumber;
  String? stationName;
  String? firebaseId;
  bool? isSelected;
  String? deleteAt;

  UserModel({
    this.id,
    this.fullName,
    this.address,
    this.city,
    this.district,
    this.state,
    this.email,
    this.phoneNumber,
    this.stationName,
    this.firebaseId,
    this.isSelected,
    this.deleteAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'] ?? json['user_id'] ?? "",
        fullName: json['name'] ?? "",
        address: json['address'] ?? "",
        city: json['city'] ?? "",
        district: json['district'] ?? "",
        state: json['state'] ?? "",
        email: json['email'] ?? "",
        phoneNumber: json['phone_number'] ?? "",
        stationName: json['station_name'] ?? "",
        firebaseId: json['firebase_id'] ?? "",
        deleteAt: json['deleted_at'] ?? "",
        isSelected: false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firebase_id'] = firebaseId;
    data['email'] = email;
    return data;
  }
}
