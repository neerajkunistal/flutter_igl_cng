part of 'view_cv_complaint_bloc.dart';

sealed class ViewCvComplaintState extends Equatable {
  const ViewCvComplaintState();
}

final class ViewCvComplaintInitial extends ViewCvComplaintState {
  @override
  List<Object> get props => [];
}

final class ViewCvComplaintPageLoadState extends ViewCvComplaintInitial {
  @override
  List<Object> get props => [];
}

final class FetchViewCvComplaintDataState extends ViewCvComplaintInitial {
  final List<CngModel> cngList;
  final List<ComplaintStatus> complaintStatusList;
  final ComplaintStatus complaintStatusData;
  final bool isLoader;
  final TextEditingController amountController;
  final File file;
  final bool isFilterLoader;
  final CngModel cngData;
  final List<File> measurementFileList;
  final File measurementFileSheet;

  FetchViewCvComplaintDataState({
    required this.cngList,
    required this.complaintStatusData,
    required this.complaintStatusList,
    required this.isLoader,
    required this.amountController,
    required this.file,
    required this.isFilterLoader,
    required this.cngData,
    required this.measurementFileList,
    required this.measurementFileSheet,
  });

  @override
  List<Object> get props => [
        cngList,
        complaintStatusData,
        complaintStatusList,
        isLoader,
        amountController,
        file,
        isFilterLoader,
        cngData,
        measurementFileList,
        measurementFileSheet,
      ];
}
