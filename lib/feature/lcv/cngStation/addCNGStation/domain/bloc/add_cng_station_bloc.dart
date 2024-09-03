import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/addCNGStation/helper/add_cng_station_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/model/cng_stattion_model.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/presentation/page/cng_station_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'add_cng_station_event.dart';
part 'add_cng_station_state.dart';

class AddCngStationBloc extends Bloc<AddCngStationEvent, AddCngStationState> {
  bool _isLoader = false;

  bool get isLoader => _isLoader;

  TextEditingController stationCodeController = TextEditingController();
  TextEditingController stationNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController officerNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  double locationLat = 0.0;
  double locationLong = 0.0;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  CngStationModel _cngStationData = CngStationModel();

  CngStationModel get cngStationData => _cngStationData;

  bool _isEdit = false;

  bool get isEdit => _isEdit;

  AddCngStationBloc() : super(AddCngStationInitial()) {
    on<AddCngStationPageLoadEvent>(_pageLoad);
    on<AddCngStationEditEvent>(_editCngStation);
    on<AddCngStationSetAddressEvent>(_setAddress);
    on<AddCngStationSubmitEvent>(_submit);
  }

  _pageLoad(AddCngStationPageLoadEvent event, emit) async {
    emit(AddCNGStationPageLoadState());
    _userData = UserInfo.instance!.userData!;
    _isLoader = false;

    addressController.text = "";
    stateController.text = "";
    cityController.text = "";
    pincodeController.text = "";
    _eventCompleted(emit);

    stationCodeController.text =
        isEdit == true ? cngStationData.stationCode.toString() : "";
    stationNameController.text =
        isEdit == true ? cngStationData.stationName.toString() : "";
    addressController.text =
        isEdit == true ? cngStationData.address.toString() : "";
    cityController.text = isEdit == true ? cngStationData.city.toString() : "";
    stateController.text =
        isEdit == true ? cngStationData.state.toString() : "";
    districtController.text =
        isEdit == true ? cngStationData.district.toString() : "";
    pincodeController.text =
        isEdit == true ? cngStationData.pincode.toString() : "";
    officerNameController.text =
        isEdit == true ? cngStationData.officerName.toString() : "";
    emailController.text =
        isEdit == true ? cngStationData.companyEmail.toString() : "";
    phoneNumberController.text =
        isEdit == true ? cngStationData.phoneNumber.toString() : "";
    _eventCompleted(emit);
  }

  _editCngStation(AddCngStationEditEvent event, emit) {
    _cngStationData = event.cngStationData;
    _isEdit = event.isEdit;
  }

  _submit(AddCngStationSubmitEvent event, emit) async {
    var textFieldValidation = await AddCngStationHelper.textFieldValidation(
        context: event.context,
        stationCode: stationCodeController.text.toString(),
        stationName: stationNameController.text.toString(),
        address: addressController.text.toString(),
        city: cityController.text.toString(),
        state: stateController.text.toString(),
        district: districtController.text.toString(),
        pincode: pincodeController.text.toString(),
        officerName: officerNameController.text.toString(),
        phoneNumber: phoneNumberController.text.toString(),
        email: emailController.text.toString());
    if (textFieldValidation == false) {
      return;
    }

    _isLoader = true;
    _eventCompleted(emit);
    var res = await AddCngStationHelper.cngStationRegistrationSubmit(
        context: event.context,
        stationCode: stationCodeController.text.toString(),
        stationName: stationNameController.text.toString(),
        address: addressController.text.toString(),
        city: cityController.text.toString(),
        state: stateController.text.toString(),
        district: districtController.text.toString(),
        pincode: pincodeController.text.toString(),
        officerName: officerNameController.text.toString(),
        phoneNumber: phoneNumberController.text.toString(),
        email: emailController.text.toString(),
        userData: userData,
        long: locationLong.toString(),
        lat: locationLat.toString(),
        isEdit: isEdit,
        stationId:
            cngStationData.id != null ? cngStationData.id.toString() : "");

    _isLoader = false;
    _eventCompleted(emit);
    if (res != null) {
      Navigator.of(event.context).push(
          MaterialPageRoute(builder: (context) => const CNGStationPage()));
    }
    _eventCompleted(emit);
  }

  _setAddress(AddCngStationSetAddressEvent event, emit) {
    dynamic address = event.address;
    if (address != null && address.toString().isNotEmpty) {
      String city = address['city'];
      String state = address['state'];
      dynamic zipcode = address['zipcode'];
      dynamic lat = address['lat'];
      dynamic lng = address['lng'];
      locationLat = lat;
      locationLong = lng;
      cityController.text = city;
      stateController.text = state;
      pincodeController.text = zipcode;
      addressController.text = address['address'].toString();
      _eventCompleted(emit);
    }
  }

  _eventCompleted(Emitter<AddCngStationState> emit) {
    emit(FetchAddCNGStationDataState(
        isLoader: isLoader,
        emailController: emailController,
        stateController: stateController,
        districtController: districtController,
        cityController: cityController,
        addressController: addressController,
        officerNameController: officerNameController,
        phoneNumberController: phoneNumberController,
        pincodeController: pincodeController,
        stationCodeController: stationCodeController,
        stationNameController: stationNameController));
  }
}
