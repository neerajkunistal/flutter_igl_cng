part of 'complaint_number_bloc.dart';

sealed class ComplaintNumberEvent extends Equatable {
  const ComplaintNumberEvent();
}

class ComplaintNumberPageLoadEvent extends ComplaintNumberEvent {
  final BuildContext context;
  final String assignType;
  final String complaintId;
  final String vendorComplaintNumber;

  const ComplaintNumberPageLoadEvent({required this.context,
    required this.assignType,
    required this.complaintId,
    required this.vendorComplaintNumber,
  });

  @override
  List<Object?> get props => [context, assignType, complaintId, vendorComplaintNumber];
}

class ComplaintNumberSubmitEvent extends ComplaintNumberEvent {
  final BuildContext context;

  const ComplaintNumberSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}