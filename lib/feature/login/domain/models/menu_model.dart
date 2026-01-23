import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

List<MenuModel> menuListResponse(var json) {
  return List<MenuModel>.from(json.map((x) => MenuModel.fromJson(x)));
}

class MenuModel {

  String? name;
  String? url;
  MenuUrlMethodType method;

  MenuModel({this.url, this.name, this.method =  MenuUrlMethodType.get});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      name: json['name'] ?? "",
      url: json['url'] ?? "",
      method: json['method'] == null ? MenuUrlMethodType.get : getMethod(json['method']),
    );
  }

  static getMethod(String method) {
    switch (method) {
      case "GET" :
        return MenuUrlMethodType.get;
      case "POST" :
        return MenuUrlMethodType.post;
    }
  }

}