import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/aasign_type_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/planner_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/vendor_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/work_center_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/helper/acknowledge_helper.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/sap_code_model.dart';
import 'package:flutter_igl_cng/feature/home/helper/home_helper.dart';
import 'package:flutter_igl_cng/feature/marketing/acknowledgeMarketing/domain/model/complaint_market_list_model.dart';
import 'package:flutter_igl_cng/feature/marketing/addAcknowledgeMarket/addAcknowledgeMarketComplaint/helper/add_acknowledge_market_helper.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:vibration/vibration.dart';

part 'acknowledge_market_state.dart';

part 'acknowledge_market_event.dart';

class AcknowledgeMarketBloc
    extends Bloc<AcknowledgeMarketEvent, AcknowledgeMarketState> {
  bool isLoader = false;

  // Market tabs data (current visible tab's list).
  List<ComplaintMarketModel> listOfComplaintData = [];

  // Per-tab cache: 0=New, 1=Ack/Assign, 2=Close, 3=Complete
  final Map<int, List<ComplaintMarketModel>> _marketCache = {};

  List<AcknowledgeModel> acknowledgeList = [];
  List<AcknowledgeUserModel> acknowledgeUserList = [];
  AcknowledgeUserModel acknowledgeUserData = AcknowledgeUserModel();
  bool isUserLoader = false;
  TextEditingController remarkController = TextEditingController();
  TextEditingController closeDateController = TextEditingController();
  TextEditingController closeTimeController = TextEditingController();
  TextEditingController plannerGroupController = TextEditingController();
  TextEditingController mainWorkCenterController = TextEditingController();
  TextEditingController personResponsibleController = TextEditingController();
  TextEditingController complaintNumberController = TextEditingController();

  List<VendorModel> vendorList = [];
  VendorModel vendorData = VendorModel();

  List<AssignTypeModel> assignTypeList = [];
  AssignTypeModel assignTypeData = AssignTypeModel();

  List<DepartmentModel> departmentList = [];
  DepartmentModel departmentData = DepartmentModel();

  List<SapCodeModel> sapCodeList = [];
  SapCodeModel sapCodeData = SapCodeModel();

  List<AcknowledgeModel> acknowledgeWithOutFilterList = [];

  int selectedTabMarketIndex = 0;
  int _selectTabIndex = 0;

  int get selectTabIndex => _selectTabIndex;

  DateTime startDate = DateTime.now().subtract(const Duration(days: 5));
  DateTime endDate = DateTime.now();

  // Always keep 4 slots so the UI can safely read complaintCount[0..3].
  List<int> complaintCount = [0, 0, 0, 0];

  List<PlannerModel> plannerList = [];
  PlannerModel plannerData = PlannerModel();
  List<WorkCenterModel> workCenterList = [];
  WorkCenterModel workCenterData = WorkCenterModel();

  bool isComplaintNumberLoader = false;
  EquipmentComplaintType equipmentComplaintType = EquipmentComplaintType.normal;

  bool get isMarket =>
      equipmentComplaintType == EquipmentComplaintType.marketing;

  AcknowledgeMarketBloc() : super(AcknowledgeMarketInitial()) {
    on<AcknowledgeMarketPageLoadEvent>(_pageLoad);
    on<AcknowledgeMarketComplaintSearchEvent>(_search);
    on<AcknowledgeMarketComplaintSelectedMarketTabIndexEvent>(_selectTabMarket);
    on<AcknowledgeMarketSelectDateRangeEvent>(_selectDateRange);
    on<AcknowledgeMarketUserListLoadEvent>(_userList);
    on<AcknowledgeMarketSelectUserEvent>(_selectUser);
    on<AcknowledgeMarketSelectVendorEvent>(_selectVendor);
    on<AcknowledgeMarketSelectAssignTypeEvent>(_selectAssignType);
    on<AcknowledgeMarketSelectDepartmentEvent>(_selectDepartment);
    on<AcknowledgeMarketSelectSapCodeEvent>(_selectSapCode);
    on<AcknowledgeMarketSelectClosedDateEvent>(_selectDate);
    on<AcknowledgeMarketSelectClosedTimeEvent>(_selectTime);
    on<AcknowledgeMarketComplaintSelectedPlannerEvent>(_selectPlanner);
    on<AcknowledgeMarketComplaintSelectedWorkCenterEvent>(_selectWorkCenter);
    on<AcknowledgeMarketUserSubmitEvent>(_submit);
  }

  // =========================================================================
  // MARKET: per-tab API mapping. 0=New, 1=Ack/Assign, 2=Close, 3=Complete
  // =========================================================================
  Future<List<ComplaintMarketModel>> _fetchMarketTab(int index) async {
    switch (index) {
      case 0:
        return await AddAcknowledgeMarketComplaintHelper
                .fetchPendingAckData() ??
            [];
      case 1:
        return await AddAcknowledgeMarketComplaintHelper
                .fetchAssignedListData() ??
            [];
      case 2:
        return await AddAcknowledgeMarketComplaintHelper
                .fetchPendingFinalClosureData() ??
            [];
      case 3:
        return await AddAcknowledgeMarketComplaintHelper
                .fetchComplaintDetailData(
                    fromDate: startDate.toString(),
                    toDate: endDate.toString()) ??
            [];
      default:
        return [];
    }
  }

  // Load all 4 tabs -> fills cache + counts, then sets current tab list.
  Future<void> _loadAllMarketTabs() async {
    final results = await Future.wait<List<ComplaintMarketModel>>([
      _fetchMarketTab(0),
      _fetchMarketTab(1),
      _fetchMarketTab(2),
      _fetchMarketTab(3),
    ]);
    for (int i = 0; i < results.length; i++) {
      _marketCache[i] = results[i];
    }
    listOfComplaintData = _marketCache[selectedTabMarketIndex] ?? [];
    _rebuildMarketCounts();
  }

  void _rebuildMarketCounts() {
    complaintCount = [
      _marketCache[0]?.length ?? 0,
      _marketCache[1]?.length ?? 0,
      _marketCache[2]?.length ?? 0,
      _marketCache[3]?.length ?? 0,
    ];
  }

  // =========================================================================

  _pageLoad(AcknowledgeMarketPageLoadEvent event, emit) async {
    emit(AcknowledgeMarketPageLoadState());
    isLoader = false;
    isUserLoader = false;
    isComplaintNumberLoader = false;
    acknowledgeList = [];
    listOfComplaintData = [];
    _marketCache.clear();
    acknowledgeUserList = [];
    vendorList = [];
    complaintCount = [0, 0, 0, 0];
    vendorData = VendorModel();
    acknowledgeUserData = AcknowledgeUserModel();
    remarkController.text = "";
    closeDateController.text = "";
    closeTimeController.text = "";
    plannerGroupController.text = "";
    mainWorkCenterController.text = "";
    personResponsibleController.text = "";
    assignTypeData = AssignTypeModel();
    _selectTabIndex = event.selectTabIndex;
    selectedTabMarketIndex = event.selectTabIndex;
    plannerData = PlannerModel();
    workCenterData = WorkCenterModel();
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    closeDateController.text = formattedDate;
    equipmentComplaintType = event.equipmentComplaintType;
    assignTypeList = AssignTypeModel().fetchData(equipmentComplaintType);

    // Prefetch all 4 tabs so the badge counts are correct and non-empty.
    await _loadAllMarketTabs();

    _eventComplete(emit);
  }

  _selectTabMarket(
      AcknowledgeMarketComplaintSelectedMarketTabIndexEvent event, emit) async {
    print(
        "🔵 TAB SELECTED -> event.selectedTabMarketIndex = ${event.selectedTabMarketIndex}"); // <-- YAHAN
    if (await Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 100);
    }
    selectedTabMarketIndex = event.selectedTabMarketIndex;
    _selectTabIndex = event.selectedTabMarketIndex;
    print(
        "🔵 AFTER UPDATE -> selectedTabMarketIndex = $selectedTabMarketIndex, cached items = ${_marketCache[selectedTabMarketIndex]?.length}"); // <-- YAHAN

    // Show cached instantly so the UI feels snappy.
    listOfComplaintData = _marketCache[selectedTabMarketIndex] ?? [];
    _rebuildMarketCounts();
    _eventComplete(emit);

    // Refresh just this tab from the API.
    emit(AcknowledgeMarketPageLoadState()); // loader
    final fresh = await _fetchMarketTab(selectedTabMarketIndex);
    _marketCache[selectedTabMarketIndex] = fresh;
    listOfComplaintData = fresh;
    _rebuildMarketCounts();

    _eventComplete(emit);
  }

  _search(AcknowledgeMarketComplaintSearchEvent event, emit) async {
    await Future.delayed(const Duration(milliseconds: 600));
    String keyword = event.keyword;

    final base = _marketCache[selectedTabMarketIndex] ?? [];
    if (keyword.isEmpty) {
      listOfComplaintData = base;
    } else {
      final k = keyword.toLowerCase();
      listOfComplaintData = base.where((e) {
        return (e.tokenNo ?? '').toLowerCase().contains(k) ||
            (e.ticketNo ?? '').toLowerCase().contains(k) ||
            (e.complaintDescription ?? '').toLowerCase().contains(k) ||
            (e.complainantName ?? '').toLowerCase().contains(k) ||
            (e.complainDateTime ?? '').toLowerCase().contains(k);
      }).toList();
    }
    _eventComplete(emit);
  }

  _selectDateRange(AcknowledgeMarketSelectDateRangeEvent event, emit) async {
    acknowledgeList = [];
    acknowledgeWithOutFilterList = [];
    listOfComplaintData = [];
    _marketCache.clear();
    startDate = event.fromDate;
    endDate = event.toDate;
    complaintCount = [0, 0, 0, 0]; // keep 4 slots, don't empty it
    emit(AcknowledgeMarketPageLoadState()); // loader (no FetchState here)

    await _loadAllMarketTabs();

    if (event.isTimerCondition == true && complaintCount[0] != 0) {
      HomeHelper.fifteenMinuteNotification(
          context: !event.context.mounted ? event.context : event.context);
    }

    _eventComplete(emit);
  }

  _userList(AcknowledgeMarketUserListLoadEvent event, emit) async {
    isUserLoader = true;
    acknowledgeUserData = AcknowledgeUserModel();
    vendorData = VendorModel();
    assignTypeData = AssignTypeModel();
    remarkController.text = "";
    _eventComplete(emit);

    closeTimeController.text =
        DateFormat('HH:mm:ss').format(DateTime.now()).toString();

    if (vendorList.isEmpty) {
      var resVendor = await AcknowledgeHelper.fetchVendorData();
      if (resVendor != null) {
        vendorList = resVendor;
      }
    }

    if (acknowledgeUserList.isEmpty) {
      var res = await AddAcknowledgeComplaintHelper.fetchUserList();
      if (res != null) {
        acknowledgeUserList = res;
      }
    }

    if (departmentList.isEmpty) {
      var resDepartment =
          await AddAcknowledgeComplaintHelper.fetchDepartmentData();
      if (resDepartment != null) {
        departmentList = resDepartment;
      }
    }

    isUserLoader = false;
    _eventComplete(emit);
  }

  _selectUser(AcknowledgeMarketSelectUserEvent event, emit) {
    acknowledgeUserData = event.acknowledgeUserData;
    _eventComplete(emit);
  }

  _selectVendor(AcknowledgeMarketSelectVendorEvent event, emit) {
    vendorData = event.vendorData;
    _eventComplete(emit);
  }

  _selectAssignType(AcknowledgeMarketSelectAssignTypeEvent event, emit) {
    assignTypeData = event.assignTypeData;
    acknowledgeUserData = AcknowledgeUserModel();
    vendorData = VendorModel();
    sapCodeData = SapCodeModel();
    departmentData = DepartmentModel();
    _eventComplete(emit);
  }

  _selectDepartment(AcknowledgeMarketSelectDepartmentEvent event, emit) {
    departmentData = event.departmentData;
    plannerList = departmentData.plannerList!;
    plannerData = PlannerModel();
    workCenterList = [];
    workCenterData = WorkCenterModel();
    _eventComplete(emit);
  }

  _selectSapCode(AcknowledgeMarketSelectSapCodeEvent event, emit) {
    sapCodeData = event.sapCodeData;
    _eventComplete(emit);
  }

  _selectDate(AcknowledgeMarketSelectClosedDateEvent event, emit) async {
    try {
      final DateTime? picked = await showDatePicker(
          context: event.context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2015, 8),
          lastDate: DateTime.now());
      if (picked != null) {
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        closeDateController.text = formattedDate;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectTime(AcknowledgeMarketSelectClosedTimeEvent event, emit) async {
    try {
      DateTime initialDate = closeTimeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm:ss').parse(closeTimeController.text.toString())
          : DateTime.now();
      final DateTime? time = await showCupertinoDatePicker(
        context: event.context,
        initialDateTime: initialDate,
      );

      if (time != null) {
        closeTimeController.text =
            DateFormat('HH:mm:ss').format(time).toString();
        _eventComplete(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectPlanner(AcknowledgeMarketComplaintSelectedPlannerEvent event, emit) {
    plannerData = event.plannerData;
    workCenterList = plannerData.workCenterList!;
    workCenterData = WorkCenterModel();
    _eventComplete(emit);
  }

  _selectWorkCenter(
      AcknowledgeMarketComplaintSelectedWorkCenterEvent event, emit) {
    workCenterData = event.workCenterData;
    _eventComplete(emit);
  }

  _submit(AcknowledgeMarketUserSubmitEvent event, emit) async {
    _eventComplete(emit);
  }

  _eventComplete(Emitter<AcknowledgeMarketState> emit) {
    emit(FetchAcknowledgeMarketDataState(
      acknowledgeList: acknowledgeList,
      listOfComplaintData: listOfComplaintData,
      isLoader: isLoader,
      acknowledgeUserData: acknowledgeUserData,
      acknowledgeUserList: acknowledgeUserList,
      isUserLoader: isUserLoader,
      remarkController: remarkController,
      vendorData: vendorData,
      vendorList: vendorList,
      assignTypeData: assignTypeData,
      assignTypeList: assignTypeList,
      departmentData: departmentData,
      departmentList: departmentList,
      sapCodeData: sapCodeData,
      sapCodeList: sapCodeList,
      selectTabIndex: selectTabIndex,
      startDate: startDate,
      endDate: endDate,
      closeDateController: closeDateController,
      closedTimeController: closeTimeController,
      complaintCount: complaintCount,
      mainWorkCenterController: mainWorkCenterController,
      personResponsibleController: personResponsibleController,
      plannerGroupController: plannerGroupController,
      plannerData: plannerData,
      plannerList: plannerList,
      workCenterData: workCenterData,
      workCenterList: workCenterList,
    ));
  }
}
