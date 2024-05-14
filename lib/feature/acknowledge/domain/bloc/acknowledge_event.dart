part of 'acknowledge_bloc.dart';

abstract class AcknowledgeEvent extends Equatable {
  const AcknowledgeEvent();
}

class AcknowledgePageLoadEvent extends AcknowledgeEvent {
  final BuildContext context;

  const AcknowledgePageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
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
