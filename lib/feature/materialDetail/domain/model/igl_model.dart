List<IglModel> iglApiListResponse(var json) {
  return List<IglModel>.from(json.map((x) => IglModel.fromJson(x)));
}

IglModel iglApiData(var json) {
  List<IglModel> list = List<IglModel>.from(json.map((x) => IglModel.fromJson(x)));
  for(int i = 0; i < list.length; ) {
    return list[i];
  }
  return IglModel();
}

class IglModel {
  String? url;
  String? userName;
  String? password;

  IglModel({
    this.password,
     this.userName,
     this.url});

  factory IglModel.fromJson(Map<String, dynamic> json) {
    return IglModel(
        password: json['password'] ?? "",
        userName:json['username'] ?? "",
        url: json['api_url'] ?? ""
    );
  }
}