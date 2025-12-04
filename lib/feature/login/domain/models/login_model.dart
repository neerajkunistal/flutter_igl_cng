import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/menu_model.dart';

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
  String? roleName;
  String? roleId;
  String? stationId;
  dynamic mDbStatus;
  dynamic stationName;
  dynamic showCivil;
  List<MenuModel>? menuPage;

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
    this.roleName,
    this.roleId,
    this.stationId,
    this.mDbStatus,
    this.stationName,
    this.showCivil,
    this.menuPage,
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
    roleName = json['role'] ?? "";
    roleId = json['role_id'] ?? "";
    stationId = json['station_id'] ?? "";
    mDbStatus = json['mdb_status'] ?? "0";
    stationName = json['station_name'] ?? "";
    showCivil = json['show_civil'] ?? "";
    roleType = json['user_type'] != null
        ? getRole(role: json['user_type'])
        : RoleType.stationUser;
    menuPage =  json['dashboard_urls'] == null ? [] : menuListResponse(json['dashboard_urls']);
  }

  getRole({required String role}) {
    switch (role) {
      case "SU":
        return RoleType.stationUser;
      case "SE":
        return RoleType.shiftEngineer;
      case "MI":
        return RoleType.mi;
      case "AMO":
        return RoleType.amo;
      case "CV":
        return RoleType.cv;
      case "CI":
        return RoleType.ci;
      case "LCVM":
        return RoleType.lcvManager;
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
      "firebaseId": firebaseId,
      "deviceId": deviceId,
    };
    return map;
  }
}
