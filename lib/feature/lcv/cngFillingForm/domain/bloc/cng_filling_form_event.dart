part of 'cng_filling_form_bloc.dart';

abstract class CngFillingFormEvent extends Equatable {
  const CngFillingFormEvent();
}

class CngFillingFormSetAssignmentDataEvent extends CngFillingFormEvent {
  final AssignmentModel assignmentData;

  const CngFillingFormSetAssignmentDataEvent({required this.assignmentData});

  @override
  List<Object?> get props => [assignmentData];
}

class CngFillingFormSetDriverNoDataEvent extends CngFillingFormEvent {
  final String drivingLicence;

  const CngFillingFormSetDriverNoDataEvent({required this.drivingLicence});

  @override
  List<Object?> get props => [drivingLicence];
}

class CngFillingFormSetTruckNoDataEvent extends CngFillingFormEvent {
  final String truckNumber;

  const CngFillingFormSetTruckNoDataEvent({required this.truckNumber});

  @override
  List<Object?> get props => [truckNumber];
}

class CngFillingFormPageLoadEvent extends CngFillingFormEvent {
  final BuildContext context;

  CngFillingFormPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class CngFillingFormSubmitEvent extends CngFillingFormEvent {
  final BuildContext context;
  final bool isMismatch;

  CngFillingFormSubmitEvent({required this.context, required this.isMismatch});

  @override
  List<Object?> get props => [context, isMismatch];
}
