import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/model/station_model.dart';

part 'add_assignment_event.dart';
part 'add_assignment_state.dart';

class AddAssignmentBloc extends Bloc<AddAssignmentEvent, AddAssignmentState> {
  bool _isLoader = false;

  bool get isLoader => _isLoader;

  List<DriverModel> _driverList = [];

  List<DriverModel> get driverList => _driverList;

  DriverModel _driverData = DriverModel();

  DriverModel get driverData => _driverData;

  List<LcvTruckModel> _lcvList = [];

  List<LcvTruckModel> get lcvList => _lcvList;

  LcvTruckModel _lcvData = LcvTruckModel();

  LcvTruckModel get lcvData => _lcvData;

  List<CngStationModel> _cngStationList = [];

  List<CngStationModel> get cngStationList => _cngStationList;

  CngStationModel _cngStationData = CngStationModel();

  CngStationModel get cngStationData => _cngStationData;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  List<StationModel> _stationList = [];

  List<StationModel> get stationList => _stationList;

  bool _isAddCngStation = false;

  bool get isAddCngStation => _isAddCngStation;

  List<MotherStationModel> _motherStationList = [];

  List<MotherStationModel> get motherStationList => _motherStationList;

  MotherStationModel _motherStationData = MotherStationModel();

  MotherStationModel get motherStationData => _motherStationData;

  TextEditingController cngQuantityController = TextEditingController();
  TextEditingController totalCngQuantityController = TextEditingController();
  TextEditingController scheduleDateTimeController = TextEditingController();

  List<CngStationRouteModel> _cngStationRouteList = [];

  List<CngStationRouteModel> get cngStationRouteList => _cngStationRouteList;

  CngStationRouteModel _cngStationRouteData = CngStationRouteModel();

  CngStationRouteModel get cngStationRouteData => _cngStationRouteData;

  bool _isRouteLoader = false;

  bool get isRouteLoader => _isRouteLoader;

   TextEditingController lcvEntryTimeController =  TextEditingController();
   TextEditingController fillStartTimeController  =  TextEditingController();
   TextEditingController flowMeterReadingOpenController =  TextEditingController();
   TextEditingController flowMeterReadingClosedController =  TextEditingController();
   TextEditingController fillEndTimeController =  TextEditingController();
   TextEditingController outPressureController =  TextEditingController();
   TextEditingController remarkController =  TextEditingController();
   TextEditingController unscheduledMaintenancePenaltyHoursController =  TextEditingController();
   TextEditingController scheduledMaintenancePenaltyHoursController =  TextEditingController();
   List<File> fileList = [];
   bool isLcvCondition =  false;
   bool isDriverFitDrive =  false;
   bool isLcvLogBookCorrection =  false;
   bool isAvailabilityMobileWithDriver =  false;
   bool isUnscheduledMaintenancePenaltyHours = false;
   bool isScheduledMaintenancePenaltyHours =  false;

   AssignmentModel _assignmentData =  AssignmentModel();
   AssignmentModel get assignmentData => _assignmentData;

