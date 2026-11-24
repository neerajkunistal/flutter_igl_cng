part of 'review_complaint_market_bloc.dart';

abstract class ReviewComplaintMarketState extends Equatable {
  const ReviewComplaintMarketState();
}

class ReviewComplaintMarketInitial extends ReviewComplaintMarketState {
  @override
  List<Object> get props => [];
}

class ReviewComplaintMarketPageLoadState extends ReviewComplaintMarketInitial {
  @override
  List<Object> get props => [];
}

class FetchReviewComplaintMarketDataState extends ReviewComplaintMarketState {
  final bool isLoader;
  final List<ComplaintMarketModel> reviewComplaintList;
  final ComplaintMarketModel reviewComplaintData;
  final String approvalValue;
  final TextEditingController observationController;
  final TextEditingController closeDateController;
  final TextEditingController closeTimeController;
  final TextEditingController rectifiedByController;
  final List<File> files;
  final bool isNoScrap;
  final List<SapCodeModel> sapCodeList;
  final SapCodeModel sapCodeData;
  final List<CodeGroupModel> codeGroupList;
  final CodeGroupModel codeGroupData;
  final bool sapCodeLoader;
  final ComplaintMarketModel marketComplaintData;

  const FetchReviewComplaintMarketDataState({
    required this.isLoader,
    required this.files,
    required this.observationController,
    required this.approvalValue,
    required this.reviewComplaintList,
    required this.reviewComplaintData,
    required this.closeDateController,
    required this.closeTimeController,
    required this.rectifiedByController,
    required this.isNoScrap,
    required this.sapCodeData,
    required this.sapCodeList,
    required this.codeGroupList,
    required this.codeGroupData,
    required this.sapCodeLoader,
    required this.marketComplaintData,
  });

  @override
  List<Object> get props => [
    isLoader,
    files,
    observationController,
    approvalValue,
    reviewComplaintList,
    reviewComplaintData,
    closeDateController,
    closeTimeController,
    rectifiedByController,
    isNoScrap,
    sapCodeData,
    sapCodeList,
    codeGroupList,
    codeGroupData,
    sapCodeLoader,
    marketComplaintData,
  ];
}
