import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/vendor_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/helper/acknowledge_helper.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/action_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_part_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/uom_type_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/helper/mi_complaint_helper.dart';

part 'mi_complaint_event.dart';
part 'mi_complaint_state.dart';

class MiComplaintBloc extends Bloc<MiComplaintEvent, MiComplaintState> {
  List<ReviewComplaintModel> reviewComplaintList = [];
  ReviewComplaintModel reviewComplaintData = ReviewComplaintModel();
  List<SparesModel> sparesList = [];
  SparesModel sparesData = SparesModel();
  String approvalValue = "";
  String action = "";
  TextEditingController observation = TextEditingController();
  TextEditingController description = TextEditingController();
  File file = File("");
  bool isLoader = false;
  List<ActionModel> actionList = [];
  ActionModel actionData = ActionModel();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  List<UomTypeModel> uomTypeList = [];
  UomTypeModel uomTypeData = UomTypeModel();

  List<SparesPartModel> sparesPartList = [];

  List<VendorModel> vendorList = [];
  VendorModel vendorData =  VendorModel();

  MiComplaintBloc() : super(MiComplaintInitial()) {
    on<MiComplaintPageLoadEvent>(_pageLoad);
    on<MiComplaintSelectComplaintData>(_selectComplaint);
    on<MiComplaintSelectSpareData>(_selectSpares);
    on<MiComplaintSelectApprovalData>(_selectApproval);
    on<MiComplaintSelectActionData>(_selectAction);
    on<MiComplaintSelectVendorData>(_selectVendor);
    on<MiComplaintAddImageEvent>(_selectFile);
    on<MiComplaintSelectDateData>(_selectDate);
    on<MiComplaintSelectTimeData>(_selectTime);
    on<MiComplaintAddSparesPartData>(_addSparesPart);
    on<MiComplaintDeleteSparesPartData>(_deleteSparesPart);
    on<MiComplaintSelectUomData>(_selectUomType);
    on<MiComplaintSubmitData>(_submit);
  }

  _pageLoad(MiComplaintPageLoadEvent event, emit) async {
    emit(MiComplaintPageLoadState());
    reviewComplaintList = [];
    reviewComplaintData = ReviewComplaintModel();
    sparesList = [];
    actionData = ActionModel();
    sparesData = SparesModel();
    approvalValue = "";
    action = "";
    observation.text = "";
    description.text = "";
    timeController.text = "";
    dateController.text = "";
    qtyController.text = "";
    uomTypeList = [];
    sparesPartList = [];
    vendorList = [];
    vendorData =  VendorModel();
    uomTypeData = UomTypeModel();
    file = File("");
    isLoader = false;

    reviewComplaintList =
        BlocProvider.of<ViewEquipmentComplaintBloc>(event.context)
            .reviewComplaintList;
    for (var complaint in reviewComplaintList) {
      if (complaint.id.toString() == event.reviewComplaintData.id.toString()) {
        reviewComplaintData = complaint;
      }
    }

    var res = await MiComplaintHelper.fetchSpareData();
    if (res != null) {
      sparesList = res;
    }

    if(vendorList.isEmpty){
      var resVendor = await AcknowledgeHelper.fetchVendorData();
      if (resVendor != null) {
        vendorList = resVendor;
        for(var vendor in vendorList){
          if(event.reviewComplaintData.assignType.toString() == "3" &&
            vendor.id.toString() == event.reviewComplaintData.assignTo.toString()){
             vendorData =  vendor;
          }
        }
      }
    }

    sparesPartList.add(SparesPartModel(
      sparesData: SparesModel(),
      uomTypeData: UomTypeModel(),
      qtyController: TextEditingController(),
    ));

    actionList = ActionModel().fetchData();
    for (var actionValue in actionList) {
      if (actionValue.id.toString() ==
          event.reviewComplaintData.action.toString()) {
        actionData = actionValue;
      }

      if (actionValue.id.toString() == "1") {
        if (reviewComplaintData.maintenanceStartDate != null &&
            reviewComplaintData.maintenanceStartDate.toString().isNotEmpty) {
          String startDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(
              reviewComplaintData.maintenanceStartDate.toString()));
          dateController.text = startDate;

          DateTime initialDate =  reviewComplaintData.maintenanceStartDate.toString().isNotEmpty ?
          DateFormat('yyyy-dd-MM h:mm:ss').parse(reviewComplaintData.maintenanceStartDate.toString())
              : DateTime.now();
          TimeOfDay initialTime =  TimeOfDay.fromDateTime(initialDate);
          var timeFormat = TimeOfDay(hour: initialTime.hour, minute: initialTime.minute).format(
              !event.context.mounted ? event.context : event.context);
          timeController.text = timeFormat;
        }
      }

      if (actionValue.id.toString() == "2") {
        if (reviewComplaintData.maintenanceHoldDate != null &&
            reviewComplaintData.maintenanceHoldDate.toString().isNotEmpty) {
          String holdDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(
              reviewComplaintData.maintenanceHoldDate.toString()));
          dateController.text = holdDate;


          DateTime initialDate =  reviewComplaintData.maintenanceHoldDate.toString().isNotEmpty ?
          DateFormat('yyyy-dd-MM h:mm:ss').parse(reviewComplaintData.maintenanceHoldDate.toString())
              : DateTime.now();
          TimeOfDay initialTime =  TimeOfDay.fromDateTime(initialDate);
          var timeFormat = TimeOfDay(hour: initialTime.hour, minute: initialTime.minute).format(
              !event.context.mounted ? event.context : event.context);
          timeController.text = timeFormat;
        }
      }

