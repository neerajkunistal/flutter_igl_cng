import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/domain/model/station_model.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/helper/view_amo_complaint_helper.dart';
import 'package:flutter_igl_cng/feature/ci/domain/model/complaint_status.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/helper/view_cng_helper.dart';

part 'view_amo_complaint_event.dart';
part 'view_amo_complaint_state.dart';

class ViewAmoComplaintBloc
    extends Bloc<ViewAmoComplaintEvent, ViewAmoComplaintState> {
  List<CngModel> cngList = [];
  List<CngModel> cngSearchList = [];
  List<ComplaintStatus> complaintStatusList = [];
  ComplaintStatus complaintStatusData = ComplaintStatus();
  bool isLoader = false;
  bool isFilterLoader = false;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  int listIndex =  0;
  int tabIndex =  0;
  List<StationModel> stationList = [];
  List<StationModel> searchStationList = [];
  StationModel stationData =  StationModel();
  bool isStationLoader =  false;
  TextEditingController stationController = TextEditingController();

  ViewAmoComplaintBloc() : super(ViewAmoComplaintInitial()) {
    on<ViewAmoComplaintPageLoadEvent>(_pageLoad);
    on<ViewAmoComplaintSearchDataEvent>(_search);
    on<ViewAmoComplaintSelectedDateRangeEvent>(_selectDate);
    on<ViewAmoComplaintSelectComplaintStatusEvent>(_selectComplaintStatus);
    on<ViewAmoComplaintSelectTabEvent>(_selectTab);
    on<ViewAmoComplaintSelectIndexEvent>(_selectList);
    on<ViewAmoComplaintFetchStationEvent>(_fetchStation);
    on<ViewAmoComplaintSelectStationDataEvent>(_selectStation);
    on<ViewAmoComplaintSearchStationEvent>(_searchStation);
    on<ViewAmoComplaintSubmitEvent>(_submit);
  }

  _pageLoad(ViewAmoComplaintPageLoadEvent event, emit) async {
    emit(ViewAmoComplaintPageLoadState());
    cngList = [];
    cngSearchList = [];
    complaintStatusList = ComplaintStatus.getComplaintData();
    complaintStatusData = ComplaintStatus();
    isLoader = false;
    isFilterLoader = false;
    isStationLoader =  false;
    listIndex =  0;
    tabIndex =  0;
    stationController.text = "";
    startDate = DateTime.now().subtract(const Duration(days: 4));
    endDate = DateTime.now();
    stationList = [];
    searchStationList = [];
    stationData =  StationModel();
    var res = await ViewCngHelper.fetchCngCivilData(
        fromDate: startDate.toString(), toDate: endDate.toString());
    if (res != null) {
      cngList = res;
      cngSearchList = res;
    }
    _eventComplete(emit);
  }

  _search(ViewAmoComplaintSearchDataEvent event, emit) async {
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
            .where((element) => element.categoryName
            .toString()
            .toLowerCase()
            .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.controlRoom
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
    } else {
      cngList = cngSearchList;
    }

    _eventComplete(emit);
  }

  _selectDate(ViewAmoComplaintSelectedDateRangeEvent event, emit) async {
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

    if(tabIndex== 0){
      cngList =  cngSearchList.where((element) => element.complaintStatus.toString() == "0").toList();
    } else {
      cngList =  cngSearchList.where((element) => element.complaintStatus.toString() == "1").toList();
    }

    isFilterLoader = false;
    _eventComplete(emit);


  }

  _selectComplaintStatus(
      ViewAmoComplaintSelectComplaintStatusEvent event, emit) {
    complaintStatusData = event.complaintStatusData;
    _eventComplete(emit);
  }

  _selectTab(ViewAmoComplaintSelectTabEvent event, emit) {
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

  _selectList(ViewAmoComplaintSelectIndexEvent event, emit) {
    listIndex =  event.listIndex;
    _eventComplete(emit);
  }

  _selectStation(ViewAmoComplaintSelectStationDataEvent event, emit) {
    stationData =  event.stationData;

    List<CngModel> searchList =  cngSearchList.where((element) => element.cngStation.toString().toLowerCase()
        == stationData.name.toString().toLowerCase()).toList();
    if(tabIndex== 0){
      cngList =  searchList.where((element) => element.complaintStatus.toString() == "0").toList();
    } else {
      cngList =  searchList.where((element) => element.complaintStatus.toString() == "1").toList();
    }
    _eventComplete(emit);
  }

  _searchStation(ViewAmoComplaintSearchStationEvent event, emit) {
    isStationLoader =  true;
    _eventComplete(emit);
    if(event.keyword.toString().isNotEmpty) {
      stationList =  searchStationList.where((element) =>
          element.name.toString().toLowerCase().contains(event.keyword.toLowerCase())).toList();
    } else {
      stationList =  searchStationList;
    }
    isStationLoader =  false;
    _eventComplete(emit);
  }

  _fetchStation(ViewAmoComplaintFetchStationEvent event, emit) async {
    isStationLoader =  true;
    stationController.text = "";
    _eventComplete(emit);
    if(searchStationList.isEmpty){
      var res =  await ViewAmoComplaintHelper.fetchStationData();
      if(res != null){
        stationList =  res;
        searchStationList =  res;
      }
    } else {
      stationList =  searchStationList;
    }

    isStationLoader =  false;
    _eventComplete(emit);
  }


  _submit(ViewAmoComplaintSubmitEvent event, emit) async {
    isLoader = true;
    _eventComplete(emit);
    var res = await ViewAmoComplaintHelper.civilComplaintApprove(
        cngData: event.cngData,
        complaintStatus: complaintStatusData,
        context: event.context);
    if (res != null) {
      Navigator.of(event.context.mounted ? event.context : event.context)
          .pop("Complete");
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewAmoComplaintState> emit) {
    emit(FetchViewAmoComplaintDataState(
      cngList: cngList,
      cngAllItemsList: cngSearchList,
      complaintStatusList: complaintStatusList,
      complaintStatusData: complaintStatusData,
      isLoader: isLoader,
      isFilterLoader: isFilterLoader,
      listIndex: listIndex,
      tabIndex: tabIndex,
      stationData: stationData,
      stationList: stationList,
      isStationLoader: isStationLoader,
      stationController: stationController,
    ));
  }
}
