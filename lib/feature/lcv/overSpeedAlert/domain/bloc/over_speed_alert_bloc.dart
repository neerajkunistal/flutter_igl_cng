import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/overSpeedAlert/domain/model/over_speed_alert_model.dart';
import 'package:flutter_igl_cng/feature/lcv/overSpeedAlert/helper/over_speed_alert_helper.dart';

part 'over_speed_alert_event.dart';
part 'over_speed_alert_state.dart';

class OverSpeedAlertBloc extends Bloc<OverSpeedAlertEvent, OverSpeedAlertState> {

  List<OverSpeedAlertModel> overSpeedAlertList = [];
  bool isLoader =  false;

  OverSpeedAlertBloc() : super(OverSpeedAlertInitial()) {
    on<OverSpeedAlertPageLoadEvent>(_pageLoad);
    on<OverSpeedAlertMarkReadEvent>(_markRead);
  }

  _pageLoad(OverSpeedAlertPageLoadEvent event, emit) async {
    emit(OverSpeedAlertPageLoadState());
    isLoader =  false;
    overSpeedAlertList = [];
    var res =  await OverSpeedAlertHelper.fetchOverSpeedData(context: event.context);
    if(res != null){
      overSpeedAlertList =  res;
    }
    _eventComplete(emit);
  }

  _markRead(OverSpeedAlertMarkReadEvent event, emit) async {
    int index =  event.index;
    BuildContext context =  event.context;
    isLoader = true;
    overSpeedAlertList[index].isSelected = true;
    _eventComplete(emit);
    var res =  await OverSpeedAlertHelper.markOverSpeedData(context: context,
        overSpeedAlertData: overSpeedAlertList[index]);
    if(res != null){
      overSpeedAlertList.removeAt(index);
    } else{
      overSpeedAlertList[index].isSelected = false;
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<OverSpeedAlertState>emit) {
    emit(FetchOverSpeedAlertDataState(
        isLoader: isLoader,
        overSpeedAlertList: overSpeedAlertList));
  }
}
