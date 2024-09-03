part of 'view_assignment_bloc.dart';

abstract class ViewAssignmentEvent extends Equatable {
  const ViewAssignmentEvent();
}

class ViewAssignmentPageLoadEvent extends ViewAssignmentEvent {
  final BuildContext context;

  const ViewAssignmentPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class ViewAssignmentUpdateStatusEvent extends ViewAssignmentEvent {
  final BuildContext context;
  final int index;

  const ViewAssignmentUpdateStatusEvent(
      {required this.context, required this.index});

  @override
  List<Object?> get props => [context, index];
}

class ViewAssignmentSelectLcvDriverEvent extends ViewAssignmentEvent {
  final BuildContext context;
  final DriverModel lcvDriverData;

  const ViewAssignmentSelectLcvDriverEvent(
      {required this.context, required this.lcvDriverData});

  @override
  List<Object> get props => [context, lcvDriverData];
}

class ViewAssignmentSelectFromDateEvent extends ViewAssignmentEvent {
  final BuildContext context;

  const ViewAssignmentSelectFromDateEvent({required this.context});

  @override
  List<Object> get props => [context];
}

class ViewAssignmentSelectToDateEvent extends ViewAssignmentEvent {
  final BuildContext context;

  const ViewAssignmentSelectToDateEvent({required this.context});

  @override
  List<Object> get props => [context];
}

class ViewAssignmentFilterSubmitEvent extends ViewAssignmentEvent {
  final BuildContext context;

  const ViewAssignmentFilterSubmitEvent({required this.context});

  @override
  List<Object> get props => [context];
}

class ViewAssignmentChangeStatusEvent extends ViewAssignmentEvent {
  final AssignmentChangeStatusModel assignmentChangeStatusData;

  const ViewAssignmentChangeStatusEvent(
      {required this.assignmentChangeStatusData});

  @override
  List<Object?> get props => [assignmentChangeStatusData];
}
