import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/model/category_model.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/model/cr_stattion_model.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/helper/add_cng_helper.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'add_cng_event.dart';
part 'add_cng_state.dart';

class AddCngBloc extends Bloc<AddCngEvent, AddCngState> {
  bool isLoader = false;
  List<CategoryModel> categoryList = [];
  CategoryModel categoryData = CategoryModel();
  List<CrStationModel> crStationList = [];
  CrStationModel crStationData = CrStationModel();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController reportedByController = TextEditingController();
  TextEditingController reportedByPhoneController = TextEditingController();
  List<File> fileList = [];

  AddCngBloc() : super(AddCngInitial()) {
    on<AddCngPageLoadEvent>(_pageLoad);
    on<AddCngSelectDateEvent>(_selectDate);
    on<AddCngSelectTimeEvent>(_selectTime);
    on<AddCngSelectCategoryDataEvent>(_selectCategory);
    on<AddCngSelectFileEvent>(_selectFile);
    on<AddCngFileDeleteEvent>(_deleteFile);
    on<AddCngSubmitEvent>(_submit);
  }

  _pageLoad(AddCngPageLoadEvent event, emit) async {
    emit(AddCngPageLoadState());
    isLoader = false;
    categoryList = [];
    categoryData = CategoryModel();
    crStationList = [];
    crStationData = CrStationModel();
    descriptionController = TextEditingController();
    dateController = TextEditingController();
    timeController = TextEditingController();
    reportedByController = TextEditingController();
    reportedByPhoneController = TextEditingController();
    fileList = [];
    fileList.add(File(""));
    fileList.add(File(""));
    fileList.add(File(""));
    fileList.add(File(""));

    var categoryRes = await AddCngHelper.fetchCategory();
    if (categoryRes != null) {
      categoryList = categoryRes;
    }

    var crStationRes = await AddCngHelper.fetchCrStation();
    if (crStationRes != null) {
      crStationData = crStationRes;
    }

    _eventCompleted(emit);
  }

  _selectDate(AddCngSelectDateEvent event, emit) async {
    try {
      final DateTime? picked = await showDatePicker(
          context: event.context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2015, 8),
          lastDate: DateTime.now());
      if (picked != null) {
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        dateController.text = formattedDate;
        _eventCompleted(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectTime(AddCngSelectTimeEvent event, emit) async {
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
        _eventCompleted(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectCategory(AddCngSelectCategoryDataEvent event, emit) {
    categoryData = event.categoryData;
    _eventCompleted(emit);
  }

  _selectFile(AddCngSelectFileEvent event, emit) async {
    if (event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventCompleted(emit);
        fileList[event.index] =  photo;
      }
    } else {
      var photo = await DashboardHelper.filePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventCompleted(emit);
        fileList[event.index] =  photo;
      }
    }
    isLoader = false;
    _eventCompleted(emit);
  }

  _deleteFile(AddCngFileDeleteEvent event, emit) {
    isLoader = true;
    _eventCompleted(emit);
    fileList.removeAt(event.index);
    isLoader = false;
    _eventCompleted(emit);
  }

  _submit(AddCngSubmitEvent event, emit) async {
    var textFiledValidation = await AddCngHelper.textFiledValidation(
        context: event.context,
        categoryData: categoryData,
        date: dateController.text.toString(),
        time: timeController.text.toString(),
        description: descriptionController.text.toString(),
        reportedBy: reportedByController.text.toString(),
        fileList: fileList);
    if (textFiledValidation == false) {
      return;
    }

    isLoader = true;
    _eventCompleted(emit);
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    var res = await AddCngHelper.submitData(
        context: !event.context.mounted ? event.context : event.context,
        categoryData: categoryData,
        date: dateController.text.toString(),
        time: timeController.text.toString(),
        description: descriptionController.text.toString(),
        reportedBy: reportedByController.text.toString(),
        reportedByPhone: reportedByPhoneController.text.toString(),
        crStationData: crStationData,
        fileList: fileList,
        userData: userData);
    if (res != null) {
      isLoader = false;
      descriptionController = TextEditingController();
      dateController = TextEditingController();
      timeController = TextEditingController();
      reportedByController = TextEditingController();
      reportedByPhoneController = TextEditingController();
      categoryData = CategoryModel();
      fileList = [];
      fileList.add(File(""));
      fileList.add(File(""));
      fileList.add(File(""));
      fileList.add(File(""));
      Navigator.of(!event.context.mounted ? event.context : event.context)
          .pop("Complete");
    }
    isLoader = false;
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<AddCngState> emit) {
    emit(FetchAddCngDataState(
      isLoader: isLoader,
      categoryData: categoryData,
      categoryList: categoryList,
      crStationList: crStationList,
      crStationData: crStationData,
      dateController: dateController,
      fileList: fileList,
      descriptionController: descriptionController,
      reportedByController: reportedByController,
      reportedByPhoneController: reportedByPhoneController,
      timeController: timeController,
    ));
  }
}
