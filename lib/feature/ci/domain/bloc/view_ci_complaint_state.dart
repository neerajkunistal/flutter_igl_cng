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
  final bool isFilterLoader;

  FetchViewCiComplaintDataState({
    required this.cngList,
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
  });
  @override
  List<Object> get props => [
    cngList,
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
  ];
}