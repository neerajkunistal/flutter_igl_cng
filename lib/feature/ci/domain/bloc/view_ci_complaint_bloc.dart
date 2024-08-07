import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/vendor_model.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/domain/model/station_model.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/helper/view_amo_complaint_helper.dart';
import 'package:flutter_igl_cng/feature/ci/domain/model/complaint_status.dart';
import 'package:flutter_igl_cng/feature/ci/helper/view_ci_complaint_helper.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';

part 'view_ci_complaint_event.dart';
part 'view_ci_complaint_state.dart';

class ViewCiComplaintBloc
    extends Bloc<ViewCiComplaintEvent, ViewCiComplaintState> {
  List<CngModel> cngList = [];
  List<CngModel> cngSearchList = [];
  List<CngModel> tempSearchList = [];
  List<VendorModel> vendorList = [];
  VendorModel vendorData = VendorModel();
  List<ComplaintStatus> complaintStatusList = [];
  ComplaintStatus complaintStatusData = ComplaintStatus();
  bool isVendorListLoader = false;
  bool isVendorAssignLoader = false;
  TextEditingController remarkController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isFilterLoader = false;
  bool isStationLoader = false;
  int listIndex = 0;
  int tabIndex = 0;
  List<StationModel> stationList = [];
  List<StationModel> searchStationList = [];
  StationModel stationData =  StationModel();
  TextEditingController stationController = TextEditingController();

  ViewCiComplaintBloc() : super(ViewCiComplaintInitial()) {
    on<ViewCiComplaintPageLoadEvent>(_pageLoad);
    on<ViewCiComplaintSearchDataEvent>(_search);
    on<ViewCiComplaintSelectedDateRangeEvent>(_selectDate);
    on<ViewCiComplaintSelectListDataEvent>(_selectList);
    on<ViewCiComplaintSelectTabDataEvent>(_selectTab);
    on<ViewCiComplaintFetchVendorEvent>(_fetchVendor);
    on<ViewCiComplaintVendorAssignEvent>(_assignVendor);
    on<ViewCiComplaintSelectVendorEvent>(_selectVendor);
    on<ViewCiComplaintStatusDataEvent>(_selectComplaintStatus);
    on<ViewCiComplaintEstimateApproveEvent>(_estimateApprove);
    on<ViewCiComplaintFinalApproveEvent>(_finalApprove);
    on<ViewCiComplaintSelectStationDataEvent>(_selectStation);
    on<ViewCiComplaintFetchStationDataEvent>(_fetchStation);
    on<ViewCiComplaintSearchStationEvent>(_searchStation);
  }

  _pageLoad(ViewCiComplaintPageLoadEvent event, emit) async {
    emit(ViewCiComplaintPageLoadState());
    cngList = [];
    cngSearchList = [];
    tempSearchList = [];
    vendorList = [];
    stationList = [];
    searchStationList = [];
    stationData =  StationModel();
    complaintStatusList = ComplaintStatus.getComplaintData();
    vendorData = VendorModel();
    isVendorListLoader = false;
    isVendorAssignLoader = false;
    isStationLoader = false;
    complaintStatusData = ComplaintStatus();
    remarkController.text = "";
    searchController.text = "";
    fromDateController.text = "";
    toDateController.text = "";
    stationController.text = "";
    isFilterLoader = false;
    listIndex = 0;
    tabIndex = 0;
    startDate = DateTime.now().subtract(const Duration(days: 4));
    endDate = DateTime.now();
    var res = await ViewCiComplaintHelper.fetchCivilData(
        fromDate: startDate.toString(), toDate: endDate.toString());
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
    _eventComplete(emit);
  }

  _search(ViewCiComplaintSearchDataEvent event, emit) async {
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

  _selectDate(ViewCiComplaintSelectedDateRangeEvent event, emit) async {
    cngList = [];
    cngSearchList = [];
    isFilterLoader = true;
    _eventComplete(emit);
    startDate = event.fromDate;
    endDate = event.toDate;
    var res = await ViewCiComplaintHelper.fetchCivilData(
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

  _selectList(ViewCiComplaintSelectListDataEvent event, emit) {
    listIndex =  event.listIndex;
    _eventComplete(emit);
  }

  _selectTab(ViewCiComplaintSelectTabDataEvent event, emit) {
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

  _fetchVendor(ViewCiComplaintFetchVendorEvent event, emit) async {
    isVendorListLoader = true;
    vendorData = VendorModel();
    _eventComplete(emit);
    var res = await ViewCiComplaintHelper.fetchVendor();
    if (res != null) {
      vendorList = res;
    }
    isVendorListLoader = false;
    _eventComplete(emit);
  }

  _selectVendor(ViewCiComplaintSelectVendorEvent event, emit) {
    vendorData = event.vendorData;
    _eventComplete(emit);
  }

  _assignVendor(ViewCiComplaintVendorAssignEvent event, emit) async {
    isVendorAssignLoader = true;
    _eventComplete(emit);
    var res = await ViewCiComplaintHelper.assignVendor(
        cngData: event.cngData, vendorData: vendorData, context: event.context);
    if (res != null) {
      Navigator.of(!event.context.mounted ? event.context : event.context)
          .pop("Complete");
    }
    isVendorAssignLoader = false;
    _eventComplete(emit);
  }

  _selectComplaintStatus(ViewCiComplaintStatusDataEvent event, emit) {
    complaintStatusData = event.complaintStatusData;
    _eventComplete(emit);
  }

  _estimateApprove(ViewCiComplaintEstimateApproveEvent event, emit) async {
    if(complaintStatusData.id == null){
      SnackBarErrorWidget(event.context).show(message: "Please select status");
      return;
    }
    isVendorAssignLoader = true;
    _eventComplete(emit);
    var res = await ViewCiComplaintHelper.estimateApprove(
        cngData: event.cngData,
        complaintStatus: complaintStatusData,
        context: event.context);
    if (res != null) {
      Navigator.of(!event.context.mounted ? event.context : event.context)
          .pop("Complete");
    }
    isVendorAssignLoader = false;
    _eventComplete(emit);
  }

  _finalApprove(ViewCiComplaintFinalApproveEvent event, emit) async {
    if(complaintStatusData.id == null){
      SnackBarErrorWidget(event.context).show(message: "Please select status");
      return;
    }
    isVendorAssignLoader = true;
    _eventComplete(emit);
    var res = await ViewCiComplaintHelper.finalApproveComplaint(
        cngData: event.cngData,
        complaintStatus: complaintStatusData,
        remark: remarkController.text.toString(),
        context: event.context);
    if (res != null) {
      Navigator.of(!event.context.mounted ? event.context : event.context)
          .pop("Complete");
    }
    isVendorAssignLoader = false;
    _eventComplete(emit);
  }

  _selectStation(ViewCiComplaintSelectStationDataEvent event, emit) {
    stationData =  event.stationData;
    cngSearchList =  tempSearchList;

    List<CngModel> searchList =  cngSearchList.where((element) => element.cngStation.toString().toLowerCase()
        == stationData.name.toString().toLowerCase()).toList();
    if(tabIndex== 0){
      cngList =  searchList.where((element) => element.complaintStatus.toString() == "0").toList();
    } else {
      cngList =  searchList.where((element) => element.complaintStatus.toString() == "1").toList();
    }
    cngSearchList = searchList;
    _eventComplete(emit);
  }

  _searchStation(ViewCiComplaintSearchStationEvent event, emit) {
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

  _fetchStation(ViewCiComplaintFetchStationDataEvent event, emit) async {
    isStationLoader =  true;
    stationController.text = "";
    _eventComplete(emit);
    if(searchStationList.isEmpty){
      var res =  await ViewAmoComplaintHelper.fetchStationData();
      if(res != null) {
        stationList =  res;
        searchStationList =  res;
      }
    }else {
      stationList =  searchStationList;
    }
    isStationLoader =  false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewCiComplaintState> emit) {
    emit(FetchViewCiComplaintDataState(
      cngList: cngList,
      vendorData: vendorData,
      vendorList: vendorList,
      complaintStatusData: complaintStatusData,
      complaintStatusList: complaintStatusList,
      isVendorListLoader: isVendorListLoader,
      isVendorAssignLoader: isVendorAssignLoader,
      remarkController: remarkController,
      searchController: searchController,
      fromDateController: fromDateController,
      toDateController: toDateController,
      isFilterLoader: isFilterLoader,
      listIndex: listIndex,
      tabIndex: tabIndex,
      cngAllItemsList: cngSearchList,
      isStationLoader: isStationLoader,
      stationList: stationList,
      stationData: stationData,
      stationController: stationController,
    ));
  }
}
