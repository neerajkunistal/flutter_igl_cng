import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/helper/driver_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/user/viewUser/domain/model/user_model.dart';
import 'package:flutter_igl_cng/feature/lcv/user/viewUser/helper/view_user_helper.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'view_user_event.dart';
part 'view_user_state.dart';

class ViewUserBloc extends Bloc<ViewUserEvent, ViewUserState> {
  List<UserModel> _userList = [];

  List<UserModel> get userList => _userList;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  ViewUserBloc() : super(ViewUserInitial()) {
    on<ViewUserPageLoadEvent>(_pageLoad);
    on<ViewUserDeleteEvent>(_deleteUser);
  }

  _pageLoad(ViewUserPageLoadEvent event, emit) async {
    emit(ViewUserPageLoadState());
    _userData = UserInfo.instance!.userData!;
    _userList = [];
    var res = await ViewUserHelper.fetchUserData(
        context: event.context, userData: userData);
    if (res != null) {
      _userList = res;
    }
    _eventComplete(emit);
  }

  _deleteUser(ViewUserDeleteEvent event, emit) async {
    List<UserModel> tempList = _userList;
    tempList[event.index].isSelected = true;
    _userList = [];
    _eventComplete(emit);

    _userList = tempList;
    _eventComplete(emit);

    var deleteRes = await DriverHelper.deleteCngStationWithUser(
        context: event.context,
        userData: userData,
        roleTypeId: "4",
        userId: userList[event.index].id.toString());
    if (deleteRes != null) {
      var res = await ViewUserHelper.fetchUserData(
          context: event.context, userData: userData);
      if (res != null) {
        _userList = res;
      }
    }
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewUserState> emit) {
    emit(FetchViewUserDateState(userList: userList));
  }
}
