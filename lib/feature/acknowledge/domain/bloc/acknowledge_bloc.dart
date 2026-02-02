import 'package:flutter/cupertino.dart';
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
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:vibration/vibration.dart';

part 'acknowledge_event.dart';
part 'acknowledge_state.dart';

class AcknowledgeBloc extends Bloc<AcknowledgeEvent, AcknowledgeState> {
  bool isLoader = false;
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

  int _selectTabIndex = 0;

  int get selectTabIndex => _selectTabIndex;

  DateTime startDate = DateTime.now().subtract(const Duration(days: 5));
  DateTime endDate = DateTime.now();

  List<String> parseAttachments = [];
  List<int> complaintCount = [];

  List<PlannerModel> plannerList = [];
  PlannerModel plannerData =  PlannerModel();
  List<WorkCenterModel> workCenterList = [];
  WorkCenterModel workCenterData =  WorkCenterModel();

  bool isComplaintNumberLoader =  false;

  AcknowledgeBloc() : super(AcknowledgeInitial()) {
    on<AcknowledgePageLoadEvent>(_pageLoad);
    on<AcknowledgeComplaintSearchEvent>(_search);
    on<AcknowledgeComplaintSelectedTabIndexEvent>(_selectTab);
    on<AcknowledgeSelectDateRangeEvent>(_selectDateRange);
    on<AcknowledgeUserListLoadEvent>(_userList);
    on<AcknowledgeSelectUserEvent>(_selectUser);
    on<AcknowledgeSelectVendorEvent>(_selectVendor);
    on<AcknowledgeSelectAssignTypeEvent>(_selectAssignType);
    on<AcknowledgeSelectDepartmentEvent>(_selectDepartment);
    on<AcknowledgeSelectSapCodeEvent>(_selectSapCode);
    on<AcknowledgeSelectClosedDateEvent>(_selectDate);
    on<AcknowledgeSelectClosedTimeEvent>(_selectTime);
    on<AcknowledgeComplaintSelectedPlannerEvent>(_selectPlanner);
    on<AcknowledgeComplaintSelectedWorkCenterEvent>(_selectWorkCenter);
    on<AcknowledgeUserSubmitEvent>(_submit);
  }

  _pageLoad(AcknowledgePageLoadEvent event, emit) async {
    emit(AcknowledgePageLoadState());
    isLoader = false;
    isUserLoader = false;
    isComplaintNumberLoader =  false;
    acknowledgeList = [];
    acknowledgeUserList = [];
    vendorList = [];
    complaintCount = [];
    vendorData = VendorModel();
    acknowledgeUserData = AcknowledgeUserModel();
    remarkController.text = "";
    closeDateController.text = "";
    closeTimeController.text = "";
    plannerGroupController.text = "";
    mainWorkCenterController.text = "";
    personResponsibleController.text = "";
    assignTypeData = AssignTypeModel();
  //  assignTypeList = AssignTypeModel().fetchData();
    assignTypeList = await AcknowledgeHelper.fetchCNGComplainAssignData() ?? [];
    _selectTabIndex = event.selectTabIndex;
    plannerData =  PlannerModel();
    workCenterData =  WorkCenterModel();
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    closeDateController.text = formattedDate;


    var resAckow = await AddAcknowledgeComplaintHelper.fetchAcknowledgeData(
      fromDate: startDate.toString(),
      toDate: endDate.toString(),
    );
    if (resAckow != null) {
      acknowledgeList = resAckow;
      acknowledgeWithOutFilterList = resAckow;
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
              element.ackStatus.toString() == "0" &&
              element.assignType.toString() == "0" &&
              element.miAssignType.toString() == "0")
          .toList();
    }
    if (acknowledgeList != null) {
      for (var d in acknowledgeList) {
        parseAttachments.addAll(
          AcknowledgeHelper.parseAttachments(d.attachmentFile),
        );
      }
    }


