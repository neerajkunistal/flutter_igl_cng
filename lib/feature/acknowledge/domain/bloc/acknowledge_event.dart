part of 'acknowledge_bloc.dart';

abstract class AcknowledgeEvent extends Equatable {
  const AcknowledgeEvent();
}

class AcknowledgePageLoadEvent extends AcknowledgeEvent {
  final BuildContext context;
  final int selectTabIndex;

  const AcknowledgePageLoadEvent({required this.context,
   required this.selectTabIndex
  });

  @override
  List<Object?> get props => [context, selectTabIndex];
}

class AcknowledgeUserListLoadEvent extends AcknowledgeEvent {
  final BuildContext context;

  const AcknowledgeUserListLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}



class AcknowledgeSelectUserEvent extends AcknowledgeEvent {
  final AcknowledgeUserModel acknowledgeUserData;

  const AcknowledgeSelectUserEvent({required this.acknowledgeUserData});

  @override
  List<Object?> get props => [acknowledgeUserData];
}

class AcknowledgeSelectDepartmentEvent extends AcknowledgeEvent {
  final DepartmentModel departmentData;

  const AcknowledgeSelectDepartmentEvent({required this.departmentData});

  @override
  List<Object?> get props => [departmentData];
}

class AcknowledgeSelectSapCodeEvent extends AcknowledgeEvent {
  final SapCodeModel sapCodeData;

  const AcknowledgeSelectSapCodeEvent({required this.sapCodeData});

  @override
  List<Object?> get props => [sapCodeData];
}

class AcknowledgeSelectVendorEvent extends AcknowledgeEvent {
  final VendorModel vendorData;

  const AcknowledgeSelectVendorEvent({required this.vendorData});

  @override
  List<Object?> get props => [vendorData];
}

class AcknowledgeSelectAssignTypeEvent extends AcknowledgeEvent {
  final AssignTypeModel assignTypeData;

  const AcknowledgeSelectAssignTypeEvent({required this.assignTypeData});

  @override
  List<Object?> get props => [assignTypeData];
}

class AcknowledgeComplaintSearchEvent extends AcknowledgeEvent {
  final String keyword;

  const AcknowledgeComplaintSearchEvent({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class AcknowledgeComplaintSelectedTabIndexEvent extends AcknowledgeEvent {
  final int selectedTabIndex;

  const AcknowledgeComplaintSelectedTabIndexEvent(
      {required this.selectedTabIndex});

  @override
  List<Object?> get props => [selectedTabIndex];
}

class AcknowledgeSelectClosedDateEvent extends AcknowledgeEvent {
  final BuildContext context;

  const AcknowledgeSelectClosedDateEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AcknowledgeSelectClosedTimeEvent extends AcknowledgeEvent {
  final BuildContext context;

  const AcknowledgeSelectClosedTimeEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AcknowledgeSelectDateRangeEvent extends AcknowledgeEvent {
  final BuildContext context;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isTimerCondition;

  const AcknowledgeSelectDateRangeEvent({
    required this.context,
    required this.fromDate,
    required this.toDate,
    required this.isTimerCondition,
  });

  @override
  List<Object?> get props => [context];
}

class AcknowledgeComplaintSelectedPlannerEvent extends AcknowledgeEvent {
  final PlannerModel plannerData;

  const AcknowledgeComplaintSelectedPlannerEvent(
      {required this.plannerData});

  @override
  List<Object?> get props => [plannerData];
}
class AcknowledgeComplaintSelectedWorkCenterEvent extends AcknowledgeEvent {
  final WorkCenterModel workCenterData;

  const AcknowledgeComplaintSelectedWorkCenterEvent(
      {required this.workCenterData});

  @override
  List<Object?> get props => [workCenterData];
}



class AcknowledgeUserSubmitEvent extends AcknowledgeEvent {
  final BuildContext context;
  final AcknowledgeModel acknowledgeData;

  const AcknowledgeUserSubmitEvent({
    required this.context,
    required this.acknowledgeData,
  });

  @override
  List<Object?> get props => [context, acknowledgeData];
}