      if (actionValue.id.toString() == "3") {
        if (reviewComplaintData.maintenanceEndDate != null &&
            reviewComplaintData.maintenanceEndDate.toString().isNotEmpty) {
          String closedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(
              reviewComplaintData.maintenanceEndDate.toString()));
          dateController.text = closedDate;

          DateTime initialDate =  reviewComplaintData.maintenanceEndDate.toString().isNotEmpty ?
          DateFormat('yyyy-dd-MM h:mm:ss').parse(reviewComplaintData.maintenanceEndDate.toString())
              : DateTime.now();
          TimeOfDay initialTime =  TimeOfDay.fromDateTime(initialDate);
          var timeFormat = TimeOfDay(hour: initialTime.hour, minute: initialTime.minute).format(
              !event.context.mounted ? event.context : event.context);
          timeController.text = timeFormat;

        }
      }

      if (actionValue.id.toString() == "4") {
        actionData =  actionValue;
      }
    }

    description.text = reviewComplaintData.complaintDescription.toString();
    _eventComplete(emit);
  }

  _selectComplaint(MiComplaintSelectComplaintData event, emit) {
    reviewComplaintData = event.reviewComplaintData;
    _eventComplete(emit);
  }

  _selectSpares(MiComplaintSelectSpareData event, emit) {
    isLoader = true;
    _eventComplete(emit);
    sparesData = event.sparesData;
    sparesPartList[event.index].sparesData = sparesData;
    isLoader = false;
    _eventComplete(emit);
  }

  _selectApproval(MiComplaintSelectApprovalData event, emit) {
    approvalValue = event.approvalValue;
    _eventComplete(emit);
  }

  _selectAction(MiComplaintSelectActionData event, emit) {
    actionData = event.actionData;
    sparesData = SparesModel();

    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dateController.text = formattedDate;
    TimeOfDay time = TimeOfDay.now();
    var timeFormat = TimeOfDay(hour: time.hour, minute: time.minute).format(event.context);
    if(actionData.id.toString() == "4"){
      timeController.text = "";
    } else {
      timeController.text = timeFormat;
    }
    _eventComplete(emit);
  }

  _selectVendor(MiComplaintSelectVendorData event, emit) {
    vendorData =  event.vendorData;
    _eventComplete(emit);
  }

  _selectFile(MiComplaintAddImageEvent event, emit) async {
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
    Navigator.pop(
        event.context.mounted ? event.context : event.context, "complete");
    _eventComplete(emit);
  }

  _selectDate(MiComplaintSelectDateData event, emit) async {
    try {

      DateTime initialDate =  dateController.text.toString().isNotEmpty ?
      DateFormat('dd-MM-yyyy').parse(dateController.text.toString())
          : DateTime.now();

      final DateTime? picked = await showDatePicker(
          context: event.context,
          initialDate: initialDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
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

  _selectTime(MiComplaintSelectTimeData event, emit) async {
    try {
      DateTime initialDate =  timeController.text.toString().isNotEmpty ?
      DateFormat('h:mm').parse(timeController.text.toString())
          : DateTime.now();

      TimeOfDay initialTime =  TimeOfDay.fromDateTime(initialDate);
      final TimeOfDay? time = await showTimePicker(
        context: event.context,
        initialTime: initialTime,
      );
      if (time != null) {
        var timeFormat = TimeOfDay(hour: time.hour, minute: time.minute).format(
            event.context);
        timeController.text = timeFormat;
        _eventComplete(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _addSparesPart(MiComplaintAddSparesPartData event, emit) {
    isLoader = true;
    _eventComplete(emit);
    sparesPartList.add(SparesPartModel(
      sparesData: SparesModel(),
      uomTypeData: UomTypeModel(),
      qtyController: TextEditingController(),
    ));
    isLoader = false;
    _eventComplete(emit);
  }

  _deleteSparesPart(MiComplaintDeleteSparesPartData event, emit) {
    isLoader = true;
    _eventComplete(emit);
    sparesPartList.removeAt(event.index);
    isLoader = false;
    _eventComplete(emit);
  }

  _selectUomType(MiComplaintSelectUomData event, emit) {
    isLoader = true;
    _eventComplete(emit);
    uomTypeData = event.uomTypeData;
    sparesPartList[event.index].uomTypeData = uomTypeData;
    isLoader = false;
    _eventComplete(emit);
  }

  _submit(MiComplaintSubmitData event, emit) async {
    if (reviewComplaintData.startDateTime.toString().isEmpty &&
        reviewComplaintData.action == "") {
      SnackBarErrorWidget(event.context).show(message: "Please select start");
      return;
    }
    isLoader = true;
    _eventComplete(emit);
    DateTime initialDate1 =  timeController.text.toString().isNotEmpty ?
    DateFormat('h:mm a').parse(timeController.text.toString())
        : DateTime.now();
    String time = "${initialDate1.hour}:${initialDate1.minute}:00";
    print("Time Print ${time}");
    var res = await MiComplaintHelper.submit(
        context: event.context,
        reviewComplaintData: reviewComplaintData,
        approvalValue: approvalValue,
        sparesData: sparesData,
        action: actionData,
        description: description.text.toString(),
        date: dateController.text.toString(),
        time: time,
        observation: observation.text.toString(),
        uomTypeData: uomTypeData,
        qty: qtyController.text.toString(),
        sparesPartList: sparesPartList,
        vendorData: vendorData,
        file: file);
    if (res != null) {
      reviewComplaintData = ReviewComplaintModel();
      sparesData = SparesModel();
      approvalValue = "";
      action = "";
      observation.text = "";
      description.text = "";
      dateController.text = "";
      timeController.text = "";
      qtyController.text = "";
      file = File("");
      isLoader = false;
      actionData = ActionModel();
      uomTypeData = UomTypeModel();
      if (!event.context.mounted) return;
      Navigator.pop(event.context, "Completed");
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<MiComplaintState> emit) {
    emit(FetchMiComplaintDataState(
      approvalValue: approvalValue,
      reviewComplaintData: reviewComplaintData,
      reviewComplaintList: reviewComplaintList,
      observationController: observation,
      file: file,
      descriptionController: description,
      action: action,
      sparesData: sparesData,
      sparesList: sparesList,
      isLoader: isLoader,
      actionData: actionData,
      actionList: actionList,
      dateController: dateController,
      timeController: timeController,
      uomTypeData: uomTypeData,
      uomTypeList: uomTypeList,
      qtyController: qtyController,
      sparesPartList: sparesPartList,
      vendorList: vendorList,
      vendorData: vendorData,
    ));
  }
}
