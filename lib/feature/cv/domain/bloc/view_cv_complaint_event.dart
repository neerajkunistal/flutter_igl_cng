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

  const ViewCvComplaintSelectComplaintStatusEvent(
      {required this.complaintStatusData});

  @override
  List<Object?> get props => [complaintStatusData];
}

class ViewCvComplaintSelectFileEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final int mediaType;

  const ViewCvComplaintSelectFileEvent(
      {required this.context, required this.mediaType});

  @override
  List<Object?> get props => [context, mediaType];
}

class ViewCvComplaintSubmitEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final CngModel cngData;

  const ViewCvComplaintSubmitEvent(
      {required this.context, required this.cngData});

  @override
  List<Object?> get props => [context, cngData];
}

class ViewCvComplaintSelectCngDataEvent extends ViewCvComplaintEvent {
  final CngModel cngData;

  const ViewCvComplaintSelectCngDataEvent(
      {required this.cngData});

  @override
  List<Object?> get props => [cngData];
}

class ViewCvComplaintSearchDataEvent extends ViewCvComplaintEvent {
  final String keyword;

  const ViewCvComplaintSearchDataEvent({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class ViewCvComplaintSelectedDateRangeEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final DateTime fromDate;
  final DateTime toDate;

  const ViewCvComplaintSelectedDateRangeEvent(
      {required this.context, required this.fromDate, required this.toDate});

  @override
  List<Object?> get props => [context];
}

class ViewCvComplaintMeasurementSelectFileEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final int mediaType;

  const ViewCvComplaintMeasurementSelectFileEvent(
      {required this.context, required this.mediaType});

  @override
  List<Object?> get props => [context, mediaType];
}

class ViewCvComplaintMeasurementDeleteFileEvent extends ViewCvComplaintEvent {
  final int index;

  const ViewCvComplaintMeasurementDeleteFileEvent(
      {required this.index});

  @override
  List<Object?> get props => [index];
}

class ViewCvComplaintMeasurementSheetSelectFileEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final int mediaType;

  const ViewCvComplaintMeasurementSheetSelectFileEvent(
      {required this.context, required this.mediaType});

  @override
  List<Object?> get props => [context, mediaType];
}

class ViewCvComplaintSubmitMeasurementEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final CngModel cngData;

  const ViewCvComplaintSubmitMeasurementEvent(
      {required this.context, required this.cngData});

  @override
  List<Object?> get props => [context, cngData];
}
