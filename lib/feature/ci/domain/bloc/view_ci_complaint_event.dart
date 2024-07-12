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
  const ViewCiComplaintVendorAssignEvent({
    required this.context, required this.cngData});
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

class ViewCiComplaintSelectedDateRangeEvent
    extends ViewCiComplaintEvent {
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
  const ViewCiComplaintEstimateApproveEvent({
    required this.context, required this.cngData});
  @override
  List<Object?> get props => [context, cngData];
}
