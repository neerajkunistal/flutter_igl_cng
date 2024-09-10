import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

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
  List<File> files = [];

  String _complaintId = "";

  String get complaintId => _complaintId;
  bool isNoScrap =  false;

  ReviewComplaintBloc() : super(ReviewComplaintInitial()) {
    on<ReviewComplaintPageLoadEvent>(_pageLoadEvent);
    on<ReviewComplaintSelectComplaintEvent>(_selectComplaint);
    on<ReviewComplaintSelectApprovalEvent>(_selectApproval);
    on<ReviewComplaintSelectScrapData>(_selectScrap);
    on<ReviewComplaintAddImageEvent>(_selectFile);
    on<ReviewComplaintSelectDateData>(_selectDate);
    on<ReviewComplaintSelectTimeData>(_selectTime);
    on<ReviewComplaintSubmitEvent>(_submit);
  }

  _pageLoadEvent(ReviewComplaintPageLoadEvent event, emit) async {
    emit(ReviewComplaintPageLoadState());
    isLoader = false;
    reviewComplaintList = [];
    reviewComplaintData = ReviewComplaintModel();
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

    _complaintId = event.complaintId ?? "";
    reviewComplaintList =
        BlocProvider.of<ViewEquipmentComplaintBloc>(event.context)
            .reviewComplaintList;
    for (var reviewData in reviewComplaintList) {
      if (event.reviewComplaintData.id.toString() == reviewData.id.toString()) {
        reviewComplaintData = reviewData;
      }
    }
    BlocProvider.of<AddScrapBloc>(!event.context.mounted ? event.context : event.context).add(
        AddScrapClearScrapDataEvent(context: !event.context.mounted ? event.context : event.context));
    _eventComplete(emit);
  }

  _selectComplaint(ReviewComplaintSelectComplaintEvent event, emit) {
    reviewComplaintData = event.reviewComplaintData;
    _eventComplete(emit);
  }

  _selectApproval(ReviewComplaintSelectApprovalEvent event, emit) {
    approvalValue = event.approvalValue;
    if(approvalValue == "1"){
      isNoScrap =  true;
    } else {
      isNoScrap =  false;
    }
    _eventComplete(emit);
  }

  _selectScrap(ReviewComplaintSelectScrapData event, emit) {
    isNoScrap =  event.isNoScrap;
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
    isLoader = false;
    _eventComplete(emit);
  }

  _selectDate(ReviewComplaintSelectDateData event, emit) async {
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

  _selectTime(ReviewComplaintSelectTimeData event, emit) async {
    try {
      DateTime initialDate = closeTimeController.text.toString().isNotEmpty
          ? DateFormat('h:mm').parse(closeTimeController.text.toString())
          : DateTime.now();

      TimeOfDay initialTime = TimeOfDay.fromDateTime(initialDate);
      final TimeOfDay? time = await showTimePicker(
        context: event.context,
        initialTime: initialTime,
      );
      if (time != null) {
        var timeFormat = TimeOfDay(hour: time.hour, minute: time.minute)
            .format(!event.context.mounted ? event.context : event.context);
        closeTimeController.text = timeFormat;
        _eventComplete(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _submit(ReviewComplaintSubmitEvent event, emit) async {
    isLoader = true;
    _eventComplete(emit);

    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    var res = userData.roleType == RoleType.shiftEngineer
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
          scrapList: BlocProvider.of<AddScrapBloc>(!event.context.mounted ? event.context : event.context).scrapList,
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
          scrapList: BlocProvider.of<AddScrapBloc>(!event.context.mounted ? event.context : event.context).scrapList,

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
    ));
  }
}
