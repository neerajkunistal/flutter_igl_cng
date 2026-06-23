import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class CngStationBloc extends Bloc<CngStationEvent, CngStationState> {
  List<CngStationModel> _cngStationList = [];

  List<CngStationModel> get cngStationList => _cngStationList;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  CngStationBloc() : super(CngStationInitial()) {
    on<CngStationPageLoadEvent>(_pageLoad);
    on<CngStationDeleteStationEvent>(_deleteCngStation);
  }

  _pageLoad(CngStationPageLoadEvent event, emit) async {
    emit(CngStationPageLoadState());
    _userData = UserInfo.instance!.userData!;
    _cngStationList = [];
    var res = await CNGStationHelper.fetchCNGStationData(
        context: event.context, userData: userData);
    if (res != null) {
      _cngStationList = res;
    }
    _eventComplete(emit);
  }

  _deleteCngStation(CngStationDeleteStationEvent event, emit) async {
    List<CngStationModel> tempList = cngStationList;
    tempList[event.index].isSelected = true;
    _cngStationList = [];
    _eventComplete(emit);

    _cngStationList = tempList;
    _eventComplete(emit);

    var res = await CNGStationHelper.deleteCngStationWithLcvTruck(
        context: event.context,
        userData: userData,
        cngStationId: cngStationList[event.index].id.toString());
    if (res != null) {
      var res = await CNGStationHelper.fetchCNGStationData(
          context: event.context, userData: userData);
      if (res != null) {
        _cngStationList = res;
      }
    }

    _eventComplete(emit);
  }

  _eventComplete(Emitter<CngStationState> emit) {
    emit(FetchCngStationDataState(cngStationList: cngStationList));
  }
}
