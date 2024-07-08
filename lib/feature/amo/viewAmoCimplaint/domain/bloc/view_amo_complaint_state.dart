part of 'view_amo_complaint_bloc.dart';

sealed class ViewAmoComplaintState extends Equatable {
  const ViewAmoComplaintState();
}

final class ViewAmoComplaintInitial extends ViewAmoComplaintState {
  @override
  List<Object> get props => [];
}

final class ViewAmoComplaintPageLoadState extends ViewAmoComplaintInitial {
  @override
  List<Object> get props => [];
}

final class FetchViewAmoComplaintDataState extends ViewAmoComplaintInitial {
  final List<CngModel> cngList;
  final List<ComplaintStatus> complaintStatusList;
  final ComplaintStatus complaintStatusData;
  final bool isLoader;
  FetchViewAmoComplaintDataState({
    required this.cngList,
    required this.complaintStatusData,
    required this.complaintStatusList,
    required this.isLoader
  });
  @override
  List<Object> get props => [
    cngList,
    complaintStatusData,
    complaintStatusList,
    isLoader,
  ];
}