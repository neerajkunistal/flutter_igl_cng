import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/model/category_model.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/addEquipmentComplaint/helper/add_equipment_complaint_market_helper.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/category_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/complaint_description_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/equipment_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/facility_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/sub_category_model.dart';

part 'add_equipment_complaint_market_event.dart';
part 'add_equipment_complaint_market_state.dart';

class AddEquipmentComplaintMarketBloc extends Bloc<AddEquipmentComplaintMarketEvent, AddEquipmentComplaintMarketState> {
  List<ComplaintTypeModel> complaintTypeList = [];
  ComplaintTypeModel complaintTypeData = ComplaintTypeModel();
  EquipmentTypeModel equipmentTypeData = EquipmentTypeModel();
  List<EquipmentTypeModel> equipmentTypeList = [];
  EquipmentModel equipmentData =  EquipmentModel();
  List<EquipmentModel> equipmentList = [];
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
  EquipmentComplaintType equipmentComplaintType =  EquipmentComplaintType.normal;
  List<ComplaintDescriptionModel> complaintDescriptionList = [];
  ComplaintDescriptionModel complaintDescriptionData =  ComplaintDescriptionModel();

  List<FacilityModel> facilityList = [];
  FacilityModel facilityData = FacilityModel();
  List<MarketCategoryModel> categoryList = [];
  MarketCategoryModel categoryData = MarketCategoryModel();
  List<SubCategoryModel> subCategoryList = [];
  SubCategoryModel subCategoryData = SubCategoryModel();
  TextEditingController facilityOtherController = TextEditingController();
  TextEditingController marketingDescriptionController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  AddEquipmentComplaintMarketBloc() : super(AddEquipmentComplaintMarketInitial()) {
    on<AddEquipmentComplaintMarketPageLoadEvent>(_pageLoad);
    on<AddEquipmentComplaintMarketSelectComplaintDataEvent>(_selectComplaintType);
    on<AddEquipmentComplaintMarketSelectEquipmentDataEvent>(_selectEquipment);
    on<AddEquipmentComplaintMarketSelectEquipmentTypeDataEvent>(_selectEquipmentType);
    on<AddEquipmentComplaintMarketSelectGeneralDataEvent>(_selectGeneral);
    on<AddEquipmentComplaintMarketSelectDescriptionDataEvent>(_selectComplaintDescription);
    on<AddEquipmentComplaintMarketSelectDateData>(_selectDate);
    on<AddEquipmentComplaintMarketSelectTimeData>(_selectTime);
    on<AddEquipmentComplaintMarketAddImageEvent>(_selectFile);
    on<AddEquipmentComplaintMarketAddVideoEvent>(_selectVideo);
    on<AddEquipmentComplaintMarketRemoveImageEvent>(_removeImage);
    on<AddEquipmentComplaintMarketRemoveVideoEvent>(_removeVideo);
    on<AddEquipmentComplaintMarketSubmitEvent>(_submit);
    on<AddEquipmentComplaintMarketSelectFacilityDataEvent>(_selectFacility);
    on<AddEquipmentComplaintMarketSelectCategoryDataEvent>(_selectCategory);
    on<AddEquipmentComplaintMarketSelectSubCategoryDataEvent>(_selectSubCategory);
  }

  _pageLoad(AddEquipmentComplaintMarketPageLoadEvent event, emit) async {
    emit(AddEquipmentComplaintMarketPageLoadState());
    complaintTypeList = [];
    complaintTypeData = ComplaintTypeModel();
    equipmentTypeData = EquipmentTypeModel();
    equipmentTypeList = [];
    generalComplaintList = [];
    videoFiles = [];
    equipmentList = [];
    equipmentData =  EquipmentModel();
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
    equipmentComplaintType =  event.equipmentComplaintType;
    complaintDescriptionData =  ComplaintDescriptionModel();
    facilityList = [];
    facilityData = FacilityModel();
    categoryList = [];
    categoryData = MarketCategoryModel();
    subCategoryList = [];
    subCategoryData = SubCategoryModel();
    facilityOtherController = TextEditingController();
    marketingDescriptionController = TextEditingController();
    userNameController = TextEditingController();
    mobileController = TextEditingController();

    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dateController.text = formattedDate;

    var resComplaint = await AddEquipmentComplaintHelper.fetchComplaintTypeData(equipmentComplaintType: equipmentComplaintType);
    if (resComplaint != null) {
      complaintTypeList = resComplaint;
    }

    var resEquipment = await AddEquipmentComplaintHelper.fetchEquipmentTypeData(equipmentComplaintType: equipmentComplaintType);
    if (resEquipment != null) {
      equipmentList = resEquipment;
      if(equipmentList.length == 1){
        equipmentData =  equipmentList.first;
      }
      equipmentTypeList = equipmentList.isNotEmpty ? equipmentList[0].equipmentTypeList! : [];
    }

    if(equipmentComplaintType == EquipmentComplaintType.normal){
      var resGeneral = await AddEquipmentComplaintHelper.fetchGeneralComplaintData();
      if (resGeneral != null) {
        generalComplaintList = resGeneral;
      }
    }
    else {
      var resDescription = await AddEquipmentComplaintHelper.fetchDescriptionComplaintData();
      if (resDescription != null) {
        complaintDescriptionList = resDescription;
      }
    }

    if(equipmentComplaintType == EquipmentComplaintType.marketing){
      var resFacility = await AddEquipmentComplaintMarkerHelper.fetchFacilityData();
      if (resFacility != null) {
        facilityList = resFacility;
      }
    }


    _eventComplete(emit);
  }