  AddAssignmentBloc() : super(AddAssignmentInitial()) {
    on<AddAssignmentPageLoadEvent>(_pageLoad);
    on<AddAssignmentSetAssignmentDataEvent>(_setAssignment);
    on<AddAssignmentSetMotherStationDataEvent>(_setMotherStation);
    on<AddAssignmentSetDriverDataEvent>(_setDriverData);
    on<AddAssignmentSetCngStationDataEvent>(_setCngStationData);
    on<AddAssignmentSetLcvTrackDataEvent>(_setLcvTrack);
    on<AddAssignmentAddMoreCngStationDataEvent>(_addMoreCNGButton);
    on<AddAssignmentAddStationEvent>(_addCNGStation);
    on<AddAssignmentRemoveStationEvent>(_removeStation);
    on<AddAssignmentStationSequenceChangeEvent>(_changeSequence);
    on<AddAssignmentSelectImageEvent>(_selectImage);
    on<AddAssignmentDeleteImageEvent>(_deleteImage);
    on<AddAssignmentSubmitEvent>(_submit);
    on<AddAssignmentSetDriverNoDataEvent>(_setDrivingLicence);
    on<AddAssignmentSetTruckNoDataEvent>(_setTruckNumber);
    on<AddAssignmentSelectDateTimeEvent>(_setScheduleDateTime);
    on<AddAssignmentSelectLcvEntryTimeEvent>(_selectLcvEntryTime);
    on<AddAssignmentSelectFillStartTimeEvent>(_selectFillStartTime);
    on<AddAssignmentSelectFillEndTimeEvent>(_selectFillEndTime);
    on<AddAssignmentSetCheckListEventEvent>(_setCheckList);
    on<AddAssignmentSetStationRouteDataEvent>(_setCngStationRoute);
  }

  _setAssignment(AddAssignmentSetAssignmentDataEvent event, emit) {
     _assignmentData =  event.assignmentData;
  }

  _pageLoad(AddAssignmentPageLoadEvent event, emit) async {
    emit(AddAssignmentPageLoadState());
    _isLoader = false;
    _cngStationList = [];
    _lcvList = [];
    _driverList = [];
    _driverData = DriverModel();
    _cngStationData = CngStationModel();
    _lcvData = LcvTruckModel();
    _stationList = [];
    _isAddCngStation = false;
    cngQuantityController.text = "";
    totalCngQuantityController.text = "";
    scheduleDateTimeController.text = "";
    _userData = UserInfo.instance!.userData!;
    _motherStationData = MotherStationModel();
    _motherStationList = [];
    _cngStationRouteList = [];
    _cngStationRouteData = CngStationRouteModel();
    _isRouteLoader = false;
    lcvEntryTimeController.text = "";
    fillStartTimeController.text = "";
    flowMeterReadingOpenController.text = "";
    flowMeterReadingClosedController.text = "";
    fillEndTimeController.text = "";
    outPressureController.text = "";
    remarkController.text = "";
    unscheduledMaintenancePenaltyHoursController.text = "";
    scheduledMaintenancePenaltyHoursController.text = "";
    fileList = [];
    isLcvCondition =  true;
    isDriverFitDrive =  true;
    isLcvLogBookCorrection =  true;
    isAvailabilityMobileWithDriver = false;
    isUnscheduledMaintenancePenaltyHours = true;
    isScheduledMaintenancePenaltyHours =  true;
    var motherStationRes = await AddAssignmentHelper.fetchMotherStationData(
        context: event.context, userData: userData);
    if (motherStationRes != null) {
      _motherStationList = motherStationRes;
      if(motherStationList.isNotEmpty && motherStationList.length == 1){
        _motherStationData =  motherStationList[0];
      }
    }

    var driverRes = await DriverHelper.fetchDriverData(
        context: !event.context.mounted ? event.context : event.context, userData: userData);
    if (driverRes != null) {
      _driverList = driverRes;
      _driverList = driverList
          .where((element) => element.status.toString() != "1")
          .toList();
      _driverList = driverList
          .where((element) => element.status.toString() != "2")
          .toList();
    }

    var cngStationRes = await CNGStationHelper.fetchCNGStationData(
        context: !event.context.mounted ? event.context : event.context, userData: userData);
    if (cngStationRes != null) {
      _cngStationList = cngStationRes;
    }

    var lcvRes = await ViewLcvTrackHelper.fetchLCVData(
        context: !event.context.mounted ? event.context : event.context, userData: userData);
    if (lcvRes != null) {
      _lcvList = lcvRes;
      _lcvList = lcvList
          .where((element) => element.deletedAt.toString().isEmpty)
          .toList();
    }

    if(assignmentData.id != null){
      for(var data in motherStationList){
        if(assignmentData.mbStationId.toString() == data.id.toString()){
          _motherStationData = data;
        }
      }

      for(var data in lcvList){
        if(assignmentData.lcvId.toString() == data.id.toString()){
          _lcvData = data;
        }
      }

      for(var data in driverList){
        if(assignmentData.driverId.toString() == data.id.toString()){
          _driverData = data;
        }
      }

      for(var data in cngStationList){
        if(assignmentData.dbCngStationId.toString() == data.id.toString()){
          _cngStationData = data;
        }
      }

      lcvEntryTimeController.text =  assignmentData.lcvEntryTime.toString();
      fillStartTimeController.text =  assignmentData.fillStartTime.toString();
      flowMeterReadingOpenController.text = assignmentData.flowMeterReadingOpening.toString();
      flowMeterReadingClosedController.text = assignmentData.flowMeterReadingClosing.toString();
      fillEndTimeController.text =  assignmentData.fillEndTime.toString();
      unscheduledMaintenancePenaltyHoursController.text = assignmentData.unscheduledMaintenancePenaltyHours.toString();
      scheduledMaintenancePenaltyHoursController.text =  assignmentData.scheduledMaintenancePenaltyHours.toString();
      isLcvCondition =  assignmentData.lcvCondition.toString() == "1" ? true : false;
      isDriverFitDrive =  assignmentData.driverFitToDrive.toString() == "1" ? true : false;
      isLcvLogBookCorrection =  assignmentData.improperLogbookCorrections.toString() == "1" ? true : false;
      isAvailabilityMobileWithDriver =  assignmentData.mobileAvailability.toString() == "1" ? true : false;

    }

    _eventCompleted(emit);
  }

