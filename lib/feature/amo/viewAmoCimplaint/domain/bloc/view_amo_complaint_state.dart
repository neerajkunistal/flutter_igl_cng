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
  final List<CngModel> cngAllItemsList;
  final List<ComplaintStatus> complaintStatusList;
  final ComplaintStatus complaintStatusData;
  final bool isLoader;
  final bool isFilterLoader;
  final int listIndex;
  final int tabIndex;
  final List<StationModel> stationList;
  final StationModel stationData;
  final bool isStationLoader;
  final TextEditingController stationController;

  FetchViewAmoComplaintDataState({
    required this.cngList,
    required this.cngAllItemsList,
    required this.complaintStatusData,
    required this.complaintStatusList,
    required this.isLoader,
    required this.isFilterLoader,
    required this.listIndex,
    required this.tabIndex,
    required this.stationList,
    required this.stationData,
    required this.isStationLoader,
    required this.stationController,
  });

  @override
  List<Object> get props => [
        cngList,
    cngAllItemsList,
        complaintStatusData,
        complaintStatusList,
        isLoader,
        isFilterLoader,
        listIndex,
        tabIndex,
        stationList,
        stationData,
        isStationLoader,
        stationController,
      ];
}
