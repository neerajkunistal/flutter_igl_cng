import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/cngFillingForm/helper/cng_filling_stattion_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/model/cng_stattion_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'cng_filling_form_event.dart';
part 'cng_filling_form_state.dart';

class CngFillingFormBloc
    extends Bloc<CngFillingFormEvent, CngFillingFormState> {
  TextEditingController driverController = TextEditingController();
  TextEditingController receivedScmQuantityController = TextEditingController();
  TextEditingController unitGasMeterController = TextEditingController();
  TextEditingController scmQuantityController = TextEditingController();
  TextEditingController drivingLicenceController = TextEditingController();
  TextEditingController truckNumberController = TextEditingController();
  TextEditingController driverLicenceIdController = TextEditingController();
  TextEditingController lcvTruckNumberController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController outPressureController = TextEditingController();

  List<CngStationModel> _cngStationList = [];

  List<CngStationModel> get cngStationList => _cngStationList;

  CngStationModel _cngStationData = CngStationModel();

  CngStationModel get cngStationData => _cngStationData;

  bool _isLoader = false;

  bool get isLoader => _isLoader;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  AssignmentModel _assignmentData = AssignmentModel();
  AssignmentModel get assignmentData => _assignmentData;

  TextEditingController arrivalTimeController = TextEditingController();
  TextEditingController lcvPointTimeController  = TextEditingController();
  TextEditingController flowMeterReadingOpenController = TextEditingController();
  TextEditingController flowMeterReadingClosedController = TextEditingController();
  TextEditingController inPressureController = TextEditingController();
  TextEditingController fillEndTimeController = TextEditingController();
  bool isLcvCondition =  false;
  bool isDriverNotWearingUniform =  false;
  List<File> fileList = [];

  CngFillingFormBloc() : super(CngFillingFormInitial()) {
    on<CngFillingFormPageLoadEvent>(_pageLoad);
    on<CngFillingArrivalTimeEvent>(_selectArrivalTime);
    on<CngFillingLcvPointTimeEvent>(_selectLcvPointTime);
    on<CngFillingFillEndTimeEvent>(_selectFillEndTime);
    on<CngFillingSelectPhotoEvent>(_selectPhoto);
    on<CngFillingDeletePhotoEvent>(_deletePhoto);
    on<CngFillingCheckListEvent>(_selectCheckList);
    on<CngFillingFormSetAssignmentDataEvent>(_setAssignment);
    on<CngFillingFormSetDriverNoDataEvent>(_setDrivingLicence);
    on<CngFillingFormSetTruckNoDataEvent>(_setTruckNumber);
    on<CngFillingFormSubmitEvent>(_submit);
  }

  _pageLoad(CngFillingFormPageLoadEvent event, emit) async {
    emit(CngFillingPageLoadState());
    _userData = UserInfo.instance!.userData!;
    _isLoader = false;
    _cngStationData = CngStationModel();
    _cngStationList = [];
    driverController.text = assignmentData.driverName.toString();
    unitGasMeterController.text = "";
    receivedScmQuantityController.text = "";
    driverLicenceIdController.text = assignmentData.driverId.toString();
    lcvTruckNumberController.text = assignmentData.lcvNumber.toString();
    remarkController.text = "";
    driverLicenceIdController.text = "";
    arrivalTimeController.text = "";
    lcvPointTimeController.text = "";
    flowMeterReadingOpenController.text = "";
    flowMeterReadingClosedController.text = "";
    inPressureController.text = "";
    fillEndTimeController.text = "";
    outPressureController.text = "";
    isLcvCondition = true;
    isDriverNotWearingUniform =  true;
    fileList = [];
    if(assignmentData.dbCngStationList!.isNotEmpty){
       for(var dbStationData in assignmentData.dbCngStationList!){
         arrivalTimeController.text =  dbStationData.arrivalTime.toString();
         lcvPointTimeController.text =  dbStationData.lcvPointTime.toString();
         flowMeterReadingOpenController.text =  dbStationData.flowMeterReadingOpening.toString();
         inPressureController.text =  dbStationData.inPressure.toString();
         flowMeterReadingClosedController.text =  dbStationData.flowMeterReadingClosing.toString();
         outPressureController.text = dbStationData.outPressure.toString();
         fillEndTimeController.text =  dbStationData.fillEndTime.toString();
         isLcvCondition = dbStationData.lcvCondition.toString() == "1" ? true : false;
         isDriverNotWearingUniform = dbStationData.driverNotWearingUniform.toString() == "1" ? true : false;
       }
    }
    _eventCompleted(emit);
  }

  _selectArrivalTime(CngFillingArrivalTimeEvent event, emit) async {
    try {
      DateTime initialDate = arrivalTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm').parse(arrivalTimeController.text.toString())
          : DateTime.now();
      TimeOfDay initialTime = TimeOfDay.fromDateTime(initialDate);
      final TimeOfDay? time = await showTimePicker(
        context: event.context,
        initialTime: initialTime,
      );
      if (time != null) {
        var timeFormat = TimeOfDay(hour: time.hour, minute: time.minute)
            .format(!event.context.mounted ? event.context : event.context);
        arrivalTimeController.text = timeFormat;
        _eventCompleted(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectLcvPointTime(CngFillingLcvPointTimeEvent event, emit) async {
    try {
      DateTime initialDate = lcvPointTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm').parse(lcvPointTimeController.text.toString())
          : DateTime.now();
      TimeOfDay initialTime = TimeOfDay.fromDateTime(initialDate);
      final TimeOfDay? time = await showTimePicker(
        context: event.context,
        initialTime: initialTime,
      );
      if (time != null) {
        var timeFormat = TimeOfDay(hour: time.hour, minute: time.minute)
            .format(!event.context.mounted ? event.context : event.context);
        lcvPointTimeController.text = timeFormat;
        _eventCompleted(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectFillEndTime(CngFillingFillEndTimeEvent event, emit) async {
    try {
      DateTime initialDate = fillEndTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm').parse(fillEndTimeController.text.toString())
          : DateTime.now();
      TimeOfDay initialTime = TimeOfDay.fromDateTime(initialDate);
      final TimeOfDay? time = await showTimePicker(
        context: event.context,
        initialTime: initialTime,
      );
      if (time != null) {
        var timeFormat = TimeOfDay(hour: time.hour, minute: time.minute)
            .format(!event.context.mounted ? event.context : event.context);
        fillEndTimeController.text = timeFormat;
        _eventCompleted(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectPhoto(CngFillingSelectPhotoEvent event, emit) async {
    if (event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if (photo != null) {
        _isLoader = true;
        _eventCompleted(emit);
        fileList.add(photo);
      }
    } else {
      var photo = await DashboardHelper.filePiker(context: event.context);
      if (photo != null) {
        _isLoader = true;
        _eventCompleted(emit);
        fileList.add(photo);
      }
    }
    _isLoader = false;
    _eventCompleted(emit);

  }

  _deletePhoto(CngFillingDeletePhotoEvent event, emit)  {
    _isLoader =  true;
    fileList.removeAt(event.index);
    _eventCompleted(emit);
    _isLoader =  false;
    _eventCompleted(emit);
  }

  _selectCheckList(CngFillingCheckListEvent event, emit) {
    bool isSelected =  event.isSelected;
    int checkList = event.checklist;
    switch(checkList) {
      case 1:
        isLcvCondition =  isSelected;
        remarkController.text = "";
        _eventCompleted(emit);
        break;
      case 2:
        isDriverNotWearingUniform =  isSelected;
        _eventCompleted(emit);
        break;
      case 3:
        break;
    }
  }

  _setAssignment(CngFillingFormSetAssignmentDataEvent event, emit) {
    _assignmentData = event.assignmentData;
  }

  _setDrivingLicence(CngFillingFormSetDriverNoDataEvent event, emit) {
    drivingLicenceController.text = event.drivingLicence;
    _eventCompleted(emit);
  }

  _setTruckNumber(CngFillingFormSetTruckNoDataEvent event, emit) {
    truckNumberController.text = event.truckNumber;
    _eventCompleted(emit);
  }

  _submit(CngFillingFormSubmitEvent event, emit) async {
    _isLoader = true;
    _eventCompleted(emit);


    DateTime arrivalInitialDate = DateTime.now();
    String arrivalTime = "";
    if(arrivalTimeController.text.toString().isNotEmpty
        && arrivalTimeController.text.toString().toLowerCase().contains("am")){
      arrivalInitialDate = arrivalTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(arrivalTimeController.text.toString())
          : DateTime.now();
      arrivalTime = arrivalTimeController.text.toString().isNotEmpty ? "${arrivalInitialDate.hour}:${arrivalInitialDate.minute}:00" : "";
    } else if (arrivalTimeController.text.toString().isNotEmpty
        && arrivalTimeController.text.toString().toLowerCase().contains("pm")){
      arrivalInitialDate = arrivalTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(arrivalTimeController.text.toString())
          : DateTime.now();
      arrivalTime = arrivalTimeController.text.toString().isNotEmpty ? "${arrivalInitialDate.hour}:${arrivalInitialDate.minute}:00" : "";
    } else {
      arrivalInitialDate = arrivalTimeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm').parse(arrivalTimeController.text.toString())
          : DateTime.now();
      arrivalTime = arrivalTimeController.text.toString().isNotEmpty ? "${arrivalInitialDate.hour}:${arrivalInitialDate.minute}:00" : "";
    }

    DateTime lcvPointInitialDate = DateTime.now();
    String lcvPointTime = "";
    if(lcvPointTimeController.text.toString().isNotEmpty
        && lcvPointTimeController.text.toString().toLowerCase().contains("am")){
      lcvPointInitialDate = lcvPointTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(lcvPointTimeController.text.toString())
          : DateTime.now();
      lcvPointTime = lcvPointTimeController.text.toString().isNotEmpty ? "${lcvPointInitialDate.hour}:${lcvPointInitialDate.minute}:00" : "";
    } else if (lcvPointTimeController.text.toString().isNotEmpty
        && lcvPointTimeController.text.toString().toLowerCase().contains("pm")){
      lcvPointInitialDate = lcvPointTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(lcvPointTimeController.text.toString())
          : DateTime.now();
      lcvPointTime = lcvPointTimeController.text.toString().isNotEmpty ? "${lcvPointInitialDate.hour}:${lcvPointInitialDate.minute}:00" : "";
    } else {
      lcvPointInitialDate = lcvPointTimeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm').parse(lcvPointTimeController.text.toString())
          : DateTime.now();
      lcvPointTime = lcvPointTimeController.text.toString().isNotEmpty ? "${lcvPointInitialDate.hour}:${lcvPointInitialDate.minute}:00" : "";
    }

    DateTime filEndTimeInitialDate = DateTime.now();
    String filEndTime = "";
    if(fillEndTimeController.text.toString().isNotEmpty
        && fillEndTimeController.text.toString().toLowerCase().contains("am")){
      filEndTimeInitialDate = fillEndTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(fillEndTimeController.text.toString())
          : DateTime.now();
      filEndTime = fillEndTimeController.text.toString().isNotEmpty ? "${filEndTimeInitialDate.hour}:${filEndTimeInitialDate.minute}:00" : "";
    } else if (fillEndTimeController.text.toString().isNotEmpty
        && fillEndTimeController.text.toString().toLowerCase().contains("pm")){
      filEndTimeInitialDate = fillEndTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(fillEndTimeController.text.toString())
          : DateTime.now();
      filEndTime = fillEndTimeController.text.toString().isNotEmpty ? "${filEndTimeInitialDate.hour}:${filEndTimeInitialDate.minute}:00" : "";
    } else {
      filEndTimeInitialDate = fillEndTimeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm').parse(fillEndTimeController.text.toString())
          : DateTime.now();
      filEndTime = fillEndTimeController.text.toString().isNotEmpty ? "${filEndTimeInitialDate.hour}:${filEndTimeInitialDate.minute}:00" : "";
    }

    String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

    var res = await CngFillingStationHelper.updateCngFillingStationList(
        userDat: userData,
        assignmentData: assignmentData,
        context: event.context,
        scmQuantity: scmQuantityController.text.toString(),
        receivedScmQuantity: receivedScmQuantityController.text.toString(),
        drivingLicence: drivingLicenceController.text.toString(),
        truckNumber: truckNumberController.text.toString(),
        remark: remarkController.text.toString(),
        isMismatch: event.isMismatch,
       fileList: fileList,
      flowMeterReadingClosed: flowMeterReadingClosedController.text.toString(),
      flowMeterReadingOpen: flowMeterReadingOpenController.text.toString(),
      lcvCondition: isLcvCondition == true ? "1" : "0",
      outPressure: outPressureController.text.toString(),
      arrivalTime: arrivalTime,
      driverUniform: isDriverNotWearingUniform == true ? "1" : "0",
      filEndTime: filEndTime,
      inPressure: inPressureController.text.toString(),
      lcvPointTime: lcvPointTime,
    );
    _isLoader = false;
    _eventCompleted(emit);
    if (res != null) {
      Navigator.of(!event.context.mounted ? event.context : event.context)
          .pop("Complete");
    }
  }

  _eventCompleted(Emitter<CngFillingFormState> emit) {
    emit(FetchCngFillingDataState(
      isLoader: isLoader,
      driverController: driverController,
      cngStationData: cngStationData,
      cngStationList: cngStationList,
      receivedScmQuantityController: receivedScmQuantityController,
      scmQuantityController: scmQuantityController,
      unitGasMeterController: unitGasMeterController,
      truckNumberController: truckNumberController,
      drivingLicenceController: drivingLicenceController,
      remarkController: remarkController,
      lcvTruckNumberController: lcvTruckNumberController,
      driverLicenceIdController: driverLicenceIdController,
      fileList: fileList,
      isLcvCondition: isLcvCondition,
      flowMeterReadingOpenController: flowMeterReadingOpenController,
      flowMeterReadingClosedController: flowMeterReadingClosedController,
      fillEndTimeController: fillEndTimeController,
      arrivalTimeController: arrivalTimeController,
      inPressureController: inPressureController,
      isDriverNotWearingUniform: isDriverNotWearingUniform,
      lcvPointTimeController: lcvPointTimeController,
      outPressureController: outPressureController,
    ));
  }
}