  _setMotherStation(AddAssignmentSetMotherStationDataEvent event, emit) {
    _motherStationData = event.motherStationData;
    _eventCompleted(emit);
  }

  _setDriverData(AddAssignmentSetDriverDataEvent event, emit) {
    _driverData = event.driverData;
    _eventCompleted(emit);
  }

  _setCngStationData(AddAssignmentSetCngStationDataEvent event, emit) async {
    _cngStationData = event.cngStationData;
    cngQuantityController.text = "";
    _eventCompleted(emit);
/*    _cngStationRouteList = [];
    _cngStationRouteData = CngStationRouteModel();
    _isRouteLoader = true;
    _eventCompleted(emit);
    var res = await RequestHelper.fetchRoute(
        context: event.context,
        userData: userData,
        sourceStationId: motherStationData.id.toString(),
        destinationStationId: cngStationData.id.toString());
    if (res != null) {
      _cngStationRouteList = res;
      if (cngStationRouteList.length == 1) {
        _cngStationRouteData = cngStationRouteList[0];
      }
    }
    _isRouteLoader = false;*/
    _eventCompleted(emit);
  }

  _setLcvTrack(AddAssignmentSetLcvTrackDataEvent event, emit) {
    _lcvData = event.lcvData;
    _eventCompleted(emit);
  }

  _addMoreCNGButton(AddAssignmentAddMoreCngStationDataEvent event, emit) {
    _isAddCngStation = event.isAddCNGStationButton;
    _eventCompleted(emit);
  }

  _setDrivingLicence(AddAssignmentSetDriverNoDataEvent event, emit) {
    for (var driverData in driverList) {
      if (driverData.driverLicenseId.toString() == event.drivingLicence) {
        _driverData = driverData;
      }
    }

    if (driverData.id == null) {
      SnackBarErrorWidget(event.context).show(message: "Driver not found");
    }
    _eventCompleted(emit);
  }

  _setTruckNumber(AddAssignmentSetTruckNoDataEvent event, emit) {
    for (var trucData in lcvList) {
      if (trucData.vehicleNo.toString() == event.truckNumber) {
        _lcvData = trucData;
      }
    }
    if (lcvData.id == null) {
      SnackBarErrorWidget(event.context).show(message: "Lcv Truck not found");
    }
    _eventCompleted(emit);
  }

