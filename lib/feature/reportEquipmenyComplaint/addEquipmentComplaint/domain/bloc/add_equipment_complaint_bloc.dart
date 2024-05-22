import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/dashboard/helper/dashboard_helper.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/complaint_type_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/equipment_type_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/general_complaint_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/helper/add_equipment_complaint_helper.dart';
import 'package:intl/intl.dart';

part 'add_equipment_complaint_event.dart';
part 'add_equipment_complaint_state.dart';

class AddEquipmentComplaintBloc
    extends Bloc<AddEquipmentComplaintEvent, AddEquipmentComplaintState> {
  List<ComplaintTypeModel> complaintTypeList = [];
  ComplaintTypeModel complaintTypeData = ComplaintTypeModel();
  EquipmentTypeModel equipmentTypeData = EquipmentTypeModel();
  List<EquipmentTypeModel> equipmentTypeList = [];
  TextEditingController descriptionController = TextEditingController();
  TextEditingController reportByController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController generalDescriptionController = TextEditingController();
  bool isLoader = false;
  List<File> files = [];
  List<GeneralComplaintModel> generalComplaintList = [];
  GeneralComplaintModel generalComplaintData = GeneralComplaintModel();

  AddEquipmentComplaintBloc() : super(AddEquipmentComplaintInitial()) {
    on<AddEquipmentComplaintPageLoadEvent>(_pageLoad);
    on<AddEquipmentComplaintSelectComplaintDataEvent>(_selectComplaintType);
    on<AddEquipmentComplaintSelectEquipmentDataEvent>(_selectEquipment);
    on<AddEquipmentComplaintSelectGeneralDataEvent>(_selectGeneral);
    on<AddEquipmentComplaintSelectDateData>(_selectDate);
    on<AddEquipmentComplaintSelectTimeData>(_selectTime);
    on<AddEquipmentComplaintAddImageEvent>(_selectFile);
    on<AddEquipmentComplaintSubmitEvent>(_submit);
  }

  _pageLoad(AddEquipmentComplaintPageLoadEvent event, emit) async {
    emit(AddEquipmentComplaintPageLoadState());
    complaintTypeList = [];
    complaintTypeData = ComplaintTypeModel();
    equipmentTypeData = EquipmentTypeModel();
    equipmentTypeList = [];
    generalComplaintList = [];
    generalComplaintData = GeneralComplaintModel();
    descriptionController.text = "";
    reportByController.text = "";
    dateController.text = "";
    timeController.text = "";
    generalDescriptionController.text = "";
    isLoader = false;
    files = [];
    files.add(File(""));
    files.add(File(""));
    files.add(File(""));

    var resComplaint =
        await AddEquipmentComplaintHelper.fetchComplaintTypeData();
    if (resComplaint != null) {
      complaintTypeList = resComplaint;
    }

    var resEquipment =
        await AddEquipmentComplaintHelper.fetchEquipmentTypeData();
    if (resEquipment != null) {
      equipmentTypeList = resEquipment;
    }

    var resGeneral =
        await AddEquipmentComplaintHelper.fetchGeneralComplaintData();
    if (resGeneral != null) {
      generalComplaintList = resGeneral;
    }

    _eventComplete(emit);
  }

  _selectComplaintType(
      AddEquipmentComplaintSelectComplaintDataEvent event, emit) {
    complaintTypeData = event.complaintTypeData;
    equipmentTypeData = EquipmentTypeModel();
    generalDescriptionController.text = "";
    generalComplaintData = GeneralComplaintModel();
    _eventComplete(emit);
  }

  _selectEquipment(AddEquipmentComplaintSelectEquipmentDataEvent event, emit) {
    equipmentTypeData = event.equipmentTypeData;
    _eventComplete(emit);
  }

  _selectGeneral(AddEquipmentComplaintSelectGeneralDataEvent event, emit) {
    generalComplaintData = event.generalComplaintData;
    generalDescriptionController.text = "";
    _eventComplete(emit);
  }

  _selectFile(AddEquipmentComplaintAddImageEvent event, emit) async {
    if (event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if (photo != null) {
        isLoader =  true;
        _eventComplete(emit);
        files[event.index] = photo;
      }
    } else {
      var photo = await DashboardHelper.filePiker(context: event.context);
      if (photo != null) {
        isLoader =  true;
        _eventComplete(emit);
        files[event.index] = photo;
      }
    }
    Navigator.pop(event.context.mounted ? event.context : event.context);
    isLoader =  false;
    _eventComplete(emit);
  }

  _selectDate(AddEquipmentComplaintSelectDateData event, emit) async {
    try {
      final DateTime? picked = await showDatePicker(
          context: event.context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2015, 8),
          lastDate: DateTime.now());
      if (picked != null) {
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        dateController.text = formattedDate;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectTime(AddEquipmentComplaintSelectTimeData event, emit) async {
    try {
      DateTime initialDate =  timeController.text.toString().isNotEmpty ?
      DateFormat('h:mm').parse(timeController.text.toString())
          : DateTime.now();

      TimeOfDay initialTime =  TimeOfDay.fromDateTime(initialDate);
      final TimeOfDay? time = await showTimePicker(
        context: event.context,
        initialTime: initialTime,
      );
      if (time != null) {
        var timeFormat = TimeOfDay(hour: time.hour, minute: time.minute).format(
            event.context);
        timeController.text = timeFormat;
        _eventComplete(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _submit(AddEquipmentComplaintSubmitEvent event, emit) async {
    isLoader = true;
    _eventComplete(emit);

    DateTime initialDate1 =  timeController.text.toString().isNotEmpty ?
    DateFormat('h:mm a').parse(timeController.text.toString())
        : DateTime.now();
    String time = "${initialDate1.hour}:${initialDate1.minute}";
    var res = await AddEquipmentComplaintHelper.submitData(
        context: event.context,
        complaintTypeData: complaintTypeData,
        equipmentTypeData: equipmentTypeData,
        description: descriptionController.text.toString(),
        name: reportByController.text.toString(),
        date: dateController.text.toString(),
        time: time,
        generalComplaintData: generalComplaintData,
        generalDescription: generalDescriptionController.text.toString(),
        file: files);
    if (res != null) {
      complaintTypeData = ComplaintTypeModel();
      equipmentTypeData = EquipmentTypeModel();
      generalComplaintData = GeneralComplaintModel();
      descriptionController.text = "";
      reportByController.text = "";
      dateController.text = "";
      timeController.text = "";
      generalDescriptionController.text = "";
      isLoader = false;
      files.add(File(""));
      files.add(File(""));
      files.add(File(""));
      if(!event.context.mounted) return;
      Navigator.of(event.context).pop("complete");
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<AddEquipmentComplaintState> emit) {
    emit(FetchAddEquipmentComplaintState(
      files: files,
      isLoader: isLoader,
      descriptionController: descriptionController,
      complaintTypeData: complaintTypeData,
      complaintTypeList: complaintTypeList,
      equipmentTypeData: equipmentTypeData,
      equipmentTypeList: equipmentTypeList,
      reportByController: reportByController,
      dateController: dateController,
      timeController: timeController,
      generalComplaintData: generalComplaintData,
      generalComplaintList: generalComplaintList,
      generalDescriptionController: generalDescriptionController,
    ));
  }
}
