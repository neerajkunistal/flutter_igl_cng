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
  final List<File> files;

  const FetchReviewComplaintDataState({
    required this.isLoader,
    required this.files,
    required this.observationController,
    required this.approvalValue,
    required this.reviewComplaintData,
    required this.reviewComplaintList,
  });

  @override
  List<Object> get props => [
        isLoader,
        files,
        observationController,
        approvalValue,
        reviewComplaintData,
        reviewComplaintList,
      ];
}
