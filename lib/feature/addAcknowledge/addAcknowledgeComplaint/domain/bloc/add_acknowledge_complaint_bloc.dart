import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

part 'add_acknowledge_complaint_state.dart';

class AddAcknowledgeComplaintBloc
    extends Bloc<AddAcknowledgeComplaintEvent, AddAcknowledgeComplaintState> {
  List<ComplaintTypeModel> complaintTypeList = [];
  ComplaintTypeModel complaintTypeData = ComplaintTypeModel();
  EquipmentTypeModel equipmentTypeData = EquipmentTypeModel();
  List<EquipmentTypeModel> equipmentTypeList = [];
  TextEditingController descriptionController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  bool isLoader = false;
  File file = File("");
  List<DepartmentModel> departmentList = [];
  DepartmentModel departmentData = DepartmentModel();
  List<ComplaintModel> complaintList = [];
  ComplaintModel complaintData = ComplaintModel();
  List<AcknowledgeModel> acknowledgeList = [];
  AcknowledgeModel acknowledgeData = AcknowledgeModel();
  ReviewComplaintModel reviewComplaintData = ReviewComplaintModel();
  List<AcknowledgeUserModel> acknowledgeUserList = [];
  AcknowledgeUserModel acknowledgeUserData = AcknowledgeUserModel();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  String breakDownvalue = "";

  bool isComplaintLoader = false;

  List<GeneralComplaintModel> generalComplaintList = [];
  GeneralComplaintModel generalComplaintData = GeneralComplaintModel();
  TextEditingController generalDescriptionController = TextEditingController();
  String complaintStatus = "0";

  AddAcknowledgeComplaintBloc() : super(AddAcknowledgeComplaintInitial()) {
    on<AddAcknowledgeComplaintPageLoadEvent>(_pageLoad);
    on<AddAcknowledgeComplaintSelectComplaintDataEvent>(_selectComplaintType);
    on<AddAcknowledgeComplaintSelectEquipmentDataEvent>(_selectEquipment);
    on<AddAcknowledgeComplaintSelectStatusData>(_selectComplaintStatus);
    on<AddAcknowledgeComplaintSelectUserEvent>(_selectUser);
    on<AddAcknowledgeComplaintSelectDepartmentEvent>(_selectDepartment);
    on<AddAcknowledgeComplaintSelectComplaintEvent>(_selectComplaint);
    on<AddAcknowledgeComplaintSelectAcknowledgeComplaintEvent>(
        _selectAcknowledget);
    on<AddAcknowledgeComplaintSelectGeneralDataEvent>(_selectGeneral);
    on<AddAcknowledgeComplaintSelectDateData>(_selectDate);
    on<AddAcknowledgeComplaintSelectTimeData>(_selectTime);
    on<AddAcknowledgeComplaintAddImageEvent>(_selectFile);
    on<AddAcknowledgeComplaintSelectBreakDownEvent>(_selectBreakdown);
    on<AddAcknowledgeComplaintSelectReviewComplaintEvent>(
        _selectReviewComplaint);
    on<AddAcknowledgeComplaintSubmitEvent>(_submit);
  }

  _pageLoad(AddAcknowledgeComplaintPageLoadEvent event, emit) async {
    emit(AddAcknowledgeComplaintPageLoadState());
    complaintTypeList = [];
    complaintTypeData = ComplaintTypeModel();
    equipmentTypeData = EquipmentTypeModel();
    equipmentTypeList = [];
    departmentList = [];
    complaintList = [];
    acknowledgeList = [];
    acknowledgeUserList = [];
    acknowledgeUserData = AcknowledgeUserModel();
    descriptionController.text = "";
    remarkController.text = "";
    dateController.text = "";
    timeController.text = "";
    isLoader = false;
    isComplaintLoader = false;
    file = File("");
    departmentData = DepartmentModel();
    complaintData = ComplaintModel();
    acknowledgeData = AcknowledgeModel();
    reviewComplaintData = ReviewComplaintModel();
    breakDownvalue = "";
    generalDescriptionController.text = "";
    generalComplaintList = [];
    generalComplaintData = GeneralComplaintModel();
    complaintStatus = "0";

    acknowledgeData = event.acknowledgeData;
    acknowledgeList =
        BlocProvider.of<AcknowledgeBloc>(event.context).acknowledgeList;

    var resComplaint =
        await AddEquipmentComplaintHelper.fetchComplaintTypeData();
    if (resComplaint != null) {
      complaintTypeList = resComplaint;
      for (var complaint in complaintTypeList) {
        if (complaint.id.toString() ==
            event.acknowledgeData.complaintTypeId.toString()) {
          complaintTypeData = complaint;
        }
      }
    }

    var resEquipment =
        await AddEquipmentComplaintHelper.fetchEquipmentTypeData(
            complaintId: acknowledgeData.id.toString());
    if (resEquipment != null) {
      equipmentTypeList = resEquipment;
      for (var equipment in equipmentTypeList) {
        if (equipment.id.toString() ==
            event.acknowledgeData.equipmentId.toString()) {
          equipmentTypeData = equipment;
        }
      }
    }

    var resDepartment =
        await AddAcknowledgeComplaintHelper.fetchDepartmentData();
    if (resDepartment != null) {
      departmentList = resDepartment;
    }

    var resGeneral =
        await AddEquipmentComplaintHelper.fetchGeneralComplaintData();
    if (resGeneral != null) {
      generalComplaintList = resGeneral;
      for (var generalData in generalComplaintList) {
        if (generalData.id.toString() ==
            event.acknowledgeData.generalComplaintId.toString()) {
          generalComplaintData = generalData;
          generalDescriptionController.text =
              event.acknowledgeData.generalComplaintRemark.toString();
        }
      }
    }

    var resUser = await AddAcknowledgeComplaintHelper.fetchUserList();
    if (resUser != null) {
      acknowledgeUserList = resUser;
      for (var user in acknowledgeUserList) {
        if (user.id.toString() == event.acknowledgeData.ackBy.toString()) {
          acknowledgeUserData = user;
        }
      }
    }


    String complaintDate = "";
    if (acknowledgeData.complaintDateTime.toString().isNotEmpty) {
      complaintDate = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(acknowledgeData.complaintDateTime.toString()));
      dateController.text = complaintDate;

      DateTime initialDate =
          acknowledgeData.complaintDateTime.toString().isNotEmpty
              ? DateFormat('yyyy-dd-MM h:mm:ss')
                  .parse(acknowledgeData.complaintDateTime.toString())
              : DateTime.now();
      TimeOfDay initialTime = TimeOfDay.fromDateTime(initialDate);
      var timeFormat =
          TimeOfDay(hour: initialTime.hour, minute: initialTime.minute)
              .format(!event.context.mounted ? event.context : event.context);
      timeController.text = timeFormat;
    }

    breakDownvalue = event.acknowledgeData.crBreakdown.toString();
    descriptionController.text =
        acknowledgeData.complaintDescription.toString();
    remarkController.text = acknowledgeData.ackRemark.toString();

    complaintStatus = acknowledgeData.ackStatus.toString();
    _eventComplete(emit);
  }

  _selectComplaintType(
      AddAcknowledgeComplaintSelectComplaintDataEvent event, emit) {
    complaintTypeData = event.complaintTypeData;
    equipmentTypeData = EquipmentTypeModel();
    _eventComplete(emit);
  }

  _selectEquipment(
      AddAcknowledgeComplaintSelectEquipmentDataEvent event, emit) {
    equipmentTypeData = event.equipmentTypeData;
    _eventComplete(emit);
  }

  _selectComplaintStatus(AddAcknowledgeComplaintSelectStatusData event, emit) {
    complaintStatus = event.complaintStatus;
    _eventComplete(emit);
  }

  _selectUser(AddAcknowledgeComplaintSelectUserEvent event, emit) {
    acknowledgeUserData = event.acknowledgeUserData;
    _eventComplete(emit);
  }

  _selectDepartment(AddAcknowledgeComplaintSelectDepartmentEvent event, emit) {
    departmentData = event.departmentData;
    _eventComplete(emit);
  }

  _selectComplaint(AddAcknowledgeComplaintSelectComplaintEvent event, emit) {
    complaintData = event.complaintData;
    _eventComplete(emit);
  }

  _selectAcknowledget(
      AddAcknowledgeComplaintSelectAcknowledgeComplaintEvent event, emit) {
    acknowledgeData = event.acknowledgeData;
    _eventComplete(emit);
  }

  _selectGeneral(AddAcknowledgeComplaintSelectGeneralDataEvent event, emit) {
    generalComplaintData = event.generalComplaintData;
    _eventComplete(emit);
  }

  _selectDate(AddAcknowledgeComplaintSelectDateData event, emit) async {
    try {
      DateTime initialDate = dateController.text.toString().isNotEmpty
          ? DateFormat('dd-MM-yyyy').parse(dateController.text.toString())
          : DateTime.now();

      final DateTime? picked = await showDatePicker(
          context: event.context,
          initialDate: initialDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
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

  _selectTime(AddAcknowledgeComplaintSelectTimeData event, emit) async {
    try {
      DateTime initialDate = timeController.text.toString().isNotEmpty
          ? DateFormat('h:mm').parse(timeController.text.toString())
          : DateTime.now();

      TimeOfDay initialTime = TimeOfDay.fromDateTime(initialDate);
      final TimeOfDay? time = await showTimePicker(
        context: event.context,
        initialTime: initialTime,
      );
      if (time != null) {
        var timeFormat = TimeOfDay(hour: time.hour, minute: time.minute)
            .format(!event.context.mounted ? event.context : event.context);
        timeController.text = timeFormat;
        _eventComplete(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectFile(AddAcknowledgeComplaintAddImageEvent event, emit) async {
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
    _eventComplete(emit);
  }

  _selectBreakdown(AddAcknowledgeComplaintSelectBreakDownEvent event, emit) {
    breakDownvalue = event.breakeDown;
    _eventComplete(emit);
  }

  _selectReviewComplaint(
      AddAcknowledgeComplaintSelectReviewComplaintEvent event, emit) async {
    reviewComplaintData = event.reviewComplaintData;
    complaintData = ComplaintModel();
    isComplaintLoader = true;
    complaintList = [];
    _eventComplete(emit);
    var resCompl = await AddAcknowledgeComplaintHelper.fetchComplaintData(
        reviewComplaintID: reviewComplaintData.id.toString());
    if (resCompl != null) {
      complaintList.add(resCompl);
      complaintData = resCompl;
    }
    isComplaintLoader = false;
    _eventComplete(emit);
  }

  _submit(AddAcknowledgeComplaintSubmitEvent event, emit) async {
    if (complaintStatus.toString() == "0" &&
        remarkController.text.toString().isEmpty) {
      SnackBarErrorWidget(event.context).show(message: "Please enter remark");
      return;
    }

    isLoader = true;
    _eventComplete(emit);

    DateTime initialDate1 = DateTime.now();
    String time = "";
    if(timeController.text.toString().isNotEmpty
        && timeController.text.toString().toLowerCase().contains("am")){
      initialDate1 = timeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(timeController.text.toString())
          : DateTime.now();
      time = timeController.text.toString().isNotEmpty ? "${initialDate1.hour}:${initialDate1.minute}:00" : "";
    } else if (timeController.text.toString().isNotEmpty
        && timeController.text.toString().toLowerCase().contains("pm")){
      initialDate1 = timeController.text.toString().isNotEmpty
          ? DateFormat('h:mm a').parse(timeController.text.toString())
          : DateTime.now();
      time = timeController.text.toString().isNotEmpty ? "${initialDate1.hour}:${initialDate1.minute}:00" : "";
    } else {
      initialDate1 = timeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm').parse(timeController.text.toString())
          : DateTime.now();
      time = timeController.text.toString().isNotEmpty ? "${initialDate1.hour}:${initialDate1.minute}:00" : "";
    }

    var res = await AddAcknowledgeComplaintHelper.submitData(
        context: event.context,
        complaintTypeData: complaintTypeData,
        equipmentTypeData: equipmentTypeData,
        description: descriptionController.text.toString(),
        remark: remarkController.text.toString(),
        complaintData: complaintData,
        departmentData: departmentData,
        acknowledgeData: acknowledgeData,
        breakDownvalue: breakDownvalue,
        acknowledgeUserData: acknowledgeUserData,
        date: dateController.text.toString(),
        time: time,
        generalDescription: generalDescriptionController.text.toString(),
        generalComplaintData: generalComplaintData,
        complaintStatus: complaintStatus,
        file: file);
    if (res != null) {
      complaintTypeData = ComplaintTypeModel();
      equipmentTypeData = EquipmentTypeModel();
      departmentData = DepartmentModel();
      complaintData = ComplaintModel();
      reviewComplaintData = ReviewComplaintModel();
      acknowledgeUserData = AcknowledgeUserModel();
      complaintList = [];
      complaintData = ComplaintModel();
      descriptionController.text = "";
      remarkController.text = "";
      dateController.text = "";
      timeController.text = "";
      isLoader = false;
      file = File("");
      breakDownvalue = "";
      isComplaintLoader = false;
      generalDescriptionController.text = "";
      generalComplaintData = GeneralComplaintModel();
      complaintStatus = "";
      if (!event.context.mounted) return;
      Navigator.pop(event.context, "Completed");
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<AddAcknowledgeComplaintState> emit) {
    emit(FetchAddAcknowledgeComplaintState(
      file: file,
      isLoader: isLoader,
      descriptionController: descriptionController,
      complaintTypeData: complaintTypeData,
      complaintTypeList: complaintTypeList,
      equipmentTypeData: equipmentTypeData,
      equipmentTypeList: equipmentTypeList,
      remarkController: remarkController,
      acknowledgeData: acknowledgeData,
      acknowledgeList: acknowledgeList,
      departmentData: departmentData,
      departmentList: departmentList,
      complaintData: complaintData,
      complaintList: complaintList,
      breakDownvalue: breakDownvalue,
      reviewComplaintData: reviewComplaintData,
      isComplaintLoader: isComplaintLoader,
      acknowledgeUserData: acknowledgeUserData,
      acknowledgeUserList: acknowledgeUserList,
      dateController: dateController,
      timeController: timeController,
      generalComplaintData: generalComplaintData,
      generalComplaintList: generalComplaintList,
      generalDescriptionController: generalDescriptionController,
      complaintStatus: complaintStatus,
    ));
  }
}
