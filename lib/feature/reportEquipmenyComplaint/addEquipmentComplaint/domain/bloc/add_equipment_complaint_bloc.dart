import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

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
  bool isFileLoader = false;
  List<File> files = [];
  List<GeneralComplaintModel> generalComplaintList = [];
  GeneralComplaintModel generalComplaintData = GeneralComplaintModel();
  List<File> videoFiles = [];

  AddEquipmentComplaintBloc() : super(AddEquipmentComplaintInitial()) {
    on<AddEquipmentComplaintPageLoadEvent>(_pageLoad);
    on<AddEquipmentComplaintSelectComplaintDataEvent>(_selectComplaintType);
    on<AddEquipmentComplaintSelectEquipmentDataEvent>(_selectEquipment);
    on<AddEquipmentComplaintSelectGeneralDataEvent>(_selectGeneral);
    on<AddEquipmentComplaintSelectDateData>(_selectDate);
    on<AddEquipmentComplaintSelectTimeData>(_selectTime);
    on<AddEquipmentComplaintAddImageEvent>(_selectFile);
    on<AddEquipmentComplaintAddVideoEvent>(_selectVideo);
    on<AddEquipmentComplaintSubmitEvent>(_submit);
  }

  _pageLoad(AddEquipmentComplaintPageLoadEvent event, emit) async {
    emit(AddEquipmentComplaintPageLoadState());
    complaintTypeList = [];
    complaintTypeData = ComplaintTypeModel();
    equipmentTypeData = EquipmentTypeModel();
    equipmentTypeList = [];
    generalComplaintList = [];
    videoFiles = [];
    generalComplaintData = GeneralComplaintModel();
    descriptionController.text = "";
    reportByController.text = "";
    dateController.text = "";
    timeController.text = "";
    generalDescriptionController.text = "";
    isLoader = false;
    isFileLoader = false;
    files = [];
    files.add(File(""));
    files.add(File(""));
    files.add(File(""));
    videoFiles.add(File(""));

    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dateController.text = formattedDate;

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

  _selectVideo(AddEquipmentComplaintAddVideoEvent event, emit) async {
    if (event.mediaType == 1) {
      var video = await DashboardHelper.videoPiker(context: event.context);
      if (video != null) {
        isLoader = true;
        isFileLoader = true;
        _eventComplete(emit);
        videoFiles[event.index] = video;
/*        print("Get Video Player ${videoFiles[event.index].path.toString()}");
        MediaInfo? mediaInfo = await VideoCompress.compressVideo(
          videoFiles[event.index].path.toString(),
          quality: VideoQuality.Res640x480Quality,
          deleteOrigin: false, // It's false by default
        );
        if(mediaInfo != null){
          videoFiles[event.index] = mediaInfo.file!;
        }*/
      }
    } else {
      var video = await DashboardHelper.filePiker(context: event.context);
      if (video != null) {
        isLoader = true;
        isFileLoader = true;
        _eventComplete(emit);
        videoFiles[event.index] = video;
      }
    }
    isLoader = false;
    isFileLoader = false;
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

        final selectedTime =  DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day,  time.hour, time.minute);
        final currentTime = DateTime.now();
        final diffMn = currentTime.difference(selectedTime).inMinutes;
        if(diffMn < 30 && diffMn >= 0){
          timeController.text = timeFormat;
          _eventComplete(emit);
        } else {
          SnackBarErrorWidget(!event.context.mounted ? event.context : event.context)
              .show(message: "Not Before 30 Mins To Current Time.");
        }
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
      file: files,
      videoFiles: videoFiles,
    );
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
      videoFiles = [];
      videoFiles.add(File(""));
      if (!event.context.mounted) return;
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
      videoFiles: videoFiles,
      isFileLoader: isFileLoader,
    ));
  }
}
