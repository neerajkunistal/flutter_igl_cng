part of 'review_complaint_market_bloc.dart';

abstract class ReviewComplaintMarketEvent extends Equatable {
  const ReviewComplaintMarketEvent();
}

class ReviewComplaintMarketPageLoadEvent extends ReviewComplaintMarketEvent {
  final BuildContext context;
  final String? complaintId;
  final EquipmentComplaintType equipmentComplaintType;
  final ComplaintMarketModel? complaintMarketData;

  const ReviewComplaintMarketPageLoadEvent(
      {required this.context,
        required this.equipmentComplaintType,
        required this.complaintMarketData,
        this.complaintId});

  @override
  List<Object?> get props => [context,equipmentComplaintType,complaintMarketData];
}

class ReviewComplaintMarketSelectComplaintEvent extends ReviewComplaintMarketEvent {
  final ReviewComplaintModel reviewComplaintData;

  const ReviewComplaintMarketSelectComplaintEvent(
      {required this.reviewComplaintData});

  @override
  List<Object?> get props => [reviewComplaintData];
}

class ReviewComplaintMarketSelectApprovalEvent extends ReviewComplaintMarketEvent {
  final String approvalValue;

  const ReviewComplaintMarketSelectApprovalEvent({required this.approvalValue});

  @override
  List<Object?> get props => [approvalValue];
}

class ReviewComplaintMarketAddImageEvent extends ReviewComplaintMarketEvent {
  final BuildContext context;
  final int mediaType;
  final int index;

  const ReviewComplaintMarketAddImageEvent(
      {required this.context, required this.mediaType, required this.index});

  @override
  List<Object?> get props => [context, mediaType];
}

class ReviewComplaintMarketRemoveImageEvent extends ReviewComplaintMarketEvent {
  final int index;
  const ReviewComplaintMarketRemoveImageEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class ReviewComplaintMarketSelectTimeData extends ReviewComplaintMarketEvent {
  final BuildContext context;

  const ReviewComplaintMarketSelectTimeData({required this.context});

  @override
  List<Object?> get props => [context];
}

class ReviewComplaintMarketSelectDateData extends ReviewComplaintMarketEvent {
  final BuildContext context;

  const ReviewComplaintMarketSelectDateData({required this.context});

  @override
  List<Object?> get props => [context];
}

class ReviewComplaintMarketSelectScrapData extends ReviewComplaintMarketEvent {
  final bool isNoScrap;

  const ReviewComplaintMarketSelectScrapData({required this.isNoScrap});

  @override
  List<Object?> get props => [isNoScrap];
}

class ReviewComplaintMarketSelectSapCodeEvent extends ReviewComplaintMarketEvent {
  final SapCodeModel sapCodeData;

  const ReviewComplaintMarketSelectSapCodeEvent({required this.sapCodeData});

  @override
  List<Object?> get props => [sapCodeData];
}

class ReviewComplaintMarketSelectCodeGroupEvent extends ReviewComplaintMarketEvent {
  final CodeGroupModel codeGroupData;

  const ReviewComplaintMarketSelectCodeGroupEvent({required this.codeGroupData});

  @override
  List<Object?> get props => [codeGroupData];
}

class ReviewComplaintMarketDeleteScarpEvent extends ReviewComplaintMarketEvent {
  final int index;

  const ReviewComplaintMarketDeleteScarpEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class ReviewComplaintMarketClearDeleteEvent extends ReviewComplaintMarketEvent {

  @override
  List<Object?> get props => [];
}


class ReviewComplaintMarketDeletePartEvent extends ReviewComplaintMarketEvent {
  final int index;

  const ReviewComplaintMarketDeletePartEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class ReviewComplaintMarketSubmitEvent extends ReviewComplaintMarketEvent {
  final BuildContext context;

  const ReviewComplaintMarketSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
