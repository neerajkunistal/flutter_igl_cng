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
  List<CngModel> tempSearchList = [];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isFilterLoader = false;
  int tabIndex =  0;
  int listIndex = 0;

  ViewCngBloc() : super(ViewCngInitial()) {
    on<ViewCngPageLoadEvent>(_pageLoad);
    on<ViewCngSearchEvent>(_search);
    on<ViewCngSelectedDateRangeEvent>(_selectDate);
    on<ViewCngSelectTabEvent>(_selectTab);
    on<ViewCngSelectIndexEvent>(_selectList);
  }

  _pageLoad(ViewCngPageLoadEvent event, emit) async {
    emit(ViewCngPageLoadState());
    cngList = [];
    cngSearchList = [];
    tempSearchList = [];
    tabIndex = 0;
    listIndex = 0;
    startDate = DateTime.now().subtract(const Duration(days: 15));
    endDate = DateTime.now();
    var res = await ViewCngHelper.fetchCngCivilData(
        fromDate: startDate.toString(), toDate: endDate.toString());
    if (res != null) {
      cngList = res;
      cngSearchList = res;
      tempSearchList = res;
    }
    _eventComplete(emit);
  }

  _search(ViewCngSearchEvent event, emit) async {
    cngList = [];
    cngSearchList = tempSearchList;
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
            .where((element) => element.reportByName
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
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.cngStation
            .toString()
            .toLowerCase()
            .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.categoryName
            .toString()
            .toLowerCase()
            .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
    } else {
      cngList = cngSearchList;
    }

    cngSearchList =  cngList;

    if(tabIndex== 0){
      cngList =  cngSearchList.where((element) => element.complaintStatus.toString() == "0").toList();
    } else {
      cngList =  cngSearchList.where((element) => element.complaintStatus.toString() == "1").toList();
    }


    _eventComplete(emit);
  }

  _selectDate(ViewCngSelectedDateRangeEvent event, emit) async {
    cngList = [];
    cngSearchList = [];
    tempSearchList = [];
    isFilterLoader = true;
    _eventComplete(emit);
    startDate = event.fromDate;
    endDate = event.toDate;
    var res = await ViewCngHelper.fetchCngCivilData(
        fromDate: event.fromDate.toString(), toDate: event.toDate.toString());
    if (res != null) {
      cngList = res;
      cngSearchList = res;
      tempSearchList = res;
    }
    if(tabIndex== 0){
      cngList =  cngSearchList.where((element) => element.complaintStatus.toString() == "0").toList();
    } else {
      cngList =  cngSearchList.where((element) => element.complaintStatus.toString() == "1").toList();
    }
    isFilterLoader = false;
    _eventComplete(emit);
  }

  _selectTab(ViewCngSelectTabEvent event, emit) {
    tabIndex =  event.tabIndex;
    isFilterLoader = true;
    _eventComplete(emit);
    if(tabIndex== 0){
      cngList =  cngSearchList.where((element) => element.complaintStatus.toString() == "0").toList();
    } else {
      cngList =  cngSearchList.where((element) => element.complaintStatus.toString() == "1").toList();
    }
    isFilterLoader = false;
    _eventComplete(emit);
  }

  _selectList(ViewCngSelectIndexEvent event, emit) {
    listIndex =  event.listIndex;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewCngState> emit) {
    emit(FetchViewCngDataState(
      cngList: cngList,
      cngAllItemsList: cngSearchList,
      isFilterLoader: isFilterLoader,
      tabIndex: tabIndex,
      listIndex: listIndex,
    ));
  }
}
