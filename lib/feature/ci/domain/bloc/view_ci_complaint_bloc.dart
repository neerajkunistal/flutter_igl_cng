import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/vendor_model.dart';
import 'package:flutter_igl_cng/feature/ci/domain/model/complaint_status.dart';
import 'package:flutter_igl_cng/feature/ci/helper/view_ci_complaint_helper.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/helper/view_cng_helper.dart';

part 'view_ci_complaint_event.dart';
part 'view_ci_complaint_state.dart';

class ViewCiComplaintBloc extends Bloc<ViewCiComplaintEvent, ViewCiComplaintState> {
  List<CngModel> cngList =  [];
  List<VendorModel> vendorList  = [];
  VendorModel vendorData = VendorModel();
  List<ComplaintStatus> complaintStatusList = [];
  ComplaintStatus complaintStatusData =  ComplaintStatus();
  bool isVendorListLoader =  false;
  bool isVendorAssignLoader =  false;
  TextEditingController remarkController =  TextEditingController();

  ViewCiComplaintBloc() : super(ViewCiComplaintInitial()) {
    on<ViewCiComplaintPageLoadEvent>(_pageLoad);
    on<ViewCiComplaintFetchVendorEvent>(_fetchVendor);
    on<ViewCiComplaintVendorAssignEvent>(_assignVendor);
    on<ViewCiComplaintSelectVendorEvent>(_selectVendor);
    on<ViewCiComplaintStatusDataEvent>(_selectComplaintStatus);
    on<ViewCiComplaintEstimateApproveEvent>(_estimateApprove);
  }

  _pageLoad(ViewCiComplaintPageLoadEvent event, emit) async {
    emit(ViewCiComplaintPageLoadState());
    cngList =  [];
    vendorList  = [];
    complaintStatusList = ComplaintStatus.getComplaintData();
    vendorData = VendorModel();
    isVendorListLoader =  false;
    isVendorAssignLoader =  false;
    complaintStatusData =  ComplaintStatus();
    remarkController.text = "";
    var res =  await ViewCngHelper.fetchCngCivilData();
    if(res != null){
      cngList =  res;
    }
    _eventComplete(emit);
  }

  _fetchVendor(ViewCiComplaintFetchVendorEvent event, emit) async {
    isVendorListLoader =  true;
    vendorData =  VendorModel();
    _eventComplete(emit);
    var res =  await ViewCiComplaintHelper.fetchVendor();
    if(res != null){
      vendorList =  res;
    }
    isVendorListLoader =  false;
    _eventComplete(emit);
  }

  _selectVendor(ViewCiComplaintSelectVendorEvent event, emit) {
    vendorData = event.vendorData;
    _eventComplete(emit);
  }

  _assignVendor(ViewCiComplaintVendorAssignEvent event, emit) async {
    isVendorAssignLoader =  true;
    _eventComplete(emit);
    var res =  await ViewCiComplaintHelper.assignVendor(cngData: event.cngData,
        vendorData: vendorData, context: event.context);
    if(res != null){
      Navigator.of(!event.context.mounted ? event.context : event.context).pop("Complete");
    }
    isVendorAssignLoader =  false;
    _eventComplete(emit);
  }

  _selectComplaintStatus(ViewCiComplaintStatusDataEvent event, emit) {
    complaintStatusData =  event.complaintStatusData;
    _eventComplete(emit);
  }

  _estimateApprove(ViewCiComplaintEstimateApproveEvent event, emit) async {
    isVendorAssignLoader =  true;
    _eventComplete(emit);
    var res =  await ViewCiComplaintHelper.estimateApprove(cngData: event.cngData,
        complaintStatus: complaintStatusData, context: event.context);
    if(res != null){
      Navigator.of(!event.context.mounted ? event.context : event.context).pop("Complete");
    }
    isVendorAssignLoader =  false;
    _eventComplete(emit);

  }

  _eventComplete(Emitter<ViewCiComplaintState>emit) {
    emit(FetchViewCiComplaintDataState(
        cngList: cngList,
        vendorData: vendorData,
        vendorList: vendorList,
        complaintStatusData: complaintStatusData,
        complaintStatusList: complaintStatusList,
        isVendorListLoader: isVendorListLoader,
        isVendorAssignLoader: isVendorAssignLoader,
        remarkController: remarkController,
    ));
  }
}