  _selectComplaintType(
      AddEquipmentComplaintMarketSelectComplaintDataEvent event, emit) {
    complaintTypeData = event.complaintTypeData;
    equipmentTypeData = EquipmentTypeModel();
    generalDescriptionController.text = "";
    generalComplaintData = GeneralComplaintModel();
    _eventComplete(emit);
  }

  _selectEquipment(AddEquipmentComplaintMarketSelectEquipmentDataEvent event, emit) {
    equipmentData = event.equipmentData;
    equipmentTypeData =  EquipmentTypeModel();
    equipmentTypeList = [];
    _eventComplete(emit);
    if(equipmentData.equipmentTypeList != null){
      for(var equipmentTypeData in equipmentData.equipmentTypeList!) {
        if(equipmentData.id.toString() == equipmentTypeData.equipmentId.toString())
        {
          equipmentTypeList.add(equipmentTypeData);
        }
      }
    }

    _eventComplete(emit);
  }

  _selectEquipmentType(AddEquipmentComplaintMarketSelectEquipmentTypeDataEvent event, emit) {
    equipmentTypeData = event.equipmentTypeData;
    _eventComplete(emit);
  }



  _selectGeneral(AddEquipmentComplaintMarketSelectGeneralDataEvent event, emit) {
    generalComplaintData = event.generalComplaintData;
    generalDescriptionController.text = "";
    _eventComplete(emit);
  }

  _selectComplaintDescription(AddEquipmentComplaintMarketSelectDescriptionDataEvent event, emit) {
    complaintDescriptionData =  event.complaintDescriptionData;
    _eventComplete(emit);
  }

