import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/bloc/add_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assignment_change_status_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/helper/view_assignment_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/model/cng_stattion_model.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/helper/cng_station_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/model/driver_model.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/helper/driver_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/viewLcvTrack/domain/model/lcv_model.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/viewLcvTrack/helper/view_lcv_track_helper.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'view_assignment_event.dart';
part 'view_assignment_state.dart';

class ViewAssignmentBloc
    extends Bloc<ViewAssignmentEvent, ViewAssignmentState> {
  List<AssignmentModel> _assignmentList = [];

  List<AssignmentModel> get assignmentList => _assignmentList;

  List<AssignmentModel> _searchAssignmentList = [];

  List<AssignmentModel> get searchAssignmentList => _searchAssignmentList;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  List<AssignmentChangeStatusModel> _assignmentChangeStatusList = [];

  List<AssignmentChangeStatusModel> get assignmentChangeStatusList =>
      _assignmentChangeStatusList;

  AssignmentChangeStatusModel _assignmentChangeStatusData =
      AssignmentChangeStatusModel();

  AssignmentChangeStatusModel get assignmentChangeStatusData =>
      _assignmentChangeStatusData;

  bool _isLoader = false;

  bool get isLoader => _isLoader;

  List<DriverModel> _lcvDriverList = [];

  List<DriverModel> get lcvDriverList => _lcvDriverList;

  DriverModel _lcvDriverData = DriverModel();

  DriverModel get lcvDriverData => _lcvDriverData;

  TextEditingController remarkController = TextEditingController();
  TextEditingController toDateTextFieldController = TextEditingController();
  TextEditingController fromDateTextFieldController = TextEditingController();

  bool _isDriverList = false;

  bool get isDriverList => _isDriverList;

  AssignmentModel _assignmentData =  AssignmentModel();
  AssignmentModel get assignmentData => _assignmentData;

  List<LcvTruckModel> _lcvList = [];

  List<LcvTruckModel> get lcvList => _lcvList;

  LcvTruckModel _lcvData = LcvTruckModel();

  LcvTruckModel get lcvData => _lcvData;

  List<CngStationModel> _cngStationList = [];

  List<CngStationModel> get cngStationList => _cngStationList;

  CngStationModel _cngStationData = CngStationModel();

  CngStationModel get cngStationData => _cngStationData;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  ViewAssignmentBloc() : super(ViewAssignmentInitial()) {
    on<ViewAssignmentPageLoadEvent>(_pageLoad);
    on<ViewAssignmentSelectAssignmentEvent>(_selectAssignment);
    on<ViewAssignmentChangeStatusEvent>(_changeStatus);
    on<ViewAssignmentKeyWordSearchDataEvent>(_searchKeyword);
    on<ViewAssignmentUpdateStatusEvent>(_updateStatus);
    on<ViewAssignmentSelectLcvDriverEvent>(_selectLcvDriver);
    on<ViewAssignmentSelectFromDateEvent>(_selectFromDate);
    on<ViewAssignmentSelectToDateEvent>(_selectToDate);
    on<ViewAssignmentSetCngStationDataEvent>(_setCngStationData);
    on<ViewAssignmentSetLcvTrackDataEvent>(_setLcvTrack);
    on<ViewAssignmentFilterSubmitEvent>(_filterSubmit);
  }

  _pageLoad(ViewAssignmentPageLoadEvent event, emit) async {
    emit(ViewAssignmentPageLoadState());
    _assignmentList = [];
    _searchAssignmentList = [];
    _lcvDriverList = [];
    _lcvDriverData = DriverModel();
    _assignmentData =  AssignmentModel();
    _lcvList = [];
    _lcvData=  LcvTruckModel();
    _cngStationList = [];
    _cngStationData =  CngStationModel();
    _userData = UserInfo.instance!.userData!;
    _assignmentChangeStatusList = AssignmentChangeStatusModel.getStatus();
    _isLoader = false;
    remarkController.text = "";
    if (assignmentChangeStatusList.length == 1) {
      _assignmentChangeStatusData = assignmentChangeStatusList[0];
    }

    startDate = DateTime.now().subtract(const Duration(days: 3));
    endDate = DateTime.now();

    var res = await ViewAssignmentHelper.fetchAssignment(
        context: event.context, userData: userData,
        fromDate: DateFormat("yyyy-MM-dd").format(startDate).toString(),
        toDate: DateFormat("yyyy-MM-dd").format(endDate).toString(),
    );
    if (res != null) {
      _assignmentList = res;
      _searchAssignmentList = res;
    }
    _eventCompleted(emit);

    _lcvDriverList =  BlocProvider.of<AddAssignmentBloc>(!event.context.mounted ? event.context : event.context).driverList;
    _lcvList =  BlocProvider.of<AddAssignmentBloc>(!event.context.mounted ? event.context : event.context).lcvList;
    _cngStationList =  BlocProvider.of<AddAssignmentBloc>(!event.context.mounted ? event.context : event.context).cngStationList;

    _isDriverList = true;
    _eventCompleted(emit);

    if (lcvDriverList.isEmpty) {
      var driverRes = await DriverHelper.fetchDriverData(
          context:!event.context.mounted ? event.context : event.context, userData: userData);
      if (driverRes != null) {
        _lcvDriverList = driverRes;
      }
    }

    if (lcvList.isEmpty) {
      var lcvRes = await ViewLcvTrackHelper.fetchLCVData(
          context: !event.context.mounted ? event.context : event.context, userData: userData);
      if (lcvRes != null) {
        _lcvList = lcvRes;
      }
    }

    if(cngStationList.isEmpty){
      var cngStationRes = await CNGStationHelper.fetchCNGStationData(
          context: !event.context.mounted ? event.context : event.context, userData: userData);
      if (cngStationRes != null) {
        _cngStationList = cngStationRes;
      }
    }

    _isDriverList = false;
    _eventCompleted(emit);
  }

  _selectAssignment(ViewAssignmentSelectAssignmentEvent event, emit) {
    _assignmentData =  event.assignmentData;
    _eventCompleted(emit);
  }

  _changeStatus(ViewAssignmentChangeStatusEvent event, emit) {
    _assignmentChangeStatusData = event.assignmentChangeStatusData;
    _eventCompleted(emit);
  }

  _selectLcvDriver(ViewAssignmentSelectLcvDriverEvent event, emit) {
    _lcvDriverData = event.lcvDriverData;
    _eventCompleted(emit);
  }

  _selectFromDate(ViewAssignmentSelectFromDateEvent event, emit) async {
    final DateTime? picked = await showDatePicker(
      context: event.context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      fromDateTextFieldController.text =
          picked.toString().replaceAll(" 00:00:00.000", "");
      _eventCompleted(emit);
    }
  }

  _selectToDate(ViewAssignmentSelectToDateEvent event, emit) async {
    final DateTime? picked = await showDatePicker(
      context: event.context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      toDateTextFieldController.text =
          picked.toString().replaceAll(" 00:00:00.000", "");
      _eventCompleted(emit);
    }
  }

  _setCngStationData(ViewAssignmentSetCngStationDataEvent event, emit) async {
    _cngStationData = event.cngStationData;
    _eventCompleted(emit);
  }

  _setLcvTrack(ViewAssignmentSetLcvTrackDataEvent event, emit) {
    _lcvData = event.lcvData;
    _eventCompleted(emit);
  }

  _filterSubmit(ViewAssignmentFilterSubmitEvent event, emit) async {
    String fromDate = fromDateTextFieldController.text.toString();
    String toDate = toDateTextFieldController.text.toString();
    var textFieldValidation =
        await ViewAssignmentHelper.textFieldValidationCheck(
            context: event.context, toDate: toDate, fromDate: fromDate);
    if (textFieldValidation == false) {
      return;
    }

    _assignmentList = [];
    _searchAssignmentList = [];
    _isLoader = true;
    _eventCompleted(emit);
    startDate = DateFormat("yyyy-MM-dd").parse(fromDate);
    endDate = DateFormat("yyyy-MM-dd").parse(toDate);
    emit(ViewAssignmentPageLoadState());
    var res = await ViewAssignmentHelper.fetchAssignment(
      context: !event.context.mounted ? event.context : event.context,
      userData: userData,
      fromDate: startDate.toString(),
      toDate: endDate.toString(),
    );
    if (res != null) {
      _searchAssignmentList = res;
    }

    if(lcvData.vehicleNo != null){
      _assignmentList.addAll(searchAssignmentList.where((element) =>
          element.lcvNumber.toString().toLowerCase().contains(lcvData.vehicleNo.toString().toLowerCase())).toList());
    }

    if(cngStationData.stationName != null){
      _assignmentList.addAll(searchAssignmentList.where((element) =>
          element.dbStationName.toString().toLowerCase().contains(cngStationData.stationName.toString().toLowerCase())).toList());
    }

    if(lcvDriverData.driverName != null){
      _assignmentList.addAll(searchAssignmentList.where((element) =>
          element.driverName.toString().toLowerCase().contains(lcvDriverData.driverName.toString().toLowerCase())).toList());
    }

    final ids = <dynamic>{};
    _assignmentList.retainWhere((element) => ids.add(element.id));

    _isLoader = false;
    _eventCompleted(emit);
  }

  _searchKeyword(ViewAssignmentKeyWordSearchDataEvent event, emit) async {

    String keyword =  event.keyword;
    _isLoader = true;
    _assignmentList = [];
    _eventCompleted(emit);
    if(lcvData.vehicleNo != null) {
      _assignmentList.addAll(searchAssignmentList.where((element) =>
          element.lcvNumber.toString().toLowerCase().contains(
              lcvData.vehicleNo.toString().toLowerCase())).toList());

      if (cngStationData.stationName != null) {
        _assignmentList.addAll(searchAssignmentList.where((element) =>
            element.dbStationName.toString().toLowerCase().contains(
                cngStationData.stationName.toString().toLowerCase()))
            .toList());
      }

      if (lcvDriverData.driverName != null) {
        _assignmentList.addAll(searchAssignmentList.where((element) =>
            element.driverName.toString().toLowerCase().contains(
                lcvDriverData.driverName.toString().toLowerCase())).toList());
      }
    }

    if(assignmentList.isEmpty) {
      _assignmentList = searchAssignmentList;
    }

    if(keyword.isNotEmpty){
      List<AssignmentModel> tempList =  assignmentList;
      _assignmentList = [];

      _assignmentList =  tempList.where((element) => element.driverName.toString().toLowerCase().contains(
        keyword.toLowerCase()
      )).toList();

      if(assignmentList.isEmpty) {
        _assignmentList =  tempList.where((element) => element.dbStationName.toString().toLowerCase().contains(
            keyword.toLowerCase()
        )).toList();
      }

      if(assignmentList.isEmpty) {
        _assignmentList =  tempList.where((element) => element.lcvNumber.toString().toLowerCase().contains(
            keyword.toLowerCase()
        )).toList();
      }

    }


    final ids = <dynamic>{};
    _assignmentList.retainWhere((element) => ids.add(element.id));
    _isLoader = false;
    _eventCompleted(emit);
  }

  _updateStatus(ViewAssignmentUpdateStatusEvent event, emit) async {
      int index = event.index;
      _isLoader =  true;
      _assignmentList[index].isSelected = true;
      _eventCompleted(emit);
      var res =  await ViewAssignmentHelper.cancelAssignment(context: event.context,
          assignmentData: assignmentList[index], remark: "");
      if(res != null){
        emit(ViewAssignmentPageLoadState());
        var listRes = await ViewAssignmentHelper.fetchAssignment(
            context: !event.context.mounted ? event.context : event.context,
            userData: userData, fromDate: startDate.toString(), toDate: endDate.toString());
        if (listRes != null) {
          _assignmentList = listRes;
        }
      } else {
        _isLoader =  true;
        _assignmentList[index].isSelected = false;
        _eventCompleted(emit);
      }

      _isLoader =  false;
      _eventCompleted(emit);

  }

  _eventCompleted(Emitter<ViewAssignmentState> emit) {
    emit(FetchViewAssignmentDataState(
      assignmentList: assignmentList,
      isLoader: isLoader,
      assignmentChangeStatusData: assignmentChangeStatusData,
      assignmentChangeStatusList: assignmentChangeStatusList,
      remarkController: remarkController,
      lcvDriverData: lcvDriverData,
      lcvDriverList: lcvDriverList,
      fromDateTextFieldController: fromDateTextFieldController,
      toDateTextFieldController: toDateTextFieldController,
      isDriverList: isDriverList,
      assignmentData: assignmentData,
      cngStationData: cngStationData,
      cngStationList: cngStationList,
      lcvData: lcvData,
      lcvList: lcvList,
    ));
  }
}
