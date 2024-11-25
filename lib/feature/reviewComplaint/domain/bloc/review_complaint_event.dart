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

class ReviewComplaintRemoveImageEvent extends ReviewComplaintEvent {
  final int index;
  const ReviewComplaintRemoveImageEvent({required this.index});

  @override
  List<Object?> get props => [index];
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

class ReviewComplaintSelectScrapData extends ReviewComplaintEvent {
  final bool isNoScrap;

  const ReviewComplaintSelectScrapData({required this.isNoScrap});

  @override
  List<Object?> get props => [isNoScrap];
}

class ReviewComplaintSelectSapCodeEvent extends ReviewComplaintEvent {
  final SapCodeModel sapCodeData;

  const ReviewComplaintSelectSapCodeEvent({required this.sapCodeData});

  @override
  List<Object?> get props => [sapCodeData];
}

class ReviewComplaintSelectCodeGroupEvent extends ReviewComplaintEvent {
  final CodeGroupModel codeGroupData;

  const ReviewComplaintSelectCodeGroupEvent({required this.codeGroupData});

  @override
  List<Object?> get props => [codeGroupData];
}

class ReviewComplaintSubmitEvent extends ReviewComplaintEvent {
  final BuildContext context;

  const ReviewComplaintSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
