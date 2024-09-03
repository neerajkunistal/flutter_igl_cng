import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/addLcvTrack/domain/model/fuel_type_model.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/addLcvTrack/helper/add_lcv_track_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/viewLcvTrack/domain/bloc/view_lcv_track_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/viewLcvTrack/domain/model/lcv_model.dart';

import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'add_lcv_track_event.dart';
part 'add_lcv_track_state.dart';

class AddLcvTrackBloc extends Bloc<AddLcvTrackEvent, AddLcvTrackState> {
  bool _isLoader = false;

  bool get isLoader => _isLoader;

  List<FuelTypeModel> _fuelTypeList = [];

  List<FuelTypeModel> get fuelTypeList => _fuelTypeList;

  FuelTypeModel _fuelTypeData = FuelTypeModel();

  FuelTypeModel get fuelTypeData => _fuelTypeData;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  LcvTruckModel _lcvTruckData = LcvTruckModel();

  LcvTruckModel get lcvTruckData => _lcvTruckData;

  bool _isEdit = false;

  bool get isEdit => _isEdit;

  TextEditingController vehicleCompanyController = TextEditingController();
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController engineNumberController = TextEditingController();
  TextEditingController chassisNumberController = TextEditingController();
  TextEditingController averageController = TextEditingController();

  AddLcvTrackBloc() : super(AddLcvTrackInitial()) {
    on<AddLcvTruckPageLoadEvent>(_pageLoad);
    on<AddLcvTruckSelectFuelTypeEvent>(_setFuelType);
    on<AddLcvTruckSubmitEvent>(_submit);
    on<AddLcvTruckEditEvent>(_truckEdit);
  }

  _pageLoad(AddLcvTruckPageLoadEvent event, emit) async {
    emit(AddLcvTrackPageLoadState());
    _userData = UserInfo.instance!.userData!;
    _isLoader = false;
    _fuelTypeList = FuelTypeModel().getFuelTypeList();
    _fuelTypeData = FuelTypeModel();
    vehicleCompanyController.text =
        isEdit == true ? lcvTruckData.vehicleCompany.toString() : "";
    vehicleNameController.text =
        isEdit == true ? lcvTruckData.vehicleName.toString() : "";
    vehicleNumberController.text =
        isEdit == true ? lcvTruckData.vehicleNo.toString() : "";
    engineNumberController.text =
        isEdit == true ? lcvTruckData.engineNumber.toString() : "";
    chassisNumberController.text =
        isEdit == true ? lcvTruckData.chassisNumber.toString() : "";
    averageController.text =
        isEdit == true ? lcvTruckData.average.toString() : "";
    _eventCompleted(emit);
  }

  _setFuelType(AddLcvTruckSelectFuelTypeEvent event, emit) {
    _fuelTypeData = event.fuelTypeData;
    _eventCompleted(emit);
  }

  _truckEdit(AddLcvTruckEditEvent event, emit) async {
    _lcvTruckData = event.lcvTruckData;
    _isEdit = event.isEdit;
  }

  _submit(AddLcvTruckSubmitEvent event, emit) async {
    var textFieldValidation = await AddLcvTrackHelper.textFieldValidation(
        context: event.context,
        vehicleCompany: vehicleCompanyController.text.toString(),
        vehicleName: vehicleNameController.text.toString(),
        vehicleNumber: vehicleNumberController.text.toString(),
        engineNumber: engineNumberController.text.toString(),
        chassisNumber: chassisNumberController.text.toString(),
        fuelType: fuelTypeData.id != null ? fuelTypeData.id.toString() : "",
        average: averageController.text.toString());
    if (textFieldValidation == false) {
      return;
    }

    _isLoader = true;
    _eventCompleted(emit);
    var res = await AddLcvTrackHelper.submitVehicleData(
        context: event.context,
        vehicleCompany: vehicleCompanyController.text.toString(),
        vehicleName: vehicleNameController.text.toString(),
        vehicleNumber: vehicleNumberController.text.toString(),
        engineNumber: engineNumberController.text.toString(),
        chassisNumber: chassisNumberController.text.toString(),
        fuelType: fuelTypeData.id != null ? fuelTypeData.id.toString() : "",
        average: averageController.text.toString(),
        userData: userData,
        lcvTruckData: lcvTruckData,
        isEdit: isEdit);
    _isLoader = false;
    _eventCompleted(emit);
    if (res != null) {
      _isLoader = false;
      _fuelTypeList = FuelTypeModel().getFuelTypeList();
      _fuelTypeData = FuelTypeModel();
      vehicleCompanyController.text = "";
      vehicleNameController.text = "";
      vehicleNumberController.text = "";
      engineNumberController.text = "";
      chassisNumberController.text = "";
      averageController.text = "";
      _eventCompleted(emit);
      BlocProvider.of<ViewLcvTrackBloc>(event.context)
          .add(ViewLcvTruckPageLoadEvent(context: event.context));
    }
  }

  _eventCompleted(Emitter<AddLcvTrackState> emit) {
    emit(FetchAddLcvTrackDataState(
        fuelTypeList: fuelTypeList,
        isLoader: isLoader,
        averageController: averageController,
        chassisNumberController: chassisNumberController,
        engineNumberController: engineNumberController,
        fuelTypeData: fuelTypeData,
        vehicleCompanyController: vehicleCompanyController,
        vehicleNameController: vehicleNameController,
        vehicleNumberController: vehicleNumberController));
  }
}
