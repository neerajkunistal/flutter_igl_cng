import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/model/cng_stattion_model.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/helper/cng_station_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/user/addUser/helper/add_user_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/user/viewUser/domain/bloc/view_user_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/user/viewUser/domain/model/user_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'add_user_event.dart';
part 'add_user_state.dart';

class AddUserBloc extends Bloc<AddUserEvent, AddUserState> {
  bool _isLoader = false;

  bool get isLoader => _isLoader;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController drivingLicenceNumberController =
      TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  List<CngStationModel> _cngStationList = [];

  List<CngStationModel> get cngStationList => _cngStationList;

  CngStationModel _cngStationData = CngStationModel();

  CngStationModel get cngStationData => _cngStationData;

  UserModel _userModelData = UserModel();

  UserModel get userModelData => _userModelData;

  bool _isEdit = false;

  bool get isEdit => _isEdit;

  AddUserBloc() : super(AddUserInitial()) {
    on<AddUserPageLoadEvent>(_pageLoad);
    on<AddUserSetCngStationDataEvent>(_setCngStationData);
    on<AddUserSubmitEvent>(_submit);
    on<AddUserEditEvent>(_userEdit);
  }

  _pageLoad(AddUserPageLoadEvent event, emit) async {
    emit(AddUserPageLoadState());
    _userData = UserInfo.instance!.userData!;
    _isLoader = false;
    fullNameController.text =
        isEdit == false ? "" : userModelData.fullName.toString();
    drivingLicenceNumberController.text = "";
    phoneNumberController.text =
        isEdit == false ? "" : userModelData.phoneNumber.toString();
    emailController.text =
        isEdit == false ? "" : userModelData.email.toString();
    addressController.text =
        isEdit == false ? "" : userModelData.address.toString();
    cityController.text = isEdit == false ? "" : userModelData.city.toString();
    districtController.text =
        isEdit == false ? "" : userModelData.district.toString();
    stateController.text =
        isEdit == false ? "" : userModelData.state.toString();
    _cngStationList = [];
    _cngStationData = CngStationModel();
    var cngStationRes = await CNGStationHelper.fetchCNGStationData(
        context: event.context, userData: userData);
    if (cngStationRes != null) {
      _cngStationList = cngStationRes;
    }

    if (isEdit == true) {
      cngStationList.forEach((element) {
        if (element.stationName.toString() ==
            userModelData.stationName.toString()) {
          _cngStationData = element;
        }
      });
    }
    _eventCompleted(emit);
  }

  _userEdit(AddUserEditEvent event, emit) {
    _isEdit = event.isEdit;
    _userModelData = event.userData;
  }

  _setCngStationData(AddUserSetCngStationDataEvent event, emit) {
    _cngStationData = event.cngStationData;
    _eventCompleted(emit);
  }

  _submit(AddUserSubmitEvent event, emit) async {
    var testFiledValidation = await AddUserHelper.textFieldValidation(
        context: event.context,
        fullName: fullNameController.text.toString(),
        phoneNumber: phoneNumberController.text.toString(),
        email: emailController.text.toString().trim(),
        address: addressController.text.toString(),
        city: cityController.text.toString(),
        district: districtController.text.toString(),
        state: stateController.text.toString(),
        cngStationData: cngStationData);
    if (testFiledValidation == false) {
      return;
    }

    _isLoader = true;
    _eventCompleted(emit);
    var res = await AddUserHelper.registration(
      context: event.context,
      fullName: fullNameController.text.toString(),
      email: emailController.text.toString(),
      phoneNumber: phoneNumberController.text.toString(),
      address: addressController.text.toString(),
      city: cityController.text.toString(),
      district: districtController.text.toString(),
      state: stateController.text.toString(),
      userData: userData,
      cngStationData: cngStationData,
      isEdit: isEdit,
      userModelData: userModelData,
    );
    _isLoader = false;
    _eventCompleted(emit);
    if (res != null) {
      _isLoader = false;
      fullNameController.text = "";
      drivingLicenceNumberController.text = "";
      phoneNumberController.text = "";
      emailController.text = "";
      addressController.text = "";
      cityController.text = "";
      districtController.text = "";
      stateController.text = "";
      _cngStationList = [];
      _cngStationData = CngStationModel();
      _eventCompleted(emit);
      BlocProvider.of<ViewUserBloc>(event.context)
          .add(ViewUserPageLoadEvent(context: event.context));
    }
  }

  _eventCompleted(Emitter<AddUserState> emit) {
    emit(FetchAddUserDataState(
        isLoader: isLoader,
        fullNameController: fullNameController,
        phoneNumberController: phoneNumberController,
        emailController: emailController,
        addressController: addressController,
        cityController: cityController,
        districtController: districtController,
        stateController: stateController,
        cngStationList: cngStationList,
        cngStationData: cngStationData));
  }
}
