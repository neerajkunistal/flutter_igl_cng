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
  final TextEditingController lcvEntryTimeController;
  final TextEditingController fillStartTimeController;
  final TextEditingController flowMeterReadingOpenController;
  final TextEditingController flowMeterReadingClosedController;
  final TextEditingController fillEndTimeController;
  final TextEditingController outPressureController;
  final TextEditingController remarkController;
  final TextEditingController unscheduledMaintenancePenaltyHoursController;
  final TextEditingController scheduledMaintenancePenaltyHoursController;
  final List<File> fileList;
  final bool isLcvCondition;
  final bool isDriverFitDrive;
  final bool isLcvLogBookCorrection;
  final bool isAvailabilityMobileWithDriver;
  final bool isUnscheduledMaintenancePenaltyHours;
  final bool isScheduledMaintenancePenaltyHours;

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
    required this.lcvEntryTimeController,
    required this.fillStartTimeController,
    required this.flowMeterReadingOpenController,
    required this.flowMeterReadingClosedController,
    required this.fillEndTimeController,
    required this.outPressureController,
    required this.remarkController,
    required this.fileList,
    required this.isLcvCondition,
    required this.isDriverFitDrive,
    required this.isLcvLogBookCorrection,
    required this.isAvailabilityMobileWithDriver,
    required this.isUnscheduledMaintenancePenaltyHours,
    required this.isScheduledMaintenancePenaltyHours,
    required this.scheduledMaintenancePenaltyHoursController,
    required this.unscheduledMaintenancePenaltyHoursController
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
        lcvEntryTimeController,
        fillStartTimeController,
        flowMeterReadingOpenController,
        flowMeterReadingClosedController,
        fillEndTimeController,
        outPressureController,
        remarkController,
        fileList,
        isLcvCondition,
        isDriverFitDrive,
        isLcvLogBookCorrection,
        isAvailabilityMobileWithDriver,
        isUnscheduledMaintenancePenaltyHours,
        isScheduledMaintenancePenaltyHours,
        scheduledMaintenancePenaltyHoursController,
        unscheduledMaintenancePenaltyHoursController,
      ];
}
