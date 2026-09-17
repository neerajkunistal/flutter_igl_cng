
part of 'add_acknowledge_market_complaint_bloc.dart';

abstract class AddAcknowledgeMarketComplaintEvent extends Equatable {
  const AddAcknowledgeMarketComplaintEvent();
}

class AddAcknowledgeMarketComplaintPageLoadEvent extends AddAcknowledgeMarketComplaintEvent {
  final BuildContext context;
  final int selectedTabIndex;
  final ComplaintMarketModel acknowledgeData;
  final EquipmentComplaintType equipmentComplaintType;

  const AddAcknowledgeMarketComplaintPageLoadEvent(
      {required this.context, required this.acknowledgeData, required this.equipmentComplaintType, required this.selectedTabIndex});

  @override
  List<Object?> get props => [context, acknowledgeData, equipmentComplaintType,selectedTabIndex];
}


class AddAcknowledgeMarketComplaintSelectDataEvent extends AddAcknowledgeMarketComplaintEvent {
  final BuildContext context;
  const AddAcknowledgeMarketComplaintSelectDataEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddAcknowledgeMarketComplaintSelectComplaintDataEvent extends AddAcknowledgeMarketComplaintEvent {
  final ComplaintTypeModel complaintTypeData;
  const AddAcknowledgeMarketComplaintSelectComplaintDataEvent({required this.complaintTypeData});
  @override
  List<Object?> get props => [complaintTypeData];
}

class AddAcknowledgeMarketComplaintSelectEquipmentDataEvent extends AddAcknowledgeMarketComplaintEvent {
  final EquipmentTypeModel equipmentTypeData;
  const AddAcknowledgeMarketComplaintSelectEquipmentDataEvent({required this.equipmentTypeData});

  @override
  List<Object?> get props => [equipmentTypeData];
}

class AddAcknowledgeMarketComplaintSelectComplaintEvent extends AddAcknowledgeMarketComplaintEvent {
  final ComplaintModel complaintData;

  const AddAcknowledgeMarketComplaintSelectComplaintEvent({required this.complaintData});

  @override
  List<Object?> get props => [complaintData];
}

class AddAcknowledgeMarketComplaintSelectReviewComplaintEvent extends AddAcknowledgeMarketComplaintEvent {
  final ReviewComplaintModel reviewComplaintData;

  const AddAcknowledgeMarketComplaintSelectReviewComplaintEvent({required this.reviewComplaintData});

  @override
  List<Object?> get props => [reviewComplaintData];
}

class AddAcknowledgeMarketComplaintSelectDepartmentEvent extends AddAcknowledgeMarketComplaintEvent {
  final DepartmentModel departmentData;

  const AddAcknowledgeMarketComplaintSelectDepartmentEvent({required this.departmentData});

  @override
  List<Object?> get props => [departmentData];
}

class AddAcknowledgeMarketComplaintSelectedPlannerEvent extends AddAcknowledgeMarketComplaintEvent {
  final PlannerModel plannerData;

  const AddAcknowledgeMarketComplaintSelectedPlannerEvent({required this.plannerData});

  @override
  List<Object?> get props => [plannerData];
}

class AddAcknowledgeMarketComplaintSelectedWorkCenterEvent extends AddAcknowledgeMarketComplaintEvent {
  final WorkCenterModel workCenterData;

  const AddAcknowledgeMarketComplaintSelectedWorkCenterEvent({required this.workCenterData});

  @override
  List<Object?> get props => [workCenterData];
}

class AddAcknowledgeMarketComplaintSelectUserEvent extends AddAcknowledgeMarketComplaintEvent {
  final AcknowledgeUserModel acknowledgeUserData;
  const AddAcknowledgeMarketComplaintSelectUserEvent({required this.acknowledgeUserData});

  @override
  List<Object?> get props => [acknowledgeUserData];
}

class AddAcknowledgeMarketComplaintSelectAcknowledgeComplaintEvent extends AddAcknowledgeMarketComplaintEvent {
  final ComplaintMarketModel acknowledgeData;

  const AddAcknowledgeMarketComplaintSelectAcknowledgeComplaintEvent({required this.acknowledgeData});

  @override
  List<Object?> get props => [acknowledgeData];
}

class AddAcknowledgeMarketComplaintSelectBreakDownEvent extends AddAcknowledgeMarketComplaintEvent {
  final String breakeDown;
  const AddAcknowledgeMarketComplaintSelectBreakDownEvent({required this.breakeDown});

  @override
  List<Object?> get props => [breakeDown];
}

class AddAcknowledgeMarketComplaintAddImageEvent extends AddAcknowledgeMarketComplaintEvent {
  final BuildContext context;
  final int mediaType;

  const AddAcknowledgeMarketComplaintAddImageEvent({required this.context, required this.mediaType});

  @override
  List<Object?> get props => [context, mediaType];
}

class AddAcknowledgeMarketComplaintSelectTimeData extends AddAcknowledgeMarketComplaintEvent {
  final BuildContext context;

  const AddAcknowledgeMarketComplaintSelectTimeData({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddAcknowledgeMarketComplaintSelectDateData extends AddAcknowledgeMarketComplaintEvent {
  final BuildContext context;

  const AddAcknowledgeMarketComplaintSelectDateData({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddAcknowledgeMarketComplaintSelectStatusData extends AddAcknowledgeMarketComplaintEvent {
  final String complaintStatus;

  const AddAcknowledgeMarketComplaintSelectStatusData({required this.complaintStatus});

  @override
  List<Object?> get props => [complaintStatus];
}

class AddAcknowledgeMarketComplaintSelectGeneralDataEvent extends AddAcknowledgeMarketComplaintEvent {
  final GeneralComplaintModel generalComplaintData;

  const AddAcknowledgeMarketComplaintSelectGeneralDataEvent({required this.generalComplaintData});

  @override
  List<Object?> get props => [generalComplaintData];
}

class AddAcknowledgeMarketComplaintSelectDescriptionDataEvent extends AddAcknowledgeMarketComplaintEvent {
  final ComplaintDescriptionModel complaintDescriptionData;
  const AddAcknowledgeMarketComplaintSelectDescriptionDataEvent({required this.complaintDescriptionData});

  @override
  List<Object?> get props => [complaintDescriptionData];
}

class AddAcknowledgeMarketComplaintSubmitEvent extends AddAcknowledgeMarketComplaintEvent {
  final BuildContext context;
  const AddAcknowledgeMarketComplaintSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddAcknowledgeMarketComplaintSelectVendorDataEvent extends AddAcknowledgeMarketComplaintEvent {
  final VendorMarketModel vendorMarketData;
  const AddAcknowledgeMarketComplaintSelectVendorDataEvent({required this.vendorMarketData});

  @override
  List<Object?> get props => [vendorMarketData];
}
