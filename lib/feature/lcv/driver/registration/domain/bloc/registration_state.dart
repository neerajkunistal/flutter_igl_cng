part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();
}

class RegistrationInitial extends RegistrationState {
  @override
  List<Object> get props => [];
}

class RegistrationPageLoadState extends RegistrationInitial {
  @override
  List<Object> get props => [];
}

class FetchRegistrationDataState extends RegistrationInitial {
  final bool isLoader;
  final TextEditingController fullNameController;
  final TextEditingController drivingLicenceNumberController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController districtController;
  final TextEditingController stateController;
  final List<RegistrationModel> registrationList;
  final File uploadCertificateImage;
  final File uploadLicenceImage;
  final File uploadPhotoImage;
  final DriverModel driverData;

  FetchRegistrationDataState({
    required this.isLoader,
    required this.fullNameController,
    required this.drivingLicenceNumberController,
    required this.phoneNumberController,
    required this.emailController,
    required this.addressController,
    required this.cityController,
    required this.districtController,
    required this.stateController,
    required this.registrationList,
    required this.uploadCertificateImage,
    required this.uploadLicenceImage,
    required this.uploadPhotoImage,
    required this.driverData,
  });

  @override
  List<Object> get props => [
        isLoader,
        fullNameController,
        drivingLicenceNumberController,
        phoneNumberController,
        emailController,
        addressController,
        cityController,
        districtController,
        registrationList,
        uploadLicenceImage,
        uploadCertificateImage,
        uploadPhotoImage,
        driverData,
      ];
}
