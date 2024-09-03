import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/model/mother_station_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/model/station_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/helper/add_assignment_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/bloc/view_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/model/cng_stattion_model.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/helper/cng_station_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/model/driver_model.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/helper/driver_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/viewLcvTrack/domain/model/lcv_model.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/viewLcvTrack/helper/view_lcv_track_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/model/cng_station_route_model.dart';
import 'package:flutter_igl_cng/feature/lcv/request/helper/request_helper.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

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

  AddAssignmentBloc() : super(AddAssignmentInitial()) {
    on<AddAssignmentPageLoadEvent>(_pageLoad);
    on<AddAssignmentSetMotherStationDataEvent>(_setMotherStation);
    on<AddAssignmentSetDriverDataEvent>(_setDriverData);
    on<AddAssignmentSetCngStationDataEvent>(_setCngStationData);
    on<AddAssignmentSetLcvTrackDataEvent>(_setLcvTrack);
    on<AddAssignmentAddMoreCngStationDataEvent>(_addMoreCNGButton);
    on<AddAssignmentAddStationEvent>(_addCNGStation);
    on<AddAssignmentRemoveStationEvent>(_removeStation);
    on<AddAssignmentStationSequenceChangeEvent>(_changeSequence);
    on<AddAssignmentSubmitEvent>(_submit);
    on<AddAssignmentSetDriverNoDataEvent>(_setDrivingLicence);
    on<AddAssignmentSetTruckNoDataEvent>(_setTruckNumber);
    on<AddAssignmentSelectDateTimeEvent>(_setScheduleDateTime);
    on<AddAssignmentSetStationRouteDataEvent>(_setCngStationRoute);
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
    var motherStationRes = await AddAssignmentHelper.fetchMotherStationData(
        context: event.context, userData: userData);
    if (motherStationRes != null) {
      _motherStationList = motherStationRes;
    }

    var driverRes = await DriverHelper.fetchDriverData(
        context: event.context, userData: userData);
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
        context: event.context, userData: userData);
    if (cngStationRes != null) {
      _cngStationList = cngStationRes;
    }

    var lcvRes = await ViewLcvTrackHelper.fetchLCVData(
        context: event.context, userData: userData);
    if (lcvRes != null) {
      _lcvList = lcvRes;
      _lcvList = lcvList
          .where((element) => element.deletedAt.toString().isEmpty)
          .toList();
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
    _cngStationRouteList = [];
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
    _isRouteLoader = false;
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
    } else {
      print("Date is not selected");
    }
    print(TimeOfDay.now());
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: event.context,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? Container(),
        );
      },
    );
    if (pickedTime != null) {
      String _time = pickedTime.format(event.context).toString();
      if (_time.toLowerCase().contains("am") ||
          _time.toLowerCase().contains("pm")) {
        print("Flutrer  iiii====================== ${_time}");
        DateTime date = DateFormat("hh:mma").parse(_time.replaceAll(" ", ""));
        time = DateFormat("HH:mm:ss").format(date).toString();
        print("Flutrer  ====================== ${time}");
      } else {
        print("shdjhsdhshd time ${_time}");
        DateTime dateTime = DateFormat("HH:mm").parse(_time);
        time = DateFormat("HH:mm:ss").format(dateTime);
      }

      print(time);
    } else {
      print("Time is not selected");
    }

    String _dateTime = "$time, $date";
    scheduleDateTimeController.text = _dateTime.toString();
    _eventCompleted(emit);
  }

  _setCngStationRoute(AddAssignmentSetStationRouteDataEvent event, emit) {
    _cngStationRouteData = event.cngStationRouteData;
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
        cngStationRouteData: cngStationRouteData);
    if (textFieldValidation == false) {
      return;
    }
    _isLoader = true;
    _eventCompleted(emit);

    var res = await AddAssignmentHelper.addAssignment(
        context: event.context,
        driverData: driverData,
        lcvData: lcvData,
        stationList: stationList,
        totalQuantity: totalCngQuantityController.text.toString(),
        userData: userData,
        motherStationData: motherStationData,
        scheduleDateTime: scheduleDateTimeController.text.toString(),
        cngStationRouteData: cngStationRouteData);
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
      _eventCompleted(emit);
      BlocProvider.of<ViewAssignmentBloc>(event.context)
          .add(ViewAssignmentPageLoadEvent(context: event.context));
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
    ));
  }
}