  _addCNGStation(AddAssignmentAddStationEvent event, emit) async {
    if (cngStationRouteData.id == null) {
      SnackBarErrorWidget(event.context).show(message: "Please select roue");
      return;
    } else if (cngQuantityController.text.isEmpty) {
      SnackBarErrorWidget(event.context)
          .show(message: "Please enter CNG Quantity");
      return;
    }

    List<StationModel> temList = stationList
        .where((element) =>
            element.cngStation.id.toString() == cngStationData.id.toString())
        .toList();
    if (temList.isNotEmpty) {
      SnackBarErrorWidget(event.context)
          .show(message: "This state already exits");
      return;
    }

    _stationList.add(
      StationModel(
        cngStation: cngStationData,
        quantity: cngQuantityController.text.toString(),
        cngStationRouteData: cngStationRouteData,
      ),
    );

    int totalQuantity = 0;
    for (var element in stationList) {
      totalQuantity += int.parse(element.quantity.toString());
    }
    totalCngQuantityController.text = totalQuantity.toString();
    _stationList.reversed;

    _isAddCngStation = true;
    _cngStationData = CngStationModel();
    _eventCompleted(emit);
  }

  _changeSequence(AddAssignmentStationSequenceChangeEvent event, emit) {
    _stationList = [];
    _eventCompleted(emit);
    _stationList = event.stationList;

    _eventCompleted(emit);
  }

  _removeStation(AddAssignmentRemoveStationEvent event, emit) {
    List<StationModel> temList = _stationList;
    _stationList = [];
    _eventCompleted(emit);
    temList.removeAt(event.index);
    _stationList = temList;
    _stationList.reversed;
    if (stationList.isEmpty) {
      _isAddCngStation = false;
    }
    int totalQuantity = 0;
    for (var element in stationList) {
      totalQuantity += int.parse(element.quantity.toString());
    }
    totalCngQuantityController.text = totalQuantity.toString();
    _eventCompleted(emit);
  }

