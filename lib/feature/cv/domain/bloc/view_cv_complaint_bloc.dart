import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/ci/domain/model/complaint_status.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/helper/view_cng_helper.dart';
import 'package:flutter_igl_cng/feature/cv/helper/view_cv_complaint_helper.dart';

part 'view_cv_complaint_event.dart';
part 'view_cv_complaint_state.dart';

class ViewCvComplaintBloc extends Bloc<ViewCvComplaintEvent, ViewCvComplaintState> {
  List<CngModel> cngList =  [];
  List<ComplaintStatus> complaintStatusList = [];
  ComplaintStatus complaintStatusData =  ComplaintStatus();
  bool isLoader =  false;
  TextEditingController amountController =  TextEditingController();
  File files =  File("");

  ViewCvComplaintBloc() : super(ViewCvComplaintInitial()) {
    on<ViewCvComplaintPageLoadEvent>(_pageLoad);
    on<ViewCvComplaintSelectComplaintStatusEvent>(_selectComplaintStatus);
    on<ViewCvComplaintSelectFileEvent>(_selectFile);
    on<ViewCvComplaintSubmitEvent>(_submit);
  }

  _pageLoad(ViewCvComplaintPageLoadEvent event, emit) async {
    emit(ViewCvComplaintPageLoadState());
    cngList =  [];
    complaintStatusList =  ComplaintStatus.getComplaintData();
    complaintStatusData =  ComplaintStatus();
    isLoader =  false;
    files =  File("");
    amountController.text = "";
    var res =  await ViewCngHelper.fetchCngCivilData();
    if(res != null){
      cngList =  res;
    }
    _eventComplete(emit);
  }

  _selectComplaintStatus(ViewCvComplaintSelectComplaintStatusEvent event, emit) {
    complaintStatusData =  event.complaintStatusData;
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

  _submit(ViewCvComplaintSubmitEvent event, emit) async {
    isLoader =  true;
    _eventComplete(emit);
    var res =  await ViewCvComplaintHelper.addEstimateData(cngData: event.cngData,
        amount: amountController.text.toString(), context: event.context, file: files);
    if(res != null){
      Navigator.of(!event.context.mounted ? event.context : event.context).pop("Complete");
    }
    isLoader =  false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewCvComplaintState>emit) {
    emit(FetchViewCvComplaintDataState(
        cngList: cngList,
        complaintStatusList: complaintStatusList,
        complaintStatusData: complaintStatusData,
        isLoader: isLoader,
        amountController: amountController,
        file: files,
    ));
  }
}
