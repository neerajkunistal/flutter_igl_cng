part of 'add_user_bloc.dart';

abstract class AddUserState extends Equatable {
  const AddUserState();
}

class AddUserInitial extends AddUserState {
  @override
  List<Object> get props => [];
}

class AddUserPageLoadState extends AddUserInitial {
  @override
  List<Object> get props => [];
}

class FetchAddUserDataState extends AddUserInitial {
  final bool isLoader;
  final TextEditingController fullNameController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController districtController;
  final TextEditingController stateController;
  final List<CngStationModel> cngStationList;
  final CngStationModel cngStationData;

  FetchAddUserDataState({
    required this.isLoader,
    required this.fullNameController,
    required this.phoneNumberController,
    required this.emailController,
    required this.addressController,
    required this.cityController,
    required this.districtController,
    required this.stateController,
    required this.cngStationList,
    required this.cngStationData,
  });

  @override
  List<Object> get props => [
        isLoader,
        fullNameController,
        phoneNumberController,
        emailController,
        addressController,
        cityController,
        districtController,
        cngStationData,
        cngStationList,
      ];
}