  _selectFile(AddEquipmentComplaintMarketAddImageEvent event, emit) async {
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

  _removeImage(AddEquipmentComplaintMarketRemoveImageEvent event, emit) {
    isLoader =  true;
    _eventComplete(emit);
    files[event.index] =  File("");
    isLoader =  false;
    _eventComplete(emit);
  }

  _removeVideo(AddEquipmentComplaintMarketRemoveVideoEvent event, emit) {
    isLoader =  true;
    _eventComplete(emit);
    videoFiles[event.index] =  File("");
    isLoader =  false;
    _eventComplete(emit);
  }

  _selectVideo(AddEquipmentComplaintMarketAddVideoEvent event, emit) async {
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

  _selectDate(AddEquipmentComplaintMarketSelectDateData event, emit) async {
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

  _selectTime(AddEquipmentComplaintMarketSelectTimeData event, emit) async {
    try {
      DateTime _parseTime(String timeStr) {
        try {
          return DateFormat('HH:mm:ss').parse(timeStr);
        } catch (_) {
          return DateFormat('HH:mm').parse(timeStr);
        }
      }

      DateTime initialDate = timeController.text.isNotEmpty
          ? _parseTime(timeController.text)
          : DateTime.now();

      final DateTime? time = await showCupertinoDatePicker(
        context: event.context,
        initialDateTime: initialDate,
      );

      if (time != null) {
        var timeFormat = TimeOfDay(hour: time.hour, minute: time.minute)
            .format(!event.context.mounted ? event.context : event.context);

        final selectedTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          time.hour,
          time.minute,
        );

        final currentTime = DateTime.now();
        final diffMn = currentTime.difference(selectedTime).inMinutes;

        if (diffMn < 30 && diffMn >= 0) {
          timeController.text = timeFormat;
          _eventComplete(emit);
        } else {
          SnackBarErrorWidget(
              !event.context.mounted ? event.context : event.context)
              .show(message: "Not Before 30 Mins To Current Time.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectFacility(AddEquipmentComplaintMarketSelectFacilityDataEvent event, emit) async {
    facilityData = event.facilityData;
    categoryList = [];
    categoryData = MarketCategoryModel();
    subCategoryList = [];
    subCategoryData = SubCategoryModel();
    _eventComplete(emit);
    if (facilityData.name?.toString().toLowerCase() == "others") {
      return;
    }
    var resCategory = await AddEquipmentComplaintMarkerHelper.fetchCategoryData(facilityId: facilityData.id ?? "");
    if (resCategory != null) {
      categoryList = resCategory;
    }
    _eventComplete(emit);
  }

  _selectCategory(AddEquipmentComplaintMarketSelectCategoryDataEvent event, emit) async {
    categoryData = event.categoryData;
    subCategoryData = SubCategoryModel();
    _eventComplete(emit);
    var resSub = await AddEquipmentComplaintMarkerHelper.fetchSubCategoryData(
        categoryId: categoryData.id ?? ""); // TODO: confirm method + param name
    if (resSub != null) {
      subCategoryList = resSub;
      if (subCategoryList.isNotEmpty) {
        subCategoryData = subCategoryList.first; // the single fixed value
      }
    }
    _eventComplete(emit);
  }

  _selectSubCategory(AddEquipmentComplaintMarketSelectSubCategoryDataEvent event, emit) async {
    subCategoryData = event.subCategoryData;
    _eventComplete(emit);
  }

  _submit(AddEquipmentComplaintMarketSubmitEvent event, emit) async {
    var textFiledValidation =  equipmentComplaintType == EquipmentComplaintType.marketing
        ? await AddEquipmentComplaintMarkerHelper.marketingValidation(
      context: event.context,
      facilityData: facilityData,
      facilityOtherDescription: facilityOtherController.text.toString(),
      categoryData: categoryData,
      subCategoryData: subCategoryData,
      description: marketingDescriptionController.text.toString(),
      complainantName: userNameController.text.toString(),
      complainantMobile: mobileController.text.toString(),
    )
        : await AddEquipmentComplaintMarkerHelper.textFieldValidation(
      context: event.context,
      complaintTypeData: complaintTypeData,
      equipmentTypeData: equipmentTypeData,
      description: descriptionController.text.toString(),
      name: reportByController.text.toString(),
      date: dateController.text.toString(),
      time: timeController.text.toString(),
      generalComplaintData: generalComplaintData,
      generalDescription: generalDescriptionController.text.toString(),
      file: files,
      videoFiles: videoFiles,
      complaintDescriptionData: complaintDescriptionData,
      equipmentComplaintType: equipmentComplaintType,
    );

    if(textFiledValidation == false){
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
    var res = equipmentComplaintType == EquipmentComplaintType.marketing
        ? await AddEquipmentComplaintMarkerHelper.marketingSubmitData(
      context: event.context,
      facilityData: facilityData,
      facilityOtherDescription: facilityOtherController.text.toString(),
      categoryData: categoryData,
      subCategoryData: subCategoryData,
      description: marketingDescriptionController.text.toString(),
      complainantName: userNameController.text.toString(),
      complainantMobile: mobileController.text.toString(),
      file: files,
      videoFiles: videoFiles,
    )
        : await AddEquipmentComplaintMarkerHelper.submitData(
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
        complaintDescriptionData: complaintDescriptionData,
        equipmentComplaintType: equipmentComplaintType
    );
    if (res != null) {
      facilityData = FacilityModel();
      categoryData = MarketCategoryModel();
      subCategoryData = SubCategoryModel();
      categoryList = [];
      subCategoryList = [];
      facilityOtherController.text = "";
      marketingDescriptionController.text = "";
      userNameController.text = "";
      mobileController.text = "";
      complaintTypeData = ComplaintTypeModel();
      equipmentTypeData = EquipmentTypeModel();
      equipmentTypeList = [];
      generalComplaintData = GeneralComplaintModel();
      descriptionController.text = "";
      reportByController.text = "";
      dateController.text = "";
      timeController.text = "";
      generalDescriptionController.text = "";
      complaintDescriptionData =  ComplaintDescriptionModel();
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

  _eventComplete(Emitter<AddEquipmentComplaintMarketState> emit) {
    emit(FetchAddEquipmentComplaintMarketState(
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
      equipmentData: equipmentData,
      equipmentList: equipmentList,
      complaintDescriptionData: complaintDescriptionData,
      complaintDescriptionList: complaintDescriptionList,
      // ---- Marketing additions ----
      facilityList: facilityList,
      facilityData: facilityData,
      categoryList: categoryList,
      categoryData: categoryData,
      subCategoryList: subCategoryList,
      subCategoryData: subCategoryData,
      facilityOtherController: facilityOtherController,
      marketingDescriptionController: marketingDescriptionController,
      userNameController: userNameController,
      mobileController: mobileController,

    ));
  }
}
