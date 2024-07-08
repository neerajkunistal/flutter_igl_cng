part of 'view_cv_complaint_bloc.dart';

sealed class ViewCvComplaintEvent extends Equatable {
  const ViewCvComplaintEvent();
}

class ViewCvComplaintPageLoadEvent extends ViewCvComplaintEvent {
  @override
  List<Object?> get props => [];
}

class ViewCvComplaintSelectComplaintStatusEvent extends ViewCvComplaintEvent {
  final ComplaintStatus complaintStatusData;
  const ViewCvComplaintSelectComplaintStatusEvent({required this.complaintStatusData});
  @override
  List<Object?> get props => [complaintStatusData];
}

class ViewCvComplaintSelectFileEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final int mediaType;
  const ViewCvComplaintSelectFileEvent({
    required this.context,
    required this.mediaType
  });
  @override
  List<Object?> get props => [context, mediaType];
}

class ViewCvComplaintSubmitEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final CngModel cngData;
  const ViewCvComplaintSubmitEvent({
    required this.context, required this.cngData});
  @override
  List<Object?> get props => [context, cngData];
}