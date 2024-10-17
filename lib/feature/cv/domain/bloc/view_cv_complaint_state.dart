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
  final TextEditingController stationController;
  final TextEditingController filterDateController;
  final List<File> file;
  final bool isFilterLoader;
  final CngModel cngData;
  final List<File> measurementFileList;
  final File measurementFileSheet;
  final int listIndex;
  final MeasurementType measurementType;
  final List<StationModel> stationList;
  final StationModel stationData;
  final bool isStationLoader;
  final List<ControlRoomModel> controlRoomList;
  final ControlRoomModel controlRoomData;
  final MeasureTypeModel measureTypeData;
  final List<MeasureTypeModel> measureTypeList;
  final TextEditingController particularController;
  final TextEditingController measureController;

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
    required this.listIndex,
    required this.measurementType,
    required this.stationList,
    required this.stationData,
    required this.isStationLoader,
    required this.stationController,
    required this.filterDateController,
    required this.controlRoomData,
    required this.controlRoomList,
    required this.measureTypeData,
    required this.measureTypeList,
    required this.particularController,
    required this.measureController,
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
        listIndex,
        measurementType,
        stationList,
        stationData,
        isStationLoader,
        stationController,
       filterDateController,
       controlRoomList,
       controlRoomData,
       measureTypeData,
       measureTypeList,
       particularController,
       measureController,
      ];
}
