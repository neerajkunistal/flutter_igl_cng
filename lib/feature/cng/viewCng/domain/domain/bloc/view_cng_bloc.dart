import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/helper/view_cng_helper.dart';

part 'view_cng_event.dart';
part 'view_cng_state.dart';

class ViewCngBloc extends Bloc<ViewCngEvent, ViewCngState> {
  List<CngModel> cngList =  [];
  ViewCngBloc() : super(ViewCngInitial()) {
    on<ViewCngPageLoadEvent>(_pageLoad);
  }

  _pageLoad(ViewCngPageLoadEvent event, emit) async {
    emit(ViewCngPageLoadState());
    cngList =  [];
    var res =  await ViewCngHelper.fetchCngCivilData();
    if(res != null){
      cngList =  res;
    }
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewCngState>emit) {
    emit(FetchViewCngDataState(cngList: cngList));
  }
}
