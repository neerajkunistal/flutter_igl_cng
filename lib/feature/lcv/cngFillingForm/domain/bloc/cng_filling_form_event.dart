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
  const CngFillingFormPageLoadEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class CngFillingArrivalTimeEvent extends CngFillingFormEvent {
  final BuildContext context;
  const CngFillingArrivalTimeEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class CngFillingLcvPointTimeEvent extends CngFillingFormEvent {
  final BuildContext context;
  const CngFillingLcvPointTimeEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class CngFillingFillEndTimeEvent extends CngFillingFormEvent {
  final BuildContext context;
  const CngFillingFillEndTimeEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class CngFillingSelectPhotoEvent extends CngFillingFormEvent {
  final BuildContext context;
  final int mediaType;
  const CngFillingSelectPhotoEvent({required this.context, required this.mediaType});
  @override
  List<Object?> get props => [context, mediaType];
}

class CngFillingDeletePhotoEvent extends CngFillingFormEvent {
  final int index;
  const CngFillingDeletePhotoEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class CngFillingCheckListEvent extends CngFillingFormEvent {
  final bool isSelected;
  final int checklist;
  const CngFillingCheckListEvent({required this.isSelected, required this.checklist});
  @override
  List<Object?> get props => [isSelected, checklist];
}


class CngFillingFormSubmitEvent extends CngFillingFormEvent {
  final BuildContext context;
  final bool isMismatch;

  const CngFillingFormSubmitEvent({required this.context, required this.isMismatch});

  @override
  List<Object?> get props => [context, isMismatch];
}
