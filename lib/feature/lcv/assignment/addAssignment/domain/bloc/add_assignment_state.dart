part of 'add_assignment_bloc.dart';

abstract class AddAssignmentState extends Equatable {
  const AddAssignmentState();
}

class AddAssignmentInitial extends AddAssignmentState {
  @override
  List<Object> get props => [];
}

class AddAssignmentPageLoadState extends AddAssignmentInitial {
  @override
  List<Object> get props => [];
}

class FetchAddAssignmentDataState extends AddAssignmentInitial {
  final bool isLoader;
  final List<DriverModel> driverList;
  final DriverModel driverData;
  final List<CngStationModel> cngStationList;
  final CngStationModel cngStationData;
  final bool isAddCngStation;
  final List<StationModel> stationList;
  final TextEditingController cngQuantityController;
  final TextEditingController totalCngQuantityController;
  final TextEditingController scheduleDateTimeController;
  final List<LcvTruckModel> lcvList;
  final LcvTruckModel lcvData;
  final List<MotherStationModel> motherStationList;
  final MotherStationModel motherStationData;
  final List<CngStationRouteModel> cngStationRouteList;
  final CngStationRouteModel cngStationRouteData;
  final bool isRouteLoader;

  FetchAddAssignmentDataState({
    required this.isLoader,
    required this.driverList,
    required this.driverData,
    required this.cngStationList,
    required this.cngStationData,
    required this.isAddCngStation,
    required this.stationList,
    required this.lcvList,
    required this.lcvData,
    required this.cngQuantityController,
    required this.totalCngQuantityController,
    required this.scheduleDateTimeController,
    required this.motherStationList,
    required this.motherStationData,
    required this.cngStationRouteList,
    required this.cngStationRouteData,
    required this.isRouteLoader,
  });

  @override
  List<Object> get props => [
        isLoader,
        driverList,
        driverData,
        cngStationList,
        cngStationData,
        isAddCngStation,
        stationList,
        cngQuantityController,
        totalCngQuantityController,
        lcvList,
        lcvData,
        scheduleDateTimeController,
        motherStationList,
        motherStationData,
        cngStationRouteList,
        cngStationRouteData,
        isRouteLoader,
      ];
}
