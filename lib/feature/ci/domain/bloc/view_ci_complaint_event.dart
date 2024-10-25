part of 'view_ci_complaint_bloc.dart';

sealed class ViewCiComplaintEvent extends Equatable {
  const ViewCiComplaintEvent();
}

class ViewCiComplaintPageLoadEvent extends ViewCiComplaintEvent {
  @override
  List<Object?> get props => [];
}

class ViewCiComplaintSelectVendorEvent extends ViewCiComplaintEvent {
  final VendorModel vendorData;

  const ViewCiComplaintSelectVendorEvent({required this.vendorData});

  @override
  List<Object?> get props => [vendorData];
}

class ViewCiComplaintFetchVendorEvent extends ViewCiComplaintEvent {
  const ViewCiComplaintFetchVendorEvent();

  @override
  List<Object?> get props => [];
}

class ViewCiComplaintVendorAssignEvent extends ViewCiComplaintEvent {
  final BuildContext context;
  final CngModel cngData;

  const ViewCiComplaintVendorAssignEvent(
      {required this.context, required this.cngData});

  @override
  List<Object?> get props => [context, cngData];
}

class ViewCiComplaintStatusDataEvent extends ViewCiComplaintEvent {
  final ComplaintStatus complaintStatusData;

  const ViewCiComplaintStatusDataEvent({required this.complaintStatusData});

  @override
  List<Object?> get props => [complaintStatusData];
}

class ViewCiComplaintSearchDataEvent extends ViewCiComplaintEvent {
  final String keyword;

  const ViewCiComplaintSearchDataEvent({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class ViewCiComplaintSearchStationEvent extends ViewCiComplaintEvent {
  final String keyword;

  const ViewCiComplaintSearchStationEvent({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class ViewCiComplaintSelectStationDataEvent extends ViewCiComplaintEvent {
  final StationModel stationData;

  const ViewCiComplaintSelectStationDataEvent({required this.stationData});

  @override
  List<Object?> get props => [stationData];
}

class ViewCiComplaintSelectListDataEvent extends ViewCiComplaintEvent {
  final int listIndex;

  const ViewCiComplaintSelectListDataEvent({required this.listIndex});

  @override
  List<Object?> get props => [listIndex];
}

class ViewCiComplaintSelectTabDataEvent extends ViewCiComplaintEvent {
  final int tabIndex;

  const ViewCiComplaintSelectTabDataEvent({required this.tabIndex});

  @override
  List<Object?> get props => [tabIndex];
}

class ViewCiComplaintFetchStationDataEvent extends ViewCiComplaintEvent {
  final BuildContext context;

  const ViewCiComplaintFetchStationDataEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class ViewCiComplaintSelectedDateRangeEvent extends ViewCiComplaintEvent {
  final BuildContext context;
  final DateTime fromDate;
  final DateTime toDate;

  const ViewCiComplaintSelectedDateRangeEvent(
      {required this.context, required this.fromDate, required this.toDate});

  @override
  List<Object?> get props => [context];
}

class ViewCiComplaintEstimateApproveEvent extends ViewCiComplaintEvent {
  final BuildContext context;
  final CngModel cngData;

  const ViewCiComplaintEstimateApproveEvent(
      {required this.context, required this.cngData});

  @override
  List<Object?> get props => [context, cngData];
}

class ViewCiComplaintSelectControlRoomDataEvent extends ViewCiComplaintEvent {
  final ControlRoomModel controlRoomData;

  const ViewCiComplaintSelectControlRoomDataEvent(
      {required this.controlRoomData,});

  @override
  List<Object?> get props => [controlRoomData];
}


class ViewCiComplaintFinalApproveDateEvent extends ViewCiComplaintEvent {
  final DateTime date;

  const ViewCiComplaintFinalApproveDateEvent(
      {required this.date,});

  @override
  List<Object?> get props => [date];
}

class ViewCiComplaintFilterSubmitEvent extends ViewCiComplaintEvent {
  final bool isFilterSubmit;

  const ViewCiComplaintFilterSubmitEvent(
      {required this.isFilterSubmit,});

  @override
  List<Object?> get props => [isFilterSubmit];
}

class ViewCiComplaintSelectVendorTableValueEvent extends ViewCiComplaintEvent {
  final String selectedVendorId;

  const ViewCiComplaintSelectVendorTableValueEvent(
      {required this.selectedVendorId,});

  @override
  List<Object?> get props => [selectedVendorId];
}

class ViewCiComplaintSendToReviewEvent extends ViewCiComplaintEvent {
  final bool isSendToReview;

  const ViewCiComplaintSendToReviewEvent(
      {required this.isSendToReview,});

  @override
  List<Object?> get props => [isSendToReview];
}

class ViewCiComplaintFinalApproveEvent extends ViewCiComplaintEvent {
  final BuildContext context;
  final CngModel cngData;

  const ViewCiComplaintFinalApproveEvent(
      {required this.context, required this.cngData});

  @override
  List<Object?> get props => [context, cngData];
}

