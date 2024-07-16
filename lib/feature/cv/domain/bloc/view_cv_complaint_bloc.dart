import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/ci/domain/model/complaint_status.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/helper/view_cng_helper.dart';
import 'package:flutter_igl_cng/feature/cv/helper/view_cv_complaint_helper.dart';

part 'view_cv_complaint_event.dart';

part 'view_cv_complaint_state.dart';

class ViewCvComplaintBloc
    extends Bloc<ViewCvComplaintEvent, ViewCvComplaintState> {
  List<CngModel> cngList = [];
  List<CngModel> cngSearchList = [];
  List<ComplaintStatus> complaintStatusList = [];
  ComplaintStatus complaintStatusData = ComplaintStatus();
  bool isLoader = false;
  bool isFilterLoader = false;
  TextEditingController amountController = TextEditingController();
  File files = File("");
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List<File> measurementFileList = [];
  File measurementFileSheet = File("");
  CngModel cngData =  CngModel();

  ViewCvComplaintBloc() : super(ViewCvComplaintInitial()) {
    on<ViewCvComplaintPageLoadEvent>(_pageLoad);
    on<ViewCvComplaintSearchDataEvent>(_search);
    on<ViewCvComplaintSelectedDateRangeEvent>(_selectDate);
    on<ViewCvComplaintSelectComplaintStatusEvent>(_selectComplaintStatus);
    on<ViewCvComplaintSelectFileEvent>(_selectFile);
    on<ViewCvComplaintSelectCngDataEvent>(_selectCngData);
    on<ViewCvComplaintMeasurementSelectFileEvent>(_selectMeasurementPhoto);
    on<ViewCvComplaintMeasurementDeleteFileEvent>(_deleteMeasurementFilePhoto);
    on<ViewCvComplaintMeasurementSheetSelectFileEvent>(_selectMeasurementSheet);
    on<ViewCvComplaintSubmitEvent>(_submit);
    on<ViewCvComplaintSubmitMeasurementEvent>(_submitMeasurement);
  }

  _pageLoad(ViewCvComplaintPageLoadEvent event, emit) async {
    emit(ViewCvComplaintPageLoadState());
    cngList = [];
    cngSearchList = [];
    measurementFileList = [];
    measurementFileSheet = File("");
    complaintStatusList = ComplaintStatus.getComplaintData();
    complaintStatusData = ComplaintStatus();
    isLoader = false;
    isFilterLoader = false;
    files = File("");
    amountController.text = "";
    cngData =  CngModel();
    startDate = DateTime.now().subtract(const Duration(days: 4));
    endDate = DateTime.now();
    var res = await ViewCngHelper.fetchCngCivilData(
        fromDate: startDate.toString(), toDate: endDate.toString());
    if (res != null) {
      cngList = res;
      cngSearchList = res;
    }
    _eventComplete(emit);
  }

  _search(ViewCvComplaintSearchDataEvent event, emit) async {
    cngList = [];
    _eventComplete(emit);
    if (event.keyword.isNotEmpty) {
      cngList = cngSearchList
          .where((element) => element.complaintNumber
              .toString()
              .toLowerCase()
              .contains(event.keyword.toUpperCase().toLowerCase()))
          .toList();
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.incidentDateTime
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.reportBy
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.complaintStatus
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.complaintDescription
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
    } else {
      cngList = cngSearchList;
    }

    _eventComplete(emit);
  }

  _selectDate(ViewCvComplaintSelectedDateRangeEvent event, emit) async {
    cngList = [];
    cngSearchList = [];
    isFilterLoader = true;
    _eventComplete(emit);
    startDate = event.fromDate;
    endDate = event.toDate;
    var res = await ViewCngHelper.fetchCngCivilData(
        fromDate: event.fromDate.toString(), toDate: event.toDate.toString());
    if (res != null) {
      cngList = res;
      cngSearchList = res;
    }
    isFilterLoader = false;
    _eventComplete(emit);
  }

  _selectComplaintStatus(
      ViewCvComplaintSelectComplaintStatusEvent event, emit) {
    complaintStatusData = event.complaintStatusData;
    _eventComplete(emit);
  }

  _selectCngData(ViewCvComplaintSelectCngDataEvent event, emit) {
    cngData =  event.cngData;
    _eventComplete(emit);
  }

  _selectFile(ViewCvComplaintSelectFileEvent event, emit) async {
    if (event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        files = photo;
      }
    } else {
      var photo = await DashboardHelper.filePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        files = photo;
      }
    }
    Navigator.pop(event.context.mounted ? event.context : event.context);
    isLoader = false;
    _eventComplete(emit);
  }

  _selectMeasurementPhoto(ViewCvComplaintMeasurementSelectFileEvent event, emit) async {

    if (event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        measurementFileList.add(photo);
      }
    } else {
      var photo = await DashboardHelper.filePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        measurementFileList.add(photo);
      }
    }
    Navigator.pop(event.context.mounted ? event.context : event.context);
    isLoader = false;
    _eventComplete(emit);
  }

  _deleteMeasurementFilePhoto(ViewCvComplaintMeasurementDeleteFileEvent event, emit) {
    isLoader = true;
    _eventComplete(emit);
    measurementFileList.removeAt(event.index);

    isLoader = false;
    _eventComplete(emit);
  }

  _selectMeasurementSheet(ViewCvComplaintMeasurementSheetSelectFileEvent event, emit) async {
    if (event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        measurementFileSheet = photo;
      }
    } else {
      var photo = await DashboardHelper.filePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        measurementFileSheet = photo;
      }
    }
    Navigator.pop(event.context.mounted ? event.context : event.context);
    isLoader = false;
    _eventComplete(emit);

  }

  _submit(ViewCvComplaintSubmitEvent event, emit) async {
    if(amountController.text.toString().isEmpty){
      SnackBarErrorWidget(event.context).show(message: "Please enter estimate amount");
      return;
    }
    isLoader = true;
    _eventComplete(emit);
    var res = await ViewCvComplaintHelper.addEstimateData(
        cngData: event.cngData,
        amount: amountController.text.toString(),
        context: event.context,
        file: files);
    if (res != null) {
      Navigator.of(!event.context.mounted ? event.context : event.context)
          .pop("Complete");
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _submitMeasurement(ViewCvComplaintSubmitMeasurementEvent event, emit) async {
    isLoader = true;
    _eventComplete(emit);
    var res = await ViewCvComplaintHelper.addMeasurementData(
        cngData: event.cngData,
        amount: amountController.text.toString(),
        context: event.context,
        measurementFileList: measurementFileList,
        measurementSheetFile: measurementFileSheet,
    );
    if (res != null) {
      Navigator.of(!event.context.mounted ? event.context : event.context)
          .pop("Complete");
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewCvComplaintState> emit) {
    emit(FetchViewCvComplaintDataState(
      cngList: cngList,
      complaintStatusList: complaintStatusList,
      complaintStatusData: complaintStatusData,
      isLoader: isLoader,
      amountController: amountController,
      file: files,
      isFilterLoader: isFilterLoader,
      cngData: cngData,
      measurementFileList: measurementFileList,
      measurementFileSheet: measurementFileSheet,
    ));
  }
}
