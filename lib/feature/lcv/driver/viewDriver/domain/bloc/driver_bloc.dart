import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/model/driver_model.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/helper/driver_helper.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  List<DriverModel> _driverList = [];

  List<DriverModel> get driverList => _driverList;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  DriverBloc() : super(DriverInitial()) {
    on<DriverPageLoadEvent>(_pageLoad);
    on<DriverDeactivateEvent>(_deactivateUser);
  }

  _pageLoad(DriverPageLoadEvent event, emit) async {
    emit(DriverPageLoadState());
    _userData = UserInfo.instance!.userData!;
    _driverList = [];
    var res = await DriverHelper.fetchDriverData(
        context: event.context, userData: userData);
    if (res != null) {
      _driverList = res;
    }
    _eventComplete(emit);
  }

  _deactivateUser(DriverDeactivateEvent event, emit) async {
    List<DriverModel> tempList = driverList;
    tempList[event.index].isSelected = true;
    _driverList = [];
    _eventComplete(emit);
    _driverList = tempList;
    _eventComplete(emit);

    var deleteRes = await DriverHelper.deleteCngStationWithUser(
        context: event.context,
        userData: userData,
        roleTypeId: "5",
        userId: driverList[event.index].id.toString());
    if (deleteRes != null) {
      _driverList = [];
      var res = await DriverHelper.fetchDriverData(
          context: event.context, userData: userData);
      if (res != null) {
        _driverList = res;
      }
      _eventComplete(emit);
    }
  }

  _eventComplete(Emitter<DriverState> emit) {
    emit(FetchDriverDateState(driverList: driverList));
  }
}