    if (selectTabIndex == 0) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
      element.ackStatus.toString() == "0" &&
          element.assignType.toString() == "0" &&
          element.miAssignType.toString() == "0")
          .toList();
    } else if (selectTabIndex == 1) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
      element.ackStatus.toString() == "1" &&
          element.complaintStatus.toString() == "0" &&
          element.assignType.toString() == "0")
          .toList();
    } else if (selectTabIndex == 2) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "2" &&
          element.miAssignType.toString() == "0" &&
          element.complaintStatus.toString() == "0")
          .toList();

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "3" &&
          element.complaintStatus.toString() == "0")
          .toList());

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "2" &&
          element.miAssignType.toString() == "3" &&
          element.complaintStatus.toString() == "0")
          .toList());

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "1" &&
          element.complaintStatus.toString() == "0")
          .toList());

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "3" &&
          element.miAssignType.toString() == "3" &&
          element.complaintStatus.toString() == "0")
          .toList());
    }
    else if (selectTabIndex == 3) {
      acknowledgeList = [];

    }

    complaintCount.add(acknowledgeWithOutFilterList
        .where((element) =>
    element.ackStatus.toString() == "0" &&
        element.assignType.toString() == "0" &&
        element.miAssignType.toString() == "0")
        .toList()
        .length);

    complaintCount.add(acknowledgeWithOutFilterList
        .where((element) =>
    element.ackStatus.toString() == "1" &&
        element.complaintStatus.toString() == "0" &&
        element.assignType.toString() == "0")
        .toList()
        .length);

    int count = 0;
    count = acknowledgeWithOutFilterList
        .where((element) =>
    element.assignType.toString() == "2" &&
        element.miAssignType.toString() == "0" &&
        element.complaintStatus.toString() == "0")
        .toList()
        .length;
    count = count +
        acknowledgeWithOutFilterList
            .where((element) =>
        element.assignType.toString() == "3" &&
            element.complaintStatus.toString() == "0")
            .toList()
            .length;
    count = count +
        acknowledgeWithOutFilterList
            .where((element) =>
        element.assignType.toString() == "2" &&
            element.miAssignType.toString() == "3" &&
            element.complaintStatus.toString() == "0")
            .toList()
            .length;
    count = count +
        acknowledgeWithOutFilterList
            .where((element) =>
        element.assignType.toString() == "1" &&
            element.complaintStatus.toString() == "0")
            .toList()
            .length;

    count = count +
        acknowledgeWithOutFilterList
            .where((element) =>
        element.assignType.toString() == "3" &&
            element.miAssignType.toString() == "3" &&
            element.complaintStatus.toString() == "0")
            .toList()
            .length;

    complaintCount.add(count);

    complaintCount.add(0); // Closre count;

    _eventComplete(emit);
  }

  _search(AcknowledgeComplaintSearchEvent event, emit) async {
    await Future.delayed(const Duration(milliseconds: 600));
    String keyword = event.keyword;

    List<AcknowledgeModel> tempList = acknowledgeWithOutFilterList;

    if (selectTabIndex == 0) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
              (element.ackStatus.toString() == "0" ||
                  element.ackStatus.toString().isEmpty) &&
                  element.complaintStatus.toString() != "3" &&
              element.assignType.toString() == "0" &&
              element.miAssignType.toString() == "0")
          .toList();
    } else if (selectTabIndex == 1) {
      tempList = acknowledgeWithOutFilterList
          .where((element) =>
              element.ackStatus.toString() == "1" &&
              element.assignType.toString().isEmpty)
          .toList();
    } else if (selectTabIndex == 2) {
      tempList = acknowledgeWithOutFilterList
          .where((element) =>
              element.assignType.toString() != "0" &&
              element.complaintStatus.toString() != "1")
          .toList();
    }

    if (keyword.isNotEmpty) {
      acknowledgeList = tempList
          .where((element) => element.tokenNo
              .toString()
              .toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();

      if (acknowledgeList.isEmpty) {
        acknowledgeList = tempList
            .where((element) => element.createdByUser
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()))
            .toList();
      }

      if (acknowledgeList.isEmpty) {
        acknowledgeList = tempList
            .where((element) => element.complaintDateTime
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()))
            .toList();
      }

      if (acknowledgeList.isEmpty) {
        acknowledgeList = tempList
            .where((element) => element.complaintDescription
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()))
            .toList();
      }

      if (acknowledgeList.isEmpty) {
        acknowledgeList = tempList
            .where((element) => element.equipmentName
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()))
            .toList();
      }
    } else {
      acknowledgeList = tempList;
    }


    _eventComplete(emit);
  }

  _selectTab(AcknowledgeComplaintSelectedTabIndexEvent event, emit) async {
    if (await Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 100);
    }
    _selectTabIndex = event.selectedTabIndex;
    complaintCount = [];
    if (selectTabIndex == 0) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
              element.ackStatus.toString() == "0" &&
              element.assignType.toString() == "0" &&
              element.miAssignType.toString() == "0")
          .toList();
    } else if (selectTabIndex == 1) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
      element.ackStatus.toString() == "1" &&
          element.complaintStatus.toString() == "0" &&
          element.assignType.toString() == "0")
          .toList();
    } else if (selectTabIndex == 2) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
              element.assignType.toString() == "2" &&
              element.miAssignType.toString() == "0" &&
              element.complaintStatus.toString() == "0")
          .toList();

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
              element.assignType.toString() == "3" &&
              element.complaintStatus.toString() == "0")
          .toList());

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
              element.assignType.toString() == "2" &&
              element.miAssignType.toString() == "3" &&
              element.complaintStatus.toString() == "0")
          .toList());

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
              element.assignType.toString() == "1" &&
              element.complaintStatus.toString() == "0")
          .toList());

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
              element.assignType.toString() == "3" &&
              element.miAssignType.toString() == "3" &&
              element.complaintStatus.toString() == "0")
          .toList());
    }
    else if (selectTabIndex == 3) {
      acknowledgeList = [];

    }

    complaintCount.add(acknowledgeWithOutFilterList
        .where((element) =>
            element.ackStatus.toString() == "0" &&
            element.assignType.toString() == "0" &&
            element.miAssignType.toString() == "0")
        .toList()
        .length);

    complaintCount.add(acknowledgeWithOutFilterList
        .where((element) =>
            element.ackStatus.toString() == "1" &&
            element.complaintStatus.toString() == "0" &&
            element.assignType.toString() == "0")
        .toList()
        .length);

    int count = 0;
    count = acknowledgeWithOutFilterList
        .where((element) =>
            element.assignType.toString() == "2" &&
            element.miAssignType.toString() == "0" &&
            element.complaintStatus.toString() == "0")
        .toList()
        .length;
    count = count +
        acknowledgeWithOutFilterList
            .where((element) =>
                element.assignType.toString() == "3" &&
                element.complaintStatus.toString() == "0")
            .toList()
            .length;
    count = count +
        acknowledgeWithOutFilterList
            .where((element) =>
                element.assignType.toString() == "2" &&
                element.miAssignType.toString() == "3" &&
                element.complaintStatus.toString() == "0")
            .toList()
            .length;
    count = count +
        acknowledgeWithOutFilterList
            .where((element) =>
                element.assignType.toString() == "1" &&
                element.complaintStatus.toString() == "0")
            .toList()
            .length;

    count = count +
        acknowledgeWithOutFilterList
            .where((element) =>
                element.assignType.toString() == "3" &&
                element.miAssignType.toString() == "3" &&
                element.complaintStatus.toString() == "0")
            .toList()
            .length;

    complaintCount.add(count);

    complaintCount.add(0); // Closure count;
    _eventComplete(emit);
  }

  _selectDateRange(AcknowledgeSelectDateRangeEvent event, emit) async {
    acknowledgeList = [];
    acknowledgeWithOutFilterList = [];
    startDate = event.fromDate;
    endDate = event.toDate;
    complaintCount = [];
    _eventComplete(emit);
    emit(AcknowledgePageLoadState());

    var resAckow = await AddAcknowledgeComplaintHelper.fetchAcknowledgeData(
      fromDate: event.fromDate.toString(),
      toDate: event.toDate.toString(),
    );
    if (resAckow != null) {
      acknowledgeList = resAckow;
      acknowledgeWithOutFilterList = resAckow;
    }

    if (selectTabIndex == 0) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
              element.ackStatus.toString() == "0" &&
              element.assignType.toString() == "0" &&
              element.miAssignType.toString() == "0")
          .toList();
    } else if (selectTabIndex == 1) {
      acknowledgeList = acknowledgeWithOutFilterList
                .where((element) =>
            element.ackStatus.toString() == "1" &&
                element.complaintStatus.toString() == "0" &&
                element.assignType.toString() == "0")
                .toList();
    } else if (selectTabIndex == 2) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
              element.assignType.toString() == "2" &&
              element.miAssignType.toString() == "0" &&
              element.complaintStatus.toString() == "0")
          .toList();

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
              element.assignType.toString() == "3" &&
              element.complaintStatus.toString() == "0")
          .toList());

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
              element.assignType.toString() == "2" &&
              element.miAssignType.toString() == "3" &&
              element.complaintStatus.toString() == "0")
          .toList());

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
              element.assignType.toString() == "1" &&
              element.complaintStatus.toString() == "0")
          .toList());

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
              element.assignType.toString() == "3" &&
              element.miAssignType.toString() == "3" &&
              element.complaintStatus.toString() == "0")
          .toList());
    }

    complaintCount.add(acknowledgeWithOutFilterList
        .where((element) =>
            element.ackStatus.toString() == "0" &&
            element.assignType.toString() == "0" &&
            element.miAssignType.toString() == "0")
        .toList()
        .length);

    complaintCount.add(acknowledgeWithOutFilterList
        .where((element) =>
            element.ackStatus.toString() == "1" &&
            element.complaintStatus.toString() == "0" &&
            element.assignType.toString() == "0")
        .toList()
        .length);

    int count = 0;
    count = acknowledgeWithOutFilterList
        .where((element) =>
            element.assignType.toString() == "2" &&
            element.miAssignType.toString() == "0" &&
            element.complaintStatus.toString() == "0")
        .toList()
        .length;
    count = count +
        acknowledgeWithOutFilterList
            .where((element) =>
                element.assignType.toString() == "3" &&
                element.complaintStatus.toString() == "0")
            .toList()
            .length;
    count = count +
        acknowledgeWithOutFilterList
            .where((element) =>
                element.assignType.toString() == "2" &&
                element.miAssignType.toString() == "3" &&
                element.complaintStatus.toString() == "0")
            .toList()
            .length;
    count = count +
        acknowledgeWithOutFilterList
            .where((element) =>
                element.assignType.toString() == "1" &&
                element.complaintStatus.toString() == "0")
            .toList()
            .length;

    count = count +
        acknowledgeWithOutFilterList
            .where((element) =>
                element.assignType.toString() == "3" &&
                element.miAssignType.toString() == "3" &&
                element.complaintStatus.toString() == "0")
            .toList()
            .length;

    complaintCount.add(count);

    complaintCount.add(0); // Closure count;

    if(event.isTimerCondition == true && complaintCount[0] != 0){
       HomeHelper.fifteenMinuteNotification(context: !event.context.mounted ? event.context : event.context);
    }

    _eventComplete(emit);
  }

  _userList(AcknowledgeUserListLoadEvent event, emit) async {
    isUserLoader = true;
    acknowledgeUserData = AcknowledgeUserModel();
    vendorData = VendorModel();
    assignTypeData = AssignTypeModel();
    remarkController.text = "";
    _eventComplete(emit);

    closeTimeController.text = DateFormat('HH:mm:ss').format(DateTime.now()).toString();

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

/*
    if(plannerList.isEmpty){
      var res =  await AcknowledgeHelper.fetchPlannerData();
      if(res !=  null){
        plannerList =  res;
      }
    }
*/

/*    if(workCenterList.isEmpty){
      var res =  await AcknowledgeHelper.fetchWorkCenterData();
      if(res !=  null){
        workCenterList =  res;
      }
    }*/

    isUserLoader = false;
    _eventComplete(emit);
  }

  _selectUser(AcknowledgeSelectUserEvent event, emit) {
    acknowledgeUserData = event.acknowledgeUserData;
    _eventComplete(emit);
  }

  _selectVendor(AcknowledgeSelectVendorEvent event, emit) {
    vendorData = event.vendorData;
    _eventComplete(emit);
  }

  _selectAssignType(AcknowledgeSelectAssignTypeEvent event, emit) {
    assignTypeData = event.assignTypeData;
    acknowledgeUserData = AcknowledgeUserModel();
    vendorData = VendorModel();
    sapCodeData = SapCodeModel();
    departmentData = DepartmentModel();
    _eventComplete(emit);
  }

  _selectDepartment(AcknowledgeSelectDepartmentEvent event, emit) {
    departmentData = event.departmentData;
    plannerList = departmentData.plannerList!;
    plannerData = PlannerModel();
    workCenterList = [];
    workCenterData =  WorkCenterModel();
    _eventComplete(emit);
  }

  _selectSapCode(AcknowledgeSelectSapCodeEvent event, emit) {
    sapCodeData = event.sapCodeData;
    _eventComplete(emit);
  }

  _selectDate(AcknowledgeSelectClosedDateEvent event, emit) async {
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

  _selectTime(AcknowledgeSelectClosedTimeEvent event, emit) async {
    try {
      DateTime initialDate = closeTimeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm:ss').parse(closeTimeController.text.toString())
          : DateTime.now();
      final DateTime? time = await showCupertinoDatePicker(
        context: event.context,
        initialDateTime: initialDate,
        mode: CupertinoDatePickerMode.dateAndTime,
      );

      if (time != null) {
        closeTimeController.text = DateFormat('HH:mm:ss').format(time).toString();
        _eventComplete(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectPlanner(AcknowledgeComplaintSelectedPlannerEvent event, emit) {
    plannerData  =  event.plannerData;
    workCenterList = plannerData.workCenterList!;
    workCenterData =  WorkCenterModel();
    _eventComplete(emit);
  }

  _selectWorkCenter(AcknowledgeComplaintSelectedWorkCenterEvent event, emit) {
    workCenterData =  event.workCenterData;
    _eventComplete(emit);
  }

  _submit(AcknowledgeUserSubmitEvent event, emit) async {
    var textFiledValidation = await AcknowledgeHelper.textFieldValidationCheck(
        context: event.context,
        vendorData: vendorData,
        userData: acknowledgeUserData,
        sapCodeModel: sapCodeData,
        plannerData: plannerData,
        workCenterData: workCenterData,
        time: closeTimeController.text.toString(),
        assignTypeData: assignTypeData);
    if (textFiledValidation == false) {
      return;
    }
    isLoader = true;
    _eventComplete(emit);
    var res = await AcknowledgeHelper.assignUser(
      context: !event.context.mounted ? event.context : event.context,
      acknowledgeData: event.acknowledgeData,
      userModel: acknowledgeUserData,
      vendorData: vendorData,
      assignTypeData: assignTypeData,
      sapCodeData: sapCodeData,
      departmentData: departmentData,
      closedDate: closeDateController.text.toString(),
      closedTime: closeTimeController.text.toString(),
      remark: remarkController.text.toString(),
      personResponsible: personResponsibleController.text.toString(),
      plannerData: plannerData,
      workCenterData: workCenterData,
      sparesPartList: BlocProvider.of<AddSparePartBloc>(!event.context.mounted
          ? event.context : event.context).partList,
      scrapList: BlocProvider.of<AddScrapBloc>(!event.context.mounted
          ? event.context : event.context).scrapList,
    );
    isLoader = false;
    _eventComplete(emit);
    if (res != null) {
      Navigator.pop(
        !event.context.mounted ? event.context : event.context,
      );
      emit(AcknowledgePageLoadState());
      isLoader = false;
      acknowledgeList = [];
      acknowledgeWithOutFilterList = [];
      startDate = startDate;
      endDate = endDate;
      closeDateController.text = "";
      closeTimeController.text = "";
      complaintCount = [];
      workCenterData = WorkCenterModel();
      plannerData =  PlannerModel();
      String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      closeDateController.text = formattedDate;

      var resAckow = await AddAcknowledgeComplaintHelper.fetchAcknowledgeData(
        fromDate: startDate.toString(),
        toDate: endDate.toString(),
      );
      if (resAckow != null) {
        acknowledgeList = resAckow;
        acknowledgeWithOutFilterList = resAckow;
      }
      if (selectTabIndex == 0) {
        acknowledgeList = acknowledgeWithOutFilterList
            .where((element) =>
                element.ackStatus.toString() == "0" &&
                element.assignType.toString() == "0" &&
                element.miAssignType.toString() == "0")
            .toList();
      } else if (selectTabIndex == 1) {
        acknowledgeList = acknowledgeWithOutFilterList
            .where((element) =>
                element.ackStatus.toString() == "1" &&
                element.complaintStatus.toString() == "0" &&
                element.assignType.toString() == "0")
            .toList();
      } else if (selectTabIndex == 2) {
        acknowledgeList = acknowledgeWithOutFilterList
            .where((element) =>
                element.assignType.toString() == "2" &&
                element.miAssignType.toString() == "0" &&
                element.complaintStatus.toString() == "0")
            .toList();

        acknowledgeList.addAll(acknowledgeWithOutFilterList
            .where((element) =>
                element.assignType.toString() == "3" &&
                element.complaintStatus.toString() == "0")
            .toList());

        acknowledgeList.addAll(acknowledgeWithOutFilterList
            .where((element) =>
                element.assignType.toString() == "2" &&
                element.miAssignType.toString() == "3" &&
                element.complaintStatus.toString() == "0")
            .toList());

        acknowledgeList.addAll(acknowledgeWithOutFilterList
            .where((element) =>
                element.assignType.toString() == "1" &&
                element.complaintStatus.toString() == "0")
            .toList());

        acknowledgeList.addAll(acknowledgeWithOutFilterList
            .where((element) =>
                element.assignType.toString() == "3" &&
                element.miAssignType.toString() == "3" &&
                element.complaintStatus.toString() == "0")
            .toList());
      }

      complaintCount.add(acknowledgeWithOutFilterList
          .where((element) =>
              element.ackStatus.toString() == "0" &&
              element.assignType.toString() == "0" &&
              element.miAssignType.toString() == "0")
          .toList()
          .length);

      complaintCount.add(acknowledgeWithOutFilterList
          .where((element) =>
              element.ackStatus.toString() == "1" &&
              element.complaintStatus.toString() == "0" &&
              element.assignType.toString() == "0")
          .toList()
          .length);

      int count = 0;
      count = acknowledgeWithOutFilterList
          .where((element) =>
              element.assignType.toString() == "2" &&
              element.miAssignType.toString() == "0" &&
              element.complaintStatus.toString() == "0")
          .toList()
          .length;
      count = count +
          acknowledgeWithOutFilterList
              .where((element) =>
                  element.assignType.toString() == "3" &&
                  element.complaintStatus.toString() == "0")
              .toList()
              .length;
      count = count +
          acknowledgeWithOutFilterList
              .where((element) =>
                  element.assignType.toString() == "2" &&
                  element.miAssignType.toString() == "3" &&
                  element.complaintStatus.toString() == "0")
              .toList()
              .length;
      count = count +
          acknowledgeWithOutFilterList
              .where((element) =>
                  element.assignType.toString() == "1" &&
                  element.complaintStatus.toString() == "0")
              .toList()
              .length;

      count = count +
          acknowledgeWithOutFilterList
              .where((element) =>
                  element.assignType.toString() == "3" &&
                  element.miAssignType.toString() == "3" &&
                  element.complaintStatus.toString() == "0")
              .toList()
              .length;

      complaintCount.add(count);

      complaintCount.add(0); // Closure count;
      _eventComplete(emit);
    }
  }

  _eventComplete(Emitter<AcknowledgeState> emit) {
    emit(FetchAcknowledgeDataState(
        acknowledgeList: acknowledgeList,
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
      parseAttachments: parseAttachments,
    ));
  }
}
