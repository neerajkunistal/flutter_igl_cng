part of 'review_complaint_bloc.dart';

abstract class ReviewComplaintState extends Equatable {
  const ReviewComplaintState();
}

class ReviewComplaintInitial extends ReviewComplaintState {
  @override
  List<Object> get props => [];
}

class ReviewComplaintPageLoadState extends ReviewComplaintInitial {
  @override
  List<Object> get props => [];
}

class FetchReviewComplaintDataState extends ReviewComplaintState {
  final bool isLoader;
  final List<ReviewComplaintModel> reviewComplaintList;
  final ReviewComplaintModel reviewComplaintData;
  final String approvalValue;
  final TextEditingController observationController;
  final TextEditingController closeDateController;
  final TextEditingController closeTimeController;
  final TextEditingController rectifiedByController;
  final List<File> files;
  final bool isNoScrap;

  const FetchReviewComplaintDataState({
    required this.isLoader,
    required this.files,
    required this.observationController,
    required this.approvalValue,
    required this.reviewComplaintData,
    required this.reviewComplaintList,
    required this.closeDateController,
    required this.closeTimeController,
    required this.rectifiedByController,
    required this.isNoScrap,
  });

  @override
  List<Object> get props => [
        isLoader,
        files,
        observationController,
        approvalValue,
        reviewComplaintData,
        reviewComplaintList,
        closeDateController,
        closeTimeController,
        rectifiedByController,
        isNoScrap,
      ];
}
