import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/sap_code_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/code_group_model.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scrap_model.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/model/part_%20model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/res/environment_config.dart';

part 'review_complaint_event.dart';

part 'review_complaint_state.dart';

class ReviewComplaintBloc
    extends Bloc<ReviewComplaintEvent, ReviewComplaintState> {
  bool isLoader = false;
  List<ReviewComplaintModel> reviewComplaintList = [];
  ReviewComplaintModel reviewComplaintData = ReviewComplaintModel();
  String approvalValue = "";
  TextEditingController observationController = TextEditingController();
  TextEditingController closeDateController = TextEditingController();
  TextEditingController closeTimeController = TextEditingController();
  TextEditingController rectifiedByController = TextEditingController();
  TextEditingController actionTakenController = TextEditingController();
  TextEditingController closedByController = TextEditingController();

  List<File> files = [];

  String _complaintId = "";

  String get complaintId => _complaintId;
  bool isNoScrap = false;

  List<SapCodeModel> sapCodeList = [];
  SapCodeModel sapCodeData = SapCodeModel();

  List<CodeGroupModel> codeGroupList = [];
  CodeGroupModel codeGroupData = CodeGroupModel();

  bool sapCodeLoader = false;

  List<ScrapModel> deleteScrapList = [];
  List<PartModel> deletePartList = [];

  ReviewComplaintBloc() : super(ReviewComplaintInitial()) {
    on<ReviewComplaintPageLoadEvent>(_pageLoadEvent);
    on<ReviewComplaintDeleteScarpEvent>(_deleteScrap);
    on<ReviewComplaintDeletePartEvent>(_deletePart);
    on<ReviewComplaintSelectComplaintEvent>(_selectComplaint);
    on<ReviewComplaintSelectApprovalEvent>(_selectApproval);
    on<ReviewComplaintSelectScrapData>(_selectScrap);
    on<ReviewComplaintAddImageEvent>(_selectFile);
    on<ReviewComplaintRemoveImageEvent>(_removeImage);
    on<ReviewComplaintSelectDateData>(_selectDate);
    on<ReviewComplaintSelectTimeData>(_selectTime);
    on<ReviewComplaintSelectCodeGroupEvent>(_selectCodeGroup);
    on<ReviewComplaintSelectSapCodeEvent>(_selectSapCode);
    on<ReviewComplaintSubmitEvent>(_submit);
  }

  _pageLoadEvent(ReviewComplaintPageLoadEvent event, emit) async {
    emit(ReviewComplaintPageLoadState());
    isLoader = false;
    reviewComplaintList = [];
    reviewComplaintData = ReviewComplaintModel();
    sapCodeData = SapCodeModel();
    approvalValue = "";
    observationController.text = "";
    closeDateController.text = "";
    closeTimeController.text = "";
    rectifiedByController.text = "";
    actionTakenController.text = "";
    closedByController.text = "";
    _complaintId = "";
    files = [];
    files.add(File(""));
    files.add(File(""));
    files.add(File(""));
    isNoScrap = false;
    sapCodeLoader = false;
    codeGroupData = CodeGroupModel();

    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    closeDateController.text = formattedDate;

    closeTimeController.text =
        DateFormat('HH:mm:ss').format(DateTime.now()).toString();

    _complaintId = event.complaintId ?? "";
    reviewComplaintList =
        BlocProvider.of<ViewEquipmentComplaintBloc>(event.context)
            .reviewComplaintList;
    for (var reviewData in reviewComplaintList) {
      if (event.reviewComplaintData.id.toString() == reviewData.id.toString()) {
        reviewComplaintData = reviewData;
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

    if (codeGroupList.isEmpty) {
      var res = await ReviewComplaintHelper.fetchCodeGroupData();
      if (res != null) {
        codeGroupList = res;
      }
    }

    deleteScrapList = [];
    deletePartList = [];

    BlocProvider.of<AddScrapBloc>(
            !event.context.mounted ? event.context : event.context)
        .add(AddScrapClearScrapDataEvent(
            context: !event.context.mounted ? event.context : event.context));
    _eventComplete(emit);
  }

  _deleteScrap(ReviewComplaintDeleteScarpEvent event, emit) {
    isLoader = true;
    _eventComplete(emit);
    deleteScrapList.add(reviewComplaintData.scrapList![event.index]);
    reviewComplaintData.scrapList!.removeAt(event.index);
    isLoader = true;
    _eventComplete(emit);
  }

  _deletePart(ReviewComplaintDeletePartEvent event, emit) {
    isLoader = true;
    _eventComplete(emit);
    deletePartList.add(reviewComplaintData.partList![event.index]);
    reviewComplaintData.partList!.removeAt(event.index);
    isLoader = false;
    _eventComplete(emit);
  }

  _selectComplaint(ReviewComplaintSelectComplaintEvent event, emit) {
    reviewComplaintData = event.reviewComplaintData;
    _eventComplete(emit);
  }

  _selectApproval(ReviewComplaintSelectApprovalEvent event, emit) {
    approvalValue = event.approvalValue;
    if (approvalValue == "1") {
      isNoScrap = true;
    } else {
      isNoScrap = false;
    }
    _eventComplete(emit);
  }

  _selectScrap(ReviewComplaintSelectScrapData event, emit) {
    isNoScrap = event.isNoScrap;
    _eventComplete(emit);
  }

  _selectFile(ReviewComplaintAddImageEvent event, emit) async {
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
    log("fileDataReview--- > ${files.toString()}");
    isLoader = false;
    _eventComplete(emit);
  }

  _removeImage(ReviewComplaintRemoveImageEvent event, emit) {
    isLoader = true;
    _eventComplete(emit);
    files[event.index] = File("");
    isLoader = false;
    _eventComplete(emit);
  }

  _selectDate(ReviewComplaintSelectDateData event, emit) async {
    try {
      final DateTime? picked = await showDatePicker(
          context: event.context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
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

  _selectTime(ReviewComplaintSelectTimeData event, emit) async {
    print("close66666TimeController--->${closeTimeController.text.toString()}");
    try {
      DateTime initialDate = closeTimeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm:ss').parse(closeTimeController.text.toString())
          : DateTime.now();

      DateTime? time = await showCupertinoDatePicker(
          initialDateTime: DateTime.now(),
          mode: CupertinoDatePickerMode.dateAndTime,
          context: event.context);
      if (time != null) {
        print("closeTimeController--->${closeTimeController.text.toString()}");
        closeTimeController.text =
            DateFormat('HH:mm:ss').format(time).toString();
        _eventComplete(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectCodeGroup(ReviewComplaintSelectCodeGroupEvent event, emit) async {
    codeGroupData = event.codeGroupData;
    sapCodeList = [];
    sapCodeData = SapCodeModel();
    sapCodeLoader = true;
    _eventComplete(emit);

    var res = await AddAcknowledgeComplaintHelper.fetchSapCodeData(
        codeGroupData: codeGroupData);
    if (res != null) {
      sapCodeList = res;
    }

    sapCodeLoader = false;
    _eventComplete(emit);
  }

  _selectSapCode(ReviewComplaintSelectSapCodeEvent event, emit) {
    sapCodeData = event.sapCodeData;
    _eventComplete(emit);
  }

  _submit(ReviewComplaintSubmitEvent event, emit) async {

    isLoader = true;
    _eventComplete(emit);
    final client = AppConfig.instanceInit()!.client;
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;

    final bool isMahanagar = client == Client.mahanagar;
    final bool isHPCL = client == Client.hpcl;
    final bool isShiftEngineer = userData.roleType == RoleType.shiftEngineer;

    if (sapCodeData.code == null && isShiftEngineer && !(isMahanagar || isHPCL)) {
      SnackBarErrorWidget(event.context).show(message: "Please select sap code");
      isLoader = false;
      _eventComplete(emit);
      return;
    } else if (codeGroupData.name == null && isShiftEngineer && !(isMahanagar || isHPCL)) {
      SnackBarErrorWidget(event.context).show(message: "Please select code group");
      isLoader = false;
      _eventComplete(emit);
      return;
    } else if (closeTimeController.text.toString().isEmpty) {
      SnackBarErrorWidget(event.context).show(message: "Please enter time");
      isLoader = false;
      _eventComplete(emit);
      return;
    } else if (closedByController.text.trim().toString().isEmpty) {
      SnackBarErrorWidget(event.context).show(message: "Please enter Closed By (Person Name)");
      isLoader = false;
      _eventComplete(emit);
      return;
    } else if (actionTakenController.text.trim().toString().isEmpty) {
      SnackBarErrorWidget(event.context).show(message: "Please enter Action Taken");
      isLoader = false;
      _eventComplete(emit);
      return;
    }

    var res = isShiftEngineer
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
            personName: closedByController.text.toString(),
            actionTaken: actionTakenController.text.toString(),
            isNoScrap: isNoScrap,
            sapCodeData: sapCodeData,
            codeGroupData: codeGroupData,
            deletePartList: deletePartList,
            deletesScrapList: deleteScrapList,
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
            personName: closedByController.text.toString(),
            actionTaken: actionTakenController.text.toString(),
            files: files,
            isNoScrap: isNoScrap,
            deletePartList: deletePartList,
            deletesScrapList: deleteScrapList,
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

  _eventComplete(Emitter<ReviewComplaintState> emit) {
    emit(FetchReviewComplaintDataState(
      isLoader: isLoader,
      files: files,
      observationController: observationController,
      approvalValue: approvalValue,
      reviewComplaintData: reviewComplaintData,
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
      actionTakenController: actionTakenController,
      closedByController: closedByController,
    ));
  }
}
