part of 'add_assignment_bloc.dart';

abstract class AddAssignmentEvent extends Equatable {
  const AddAssignmentEvent();
}

class AddAssignmentPageLoadEvent extends AddAssignmentEvent {
  final BuildContext context;
  const AddAssignmentPageLoadEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class AddAssignmentSetAssignmentDataEvent extends AddAssignmentEvent {
  final AssignmentModel assignmentData;
  const AddAssignmentSetAssignmentDataEvent({required this.assignmentData});
  @override
  List<Object?> get props => [assignmentData];
}

class AddAssignmentSelectDateTimeEvent extends AddAssignmentEvent {
  final BuildContext context;
  const AddAssignmentSelectDateTimeEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class AddAssignmentSelectLcvEntryTimeEvent extends AddAssignmentEvent {
  final BuildContext context;
  const AddAssignmentSelectLcvEntryTimeEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class AddAssignmentSelectFillStartTimeEvent extends AddAssignmentEvent {
  final BuildContext context;
  const AddAssignmentSelectFillStartTimeEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class AddAssignmentSelectFillEndTimeEvent extends AddAssignmentEvent {
  final BuildContext context;
  const AddAssignmentSelectFillEndTimeEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class AddAssignmentSetMotherStationDataEvent extends AddAssignmentEvent {
  final MotherStationModel motherStationData;

  const AddAssignmentSetMotherStationDataEvent(
      {required this.motherStationData});

  @override
  List<Object?> get props => [motherStationData];
}

class AddAssignmentSetDriverDataEvent extends AddAssignmentEvent {
  final DriverModel driverData;

  const AddAssignmentSetDriverDataEvent({required this.driverData});

  @override
  List<Object?> get props => [driverData];
}

class AddAssignmentSetCngStationDataEvent extends AddAssignmentEvent {
  final CngStationModel cngStationData;
  final BuildContext context;

  const AddAssignmentSetCngStationDataEvent(
      {required this.cngStationData, required this.context});

  @override
  List<Object?> get props => [cngStationData, context];
}

class AddAssignmentSetLcvTrackDataEvent extends AddAssignmentEvent {
  final LcvTruckModel lcvData;

  const AddAssignmentSetLcvTrackDataEvent({required this.lcvData});

  @override
  List<Object?> get props => [lcvData];
}

class AddAssignmentAddMoreCngStationDataEvent extends AddAssignmentEvent {
  final bool isAddCNGStationButton;

  const AddAssignmentAddMoreCngStationDataEvent(
      {required this.isAddCNGStationButton});

  @override
  List<Object?> get props => [isAddCNGStationButton];
}

class AddAssignmentAddStationEvent extends AddAssignmentEvent {
  final BuildContext context;

  const AddAssignmentAddStationEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddAssignmentRemoveStationEvent extends AddAssignmentEvent {
  final int index;

  const AddAssignmentRemoveStationEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class AddAssignmentStationSequenceChangeEvent extends AddAssignmentEvent {
  final List<StationModel> stationList;

  const AddAssignmentStationSequenceChangeEvent({required this.stationList});

  @override
  List<Object?> get props => [stationList];
}

class AddAssignmentSetDriverNoDataEvent extends AddAssignmentEvent {
  final String drivingLicence;
  final BuildContext context;

  const AddAssignmentSetDriverNoDataEvent(
      {required this.drivingLicence, required this.context});

  @override
  List<Object?> get props => [drivingLicence, context];
}

class AddAssignmentSetTruckNoDataEvent extends AddAssignmentEvent {
  final String truckNumber;
  final BuildContext context;

  const AddAssignmentSetTruckNoDataEvent(
      {required this.truckNumber, required this.context});

  @override
  List<Object?> get props => [truckNumber, context];
}

class AddAssignmentSetStationRouteDataEvent extends AddAssignmentEvent {
  final CngStationRouteModel cngStationRouteData;

  const AddAssignmentSetStationRouteDataEvent(
      {required this.cngStationRouteData});

  @override
  List<Object?> get props => [cngStationRouteData];
}

class AddAssignmentSetCheckListEventEvent extends AddAssignmentEvent {
  final int checkList;
  final bool isSelected;
  const AddAssignmentSetCheckListEventEvent(
      {required this.checkList, required this.isSelected});
  @override
  List<Object?> get props => [checkList,  isSelected];
}

class AddAssignmentSelectImageEvent extends AddAssignmentEvent {
  final BuildContext context;
  final int mediaType;
  const AddAssignmentSelectImageEvent({required this.context, required this.mediaType});
  @override
  List<Object?> get props => [context, mediaType];
}

class AddAssignmentDeleteImageEvent extends AddAssignmentEvent {
  final int index;
  const AddAssignmentDeleteImageEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class AddAssignmentSubmitEvent extends AddAssignmentEvent {
  final BuildContext context;

  const AddAssignmentSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
