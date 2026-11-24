import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/sap_code_model.dart';
import 'package:flutter_igl_cng/feature/marketing/acknowledgeMarketing/domain/model/complaint_market_list_model.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/viewEquipmentComplaint/domain/bloc/view_equipment_complaint_market_bloc.dart';
import 'package:flutter_igl_cng/feature/marketing/reviewComplaintMarket/helper/review_complaint_market_helper.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/code_group_model.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scrap_model.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/model/part_%20model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'review_complaint_market_event.dart';
part 'review_complaint_market_state.dart';

class ReviewComplaintMarketBloc
    extends Bloc<ReviewComplaintMarketEvent, ReviewComplaintMarketState> {
  bool isLoader = false;
  List<ComplaintMarketModel> reviewComplaintList = [];
  ReviewComplaintModel reviewComplaintData = ReviewComplaintModel();
  ComplaintMarketModel marketComplaintData = ComplaintMarketModel();
  String approvalValue = "";
  TextEditingController observationController = TextEditingController();
  TextEditingController closeDateController = TextEditingController();
  TextEditingController closeTimeController = TextEditingController();
  TextEditingController rectifiedByController = TextEditingController();
  List<File> files = [];

  String _complaintId = "";

  String get complaintId => _complaintId;
  bool isNoScrap =  false;

  List<SapCodeModel> sapCodeList = [];
  SapCodeModel sapCodeData = SapCodeModel();

  List<CodeGroupModel> codeGroupList = [];
  CodeGroupModel codeGroupData =  CodeGroupModel();

  bool sapCodeLoader =  false;

  List<ScrapModel> deleteScrapList = [];
  List<PartModel> deletePartList = [];
  EquipmentComplaintType equipmentComplaintType =  EquipmentComplaintType.normal;

  ReviewComplaintMarketBloc() : super(ReviewComplaintMarketInitial()) {
    on<ReviewComplaintMarketPageLoadEvent>(_pageLoadEvent);
    on<ReviewComplaintMarketDeleteScarpEvent>(_deleteScrap);
    on<ReviewComplaintMarketDeletePartEvent>(_deletePart);
    on<ReviewComplaintMarketSelectComplaintEvent>(_selectComplaint);
    on<ReviewComplaintMarketSelectApprovalEvent>(_selectApproval);
    on<ReviewComplaintMarketSelectScrapData>(_selectScrap);
    on<ReviewComplaintMarketAddImageEvent>(_selectFile);
    on<ReviewComplaintMarketRemoveImageEvent>(_removeImage);
    on<ReviewComplaintMarketSelectDateData>(_selectDate);
    on<ReviewComplaintMarketSelectTimeData>(_selectTime);
    on<ReviewComplaintMarketSelectCodeGroupEvent>(_selectCodeGroup);
    on<ReviewComplaintMarketSelectSapCodeEvent>(_selectSapCode);
    on<ReviewComplaintMarketSubmitEvent>(_submit);
  }

  _pageLoadEvent(ReviewComplaintMarketPageLoadEvent event, emit) async {
    emit(ReviewComplaintMarketPageLoadState());
    isLoader = false;
    reviewComplaintList = [];
    reviewComplaintData = ReviewComplaintModel();
    marketComplaintData = ComplaintMarketModel();
    sapCodeData = SapCodeModel();
    approvalValue = "";
    observationController.text = "";
    closeDateController.text = "";
    closeTimeController.text = "";
    rectifiedByController.text = "";
    _complaintId = "";
    files = [];
    files.add(File(""));
    files.add(File(""));
    files.add(File(""));
    isNoScrap =  false;
    sapCodeLoader =  false;
    codeGroupData =  CodeGroupModel();
    equipmentComplaintType =  event.equipmentComplaintType;

    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    closeDateController.text = formattedDate;


    closeTimeController.text =  DateFormat('HH:mm:ss').format(DateTime.now()).toString();

    _complaintId = event.complaintId ?? "";

    if (equipmentComplaintType == EquipmentComplaintType.marketing) {
      final marketList = BlocProvider.of<ViewEquipmentComplaintMarketBloc>(event.context).listOfComplaintData;
        for (var m in marketList) {
          if (m.id.toString() == _complaintId) { marketComplaintData = m; break; }
        }

    } else {
      reviewComplaintList = BlocProvider.of<ViewEquipmentComplaintMarketBloc>(event.context).listOfComplaintData;
      for (var reviewData in reviewComplaintList) {
        if (event.complaintMarketData!.id.toString() == reviewData.id.toString()) {
          marketComplaintData = reviewData;
          String stationPersonDateTime =
          reviewComplaintData.stationPersonDateTime.toString();
          if (stationPersonDateTime.isNotEmpty) {
            try {
              DateTime closerDateTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').parse(stationPersonDateTime);
              closeTimeController.text =
                  DateFormat('HH:mm:ss').format(closerDateTime).toString();
              closeDateController.text =
              "${closerDateTime.day}-${closerDateTime.month}-${closerDateTime.year}";
            } catch (_) {}
          }
          reviewComplaintData.scrapList!.addAll(deleteScrapList);
          reviewComplaintData.partList!.addAll(deletePartList);
        }
      }
    }

    if(codeGroupList.isEmpty){
      var res =  await ReviewComplaintHelper.fetchCodeGroupData();
      if(res != null){
        codeGroupList =  res;
      }
    }

    deleteScrapList = [];
    deletePartList = [];

    BlocProvider.of<AddScrapBloc>(!event.context.mounted ? event.context : event.context).add(
        AddScrapClearScrapDataEvent(context: !event.context.mounted ? event.context : event.context));
    _eventComplete(emit);
  }

  _deleteScrap(ReviewComplaintMarketDeleteScarpEvent event, emit) {
    isLoader =  true;
    _eventComplete(emit);
    deleteScrapList.add( reviewComplaintData.scrapList![event.index]);
    reviewComplaintData.scrapList!.removeAt(event.index);
    isLoader =  true;
    _eventComplete(emit);
  }

  _deletePart(ReviewComplaintMarketDeletePartEvent event, emit) {
    isLoader =  true;
    _eventComplete(emit);
    deletePartList.add(reviewComplaintData.partList![event.index]);
    reviewComplaintData.partList!.removeAt(event.index);
    isLoader =  false;
    _eventComplete(emit);
  }

  _selectComplaint(ReviewComplaintMarketSelectComplaintEvent event, emit) {
    reviewComplaintData = event.reviewComplaintData;
    _eventComplete(emit);
  }

  _selectApproval(ReviewComplaintMarketSelectApprovalEvent event, emit) {
    approvalValue = event.approvalValue;
    if(approvalValue == "1"){
      isNoScrap =  true;
    } else {
      isNoScrap =  false;
    }
    _eventComplete(emit);
  }

  _selectScrap(ReviewComplaintMarketSelectScrapData event, emit) {
    isNoScrap =  event.isNoScrap;
    _eventComplete(emit);
  }

  _selectFile(ReviewComplaintMarketAddImageEvent event, emit) async {
    if (event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        files[event.index] = photo;
      }
    } else {
      var photo = await DashboardHelper.filePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        files[event.index] = photo;
      }
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _removeImage(ReviewComplaintMarketRemoveImageEvent event, emit) {
    isLoader = true;
    _eventComplete(emit);
    files[event.index] =  File("");
    isLoader = false;
    _eventComplete(emit);
  }

  _selectDate(ReviewComplaintMarketSelectDateData event, emit) async {
    try {
      final DateTime? picked = await showDatePicker(
          context: event.context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2015, 8),
          lastDate: DateTime.now());
      if (picked != null) {
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        closeDateController.text = formattedDate;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectTime(ReviewComplaintMarketSelectTimeData event, emit) async {

    try {
      DateTime initialDate = closeTimeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm:ss').parse(closeTimeController.text.toString())
          : DateTime.now();

      DateTime? time =  await showCupertinoDatePicker(
          initialDateTime: initialDate,
          context: event.context);
      if (time != null) {
        closeTimeController.text = DateFormat('HH:mm:ss').format(time).toString();
        _eventComplete(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectCodeGroup(ReviewComplaintMarketSelectCodeGroupEvent event, emit) async {
    codeGroupData  =  event.codeGroupData;
    sapCodeList = [];
    sapCodeData =  SapCodeModel();
    sapCodeLoader =  true;
    _eventComplete(emit);

    var res = await AddAcknowledgeComplaintHelper.fetchSapCodeData(
        codeGroupData: codeGroupData);
    if (res != null) {
      sapCodeList = res;
    }

    sapCodeLoader =  false;
    _eventComplete(emit);
  }

  _selectSapCode(ReviewComplaintMarketSelectSapCodeEvent event, emit) {
    sapCodeData = event.sapCodeData;
    _eventComplete(emit);
  }



  _submit(ReviewComplaintMarketSubmitEvent event, emit) async {
    // ═══ MARKET: station close (sirf complaintId + remarks + files) ═══
    if (equipmentComplaintType == EquipmentComplaintType.marketing) {
      if (closeTimeController.text.toString().isEmpty) {
        SnackBarErrorWidget(event.context).show(message: "Please enter time");
        return;
      }

      isLoader = true;
      _eventComplete(emit);

      var res = await ReviewComplaintMarketHelper.stationCloseApi(
        context: !event.context.mounted ? event.context : event.context,
        complaintMarketModel: marketComplaintData,
        remarks: observationController.text.toString(),
        files: files,
        equipmentComplaintType: equipmentComplaintType,
      );

      if (res != null) {
        isLoader = false;
        marketComplaintData = ComplaintMarketModel();
        observationController.text = "";
        closeDateController.text = "";
        closeTimeController.text = "";
        rectifiedByController.text = "";
        files = [];
        files.add(File(""));
        files.add(File(""));
        files.add(File(""));
        closeDateController.text =
            DateFormat('dd-MM-yyyy').format(DateTime.now());
        if (!event.context.mounted) return;
        Navigator.pop(event.context, "Completed");
        return;
      }
      isLoader = false;
      _eventComplete(emit);
      return;
    }
    // ═══ NORMAL (aapka original flow, waisa hi) ═══
    isLoader = true;
    _eventComplete(emit);

    LoginDataModel userData = UserInfo.instanceInit()!.userData!;

    if(sapCodeData.code == null && userData.roleType == RoleType.shiftEngineer){
      SnackBarErrorWidget(event.context).show(message: "Please select sap code");
      isLoader = false;
      _eventComplete(emit);
      return;
    }
    else if(codeGroupData.name == null && userData.roleType == RoleType.shiftEngineer){
      SnackBarErrorWidget(event.context).show(message: "Please select code group");
      isLoader = false;
      _eventComplete(emit);
      return;
    }
    else if(closeTimeController.text.toString().isEmpty){
      SnackBarErrorWidget(event.context).show(message: "Please enter time");
      isLoader = false;
      _eventComplete(emit);
      return;
    }


    var res = userData.roleType == RoleType.shiftEngineer
        || userData.roleType == RoleType.it
        ? await ReviewComplaintHelper.submit(
      context: !event.context.mounted ? event.context : event.context,
      reviewComplaintData: reviewComplaintData,
      approvalValue: approvalValue,
      complaintId: complaintId,
      observation: observationController.text.toString(),
      files: files,
      closedDate: closeDateController.text.toString(),
      closedTime: closeTimeController.text.toString(),
      rectifyBy: rectifiedByController.text.toString(),
      isNoScrap: isNoScrap,
      sapCodeData: sapCodeData,
      codeGroupData: codeGroupData,
      deletePartList: deletePartList,
      deletesScrapList: deleteScrapList,
      equipmentComplaintType: equipmentComplaintType,
      scrapList: BlocProvider.of<AddScrapBloc>(!event.context.mounted ? event.context : event.context).scrapList,
      partList: BlocProvider.of<AddSparePartBloc>(!event.context.mounted ? event.context : event.context).partList,
    )
        : await ReviewComplaintHelper.reviewComplaint(
      context: !event.context.mounted ? event.context : event.context,
      reviewComplaintData: reviewComplaintData,
      approvalValue: approvalValue,
      observation: observationController.text.toString(),
      closedDate: closeDateController.text.toString(),
      closedTime: closeTimeController.text.toString(),
      rectifyBy: rectifiedByController.text.toString(),
      files: files,
      isNoScrap: isNoScrap,
      deletePartList: deletePartList,
      deletesScrapList: deleteScrapList,
      equipmentComplaintType: equipmentComplaintType,
      scrapList: BlocProvider.of<AddScrapBloc>(!event.context.mounted ? event.context : event.context).scrapList,
      partList: BlocProvider.of<AddSparePartBloc>(!event.context.mounted ? event.context : event.context).partList,


    );
    if (res != null) {
      isLoader = false;
      reviewComplaintData = ReviewComplaintModel();
      approvalValue = "";
      observationController.text = "";
      closeDateController.text = "";
      closeTimeController.text = "";
      rectifiedByController.text = "";
      files = [];
      files.add(File(""));
      files.add(File(""));
      files.add(File(""));
      String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      closeDateController.text = formattedDate;
      if (!event.context.mounted) return;
      Navigator.pop(event.context, "Completed");
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ReviewComplaintMarketState> emit) {
    emit(FetchReviewComplaintMarketDataState(
      isLoader: isLoader,
      files: files,
      observationController: observationController,
      approvalValue: approvalValue,
      reviewComplaintData: marketComplaintData,
      reviewComplaintList: reviewComplaintList,
      closeDateController: closeDateController,
      closeTimeController: closeTimeController,
      rectifiedByController: rectifiedByController,
      isNoScrap: isNoScrap,
      sapCodeData: sapCodeData,
      sapCodeList: sapCodeList,
      codeGroupData: codeGroupData,
      codeGroupList: codeGroupList,
      sapCodeLoader: sapCodeLoader,
      marketComplaintData: marketComplaintData,
    ));
  }
}