  _setScheduleDateTime(AddAssignmentSelectDateTimeEvent event, emit) async {
    DateTime now = DateTime.now();
    String date = DateFormat('dd-MMM-yyyy').format(now);
    String time = DateFormat('HH:mm:ss').format(now);
    String dateTime = date;
    DateTime? pickedDate = await showDatePicker(
      context: event.context,
      initialDate: DateTime.now(),
      firstDate: now,
      lastDate: DateTime(now.year, now.month + 1, now.day),
    );
    if (pickedDate != null) {
      String formattedDateChange = DateFormat('dd-MMM-yyyy').format(pickedDate);
      dateTime = formattedDateChange.toString();
      date = dateTime;
    }
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: !event.context.mounted ? event.context : event.context,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? Container(),
        );
      },
    );
    if (pickedTime != null) {
      String time0 = pickedTime.format(!event.context.mounted ? event.context : event.context).toString();
      if (time0.toLowerCase().contains("am") ||
          time0.toLowerCase().contains("pm")) {
        DateTime date = DateFormat("hh:mma").parse(time0.replaceAll(" ", ""));
        time = DateFormat("HH:mm:ss").format(date).toString();
      } else {
        DateTime dateTime = DateFormat("HH:mm").parse(time0);
        time = DateFormat("HH:mm:ss").format(dateTime);
      }
    }
    String dateTime0 = "$time, $date";
    scheduleDateTimeController.text = dateTime0.toString();
    _eventCompleted(emit);
  }

  _setCngStationRoute(AddAssignmentSetStationRouteDataEvent event, emit) {
    _cngStationRouteData = event.cngStationRouteData;
    _eventCompleted(emit);
  }

  _selectLcvEntryTime(AddAssignmentSelectLcvEntryTimeEvent event, emit) async {
    try {
      DateTime initialDate = lcvEntryTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm').parse(lcvEntryTimeController.text.toString())
          : DateTime.now();

      TimeOfDay initialTime = TimeOfDay.fromDateTime(initialDate);
      final TimeOfDay? time = await showTimePicker(
        context: event.context,
        initialTime: initialTime,
      );
      if (time != null) {
        var timeFormat = TimeOfDay(hour: time.hour, minute: time.minute)
            .format(!event.context.mounted ? event.context : event.context);
        lcvEntryTimeController.text = timeFormat;
        _eventCompleted(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectFillStartTime(AddAssignmentSelectFillStartTimeEvent event, emit) async {
    try {
      DateTime initialDate = fillStartTimeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm:ss').parse(fillStartTimeController.text.toString())
          : DateTime.now();

      DateTime? time =  await showCupertinoDatePicker(
          initialDateTime: initialDate,
          mode: CupertinoDatePickerMode.dateAndTime,
          context: event.context);
      if (time != null) {
        fillStartTimeController.text = DateFormat('HH:mm:ss').format(time).toString();
        _eventCompleted(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectFillEndTime(AddAssignmentSelectFillEndTimeEvent event, emit) async {
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

  _setCheckList(AddAssignmentSetCheckListEventEvent event, emit) {
    bool isSelected =  event.isSelected;
    int checkList = event.checkList;
    switch(checkList) {
      case 1:
        isLcvCondition =  isSelected;
        remarkController.text = "";
        _eventCompleted(emit);
        break;
      case 2:
        isDriverFitDrive =  isSelected;
        _eventCompleted(emit);
        break;
      case 3:
        isLcvLogBookCorrection =  isSelected;
        _eventCompleted(emit);
        break;
      case 4:
        isAvailabilityMobileWithDriver =  isSelected;
        _eventCompleted(emit);
        break;
      case 5:
        break;
    }
  }

  _selectImage(AddAssignmentSelectImageEvent event, emit) async {
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

  _deleteImage(AddAssignmentDeleteImageEvent event, emit) async {
    _isLoader = true;
    _eventCompleted(emit);
    fileList.removeAt(event.index);
    _isLoader = false;
    _eventCompleted(emit);
  }

  _submit(AddAssignmentSubmitEvent event, emit) async {
    var textFieldValidation = await AddAssignmentHelper.textFieldValidation(
        context: event.context,
        driverData: driverData,
        lcvData: lcvData,
        stationList: stationList,
        totalQuantity: totalCngQuantityController.text.toString(),
        motherStationData: motherStationData,
        scheduleDateTime: scheduleDateTimeController.text.toString(),
        cngStationRouteData: cngStationRouteData,
        lcvEntryTime: lcvEntryTimeController.text.toString(),
        cngStation: cngStationData,
    );
    if (textFieldValidation == false) {
      return;
    }
    _isLoader = true;
    _eventCompleted(emit);

    DateTime initialDate = DateTime.now();
    String lcvEntryTime = "";
    if(lcvEntryTimeController.text.toString().isNotEmpty
        && lcvEntryTimeController.text.toString().toLowerCase().contains("am")){
      initialDate = lcvEntryTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(lcvEntryTimeController.text.toString())
          : DateTime.now();
      lcvEntryTime = lcvEntryTimeController.text.toString().isNotEmpty ? "${initialDate.hour}:${initialDate.minute}:00" : "";
    } else if (lcvEntryTimeController.text.toString().isNotEmpty
        && lcvEntryTimeController.text.toString().toLowerCase().contains("pm")){
      initialDate = lcvEntryTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(lcvEntryTimeController.text.toString())
          : DateTime.now();
      lcvEntryTime = lcvEntryTimeController.text.toString().isNotEmpty ? "${initialDate.hour}:${initialDate.minute}:00" : "";
    } else {
      initialDate = lcvEntryTimeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm').parse(lcvEntryTimeController.text.toString())
          : DateTime.now();
      lcvEntryTime = lcvEntryTimeController.text.toString().isNotEmpty ? "${initialDate.hour}:${initialDate.minute}:00" : "";
    }

    DateTime fillEndTimeInitaialDateTime = DateTime.now();
    String fillEndTime = "";
    if(fillEndTimeController.text.toString().isNotEmpty
        && fillEndTimeController.text.toString().toLowerCase().contains("am")){
      fillEndTimeInitaialDateTime = fillEndTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(fillEndTimeController.text.toString())
          : DateTime.now();
      fillEndTime = fillEndTimeController.text.toString().isNotEmpty ? "${fillEndTimeInitaialDateTime.hour}:${fillEndTimeInitaialDateTime.minute}:00" : "";
    } else if (fillEndTimeController.text.toString().isNotEmpty
        && fillEndTimeController.text.toString().toLowerCase().contains("pm")){
      fillEndTimeInitaialDateTime = fillEndTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(fillEndTimeController.text.toString())
          : DateTime.now();
      fillEndTime = fillEndTimeController.text.toString().isNotEmpty ? "${fillEndTimeInitaialDateTime.hour}:${fillEndTimeInitaialDateTime.minute}:00" : "";
    } else {
      fillEndTimeInitaialDateTime = fillEndTimeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm').parse(fillEndTimeController.text.toString())
          : DateTime.now();
      fillEndTime = fillEndTimeController.text.toString().isNotEmpty ? "${fillEndTimeInitaialDateTime.hour}:${fillEndTimeInitaialDateTime.minute}:00" : "";
    }

    DateTime fillStartTimeInitialDate = DateTime.now();
    String fillStartTime = "";
    if(fillStartTimeController.text.toString().isNotEmpty
        && fillStartTimeController.text.toString().toLowerCase().contains("am")){
      fillStartTimeInitialDate = fillStartTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(fillStartTimeController.text.toString())
          : DateTime.now();
      fillStartTime = fillStartTimeController.text.toString().isNotEmpty ? "${fillStartTimeInitialDate.hour}:${fillStartTimeInitialDate.minute}:00" : "";
    } else if (fillStartTimeController.text.toString().isNotEmpty
        && fillStartTimeController.text.toString().toLowerCase().contains("pm")){
      fillStartTimeInitialDate = fillStartTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(fillStartTimeController.text.toString())
          : DateTime.now();
      fillStartTime = fillStartTimeController.text.toString().isNotEmpty ? "${fillStartTimeInitialDate.hour}:${fillStartTimeInitialDate.minute}:00" : "";
    } else {
      fillStartTimeInitialDate = fillStartTimeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm').parse(fillStartTimeController.text.toString())
          : DateTime.now();
      fillStartTime = fillStartTimeController.text.toString().isNotEmpty ? "${fillStartTimeInitialDate.hour}:${fillStartTimeInitialDate.minute}:00" : "";
    }

    print(cngStationData.id.toString());
    var res = await AddAssignmentHelper.addAssignment(
        context: !event.context.mounted ? event.context : event.context,
        driverData: driverData,
        lcvData: lcvData,
        stationList: stationList,
        totalQuantity: totalCngQuantityController.text.toString(),
        userData: userData,
        motherStationData: motherStationData,
        scheduleDateTime: scheduleDateTimeController.text.toString(),
        cngStationRouteData: cngStationRouteData,
        fileList: fileList,
        unscheduledMaintenancePenaltyHours: unscheduledMaintenancePenaltyHoursController.text.toString(),
        scheduledMaintenancePenaltyHours: scheduledMaintenancePenaltyHoursController.text.toString(),
        outPressure: outPressureController.text.toString(),
        lcvRemark: remarkController.text.toString(),
        lcvLogBookCorrection: isLcvLogBookCorrection == true ? "1" : "0",
        lcvCondition: isLcvCondition == true ? "1" : "0",
        flowMeterReadingOpen: flowMeterReadingOpenController.text.toString(),
        flowMeterReadingClosed: flowMeterReadingClosedController.text.toString(),
        fillStartTime: fillStartTime,
        fillEndTime: fillEndTime,
        driverToFitDrive: isDriverFitDrive == true ? "1" : "0",
        cngStationData: cngStationData,
        availabilityOfMobileWithDriver: isAvailabilityMobileWithDriver == true ? "1" : "0",
        lcvEntryTime: lcvEntryTime,
        assignmentData: assignmentData
    );
    _isLoader = false;
    _eventCompleted(emit);
    if (res != null) {
      _isLoader = false;
      _driverData = DriverModel();
      _cngStationData = CngStationModel();
      _lcvData = LcvTruckModel();
      _isAddCngStation = false;
      cngQuantityController.text = "";
      totalCngQuantityController.text = "";
      scheduleDateTimeController.text = "";
      _motherStationData = MotherStationModel();
      _stationList = [];
      lcvEntryTimeController.text = "";
      fillStartTimeController.text = "";
      flowMeterReadingOpenController.text = "";
      flowMeterReadingClosedController.text = "";
      fillEndTimeController.text = "";
      outPressureController.text = "";
      remarkController.text = "";
      unscheduledMaintenancePenaltyHoursController.text = "";
      scheduledMaintenancePenaltyHoursController.text = "";
      fileList = [];
      isLcvCondition =  true;
      isDriverFitDrive =  true;
      isLcvLogBookCorrection =  true;
      isAvailabilityMobileWithDriver = false;
      isUnscheduledMaintenancePenaltyHours = true;
      isScheduledMaintenancePenaltyHours =  true;
      _eventCompleted(emit);
      BlocProvider.of<LcvDashboardBloc>(!event.context.mounted ? event.context : event.context).add(
          LcvDashboardChangeBottomNavigationItemEvent(
              index: 2, context: !event.context.mounted ? event.context : event.context));
    }
  }

  _eventCompleted(Emitter<AddAssignmentState> emit) {
    emit(FetchAddAssignmentDataState(
      isLoader: isLoader,
      driverData: driverData,
      driverList: driverList,
      cngStationData: cngStationData,
      cngStationList: cngStationList,
      stationList: stationList,
      isAddCngStation: isAddCngStation,
      cngQuantityController: cngQuantityController,
      totalCngQuantityController: totalCngQuantityController,
      scheduleDateTimeController: scheduleDateTimeController,
      lcvList: lcvList,
      lcvData: lcvData,
      motherStationList: motherStationList,
      motherStationData: motherStationData,
      cngStationRouteData: cngStationRouteData,
      cngStationRouteList: cngStationRouteList,
      isRouteLoader: isRouteLoader,
      fileList: fileList,
      remarkController: remarkController,
      fillEndTimeController: fillEndTimeController,
      fillStartTimeController: fillStartTimeController,
      flowMeterReadingClosedController: flowMeterReadingClosedController,
      flowMeterReadingOpenController: flowMeterReadingOpenController,
      isAvailabilityMobileWithDriver: isAvailabilityMobileWithDriver,
      isDriverFitDrive: isDriverFitDrive,
      isLcvCondition: isLcvCondition,
      isLcvLogBookCorrection: isLcvLogBookCorrection,
      isScheduledMaintenancePenaltyHours: isScheduledMaintenancePenaltyHours,
      isUnscheduledMaintenancePenaltyHours: isUnscheduledMaintenancePenaltyHours,
      lcvEntryTimeController: lcvEntryTimeController,
      outPressureController: outPressureController,
      unscheduledMaintenancePenaltyHoursController: unscheduledMaintenancePenaltyHoursController,
      scheduledMaintenancePenaltyHoursController: scheduledMaintenancePenaltyHoursController,
    ));
  }
}
