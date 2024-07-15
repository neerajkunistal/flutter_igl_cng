import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/helper/view_cng_helper.dart';

part 'view_cng_event.dart';

part 'view_cng_state.dart';

class ViewCngBloc extends Bloc<ViewCngEvent, ViewCngState> {
  List<CngModel> cngList = [];
  List<CngModel> cngSearchList = [];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isFilterLoader = false;

  ViewCngBloc() : super(ViewCngInitial()) {
    on<ViewCngPageLoadEvent>(_pageLoad);
    on<ViewCngSearchEvent>(_search);
    on<ViewCngSelectedDateRangeEvent>(_selectDate);
  }

  _pageLoad(ViewCngPageLoadEvent event, emit) async {
    emit(ViewCngPageLoadState());
    cngList = [];
    cngSearchList = [];
    startDate = DateTime.now().subtract(const Duration(days: 4));
    endDate = DateTime.now();
    var res = await ViewCngHelper.fetchCngCivilData(
        fromDate: startDate.toString(), toDate: endDate.toString());
    if (res != null) {
      cngList = res;
      cngSearchList = res;
    }
    _eventComplete(emit);
  }

  _search(ViewCngSearchEvent event, emit) async {
    cngList = [];
    _eventComplete(emit);
    if (event.keyword.isNotEmpty) {
      cngList = cngSearchList
          .where((element) => element.complaintNumber
              .toString()
              .toLowerCase()
              .contains(event.keyword.toUpperCase().toLowerCase()))
          .toList();
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.incidentDateTime
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.reportBy
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.complaintStatus
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.complaintDescription
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
    } else {
      cngList = cngSearchList;
    }

    _eventComplete(emit);
  }

  _selectDate(ViewCngSelectedDateRangeEvent event, emit) async {
    cngList = [];
    cngSearchList = [];
    isFilterLoader = true;
    _eventComplete(emit);
    startDate = event.fromDate;
    endDate = event.toDate;
    var res = await ViewCngHelper.fetchCngCivilData(
        fromDate: event.fromDate.toString(), toDate: event.toDate.toString());
    if (res != null) {
      cngList = res;
      cngSearchList = res;
    }
    isFilterLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewCngState> emit) {
    emit(FetchViewCngDataState(
      cngList: cngList,
      isFilterLoader: isFilterLoader,
    ));
  }
}
