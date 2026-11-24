import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/cngScmInfo/viewCngScm/domain/model/cng_scm_model.dart';
import 'package:flutter_igl_cng/feature/lcv/cngScmInfo/viewCngScm/helper/view_cng_scm_helper.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'view_cng_scm_event.dart';
part 'view_cng_scm_state.dart';

class ViewCngScmBloc extends Bloc<ViewCngScmEvent, ViewCngScmState> {
  List<CngScmModel> _cngScmList = [];

  List<CngScmModel> get cngScmList => _cngScmList;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  ViewCngScmBloc() : super(ViewCngScmInitial()) {
    on<ViewCngScmPageLoadEvent>(_pageLoad);
  }

  _pageLoad(ViewCngScmPageLoadEvent event, emit) async {
    emit(ViewCngScmPageLoadState());
    _cngScmList = [];
    _userData = UserInfo.instance!.userData!;
    var res = await ViewCngScmHelper.fetchCngScmData(
        context: event.context, userData: userData);
    if (res != null) {
      _cngScmList = res;
    }
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewCngScmState> emit) {
    emit(FetchViewCngScmDataState(cngScmList: cngScmList));
  }
}
