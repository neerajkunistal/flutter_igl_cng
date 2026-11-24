part of 'acknowledge_market_bloc.dart';


abstract class AcknowledgeMarketEvent extends Equatable {
  const AcknowledgeMarketEvent();
}

class AcknowledgeMarketPageLoadEvent extends AcknowledgeMarketEvent {
  final BuildContext context;
  final int selectTabIndex;
  final EquipmentComplaintType equipmentComplaintType;

  const AcknowledgeMarketPageLoadEvent({required this.context,
   required this.selectTabIndex,
   required this.equipmentComplaintType,
  });

  @override
  List<Object?> get props => [context, selectTabIndex, equipmentComplaintType];
}

class AcknowledgeMarketUserListLoadEvent extends AcknowledgeMarketEvent {
  final BuildContext context;

  const AcknowledgeMarketUserListLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}



class AcknowledgeMarketSelectUserEvent extends AcknowledgeMarketEvent {
  final AcknowledgeUserModel acknowledgeUserData;

  const AcknowledgeMarketSelectUserEvent({required this.acknowledgeUserData});

  @override
  List<Object?> get props => [acknowledgeUserData];
}

class AcknowledgeMarketSelectDepartmentEvent extends AcknowledgeMarketEvent {
  final DepartmentModel departmentData;

  const AcknowledgeMarketSelectDepartmentEvent({required this.departmentData});

  @override
  List<Object?> get props => [departmentData];
}

class AcknowledgeMarketSelectSapCodeEvent extends AcknowledgeMarketEvent {
  final SapCodeModel sapCodeData;

  const AcknowledgeMarketSelectSapCodeEvent({required this.sapCodeData});

  @override
  List<Object?> get props => [sapCodeData];
}

class AcknowledgeMarketSelectVendorEvent extends AcknowledgeMarketEvent {
  final VendorModel vendorData;

  const AcknowledgeMarketSelectVendorEvent({required this.vendorData});

  @override
  List<Object?> get props => [vendorData];
}

class AcknowledgeMarketSelectAssignTypeEvent extends AcknowledgeMarketEvent {
  final AssignTypeModel assignTypeData;

  const AcknowledgeMarketSelectAssignTypeEvent({required this.assignTypeData});

  @override
  List<Object?> get props => [assignTypeData];
}

class AcknowledgeMarketComplaintSearchEvent extends AcknowledgeMarketEvent {
  final String keyword;

  const AcknowledgeMarketComplaintSearchEvent({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class AcknowledgeMarketComplaintSelectedMarketTabIndexEvent extends AcknowledgeMarketEvent {
  final int selectedTabMarketIndex;

  const AcknowledgeMarketComplaintSelectedMarketTabIndexEvent(
      {required this.selectedTabMarketIndex});

  @override
  List<Object?> get props => [selectedTabMarketIndex];
}



class AcknowledgeMarketSelectClosedDateEvent extends AcknowledgeMarketEvent {
  final BuildContext context;

  const AcknowledgeMarketSelectClosedDateEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AcknowledgeMarketSelectClosedTimeEvent extends AcknowledgeMarketEvent {
  final BuildContext context;

  const AcknowledgeMarketSelectClosedTimeEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AcknowledgeMarketSelectDateRangeEvent extends AcknowledgeMarketEvent {
  final BuildContext context;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isTimerCondition;

  const AcknowledgeMarketSelectDateRangeEvent({
    required this.context,
    required this.fromDate,
    required this.toDate,
    required this.isTimerCondition,
  });

  @override
  List<Object?> get props => [context];
}

class AcknowledgeMarketComplaintSelectedPlannerEvent extends AcknowledgeMarketEvent {
  final PlannerModel plannerData;

  const AcknowledgeMarketComplaintSelectedPlannerEvent(
      {required this.plannerData});

  @override
  List<Object?> get props => [plannerData];
}
class AcknowledgeMarketComplaintSelectedWorkCenterEvent extends AcknowledgeMarketEvent {
  final WorkCenterModel workCenterData;

  const AcknowledgeMarketComplaintSelectedWorkCenterEvent(
      {required this.workCenterData});

  @override
  List<Object?> get props => [workCenterData];
}



class AcknowledgeMarketUserSubmitEvent extends AcknowledgeMarketEvent {
  final BuildContext context;
  final ComplaintMarketModel acknowledgeData;

  const AcknowledgeMarketUserSubmitEvent({
    required this.context,
    required this.acknowledgeData,
  });

  @override
  List<Object?> get props => [context, acknowledgeData];
}

class AcknowledgeMarketComplaintPageLoadEvent extends AddAcknowledgeComplaintEvent {
  final BuildContext context;
  final ComplaintMarketModel acknowledgeData;
  final EquipmentComplaintType equipmentComplaintType;

  const AcknowledgeMarketComplaintPageLoadEvent({
    required this.context,
    required this.acknowledgeData,
    required this.equipmentComplaintType,
  });

  @override
  List<Object?> get props => [context, acknowledgeData, equipmentComplaintType];
}