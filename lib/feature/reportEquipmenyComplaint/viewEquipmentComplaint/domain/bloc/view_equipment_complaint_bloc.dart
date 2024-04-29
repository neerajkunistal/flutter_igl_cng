import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/review_complaint_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/helper/review_complaint_helper.dart';

part 'view_equipment_complaint_event.dart';
part 'view_equipment_complaint_state.dart';

class ViewEquipmentComplaintBloc extends Bloc<ViewEquipmentComplaintEvent, ViewEquipmentComplaintState> {

  List<ReviewComplaintModel> reviewComplaintList = [];

  ViewEquipmentComplaintBloc() : super(ViewEquipmentComplaintInitial()) {
    on<ViewEquipmentComplaintPageLoadEvent>(_pageLoad);
  }

  _pageLoad(ViewEquipmentComplaintPageLoadEvent event, emit) async {
    emit(ViewEquipmentComplaintPageLoadState());
    reviewComplaintList = [];
    var res =  await ReviewComplaintHelper.fetchReviewComplaint(type: "1");
    if(res != null){
      reviewComplaintList = res;
    }
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewEquipmentComplaintState>emit) {
    emit(FetchViewEquipmentComplaintDataState(reviewComplaintList: reviewComplaintList));
  }
}
