import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/planner_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/work_center_model.dart';
import 'package:flutter_igl_cng/feature/marketing/acknowledgeMarketing/domain/model/complaint_market_list_model.dart';
import 'package:flutter_igl_cng/feature/marketing/addAcknowledgeMarket/addAcknowledgeMarketComplaint/domain/model/vendor_model.dart';
import 'package:flutter_igl_cng/feature/marketing/addAcknowledgeMarket/addAcknowledgeMarketComplaint/helper/add_acknowledge_market_helper.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/addEquipmentComplaint/helper/add_equipment_complaint_market_helper.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/complaint_description_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/equipment_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'add_acknowledge_market_complaint_state.dart';

part 'add_acknowledge_market_complaint_event.dart';

class AddAcknowledgeMarketComplaintBloc extends Bloc<
    AddAcknowledgeMarketComplaintEvent, AddAcknowledgeMarketComplaintState> {
  List<VendorMarketModel> listOfVendorMarketData = [];
  VendorMarketModel vendorMarketData = VendorMarketModel();

  List<ComplaintTypeModel> complaintTypeList = [];
  ComplaintTypeModel complaintTypeData = ComplaintTypeModel();
  EquipmentTypeModel equipmentTypeData = EquipmentTypeModel();
  List<EquipmentTypeModel> equipmentTypeList = [];
  List<EquipmentModel> equipmentList = [];
  TextEditingController descriptionController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController personResponsibleController = TextEditingController();
  bool isLoader = false;
  File file = File("");
  List<DepartmentModel> departmentList = [];
  DepartmentModel departmentData = DepartmentModel();
  List<ComplaintModel> complaintList = [];
  ComplaintModel complaintData = ComplaintModel();
  List<AcknowledgeModel> acknowledgeList = [];
  ComplaintMarketModel acknowledgeData = ComplaintMarketModel();
  ReviewComplaintModel reviewComplaintData = ReviewComplaintModel();
  List<AcknowledgeUserModel> acknowledgeUserList = [];
  AcknowledgeUserModel acknowledgeUserData = AcknowledgeUserModel();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  int selectedTabIndex = 0;
  String breakDownvalue = "2";

  bool isComplaintLoader = false;

  List<GeneralComplaintModel> generalComplaintList = [];
  GeneralComplaintModel generalComplaintData = GeneralComplaintModel();
  TextEditingController generalDescriptionController = TextEditingController();
  String complaintStatus = "0";

  List<PlannerModel> plannerList = [];
  PlannerModel plannerData = PlannerModel();
  List<WorkCenterModel> workCenterList = [];
  WorkCenterModel workCenterData = WorkCenterModel();
  EquipmentComplaintType equipmentComplaintType = EquipmentComplaintType.normal;
  List<ComplaintDescriptionModel> complaintDescriptionList = [];
  ComplaintDescriptionModel complaintDescriptionData =
      ComplaintDescriptionModel();

  AddAcknowledgeMarketComplaintBloc()
      : super(AddAcknowledgeMarketComplaintInitial()) {
    on<AddAcknowledgeMarketComplaintPageLoadEvent>(_pageLoad);
    on<AddAcknowledgeMarketComplaintSelectComplaintDataEvent>(
        _selectComplaintType);
    on<AddAcknowledgeMarketComplaintSelectVendorDataEvent>(_selectVendorData);
    on<AddAcknowledgeMarketComplaintSelectEquipmentDataEvent>(_selectEquipment);
    on<AddAcknowledgeMarketComplaintSelectStatusData>(_selectComplaintStatus);
    on<AddAcknowledgeMarketComplaintSelectUserEvent>(_selectUser);
    on<AddAcknowledgeMarketComplaintSelectDepartmentEvent>(_selectDepartment);
    on<AddAcknowledgeMarketComplaintSelectedPlannerEvent>(_selectPlanner);
    on<AddAcknowledgeMarketComplaintSelectedWorkCenterEvent>(_selectWorkCenter);
    on<AddAcknowledgeMarketComplaintSelectComplaintEvent>(_selectComplaint);
    on<AddAcknowledgeMarketComplaintSelectAcknowledgeComplaintEvent>(
        _selectAcknowledget);
    on<AddAcknowledgeMarketComplaintSelectGeneralDataEvent>(_selectGeneral);
    on<AddAcknowledgeMarketComplaintSelectDescriptionDataEvent>(
        _selectComplaintDescription);
    on<AddAcknowledgeMarketComplaintSelectDateData>(_selectDate);
    on<AddAcknowledgeMarketComplaintSelectTimeData>(_selectTime);
    on<AddAcknowledgeMarketComplaintAddImageEvent>(_selectFile);
    on<AddAcknowledgeMarketComplaintSelectBreakDownEvent>(_selectBreakdown);
    on<AddAcknowledgeMarketComplaintSelectReviewComplaintEvent>(
        _selectReviewComplaint);
    on<AddAcknowledgeMarketComplaintSubmitEvent>(_submit);
  }

  _pageLoad(AddAcknowledgeMarketComplaintPageLoadEvent event, emit) async {
    emit(AddAcknowledgeMarketComplaintPageLoadState());
    try {
      complaintTypeList = [];
      complaintTypeData = ComplaintTypeModel();
      equipmentTypeData = EquipmentTypeModel();
      equipmentTypeList = [];
      equipmentList = [];
      departmentList = [];
      complaintList = [];
      acknowledgeList = [];
      acknowledgeUserList = [];
      acknowledgeUserData = AcknowledgeUserModel();
      descriptionController.text = "";
      remarkController.text = "";
      dateController.text = "";
      timeController.text = "";
      isLoader = false;
      isComplaintLoader = false;
      file = File("");
      departmentData = DepartmentModel();
      complaintData = ComplaintModel();
      acknowledgeData = ComplaintMarketModel();
      reviewComplaintData = ReviewComplaintModel();
      breakDownvalue = "2";
      generalDescriptionController.text = "";
      personResponsibleController.text = "";
      generalComplaintList = [];
      generalComplaintData = GeneralComplaintModel();
      complaintStatus = "0";
      plannerData = PlannerModel();
      workCenterData = WorkCenterModel();
      complaintDescriptionList = [];
      complaintDescriptionData = ComplaintDescriptionModel();
      equipmentComplaintType = event.equipmentComplaintType;
      listOfVendorMarketData = [];
      vendorMarketData = VendorMarketModel();
      selectedTabIndex = event.selectedTabIndex;
      acknowledgeData = event.acknowledgeData;
      await _loadAllTabsData();
      // acknowledgeList =
      //     BlocProvider.of<AcknowledgeBloc>(event.context).acknowledgeList;

      // var resVendor =
      //     await AddEquipmentComplaintMarkerHelper.fetchVendorTypeData();
      // if (resVendor != null) {
      //   listOfVendorMarketData = resVendor;
      // }
      //
      // var resComplaint =
      //     await AddEquipmentComplaintMarkerHelper.fetchComplaintTypeData(
      //         equipmentComplaintType: equipmentComplaintType);
      // if (resComplaint != null) {
      //   complaintTypeList = resComplaint;
      //   for (var complaint in complaintTypeList) {
      //     if (complaint.id.toString() ==
      //         event.acknowledgeData.ticketNo.toString()) {
      //       complaintTypeData = complaint;
      //     }
      //   }
      // }
      //
      // var resUser = await AddAcknowledgeMarketComplaintHelper.fetchUserList();
      // if (resUser != null) {
      //   acknowledgeUserList = resUser;
      //   for (var user in acknowledgeUserList) {
      //     if (user.id.toString() == event.acknowledgeData.ackBy.toString()) {
      //       acknowledgeUserData = user;
      //     }
      //   }
      // }

      String complaintDate = "";
      if (acknowledgeData.incidentDateTime.toString().isNotEmpty) {
        complaintDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(acknowledgeData.incidentDateTime.toString()));
        dateController.text = complaintDate;

        DateTime initialDate = acknowledgeData.incidentDateTime.toString().isNotEmpty
                ? DateFormat('yyyy-dd-MM HH:mm:ss').parse(acknowledgeData.incidentDateTime.toString())
                : DateTime.now();
        timeController.text = DateFormat('HH:mm:ss').format(initialDate).toString();
      }

      // breakDownvalue = event.acknowledgeData.crBreakdown.toString() == "0"
      //     ? "2"
      //     : event.acknowledgeData.crBreakdown.toString();

      descriptionController.text = acknowledgeData.ackRemarks.toString().isNotEmpty
              ? acknowledgeData.ackRemarks.toString()
              : acknowledgeData.complaintDescription.toString();
      remarkController.text = acknowledgeData.complaintDescription.toString();
      complaintStatus = acknowledgeData.ackStatus.toString();
      personResponsibleController.text = acknowledgeData.ackResponse.toString();

      if (plannerList.isEmpty && departmentData.plannerList != null) {
        plannerList = departmentData.plannerList!;
      }

      // for (var data in plannerList) {
      //   if (data.plannerGroup.toString().toLowerCase() ==
      //       event.acknowledgeData.plannerGroup.toString().toLowerCase()) {
      //     plannerData = data;
      //   }
      // }

      if (workCenterList.isEmpty && plannerData.workCenterList != null) {
        workCenterList = plannerData.workCenterList!;
      }

      // for (var data in workCenterList) {
      //   if (data.workCenter.toString().toLowerCase() ==
      //       event.acknowledgeData.mainWorkCenter.toString().toLowerCase()) {
      //     workCenterData = data;
      //   }
      // }

      // var resDescription = await AddEquipmentComplaintHelper.fetchDescriptionComplaintData();
      // if (resDescription != null) {
      //   complaintDescriptionList = resDescription;
      //   for (var data in complaintDescriptionList) {
      //     if (data.description.toString().toLowerCase() ==
      //         acknowledgeData.complaintDescription.toString().toLowerCase()) {
      //       complaintDescriptionData = data;
      //     }
      //   }
      // }
    } catch (e) {
      if (kDebugMode) print("market pageLoad error: $e");
    }
    _eventComplete(emit);
  }

  Future<void> _loadAllTabsData() async {
// Load Vendor Data
    var resVendor = await AddEquipmentComplaintMarkerHelper.fetchVendorTypeData();
    if (resVendor != null) {
      listOfVendorMarketData = resVendor;
    }

// Load Complaint Type Data
    var resComplaint = await AddEquipmentComplaintMarkerHelper.fetchComplaintTypeData(equipmentComplaintType: equipmentComplaintType);
    if (resComplaint != null) {
      complaintTypeList = resComplaint;
      for (var complaint in complaintTypeList) {
        if (complaint.id.toString() == acknowledgeData.ticketNo.toString()) {
          complaintTypeData = complaint;
        }
      }
    }

// Load User List
    var resUser = await AddAcknowledgeMarketComplaintHelper.fetchUserList();
    if (resUser != null) {acknowledgeUserList = resUser;
    for (var user in acknowledgeUserList) {
      if (user.id.toString() == acknowledgeData.ackBy.toString()) {
        acknowledgeUserData = user;
      }
    }
    }

// Load Description Data
    var resDescription = await AddEquipmentComplaintHelper.fetchDescriptionComplaintData();
    if (resDescription != null) {
      complaintDescriptionList = resDescription;
      for (var data in complaintDescriptionList) {
        if (data.description.toString().toLowerCase() == acknowledgeData.complaintDescription.toString().toLowerCase()) {
          complaintDescriptionData = data;
        }
      }
    }
  }

  _selectComplaintType(
      AddAcknowledgeMarketComplaintSelectComplaintDataEvent event, emit) {
    complaintTypeData = event.complaintTypeData;
    equipmentTypeData = EquipmentTypeModel();
    _eventComplete(emit);
  }

  _selectVendorData(
      AddAcknowledgeMarketComplaintSelectVendorDataEvent event, emit) {
    vendorMarketData = event.vendorMarketData;
    _eventComplete(emit);
  }

  _selectEquipment(
      AddAcknowledgeMarketComplaintSelectEquipmentDataEvent event, emit) {
    equipmentTypeData = event.equipmentTypeData;
    _eventComplete(emit);
  }

  _selectComplaintStatus(
      AddAcknowledgeMarketComplaintSelectStatusData event, emit) {
    complaintStatus = event.complaintStatus;
    _eventComplete(emit);
  }

  _selectUser(AddAcknowledgeMarketComplaintSelectUserEvent event, emit) {
    acknowledgeUserData = event.acknowledgeUserData;
    _eventComplete(emit);
  }

  _selectDepartment(
      AddAcknowledgeMarketComplaintSelectDepartmentEvent event, emit) {
    departmentData = event.departmentData;
    plannerList = departmentData.plannerList!;
    ;
    plannerData = PlannerModel();
    workCenterList = [];
    workCenterData = WorkCenterModel();
    _eventComplete(emit);
  }

  _selectPlanner(
      AddAcknowledgeMarketComplaintSelectedPlannerEvent event, emit) {
    plannerData = event.plannerData;
    workCenterList = plannerData.workCenterList!;
    workCenterData = WorkCenterModel();
    _eventComplete(emit);
  }

  _selectWorkCenter(
      AddAcknowledgeMarketComplaintSelectedWorkCenterEvent event, emit) {
    workCenterData = event.workCenterData;
    _eventComplete(emit);
  }

  _selectComplaint(
      AddAcknowledgeMarketComplaintSelectComplaintEvent event, emit) {
    complaintData = event.complaintData;
    _eventComplete(emit);
  }

  _selectAcknowledget(
      AddAcknowledgeMarketComplaintSelectAcknowledgeComplaintEvent event,
      emit) {
    acknowledgeData = event.acknowledgeData;
    _eventComplete(emit);
  }

  _selectGeneral(
      AddAcknowledgeMarketComplaintSelectGeneralDataEvent event, emit) {
    generalComplaintData = event.generalComplaintData;
    _eventComplete(emit);
  }

  _selectComplaintDescription(
      AddAcknowledgeMarketComplaintSelectDescriptionDataEvent event, emit) {
    complaintDescriptionData = event.complaintDescriptionData;
    _eventComplete(emit);
  }

  _selectDate(AddAcknowledgeMarketComplaintSelectDateData event, emit) async {
    try {
      DateTime initialDate = dateController.text.toString().isNotEmpty
          ? DateFormat('dd-MM-yyyy').parse(dateController.text.toString())
          : DateTime.now();

      final DateTime? picked = await showDatePicker(
          context: event.context,
          initialDate: initialDate,
          firstDate: DateTime.now().subtract(const Duration(days: 1)),
          lastDate: DateTime.now());
      if (picked != null) {
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        dateController.text = formattedDate;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectTime(AddAcknowledgeMarketComplaintSelectTimeData event, emit) async {
    try {
      DateTime initialDate = timeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm:ss').parse(timeController.text.toString())
          : DateTime.now();

      final DateTime? time = await showCupertinoDatePicker(
        context: event.context,
        initialDateTime: initialDate,
      );
      if (time != null) {
        timeController.text = DateFormat('HH:mm:ss').format(time).toString();
        _eventComplete(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectFile(AddAcknowledgeMarketComplaintAddImageEvent event, emit) async {
    if (event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if (photo != null) {
        file = photo;
      }
    } else {
      var photo = await DashboardHelper.filePiker(context: event.context);
      if (photo != null) {
        file = photo;
      }
    }
    _eventComplete(emit);
  }

  _selectBreakdown(
      AddAcknowledgeMarketComplaintSelectBreakDownEvent event, emit) {
    breakDownvalue = event.breakeDown;
    _eventComplete(emit);
  }

  _selectReviewComplaint(
      AddAcknowledgeMarketComplaintSelectReviewComplaintEvent event,
      emit) async {
    reviewComplaintData = event.reviewComplaintData;
    complaintData = ComplaintModel();
    isComplaintLoader = true;
    complaintList = [];
    _eventComplete(emit);
    var resCompl = await AddAcknowledgeMarketComplaintHelper.fetchComplaintData(
        reviewComplaintID: reviewComplaintData.id.toString());
    if (resCompl != null) {
      complaintList.add(resCompl);
      complaintData = resCompl;
    }
    isComplaintLoader = false;
    _eventComplete(emit);
  }

  _submit(AddAcknowledgeMarketComplaintSubmitEvent event, emit) async {
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    // if (remarkController.text.toString().isEmpty) {
    if (complaintDescriptionData.id.toString().isEmpty) {
      SnackBarErrorWidget(event.context).show(
          message:
              "Please ${complaintStatus.toString() == "1" ? AppString.enterSapComplaintDescription : AppString.enterRemarkForComplaintRejection}");
      return;
    }

    if (equipmentComplaintType == EquipmentComplaintType.it &&
        complaintDescriptionData.description == null) {
      SnackBarErrorWidget(event.context)
          .show(message: "Please select description");
      return;
    }

    isLoader = true;
    _eventComplete(emit);

    DateTime initialDate1 = DateTime.now();
    String time = "";
    if (timeController.text.toString().isNotEmpty &&
        timeController.text.toString().toLowerCase().contains("am")) {
      initialDate1 = timeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(timeController.text.toString())
          : DateTime.now();
      time = timeController.text.toString().isNotEmpty
          ? "${initialDate1.hour}:${initialDate1.minute}:00"
          : "";
    } else if (timeController.text.toString().isNotEmpty &&
        timeController.text.toString().toLowerCase().contains("pm")) {
      initialDate1 = timeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(timeController.text.toString())
          : DateTime.now();
      time = timeController.text.toString().isNotEmpty
          ? "${initialDate1.hour}:${initialDate1.minute}:00"
          : "";
    } else {
      initialDate1 = timeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm').parse(timeController.text.toString())
          : DateTime.now();
      time = timeController.text.toString().isNotEmpty
          ? "${initialDate1.hour}:${initialDate1.minute}:00"
          : "";
    }

    var res = selectedTabIndex == 0
        ? await AddAcknowledgeMarketComplaintHelper.submitAckAssignData(
            context: event.context,
            acknowledgeData: acknowledgeData,
            vendorId: vendorMarketData,
            ackRemarks: descriptionController.text.toString(),
            breakDownvalue: breakDownvalue,
            complaintStatus: complaintStatus,
            date: dateController.text.toString(),
            time: time,
          )
        : await AddAcknowledgeMarketComplaintHelper.submitAmoFinalCloseData(
            context: event.context,
            acknowledgeData: acknowledgeData,
            remarks: descriptionController.text.toString(),
          );
    if (res != null) {
      await _loadAllTabsData();
      complaintTypeData = ComplaintTypeModel();
      equipmentTypeData = EquipmentTypeModel();
      departmentData = DepartmentModel();
      complaintData = ComplaintModel();
      reviewComplaintData = ReviewComplaintModel();
      acknowledgeUserData = AcknowledgeUserModel();
      complaintList = [];
      complaintData = ComplaintModel();
      descriptionController.text = "";
      remarkController.text = "";
      dateController.text = "";
      timeController.text = "";
      isLoader = false;
      file = File("");
      breakDownvalue = "2";
      isComplaintLoader = false;
      generalDescriptionController.text = "";
      generalComplaintData = GeneralComplaintModel();
      complaintStatus = "";
      if (!event.context.mounted) return;
      Navigator.pop(event.context, "Completed");
    }
    isLoader = false;
    _eventComplete(emit);
  }


  _eventComplete(Emitter<AddAcknowledgeMarketComplaintState> emit) {
    emit(FetchAddAcknowledgeMarketComplaintState(
      file: file,
      isLoader: isLoader,
      descriptionController: descriptionController,
      complaintTypeData: complaintTypeData,
      complaintTypeList: complaintTypeList,
      equipmentTypeData: equipmentTypeData,
      equipmentTypeList: equipmentTypeList,
      remarkController: remarkController,
      acknowledgeData: acknowledgeData,
      acknowledgeList: acknowledgeList,
      departmentData: departmentData,
      departmentList: departmentList,
      complaintData: complaintData,
      complaintList: complaintList,
      breakDownvalue: breakDownvalue,
      reviewComplaintData: reviewComplaintData,
      isComplaintLoader: isComplaintLoader,
      acknowledgeUserData: acknowledgeUserData,
      acknowledgeUserList: acknowledgeUserList,
      dateController: dateController,
      timeController: timeController,
      generalComplaintData: generalComplaintData,
      generalComplaintList: generalComplaintList,
      generalDescriptionController: generalDescriptionController,
      complaintStatus: complaintStatus,
      workCenterData: workCenterData,
      plannerData: plannerData,
      workCenterList: workCenterList,
      plannerList: plannerList,
      personResponsibleController: personResponsibleController,
      complaintDescriptionData: complaintDescriptionData,
      complaintDescriptionList: complaintDescriptionList,
      listOfVendorMarketData: listOfVendorMarketData,
      vendorMarketData: vendorMarketData,
    ));
  }
}
