part of 'view_ci_complaint_bloc.dart';

sealed class ViewCiComplaintState extends Equatable {
  const ViewCiComplaintState();
}

final class ViewCiComplaintInitial extends ViewCiComplaintState {
  @override
  List<Object> get props => [];
}

final class ViewCiComplaintPageLoadState extends ViewCiComplaintInitial {
  @override
  List<Object> get props => [];
}

final class FetchViewCiComplaintDataState extends ViewCiComplaintInitial {
  final List<CngModel> cngList;
  final List<CngModel> cngAllItemsList;
  final List<VendorModel> vendorList;
  final VendorModel vendorData;
  final List<ComplaintStatus> complaintStatusList;
  final ComplaintStatus complaintStatusData;
  final bool isVendorListLoader;
  final bool isVendorAssignLoader;
  final TextEditingController remarkController;
  final TextEditingController searchController;
  final TextEditingController fromDateController;
  final TextEditingController toDateController;
  final TextEditingController reasonForRejectionController;
  final DateTime finalDate;
  final bool isFilterLoader;
  final int listIndex;
  final int tabIndex;
  final bool isStationLoader;
  final List<StationModel> stationList;
  final StationModel stationData;
  final TextEditingController stationController;
  final TextEditingController filterDateController;
  final TextEditingController estimateRemarkController;
  final TextEditingController amountRemarkController;
  final List<ControlRoomModel> controlRoomList;
  final ControlRoomModel controlRoomData;
  final String selectedVendorId;
  final bool isSendToReview;


  FetchViewCiComplaintDataState({
    required this.cngList,
    required this.cngAllItemsList,
    required this.vendorData,
    required this.vendorList,
    required this.complaintStatusList,
    required this.complaintStatusData,
    required this.isVendorListLoader,
    required this.isVendorAssignLoader,
    required this.remarkController,
    required this.searchController,
    required this.fromDateController,
    required this.toDateController,
    required this.isFilterLoader,
    required this.listIndex,
    required this.tabIndex,
    required this.isStationLoader,
    required this.stationData,
    required this.stationList,
    required this.stationController,
    required this.finalDate,
    required this.filterDateController,
    required this.controlRoomList,
    required this.controlRoomData,
    required this.estimateRemarkController,
    required this.amountRemarkController,
    required this.selectedVendorId,
    required this.isSendToReview,
    required this.reasonForRejectionController,
  });

  @override
  List<Object> get props => [
        cngList,
        cngAllItemsList,
        vendorData,
        vendorList,
        complaintStatusList,
        complaintStatusData,
        isVendorListLoader,
        isVendorAssignLoader,
        remarkController,
        searchController,
        fromDateController,
        toDateController,
        isFilterLoader,
        listIndex,
        tabIndex,
        isStationLoader,
        stationData,
        stationList,
        stationController,
        finalDate,
        filterDateController,
        controlRoomList,
        controlRoomData,
        estimateRemarkController,
        amountRemarkController,
        selectedVendorId,
        isSendToReview,
        reasonForRejectionController,
      ];
}
