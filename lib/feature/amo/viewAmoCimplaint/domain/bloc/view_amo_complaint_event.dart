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

  const ViewAmoComplaintSelectComplaintStatusEvent(
      {required this.complaintStatusData});

  @override
  List<Object?> get props => [complaintStatusData];
}

class ViewAmoComplaintSubmitEvent extends ViewAmoComplaintEvent {
  final BuildContext context;
  final CngModel cngData;

  const ViewAmoComplaintSubmitEvent(
      {required this.context, required this.cngData});

  @override
  List<Object?> get props => [context, cngData];
}

class ViewAmoComplaintSearchDataEvent extends ViewAmoComplaintEvent {
  final String keyword;

  const ViewAmoComplaintSearchDataEvent({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class ViewAmoComplaintSelectIndexEvent extends ViewAmoComplaintEvent {
  final int listIndex;
  const ViewAmoComplaintSelectIndexEvent({required this.listIndex});
  @override
  List<Object?> get props => [listIndex];
}

class ViewAmoComplaintSelectTabEvent extends ViewAmoComplaintEvent {
  final int tabIndex;
  const ViewAmoComplaintSelectTabEvent({required this.tabIndex});
  @override
  List<Object?> get props => [tabIndex];
}

class ViewAmoComplaintSelectedDateRangeEvent extends ViewAmoComplaintEvent {
  final BuildContext context;
  final DateTime fromDate;
  final DateTime toDate;

  const ViewAmoComplaintSelectedDateRangeEvent(
      {required this.context, required this.fromDate, required this.toDate});

  @override
  List<Object?> get props => [context];
}
