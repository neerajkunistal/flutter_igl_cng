import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

List<LoginDataModel> loginScreenResponseData(var json) {
  return List<LoginDataModel>.from(json.map((x) => LoginDataModel.fromJson(x)));
}

LoginDataModel loginResponse(var json) {
  return LoginDataModel.fromJson(json);
}

class LoginDataModel {
  String? userId;
  String? email;
  String? moduleId;
  String? name;
  String? userStatus;
  String? pwdChanged;
  dynamic modules;
  String? schema;
  String? spreadId;
  String? sectionId;
  String? password;
  String? token;
  RoleType? roleType;
  String? role;

  LoginDataModel({
    this.userId,
    this.email,
    this.moduleId,
    this.name,
    this.userStatus,
    this.pwdChanged,
    this.modules,
    this.schema,
    this.spreadId,
    this.sectionId,
    this.token,
    this.roleType,
    this.password,
    this.role,
  });

  LoginDataModel.fromJson(Map<String, dynamic> json) {
    userId = json['id'];
    email = json['email'];
    password = json['password'];
    moduleId = json['module_id'];
    name = json['name'];
    userStatus = json['user_status'];
    pwdChanged = json['pwd_changed'];
    modules = json['modules'];
    schema = json['schema'];
    spreadId = json['spread_id'];
    sectionId = json['section_id'];
    role = json['user_type'] ?? "";
    roleType = json['user_type'] != null
        ? getRole(role: json['user_type'])
        : RoleType.stationUser;
  }

  getRole({required String role}) {
    switch (role) {
      case "SU":
        return RoleType.stationUser;
      case "SE":
        return RoleType.shiftEngineer;
      case "MI":
        return RoleType.mi;
/*      case "CRIC" :
        return RoleType.CRIC;*/
      default:
        return RoleType.noRole;
    }
  }
}

class LoginScreenRequestModel {
  final String userEmailId;
  final String password;
  final String firebaseId;
  final String deviceId;

  LoginScreenRequestModel(
      {required this.userEmailId,
      required this.password,
      required this.firebaseId,
      required this.deviceId});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "email": userEmailId,
      "password": password,
      "firebase_id": firebaseId,
      "device_id": deviceId,
    };
    return map;
  }
}
