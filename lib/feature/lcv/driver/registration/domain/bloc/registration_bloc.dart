import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/registration/domain/model/registration_model.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/registration/helper/registration_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/bloc/driver_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/model/driver_model.dart';
import 'package:flutter_igl_cng/services/location/location_helper.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
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

  List<RegistrationModel> _registrationList = [];

  List<RegistrationModel> get registrationList => _registrationList;

  RegistrationModel _registrationData = RegistrationModel();

  RegistrationModel get registrationData => _registrationData;

  DriverModel _driverData = DriverModel();

  DriverModel get driverData => _driverData;

  bool _isEdit = false;

  bool get isEdit => _isEdit;
  late File uploadCertificateImage;
  late File uploadLicenceImage;
  late File uploadPhotoImage;

  RegistrationBloc() : super(RegistrationInitial()) {
    on<RegistrationPageLoadEvent>(_pageLoad);
    on<RegistrationSelectUserRoleEvent>(_setUserRole);
    on<RegistrationSubmitEvent>(_submit);
    on<RegistrationEditEvent>(_driverEdit);
    on<RegistrationUploadPhotoEvent>(_uploadPhoto);
  }

  _pageLoad(RegistrationPageLoadEvent event, emit) async {
    emit(RegistrationPageLoadState());
    _userData = UserInfo.instance!.userData!;
    _isLoader = false;
    uploadLicenceImage = File("");
    uploadCertificateImage = File("");
    uploadPhotoImage = File("");
    fullNameController.text =
        isEdit == true ? driverData.driverName.toString() : "";
    drivingLicenceNumberController.text =
        isEdit == true ? driverData.driverLicenseId.toString() : "";
    phoneNumberController.text =
        isEdit == true ? driverData.phoneNumber.toString() : "";
    emailController.text =
        isEdit == true ? driverData.companyEmail.toString() : "";
    addressController.text =
        isEdit == true ? driverData.address.toString() : "";
    cityController.text = isEdit == true ? driverData.city.toString() : "";
    districtController.text =
        isEdit == true ? driverData.district.toString() : "";
    stateController.text = isEdit == true ? driverData.state.toString() : "";
    _registrationList = [];
    _registrationData = RegistrationModel();
    _eventCompleted(emit);
  }

  _setUserRole(RegistrationSelectUserRoleEvent event, emit) {
    _registrationData = event.registrationData;
    _eventCompleted(emit);
  }

  _submit(RegistrationSubmitEvent event, emit) async {
    var testFiledValidation = await RegistrationHelper.textFieldValidation(
      context: event.context,
      fullName: fullNameController.text.toString(),
      drivingLicence:
          drivingLicenceNumberController.text.toString().replaceAll(" ", ""),
      phoneNumber: phoneNumberController.text.toString(),
      email: emailController.text.toString().trim(),
      address: addressController.text.toString(),
      city: cityController.text.toString(),
      district: districtController.text.toString(),
      state: stateController.text.toString(),
      uploadCertificateImage: uploadLicenceImage,
      uploadLicenceImage: uploadLicenceImage,
      uploadPhotoImage: uploadPhotoImage,
      isEdit: isEdit,
    );
    if (testFiledValidation == false) {
      return;
    }

    _isLoader = true;
    _eventCompleted(emit);
    var res = await RegistrationHelper.registration(
        context: event.context,
        fullName: fullNameController.text.toString(),
        email: emailController.text.toString(),
        drivingLicence:
            drivingLicenceNumberController.text.toString().replaceAll(" ", ""),
        phoneNumber: phoneNumberController.text.toString(),
        address: addressController.text.toString(),
        city: cityController.text.toString(),
        district: districtController.text.toString(),
        state: stateController.text.toString(),
        userData: userData,
        registrationData: registrationData,
        driverModel: driverData,
        isEdit: isEdit,
        uploadCertificateImage: uploadCertificateImage,
        uploadLicenceImage: uploadLicenceImage,
        uploadPhotoImage: uploadPhotoImage);
    _isLoader = false;
    _eventCompleted(emit);
    if (res != null) {
      BlocProvider.of<DriverBloc>(event.context)
          .add(DriverPageLoadEvent(context: event.context));
      Navigator.pop(event.context);
    }
  }

  _driverEdit(RegistrationEditEvent event, emit) {
    _driverData = event.driverData;
    _isEdit = event.isEdit;
  }

  _uploadPhoto(RegistrationUploadPhotoEvent event, emit) async {
    if (await LocationHelper.checkImagePermission(context: event.context) ==
        false) {
      return;
    }
    if (event.photoIndex == 1) {
      var photo = await RegistrationHelper.imagePiker(context: event.context);
      uploadCertificateImage = photo;
    } else if (event.photoIndex == 2) {
      var photo = await RegistrationHelper.imagePiker(context: event.context);
      uploadLicenceImage = photo;
    } else if (event.photoIndex == 3) {
      var photo = await RegistrationHelper.imagePiker(context: event.context);
      uploadPhotoImage = photo;
    }
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<RegistrationState> emit) {
    emit(FetchRegistrationDataState(
      isLoader: isLoader,
      fullNameController: fullNameController,
      drivingLicenceNumberController: drivingLicenceNumberController,
      phoneNumberController: phoneNumberController,
      emailController: emailController,
      addressController: addressController,
      cityController: cityController,
      districtController: districtController,
      stateController: stateController,
      registrationList: registrationList,
      uploadCertificateImage: uploadCertificateImage,
      uploadLicenceImage: uploadLicenceImage,
      uploadPhotoImage: uploadPhotoImage,
      driverData: driverData,
    ));
  }
}
