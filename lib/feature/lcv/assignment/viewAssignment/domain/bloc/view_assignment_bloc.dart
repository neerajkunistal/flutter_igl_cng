import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/helper/add_assignment_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assignment_change_status_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/helper/view_assignment_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/model/driver_model.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/helper/driver_helper.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'view_assignment_event.dart';
part 'view_assignment_state.dart';

class ViewAssignmentBloc
    extends Bloc<ViewAssignmentEvent, ViewAssignmentState> {
  List<AssignmentModel> _assignmentList = [];

  List<AssignmentModel> get assignmentList => _assignmentList;

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

  ViewAssignmentBloc() : super(ViewAssignmentInitial()) {
    on<ViewAssignmentPageLoadEvent>(_pageLoad);
    on<ViewAssignmentChangeStatusEvent>(_changeStatus);
    on<ViewAssignmentUpdateStatusEvent>(_updateStatus);
    on<ViewAssignmentSelectLcvDriverEvent>(_selectLcvDriver);
    on<ViewAssignmentSelectFromDateEvent>(_selectFromDate);
    on<ViewAssignmentSelectToDateEvent>(_selectToDate);
    on<ViewAssignmentFilterSubmitEvent>(_filterSubmit);
  }

  _pageLoad(ViewAssignmentPageLoadEvent event, emit) async {
    emit(ViewAssignmentPageLoadState());
    _assignmentList = [];
    _lcvDriverList = [];
    _lcvDriverData = DriverModel();
    _userData = UserInfo.instance!.userData!;
    _assignmentChangeStatusList = AssignmentChangeStatusModel.getStatus();
    _isLoader = false;
    remarkController.text = "";
    if (assignmentChangeStatusList.length == 1) {
      _assignmentChangeStatusData = assignmentChangeStatusList[0];
    }
    var res = await ViewAssignmentHelper.fetchAssignment(
        context: event.context, userData: userData);
    if (res != null) {
      _assignmentList = res;
    }
    _eventCompleted(emit);

    if (userData.roleType != RoleType.driver) {
      _isDriverList = true;
      _eventCompleted(emit);
      var driverRes = await DriverHelper.fetchDriverData(
          context: event.context, userData: userData);
      if (driverRes != null) {
        _lcvDriverList = driverRes;
      }
      _isDriverList = false;
      _eventCompleted(emit);
    }
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
      lastDate: DateTime(2025),
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
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      toDateTextFieldController.text =
          picked.toString().replaceAll(" 00:00:00.000", "");
      _eventCompleted(emit);
    }
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
    _isLoader = true;
    _eventCompleted(emit);
    var res = await ViewAssignmentHelper.fetchAssignment(
        context: event.context,
        userData: userData,
        fromDate: fromDate,
        toDate: toDate);
    if (res != null) {
      _assignmentList = res;
    }
    _isLoader = false;
    _eventCompleted(emit);
  }

  _updateStatus(ViewAssignmentUpdateStatusEvent event, emit) async {
    _isLoader == true;
    _eventCompleted(emit);
    var res = await AddAssignmentHelper.updateStatus(
      context: event.context,
      statusId: "4",
      assignmentId: assignmentList[event.index].id,
      userData: userData,
      uploadTruckImage: File(""),
      assignmentData: assignmentList[event.index],
      uploadPhotoImage: File(""),
      remarks:
          "${assignmentChangeStatusData.status}   ${remarkController.text.toString()}",
      assignmentStatus: AssignmentModel.getAssignmentStatus(
          status: assignmentList[event.index].id.toString()),
    );
    _isLoader == false;
    _eventCompleted(emit);
    if (res != null) {
      BlocProvider.of<ViewAssignmentBloc>(event.context)
          .add(ViewAssignmentPageLoadEvent(context: event.context));
      Navigator.pop(event.context);
    }
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
    ));
  }
}
