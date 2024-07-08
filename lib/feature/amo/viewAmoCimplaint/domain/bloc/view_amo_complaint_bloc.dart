import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/helper/view_amo_complaint_helper.dart';
import 'package:flutter_igl_cng/feature/ci/domain/model/complaint_status.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/helper/view_cng_helper.dart';

part 'view_amo_complaint_event.dart';
part 'view_amo_complaint_state.dart';

class ViewAmoComplaintBloc extends Bloc<ViewAmoComplaintEvent, ViewAmoComplaintState> {
  List<CngModel> cngList =  [];
  List<ComplaintStatus> complaintStatusList = [];
  ComplaintStatus complaintStatusData =  ComplaintStatus();
  bool isLoader =  false;

  ViewAmoComplaintBloc() : super(ViewAmoComplaintInitial()) {
    on<ViewAmoComplaintPageLoadEvent>(_pageLoad);
    on<ViewAmoComplaintSelectComplaintStatusEvent>(_selectComplaintStatus);
    on<ViewAmoComplaintSubmitEvent>(_submit);
  }

  _pageLoad(ViewAmoComplaintPageLoadEvent event, emit) async {
    emit(ViewAmoComplaintPageLoadState());
    cngList =  [];
    complaintStatusList =  ComplaintStatus.getComplaintData();
    complaintStatusData =  ComplaintStatus();
    isLoader =  false;
    var res =  await ViewCngHelper.fetchCngCivilData();
    if(res != null){
      cngList =  res;
    }
    _eventComplete(emit);
  }

  _selectComplaintStatus(ViewAmoComplaintSelectComplaintStatusEvent event, emit) {
    complaintStatusData =  event.complaintStatusData;
    _eventComplete(emit);
  }

  _submit(ViewAmoComplaintSubmitEvent event, emit) async {
    isLoader =  true;
    _eventComplete(emit);
    
    var res =  await ViewAmoComplaintHelper.civilComplaintApprove(
       cngData: event.cngData,
        complaintStatus: complaintStatusData,
        context: event.context);
    if(res != null){
      Navigator.of(event.context.mounted ?  event.context :  event.context).pop("Complete");
    }
    
    isLoader =  false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewAmoComplaintState>emit) {
    emit(FetchViewAmoComplaintDataState(
        cngList: cngList,
        complaintStatusList: complaintStatusList,
        complaintStatusData: complaintStatusData,
        isLoader: isLoader
    ));
  }
}
