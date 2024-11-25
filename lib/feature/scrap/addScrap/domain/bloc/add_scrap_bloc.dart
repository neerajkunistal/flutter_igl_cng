import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scarp_unit_type_model.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scrap_model.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/helper/add_scrap_helper.dart';

part 'add_scrap_event.dart';
part 'add_scrap_state.dart';

class AddScrapBloc extends Bloc<AddScrapEvent, AddScrapState> {

  bool isLoader =  false;
  List<ScrapUnitTypeModel> scrapUnitTypeList = [];
  ScrapUnitTypeModel scrapUnitTypeData =  ScrapUnitTypeModel();
  TextEditingController srNumberController =  TextEditingController();
  TextEditingController descriptionController =  TextEditingController();
  TextEditingController unitController =  TextEditingController();
  List<File> filesList = [];
  List<ScrapModel> scrapList = [];

  AddScrapBloc() : super(AddScrapInitial()) {
    on<AddScrapPageLoadEvent>(_pageLoad);
    on<AddScrapSelectScrapUnitTypeEvent>(_selectScrapData);
    on<AddScrapSelectFileEvent>(_selectFile);
    on<AddScrapClearScrapDataEvent>(_clearScrapData);
    on<AddScrapDeleteEvent>(_deleteScrap);
    on<AddScrapSubmitEvent>(_submit);
  }

  _pageLoad(AddScrapPageLoadEvent event, emit) async {
    emit(AddScrapPageLoadState());
    _eventCompleted(emit);
    isLoader =  false;
    scrapUnitTypeList = [];
    scrapUnitTypeData =  ScrapUnitTypeModel();
    srNumberController =  TextEditingController();
    descriptionController =  TextEditingController();
    unitController =  TextEditingController();
    filesList = [];
    filesList.add(File(""));
    filesList.add(File(""));
    filesList.add(File(""));
    if(scrapUnitTypeList.isEmpty){
      var res =  await ScrapHelper.fetchUnitType();
      if(res != null){
        scrapUnitTypeList =  res;
      }
    }
    _eventCompleted(emit);
  }

  _selectScrapData(AddScrapSelectScrapUnitTypeEvent event, emit) {
    scrapUnitTypeData =  event.scrapUnitTypeData;
    _eventCompleted(emit);
  }

  _selectFile(AddScrapSelectFileEvent event, emit) async {
    isLoader =  true;
    _eventCompleted(emit);
    if (event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if (photo != null) {
        filesList[event.index] = photo;
      }
    } else {
      var photo = await DashboardHelper.filePiker(context: event.context);
      if (photo != null) {
        filesList[event.index] = photo;
      }
    }
    isLoader =  false;
    _eventCompleted(emit);
  }

  _deleteScrap(AddScrapDeleteEvent event, emit) {
    isLoader =  true;
    _eventCompleted(emit);
    scrapList.removeAt(event.index);
    isLoader =  false;
    _eventCompleted(emit);
  }

  _clearScrapData(AddScrapClearScrapDataEvent event, emit) {
    isLoader =  true;
    _eventCompleted(emit);
    scrapList = [];
    isLoader =  false;
    _eventCompleted(emit);
  }

  _submit(AddScrapSubmitEvent event, emit) async {

    var textFiledValidation =  await ScrapHelper.textFiledValidation(context: event.context,
        srNumber: srNumberController.text.toString(),
        description: descriptionController.text.toString(),
        scrapUnitTypeData: scrapUnitTypeData, unit: unitController.text.toString());
    if(textFiledValidation == false){
      return;
    }

    isLoader =  true;
    _eventCompleted(emit);
    ScrapUnitTypeModel scrapUnitTypeData1 =  scrapUnitTypeData;
    scrapUnitTypeData1.unit =  unitController.text.toString();
    ScrapModel scrapData =  ScrapModel(
      srNumber: srNumberController.text.toString(),
      description: descriptionController.text.toString(),
      scrapUnitTypeData: scrapUnitTypeData1,
      filesList: filesList,
    );
    scrapList.add(scrapData);
    isLoader =  false;
    _eventCompleted(emit);
    if (!event.context.mounted) return;
    Navigator.pop(event.context, "Completed");
  }

  _eventCompleted( Emitter<AddScrapState>emit ) {
    emit(FetchAddScrapDataState(
        filesList: filesList,
        scrapUnitTypeData: scrapUnitTypeData,
        isLoader: isLoader,
        descriptionController: descriptionController,
        scrapUnitTypeList: scrapUnitTypeList,
        srNumberController: srNumberController,
        unitController: unitController,
       scrapList: scrapList,
    ));
  }
}
