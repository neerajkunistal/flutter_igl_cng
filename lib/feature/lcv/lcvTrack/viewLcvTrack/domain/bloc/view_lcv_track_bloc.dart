import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/helper/cng_station_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/viewLcvTrack/domain/model/lcv_model.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/viewLcvTrack/helper/view_lcv_track_helper.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'view_lcv_track_event.dart';
part 'view_lcv_track_state.dart';

class ViewLcvTrackBloc extends Bloc<ViewLcvTrackEvent, ViewLcvTrackState> {
  List<LcvTruckModel> _lcvTruckList = [];

  List<LcvTruckModel> get lcvTruckList => _lcvTruckList;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  ViewLcvTrackBloc() : super(ViewLcvTrackInitial()) {
    on<ViewLcvTruckPageLoadEvent>(_pageLoad);
    on<ViewLcvTruckDeleteStationEvent>(_deleteLcvTruck);
  }

  _pageLoad(ViewLcvTruckPageLoadEvent event, emit) async {
    emit(ViewLcvTrackPageLoadState());
    _userData = UserInfo.instance!.userData!;
    _lcvTruckList = [];
    var res = await ViewLcvTrackHelper.fetchLCVData(
        context: event.context, userData: userData);
    if (res != null) {
      _lcvTruckList = res;
    }
    _eventCompleted(emit);
  }

  _deleteLcvTruck(ViewLcvTruckDeleteStationEvent event, emit) async {
    List<LcvTruckModel> tempList = lcvTruckList;
    tempList[event.index].isSelected == true;
    _lcvTruckList = [];
    _eventCompleted(emit);

    _lcvTruckList = tempList;
    _eventCompleted(emit);

    var res = await CNGStationHelper.deleteCngStationWithLcvTruck(
        context: event.context,
        userData: userData,
        lcvTruckId: lcvTruckList[event.index].id.toString());
    if (res != null) {
      var res = await ViewLcvTrackHelper.fetchLCVData(
          context: event.context, userData: userData);
      if (res != null) {
        _lcvTruckList = res;
      }
    }
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<ViewLcvTrackState> emit) {
    emit(FetchViewLcvTrackDataState(lcvTruckList: lcvTruckList));
  }
}
