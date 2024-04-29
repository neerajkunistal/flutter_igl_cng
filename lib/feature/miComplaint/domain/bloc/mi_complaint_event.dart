part of 'mi_complaint_bloc.dart';

abstract class MiComplaintEvent extends Equatable {
  const MiComplaintEvent();
}

class MiComplaintPageLoadEvent extends MiComplaintEvent {
  final BuildContext context;
  const MiComplaintPageLoadEvent({required this.context});
  @override
  List<Object?> get props => [context];
}


class MiComplaintSelectComplaintData extends MiComplaintEvent {
  final ReviewComplaintModel reviewComplaintData;
  const MiComplaintSelectComplaintData({required this.reviewComplaintData});
  @override
  List<Object?> get props => [reviewComplaintData];
}

class MiComplaintSelectSpareData extends MiComplaintEvent {
  final SparesModel sparesData;
  const MiComplaintSelectSpareData({required this.sparesData});
  @override
  List<Object?> get props => [sparesData];
}

class MiComplaintSelectApprovalData extends MiComplaintEvent {
  final String approvalValue;
  const MiComplaintSelectApprovalData({required this.approvalValue});
  @override
  List<Object?> get props => [approvalValue];
}

class MiComplaintSelectActionData extends MiComplaintEvent {
  final ActionModel actionData;
  const MiComplaintSelectActionData({required this.actionData});
  @override
  List<Object?> get props => [actionData];
}


class MiComplaintAddImageEvent extends MiComplaintEvent {
  final BuildContext context;
  final int mediaType;
  const MiComplaintAddImageEvent({required this.context, required this.mediaType});
  @override
  List<Object?> get props => [context, mediaType];
}

class MiComplaintSubmitData extends MiComplaintEvent {
  final BuildContext context;
  const MiComplaintSubmitData({required this.context});
  @override
  List<Object?> get props => [context];
}