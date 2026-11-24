part of 'add_cng_station_bloc.dart';

abstract class AddCngStationState extends Equatable {
  const AddCngStationState();
}

class AddCngStationInitial extends AddCngStationState {
  @override
  List<Object> get props => [];
}

class AddCNGStationPageLoadState extends AddCngStationInitial {
  @override
  List<Object> get props => [];
}

class FetchAddCNGStationDataState extends AddCngStationInitial {
  final bool isLoader;
  final TextEditingController stationCodeController;
  final TextEditingController stationNameController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController districtController;
  final TextEditingController pincodeController;
  final TextEditingController officerNameController;
  final TextEditingController emailController;
  final TextEditingController phoneNumberController;

  FetchAddCNGStationDataState(
      {required this.isLoader,
      required this.emailController,
      required this.stateController,
      required this.districtController,
      required this.cityController,
      required this.addressController,
      required this.officerNameController,
      required this.phoneNumberController,
      required this.pincodeController,
      required this.stationCodeController,
      required this.stationNameController});

  @override
  List<Object> get props => [
        isLoader,
        emailController,
        stateController,
        districtController,
        cityController,
        addressController,
        officerNameController,
        phoneNumberController,
        pincodeController,
        stationCodeController,
        stationNameController
      ];
}
