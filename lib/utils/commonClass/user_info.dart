

import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';

class UserInfo {

  static UserInfo? instance;
  LoginDataModel? userData;

  static UserInfo? instanceInit(){
    instance ??= UserInfo();
    return instance;
  }

   setUserInfo(LoginDataModel useData){
     userData ??= LoginDataModel();
     userData = useData;
  }
}