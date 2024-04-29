import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/dashboard/helper/dashboard_helper.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/action_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/helper/mi_complaint_helper.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/review_complaint_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/helper/review_complaint_helper.dart';

part 'mi_complaint_event.dart';
part 'mi_complaint_state.dart';

class MiComplaintBloc extends Bloc<MiComplaintEvent, MiComplaintState> {

  List<ReviewComplaintModel> reviewComplaintList = [];
  ReviewComplaintModel reviewComplaintData =  ReviewComplaintModel();
  List<SparesModel> sparesList = [];
  SparesModel sparesData =  SparesModel();
  String approvalValue = "";
  String action =  "";
  TextEditingController observation =  TextEditingController();
  TextEditingController description =  TextEditingController();
  File file =  File("");
  bool isLoader =  false;
  List<ActionModel> actionList = [];
  ActionModel actionData =  ActionModel();

  MiComplaintBloc() : super(MiComplaintInitial()) {
    on<MiComplaintPageLoadEvent>(_pageLoad);
    on<MiComplaintSelectComplaintData>(_selectComplaint);
    on<MiComplaintSelectSpareData>(_selectSpares);
    on<MiComplaintSelectApprovalData>(_selectApproval);
    on<MiComplaintSelectActionData>(_selectAction);
    on<MiComplaintAddImageEvent>(_selectFile);
    on<MiComplaintSubmitData>(_submit);
  }

  _pageLoad(MiComplaintPageLoadEvent event, emit) async {
    emit(MiComplaintPageLoadState());
     reviewComplaintList = [];
     reviewComplaintData =  ReviewComplaintModel();
     sparesList = [];
     actionList = ActionModel().fetchData();
     actionData =  ActionModel();
     sparesData =  SparesModel();
     approvalValue = "";
     action =  "";
     observation.text = "";
     description.text = "";
     file =  File("");
     isLoader =  false;

     var res =  await MiComplaintHelper.fetchSpareData();
     if(res !=  null){
        sparesList =  res;
     }

    var resReview =  await MiComplaintHelper.fetchMiComplaint();
    if(resReview != null){
      reviewComplaintList =  resReview;
    }

    _eventComplete(emit);
  }

  _selectComplaint(MiComplaintSelectComplaintData event, emit) {
    reviewComplaintData =  event.reviewComplaintData;
    _eventComplete(emit);
  }

  _selectSpares(MiComplaintSelectSpareData event, emit) {
    sparesData =  event.sparesData;
    _eventComplete(emit);
  }

  _selectApproval(MiComplaintSelectApprovalData event, emit) {
    approvalValue = event.approvalValue;
    _eventComplete(emit);
  }

  _selectAction(MiComplaintSelectActionData event, emit) {
    actionData =  event.actionData;
    _eventComplete(emit);
  }

  _selectFile(MiComplaintAddImageEvent event, emit) async {
    if(event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if(photo != null){
        file  = photo;
      }
    } else{
      var photo = await DashboardHelper.filePiker(context: event.context);
      if(photo != null){
        file  = photo;
      }
    }
    Navigator.pop(event.context.mounted ? event.context : event.context);
    _eventComplete(emit);
  }

  _submit(MiComplaintSubmitData event, emit) async {
    isLoader = true;
    _eventComplete(emit);
    var res =  await MiComplaintHelper.submit(context: event.context,
        reviewComplaintData: reviewComplaintData, approvalValue: approvalValue,
        sparesData: sparesData, action: actionData,
        description: description.text.toString(), observation: observation.text.toString(), file: file);
    if(res != null){
      reviewComplaintData =  ReviewComplaintModel();
      sparesData =  SparesModel();
      approvalValue = "";
      action =  "";
      observation.text = "";
      description.text = "";
      file =  File("");
      isLoader =  false;
      actionData =  ActionModel();
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<MiComplaintState>emit){
    emit(FetchMiComplaintDataState(
        approvalValue: approvalValue,
        reviewComplaintData: reviewComplaintData,
        reviewComplaintList: reviewComplaintList,
        observationController: observation,
        file: file,
        descriptionController: description,
        action: action,
        sparesData: sparesData,
        sparesList: sparesList,
        isLoader: isLoader,
        actionData: actionData,
        actionList: actionList,
    ));
  }
}
