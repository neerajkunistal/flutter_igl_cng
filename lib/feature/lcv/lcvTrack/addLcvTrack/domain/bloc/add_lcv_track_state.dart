part of 'add_lcv_track_bloc.dart';

abstract class AddLcvTrackState extends Equatable {
  const AddLcvTrackState();
}

class AddLcvTrackInitial extends AddLcvTrackState {
  @override
  List<Object> get props => [];
}

class AddLcvTrackPageLoadState extends AddLcvTrackInitial {
  @override
  List<Object> get props => [];
}

class FetchAddLcvTrackDataState extends AddLcvTrackInitial {
  final bool isLoader;
  final TextEditingController vehicleCompanyController;
  final TextEditingController vehicleNameController;
  final TextEditingController vehicleNumberController;
  final TextEditingController engineNumberController;
  final TextEditingController chassisNumberController;
  final TextEditingController averageController;
  final List<FuelTypeModel> fuelTypeList;
  final FuelTypeModel fuelTypeData;

  FetchAddLcvTrackDataState({
    required this.fuelTypeList,
    required this.isLoader,
    required this.averageController,
    required this.chassisNumberController,
    required this.engineNumberController,
    required this.fuelTypeData,
    required this.vehicleCompanyController,
    required this.vehicleNameController,
    required this.vehicleNumberController,
  });

  @override
  List<Object> get props => [
        fuelTypeList,
        isLoader,
        averageController,
        chassisNumberController,
        engineNumberController,
        fuelTypeData,
        vehicleCompanyController,
        vehicleNameController,
        vehicleNumberController,
      ];
}
