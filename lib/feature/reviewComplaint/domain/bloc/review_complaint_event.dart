part of 'review_complaint_bloc.dart';

abstract class ReviewComplaintEvent extends Equatable {
  const ReviewComplaintEvent();
}

class ReviewComplaintPageLoadEvent extends ReviewComplaintEvent {
  final BuildContext context;
  final String? complaintId;
  final ReviewComplaintModel reviewComplaintData;

  const ReviewComplaintPageLoadEvent(
      {required this.context,
      required this.reviewComplaintData,
      this.complaintId});

  @override
  List<Object?> get props => [context, reviewComplaintData];
}

class ReviewComplaintSelectComplaintEvent extends ReviewComplaintEvent {
  final ReviewComplaintModel reviewComplaintData;

  const ReviewComplaintSelectComplaintEvent(
      {required this.reviewComplaintData});

  @override
  List<Object?> get props => [reviewComplaintData];
}

class ReviewComplaintSelectApprovalEvent extends ReviewComplaintEvent {
  final String approvalValue;

  const ReviewComplaintSelectApprovalEvent({required this.approvalValue});

  @override
  List<Object?> get props => [approvalValue];
}

class ReviewComplaintAddImageEvent extends ReviewComplaintEvent {
  final BuildContext context;
  final int mediaType;
  final int index;

  const ReviewComplaintAddImageEvent(
      {required this.context, required this.mediaType, required this.index});

  @override
  List<Object?> get props => [context, mediaType];
}

class ReviewComplaintSelectTimeData extends ReviewComplaintEvent {
  final BuildContext context;

  const ReviewComplaintSelectTimeData({required this.context});

  @override
  List<Object?> get props => [context];
}

class ReviewComplaintSelectDateData extends ReviewComplaintEvent {
  final BuildContext context;

  const ReviewComplaintSelectDateData({required this.context});

  @override
  List<Object?> get props => [context];
}

class ReviewComplaintSubmitEvent extends ReviewComplaintEvent {
  final BuildContext context;

  const ReviewComplaintSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
