part of 'view_amo_complaint_bloc.dart';

sealed class ViewAmoComplaintEvent extends Equatable {
  const ViewAmoComplaintEvent();
}

class ViewAmoComplaintPageLoadEvent extends ViewAmoComplaintEvent {
  @override
  List<Object?> get props => [];
}

class ViewAmoComplaintSelectComplaintStatusEvent extends ViewAmoComplaintEvent {
  final ComplaintStatus complaintStatusData;
  const ViewAmoComplaintSelectComplaintStatusEvent({required this.complaintStatusData});
  @override
  List<Object?> get props => [complaintStatusData];
}

class ViewAmoComplaintSubmitEvent extends ViewAmoComplaintEvent {
  final BuildContext context;
  final CngModel cngData;
  const ViewAmoComplaintSubmitEvent({
    required this.context, required this.cngData});
  @override
  List<Object?> get props => [context, cngData];
}