import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/feature/dashboard/helper/dashboard_helper.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/complaint_type_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/equipment_type_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/helper/add_equipment_complaint_helper.dart';

part 'add_equipment_complaint_event.dart';
part 'add_equipment_complaint_state.dart';

class AddEquipmentComplaintBloc extends Bloc<AddEquipmentComplaintEvent, AddEquipmentComplaintState> {

  List<ComplaintTypeModel> complaintTypeList = [];
  ComplaintTypeModel complaintTypeData =  ComplaintTypeModel();
  EquipmentTypeModel equipmentTypeData =  EquipmentTypeModel();
  List<EquipmentTypeModel> equipmentTypeList = [];
  TextEditingController descriptionController =  TextEditingController();
  TextEditingController reportByController =  TextEditingController();
  bool isLoader =  false;
  File file =  File("");

  AddEquipmentComplaintBloc() : super(AddEquipmentComplaintInitial()) {
    on<AddEquipmentComplaintPageLoadEvent>(_pageLoad);
    on<AddEquipmentComplaintSelectComplaintDataEvent>(_selectComplaintType);
    on<AddEquipmentComplaintSelectEquipmentDataEvent>(_selectEquipment);
    on<AddEquipmentComplaintAddImageEvent>(_selectFile);
    on<AddEquipmentComplaintSubmitEvent>(_submit);
  }

  _pageLoad(AddEquipmentComplaintPageLoadEvent event, emit) async {
    emit(AddEquipmentComplaintPageLoadState());
    complaintTypeList = [];
    complaintTypeData =  ComplaintTypeModel();
    equipmentTypeData =  EquipmentTypeModel();
    equipmentTypeList = [];
    descriptionController.text = "";
    reportByController.text = "";
    isLoader =  false;
    file =  File("");

    var resComplaint =  await AddEquipmentComplaintHelper.fetchComplaintTypeData();
    if(resComplaint !=  null){
      complaintTypeList =  resComplaint;
    }

    var resEquipment =  await AddEquipmentComplaintHelper.fetchEquipmentTypeData();
    if(resEquipment != null){
      equipmentTypeList =  resEquipment;
    }
    _eventComplete(emit);
  }

  _selectComplaintType(AddEquipmentComplaintSelectComplaintDataEvent event, emit) {
    complaintTypeData =  event.complaintTypeData;
    equipmentTypeData = EquipmentTypeModel();
    _eventComplete(emit);
  }

  _selectEquipment(AddEquipmentComplaintSelectEquipmentDataEvent event, emit) {
    equipmentTypeData = event.equipmentTypeData;
    _eventComplete(emit);
  }

  _selectFile(AddEquipmentComplaintAddImageEvent event, emit) async {
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

  _submit(AddEquipmentComplaintSubmitEvent event, emit) async {
    isLoader =  true;
    _eventComplete(emit);

    var res =  await AddEquipmentComplaintHelper.submitData(context: event.context,
        complaintTypeData: complaintTypeData, equipmentTypeData: equipmentTypeData,
        description: descriptionController.text.toString(), name: reportByController.text.toString(),
        file: file);
    if(res != null){
      complaintTypeData =  ComplaintTypeModel();
      equipmentTypeData =  EquipmentTypeModel();
      descriptionController.text = "";
      reportByController.text = "";
      isLoader =  false;
      file =  File("");
    }
    isLoader =  false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<AddEquipmentComplaintState> emit) {
    emit(FetchAddEquipmentComplaintState(
        file: file,
        isLoader: isLoader,
        descriptionController: descriptionController,
        complaintTypeData: complaintTypeData,
        complaintTypeList: complaintTypeList,
        equipmentTypeData: equipmentTypeData,
        equipmentTypeList: equipmentTypeList,
        reportByController: reportByController
    ));
  }
}
