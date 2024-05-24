import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/aasign_type_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/vendor_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/helper/acknowledge_helper.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/sap_code_model.dart';
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

  DateTime startDate = DateTime.now().subtract(const Duration(days: 4));
  DateTime endDate = DateTime.now();

  List<int> complaintCount = [];

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
    on<AcknowledgeUserSubmitEvent>(_submit);
  }

  _pageLoad(AcknowledgePageLoadEvent event, emit) async {
    emit(AcknowledgePageLoadState());
    isLoader = false;
    isUserLoader = false;
    acknowledgeList = [];
    acknowledgeUserList = [];
    vendorList = [];
    complaintCount = [];
    vendorData = VendorModel();
    acknowledgeUserData = AcknowledgeUserModel();
    remarkController.text = "";
    assignTypeData = AssignTypeModel();
    assignTypeList = AssignTypeModel().fetchData();
    _selectTabIndex = 0;

    var resAckow = await AddAcknowledgeComplaintHelper.fetchAcknowledgeData(
      fromDate: startDate.toString(),
      toDate: endDate.toString(),
    );
    if (resAckow != null) {
      acknowledgeList = resAckow;
      acknowledgeWithOutFilterList = resAckow;
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) => element.ackStatus.toString().isEmpty)
          .toList();
    }

    if (selectTabIndex == 0) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
      ( element.ackStatus.toString() == "0" || element.ackStatus.toString().isEmpty)
          && element.assignType.toString()  == "0"
          && element.miAssignType.toString() == "0")
          .toList();
    } else if (selectTabIndex == 1) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
      element.ackStatus.toString() == "1" &&
          (element.assignType.toString() == "0" ||
              element.assignType.toString().isEmpty))
          .toList();
    } else if (selectTabIndex == 2) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "2"
          && element.miAssignType.toString() == "0"
          && element.complaintStatus.toString() == "0")
          .toList();

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "3"
          && element.complaintStatus.toString() == "0")
          .toList());

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "2"
          && element.miAssignType.toString() == "3"
          && element.complaintStatus.toString() == "0")
          .toList());
    }

    complaintCount.add(acknowledgeWithOutFilterList
        .where((element) =>
    ( element.ackStatus.toString() == "0" || element.ackStatus.toString().isEmpty)
        && element.assignType.toString()  == "0"
        && element.miAssignType.toString() == "0")
        .toList()
        .length);

    complaintCount.add(acknowledgeWithOutFilterList
        .where((element) =>
    element.ackStatus.toString() == "1" &&
        (element.assignType.toString() == "0" ||
            element.assignType.toString().isEmpty))
        .toList()
        .length);


    int count = 0;
    count = acknowledgeWithOutFilterList
        .where((element) =>
    element.assignType.toString() == "2"
        && element.miAssignType.toString() == "0"
        && element.complaintStatus.toString() == "0")
        .toList().length;
    count = count+acknowledgeWithOutFilterList
        .where((element) =>
    element.assignType.toString() == "3"
        && element.complaintStatus.toString() == "0")
        .toList().length;
    count = count+acknowledgeWithOutFilterList
        .where((element) =>
    element.assignType.toString() == "2"
        && element.miAssignType.toString() == "3"
        && element.complaintStatus.toString() == "0")
        .toList().length;
    complaintCount.add(count);

    _eventComplete(emit);
  }

  _search(AcknowledgeComplaintSearchEvent event, emit) async {
    await Future.delayed(const Duration(milliseconds: 600));
    String keyword = event.keyword;

    List<AcknowledgeModel> tempList = acknowledgeWithOutFilterList;

    if (selectTabIndex == 0) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
      ( element.ackStatus.toString() == "0" || element.ackStatus.toString().isEmpty)
          && element.assignType.toString()  == "0"
          && element.miAssignType.toString() == "0")
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
      ( element.ackStatus.toString() == "0" || element.ackStatus.toString().isEmpty)
          && element.assignType.toString()  == "0"
          && element.miAssignType.toString() == "0")
          .toList();
    } else if (selectTabIndex == 1) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
      element.ackStatus.toString() == "1" &&
          (element.assignType.toString() == "0" ||
              element.assignType.toString().isEmpty))
          .toList();
    } else if (selectTabIndex == 2) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "2"
          && element.miAssignType.toString() == "0"
          && element.complaintStatus.toString() == "0")
          .toList();

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "3"
          && element.complaintStatus.toString() == "0")
          .toList());

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "2"
          && element.miAssignType.toString() == "3"
          && element.complaintStatus.toString() == "0")
          .toList());
    }

    complaintCount.add(acknowledgeWithOutFilterList
        .where((element) =>
    ( element.ackStatus.toString() == "0" || element.ackStatus.toString().isEmpty)
        && element.assignType.toString()  == "0"
        && element.miAssignType.toString() == "0")
        .toList()
        .length);

    complaintCount.add(acknowledgeWithOutFilterList
        .where((element) =>
    element.ackStatus.toString() == "1" &&
        (element.assignType.toString() == "0" ||
            element.assignType.toString().isEmpty))
        .toList()
        .length);


    int count = 0;
    count = acknowledgeWithOutFilterList
        .where((element) =>
    element.assignType.toString() == "2"
        && element.miAssignType.toString() == "0"
        && element.complaintStatus.toString() == "0")
        .toList().length;
    count = count+acknowledgeWithOutFilterList
        .where((element) =>
    element.assignType.toString() == "3"
        && element.complaintStatus.toString() == "0")
        .toList().length;
    count = count+acknowledgeWithOutFilterList
        .where((element) =>
    element.assignType.toString() == "2"
        && element.miAssignType.toString() == "3"
        && element.complaintStatus.toString() == "0")
        .toList().length;
    complaintCount.add(count);

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
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) => element.ackStatus.toString().isEmpty)
          .toList();
    }
    if (selectTabIndex == 0) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
      ( element.ackStatus.toString() == "0" || element.ackStatus.toString().isEmpty)
          && element.assignType.toString()  == "0"
          && element.miAssignType.toString() == "0")
          .toList();
    } else if (selectTabIndex == 1) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
              element.ackStatus.toString() == "1" &&
              (element.assignType.toString() == "0" ||
                  element.assignType.toString().isEmpty))
          .toList();
    } else if (selectTabIndex == 2) {
      acknowledgeList = acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "2"
          && element.miAssignType.toString() == "0"
          && element.complaintStatus.toString() == "0")
          .toList();

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "3"
          && element.complaintStatus.toString() == "0")
          .toList());

      acknowledgeList.addAll(acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "2"
          && element.miAssignType.toString() == "3"
          && element.complaintStatus.toString() == "0")
          .toList());
    }

    complaintCount.add(acknowledgeWithOutFilterList
        .where((element) =>
    ( element.ackStatus.toString() == "0" || element.ackStatus.toString().isEmpty)
        && element.assignType.toString()  == "0"
        && element.miAssignType.toString() == "0")
        .toList()
        .length);

    complaintCount.add(acknowledgeWithOutFilterList
        .where((element) =>
            element.ackStatus.toString() == "1" &&
            (element.assignType.toString() == "0" ||
                element.assignType.toString().isEmpty))
        .toList()
        .length);


    int count = 0;
    count = acknowledgeWithOutFilterList
        .where((element) =>
    element.assignType.toString() == "2"
        && element.miAssignType.toString() == "0"
        && element.complaintStatus.toString() == "0")
        .toList().length;
    count = count+acknowledgeWithOutFilterList
        .where((element) =>
    element.assignType.toString() == "3"
        && element.complaintStatus.toString() == "0")
        .toList().length;
    count = count+acknowledgeWithOutFilterList
        .where((element) =>
    element.assignType.toString() == "2"
        && element.miAssignType.toString() == "3"
        && element.complaintStatus.toString() == "0")
        .toList().length;
    complaintCount.add(count);

    _eventComplete(emit);
  }

  _userList(AcknowledgeUserListLoadEvent event, emit) async {
    isUserLoader = true;
    acknowledgeUserData = AcknowledgeUserModel();
    vendorData = VendorModel();
    assignTypeData = AssignTypeModel();
    _eventComplete(emit);

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

    if (sapCodeList.isEmpty) {
      var res = await AddAcknowledgeComplaintHelper.fetchSapCodeData();
      if (res != null) {
        sapCodeList = res;
      }
    }

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
    _eventComplete(emit);
  }

  _selectSapCode(AcknowledgeSelectSapCodeEvent event, emit) {
    sapCodeData = event.sapCodeData;
    _eventComplete(emit);
  }

  _submit(AcknowledgeUserSubmitEvent event, emit) async {
    var textFiledValidation = await AcknowledgeHelper.textFieldValidationCheck(
        context: event.context,
        vendorData: vendorData,
        userData: acknowledgeUserData,
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
      remark: remarkController.text.toString(),
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
      complaintCount = [];

      var resAckow = await AddAcknowledgeComplaintHelper.fetchAcknowledgeData(
        fromDate: startDate.toString(),
        toDate: endDate.toString(),
      );
      if (resAckow != null) {
        acknowledgeList = resAckow;
        acknowledgeWithOutFilterList = resAckow;
        acknowledgeList = acknowledgeWithOutFilterList
            .where((element) => element.ackStatus.toString().isEmpty)
            .toList();
      }
      if (selectTabIndex == 0) {
        acknowledgeList = acknowledgeWithOutFilterList
            .where((element) =>
        ( element.ackStatus.toString() == "0" || element.ackStatus.toString().isEmpty)
            && element.assignType.toString()  == "0"
            && element.miAssignType.toString() == "0")
            .toList();
      } else if (selectTabIndex == 1) {
        acknowledgeList = acknowledgeWithOutFilterList
            .where((element) =>
        element.ackStatus.toString() == "1" &&
            (element.assignType.toString() == "0" ||
                element.assignType.toString().isEmpty))
            .toList();
      } else if (selectTabIndex == 2) {
        acknowledgeList = acknowledgeWithOutFilterList
            .where((element) =>
        element.assignType.toString() == "2"
            && element.miAssignType.toString() == "0"
            && element.complaintStatus.toString() == "0")
            .toList();

        acknowledgeList.addAll(acknowledgeWithOutFilterList
            .where((element) =>
        element.assignType.toString() == "3"
            && element.complaintStatus.toString() == "0")
            .toList());

        acknowledgeList.addAll(acknowledgeWithOutFilterList
            .where((element) =>
        element.assignType.toString() == "2"
            && element.miAssignType.toString() == "3"
            && element.complaintStatus.toString() == "0")
            .toList());
      }

      complaintCount.add(acknowledgeWithOutFilterList
          .where((element) =>
      ( element.ackStatus.toString() == "0" || element.ackStatus.toString().isEmpty)
          && element.assignType.toString()  == "0"
          && element.miAssignType.toString() == "0")
          .toList()
          .length);

      complaintCount.add(acknowledgeWithOutFilterList
          .where((element) =>
      element.ackStatus.toString() == "1" &&
          (element.assignType.toString() == "0" ||
              element.assignType.toString().isEmpty))
          .toList()
          .length);


      int count = 0;
      count = acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "2"
          && element.miAssignType.toString() == "0"
          && element.complaintStatus.toString() == "0")
          .toList().length;
      count = count+acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "3"
          && element.complaintStatus.toString() == "0")
          .toList().length;
      count = count+acknowledgeWithOutFilterList
          .where((element) =>
      element.assignType.toString() == "2"
          && element.miAssignType.toString() == "3"
          && element.complaintStatus.toString() == "0")
          .toList().length;
      complaintCount.add(count);
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
        complaintCount: complaintCount));
  }
}
