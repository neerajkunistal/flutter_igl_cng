import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
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
  File file = File("");

  ReviewComplaintBloc() : super(ReviewComplaintInitial()) {
    on<ReviewComplaintPageLoadEvent>(_pageLoadEvent);
    on<ReviewComplaintSelectComplaintEvent>(_selectComplaint);
    on<ReviewComplaintSelectApprovalEvent>(_selectApproval);
    on<ReviewComplaintAddImageEvent>(_selectFile);
    on<ReviewComplaintSubmitEvent>(_submit);
  }

  _pageLoadEvent(ReviewComplaintPageLoadEvent event, emit) async {
    emit(ReviewComplaintPageLoadState());
    isLoader = false;
    reviewComplaintList = [];
    reviewComplaintData = ReviewComplaintModel();
    approvalValue = "";
    observationController.text = "";
    file = File("");

    reviewComplaintList =
        BlocProvider.of<ViewEquipmentComplaintBloc>(event.context)
            .reviewComplaintList;
    for (var reviewData in reviewComplaintList) {
      if (event.reviewComplaintData.id.toString() == reviewData.id.toString()) {
        reviewComplaintData = reviewData;
      }
    }

    _eventComplete(emit);
  }

  _selectComplaint(ReviewComplaintSelectComplaintEvent event, emit) {
    reviewComplaintData = event.reviewComplaintData;
    _eventComplete(emit);
  }

  _selectApproval(ReviewComplaintSelectApprovalEvent event, emit) {
    approvalValue = event.approvalValue;
    _eventComplete(emit);
  }

  _selectFile(ReviewComplaintAddImageEvent event, emit) async {
    if (event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if (photo != null) {
        file = photo;
      }
    } else {
      var photo = await DashboardHelper.filePiker(context: event.context);
      if (photo != null) {
        file = photo;
      }
    }
    Navigator.pop(event.context.mounted ? event.context : event.context);
    _eventComplete(emit);
  }

  _submit(ReviewComplaintSubmitEvent event, emit) async {
    isLoader = true;
    _eventComplete(emit);

    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    var res = userData.roleType == RoleType.shiftEngineer
        ? await ReviewComplaintHelper.submit(
            context: event.context,
            reviewComplaintData: reviewComplaintData,
            approvalValue: approvalValue,
            observation: observationController.text.toString(),
            file: file)
        : await ReviewComplaintHelper.reviewComplaint(
            context: event.context,
            reviewComplaintData: reviewComplaintData,
            approvalValue: approvalValue,
            observation: observationController.text.toString(),
            file: file);
    if (res != null) {
      isLoader = false;
      reviewComplaintData = ReviewComplaintModel();
      approvalValue = "";
      observationController.text = "";
      file = File("");
      if (!event.context.mounted) return;
      Navigator.pop(event.context, "Completed");
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ReviewComplaintState> emit) {
    emit(FetchReviewComplaintDataState(
      isLoader: isLoader,
      file: file,
      observationController: observationController,
      approvalValue: approvalValue,
      reviewComplaintData: reviewComplaintData,
      reviewComplaintList: reviewComplaintList,
    ));
  }
}
