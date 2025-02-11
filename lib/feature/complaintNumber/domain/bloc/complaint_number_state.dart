part of 'complaint_number_bloc.dart';

sealed class ComplaintNumberState extends Equatable {
  const ComplaintNumberState();
}

final class ComplaintNumberInitial extends ComplaintNumberState {
  @override
  List<Object> get props => [];
}

final class ComplaintNumberPageState extends ComplaintNumberInitial {
  @override
  List<Object> get props => [];
}

final class FetchComplaintNumberDataState extends ComplaintNumberInitial {
  final bool isLoader;
  final TextEditingController complaintNumberController;
  final String assignType;
  final String complaintId;
  final String vendorComplaintNumber;
  final String complaintNumber;

  FetchComplaintNumberDataState({
   required this.assignType,
   required this.complaintNumberController,
   required this.isLoader,
   required this.complaintId,
   required this.vendorComplaintNumber,
   required this.complaintNumber,
});

  @override
  List<Object> get props => [
    assignType,
    complaintNumberController,
    isLoader,
    complaintId,
    vendorComplaintNumber,
    complaintNumber,
  ];
}