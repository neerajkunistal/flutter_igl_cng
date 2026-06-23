import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/domain/model/station_model.dart';
part 'view_cv_complaint_event.dart';
part 'view_cv_complaint_state.dart';

class ViewCvComplaintBloc
    extends Bloc<ViewCvComplaintEvent, ViewCvComplaintState> {
  List<CngModel> cngList = [];
  List<CngModel> cngSearchList = [];
  List<ComplaintStatus> complaintStatusList = [];
  ComplaintStatus complaintStatusData = ComplaintStatus();
  bool isLoader = false;
  bool isFilterLoader = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController stationController = TextEditingController();
  TextEditingController filterDateController = TextEditingController();
  TextEditingController particularController = TextEditingController();
  TextEditingController measureController = TextEditingController();
  List<File> files = [];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List<File> measurementFileList = [];
  File measurementFileSheet = File("");
  CngModel cngData = CngModel();
  int listIndex = 0;
  MeasurementType measurementType = MeasurementType.non;
  List<StationModel> stationList = [];
  List<StationModel> searchStationList = [];
  StationModel stationData = StationModel();
  bool isStationLoader = false;
  List<ControlRoomModel> controlRoomList = [];
  ControlRoomModel controlRoomData = ControlRoomModel();
  FilterModel filterData = FilterModel();

  MeasureTypeModel measureTypeData =  MeasureTypeModel();
  List<MeasureTypeModel> measureTypeList = [];

  List<ParticularModel> particularList = [];
  bool isParticularWidgetShow = true;

  UnitName unitNameData = UnitName();

  ViewCvComplaintBloc() : super(ViewCvComplaintInitial()) {
    on<ViewCvComplaintPageLoadEvent>(_pageLoad);
    on<ViewCvComplaintSearchDataEvent>(_search);
    on<ViewCvComplaintSelectedDateRangeEvent>(_selectDate);
    on<ViewCvComplaintSearchStationEvent>(_searchStation);
    on<ViewCvComplaintSelectStationEvent>(_selectStation);
    on<ViewCvComplaintSelectControlRoomDataEvent>(_selectControlRoom);
    on<ViewCvComplaintFetchStationEvent>(_fetchStation);
    on<ViewCvComplaintSelectComplaintStatusEvent>(_selectComplaintStatus);
    on<ViewCvComplaintSelectFileEvent>(_selectFile);
    on<ViewCvComplaintSelectUnitNameEvent>(_selectUnitName);
    on<ViewCvComplaintSelectCngDataEvent>(_selectCngData);
    on<ViewCvComplaintFilterSubmitEvent>(_filterSubmit);
    on<ViewCvComplaintDeleteEstimatePhotoFileEvent>(_deleteEstimatePhoto);
    on<ViewCvComplaintMeasurementSelectFileEvent>(_selectMeasurementPhoto);
    on<ViewCvComplaintMeasurementDeleteFileEvent>(_deleteMeasurementFilePhoto);
    on<ViewCvComplaintMeasurementSheetSelectFileEvent>(_selectMeasurementSheet);
    on<ViewCvComplaintSubmitEvent>(_submit);
    on<ViewCvComplaintSelectListEvent>(_selectList);
    on<ViewCvComplaintSelectMeasureDataEvent>(_selectMeasureType);
    on<ViewCvComplaintAddParticularEvent>(_addParticular);
    on<ViewCvComplaintRemoveParticularEvent>(_removeParticular);
    on<ViewCvComplaintSubmitMeasurementEvent>(_submitMeasurement);
  }

  _pageLoad(ViewCvComplaintPageLoadEvent event, emit) async {
    emit(ViewCvComplaintPageLoadState());
    cngList = [];
    cngSearchList = [];
    filterData = FilterModel();
    controlRoomData = ControlRoomModel();
    controlRoomList = [];
    measurementFileList = [];
    measurementFileSheet = File("");
    complaintStatusList = ComplaintStatus.getComplaintData();
    complaintStatusData = ComplaintStatus();
    isLoader = false;
    stationList = [];
    particularList = [];
    stationData = StationModel();
    isStationLoader = false;
    isFilterLoader = false;
    unitNameData = UnitName();
    listIndex = 0;
    files = [];
    amountController.text = "";
    stationController.text = "";
    particularController.text = "";
    measureController.text = "";
    isParticularWidgetShow = true;
    cngData = CngModel();
    startDate = DateTime.now().subtract(const Duration(days: 15));
    endDate = DateTime.now();
    measureTypeData =  MeasureTypeModel();
    filterData = FilterModel(
        stationData: stationData,
        controlRoomData: controlRoomData,
        startDate: startDate,
        endDate: endDate);
    filterDateController.text =
        "${filterData.startDate!.day}-${filterData.startDate!.month}-${filterData.startDate!.year},${filterData.endDate!.day}-${filterData.endDate!.month}-${filterData.endDate!.year}";
    var res = await ViewCvComplaintHelper.addCivilVendorComplaintApi(
        fromDate: startDate.toString(), toDate: endDate.toString());
    if (res != null) {
      cngList = res;
      cngSearchList = res;
    }

    if(measureTypeList.isEmpty){
       var res =  await ViewCvComplaintHelper.fetchMeasureTypeData();
       if(res != null){
         measureTypeList =  res;
       }
    }
    measurementType = MeasurementType.non;
    _eventComplete(emit);
  }

  _search(ViewCvComplaintSearchDataEvent event, emit) async {
    cngList = [];
    _eventComplete(emit);
    if (event.keyword.isNotEmpty) {
      cngList = cngSearchList
          .where((element) => element.complaintNumber
              .toString()
              .toLowerCase()
              .contains(event.keyword.toUpperCase().toLowerCase()))
          .toList();
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.incidentDateTime
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.reportByName
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.complaintStatus
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.complaintDescription
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.categoryName
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.controlRoom
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
      if (cngList.isEmpty) {
        cngList = cngSearchList
            .where((element) => element.cngStation
                .toString()
                .toLowerCase()
                .contains(event.keyword.toUpperCase().toLowerCase()))
            .toList();
      }
    } else {
      cngList = cngSearchList;
    }

    _eventComplete(emit);
  }

  _searchStation(ViewCvComplaintSearchStationEvent event, emit) {
    isStationLoader = true;
    _eventComplete(emit);
    if (event.keyword.toString().isNotEmpty) {
      stationList = searchStationList
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(event.keyword.toLowerCase()))
          .toList();
    } else {
      stationList = searchStationList;
    }
    isStationLoader = false;
    _eventComplete(emit);
  }

  _selectStation(ViewCvComplaintSelectStationEvent event, emit) {
    isFilterLoader = true;
    _eventComplete(emit);
    stationData = event.stationData;
    isFilterLoader = false;
    _eventComplete(emit);
  }

  _selectControlRoom(ViewCvComplaintSelectControlRoomDataEvent event, emit) {
    controlRoomData = event.controlRoomData;
    _eventComplete(emit);
  }

  _fetchStation(ViewCvComplaintFetchStationEvent event, emit) async {
    isStationLoader = true;
    stationController.text = "";
    stationData = StationModel();
    controlRoomData = ControlRoomModel();
    _eventComplete(emit);
    if (searchStationList.isEmpty) {
      var res = await ViewAmoComplaintHelper.fetchStationData();
      if (res != null) {
        stationList = res;
        searchStationList = res;
      }
    } else {
      stationList = searchStationList;
    }

    if (controlRoomList.isEmpty) {
      var resControlRoom = await ViewCiComplaintHelper.fetchControlRoomData();
      if (resControlRoom != null) {
        controlRoomList = resControlRoom;
      }
    }

    if (filterData.startDate != null) {
      filterDateController.text =
          "${filterData.startDate!.day}-${filterData.startDate!.month}-${filterData.startDate!.year},${filterData.endDate!.day}-${filterData.endDate!.month}-${filterData.endDate!.year}";
    }

    if (filterData.stationData != null &&
        filterData.stationData!.name != null) {
      stationData = filterData.stationData!;
    }

    if (filterData.controlRoomData != null &&
        filterData.controlRoomData!.controlRoomName != null) {
      controlRoomData = filterData.controlRoomData!;
    }

    isStationLoader = false;
    _eventComplete(emit);
  }

  _selectDate(ViewCvComplaintSelectedDateRangeEvent event, emit) async {
    isFilterLoader = true;
    _eventComplete(emit);
    startDate = event.fromDate;
    endDate = event.toDate;
    filterDateController.text =
        "${startDate.day}-${startDate.month}-${startDate.year},${endDate.day}-${endDate.month}-${endDate.year}";

    isFilterLoader = false;
    _eventComplete(emit);
  }

  _selectComplaintStatus(
      ViewCvComplaintSelectComplaintStatusEvent event, emit) {
    complaintStatusData = event.complaintStatusData;
    _eventComplete(emit);
  }

  _selectCngData(ViewCvComplaintSelectCngDataEvent event, emit) {
    cngData = event.cngData;
    _eventComplete(emit);
  }

  _filterSubmit(ViewCvComplaintFilterSubmitEvent event, emit) async {
    cngList = [];
    cngSearchList = [];
    isFilterLoader = true;
    _eventComplete(emit);

    if(event.isFilterSubmit == false){
      startDate = DateTime.now().subtract(const Duration(days: 15));
      endDate = DateTime.now();
      stationData =  StationModel();
      controlRoomData =  ControlRoomModel();
    }


    filterData.startDate = startDate;
    filterData.endDate = endDate;

    filterData.stationData = stationData;
    filterData.controlRoomData = controlRoomData;

    var res = await ViewCvComplaintHelper.addCivilVendorComplaintApi(
        fromDate: startDate.toString(), toDate: endDate.toString());
    if (res != null) {
      cngList = res;
      cngSearchList = res;
    }

    if (event.isFilterSubmit == true) {
      if (filterData.stationData != null &&
          filterData.stationData!.name != null) {
        stationData = filterData.stationData!;
        List<CngModel> searchList = cngSearchList
            .where((element) =>
                element.cngStation.toString().toLowerCase() ==
                stationData.name.toString().toLowerCase())
            .toList();
        cngSearchList = searchList;
      }

      if (filterData.controlRoomData != null &&
          filterData.controlRoomData!.controlRoomName != null) {
        controlRoomData = filterData.controlRoomData!;
        List<CngModel> searchList = cngSearchList
            .where((element) =>
                element.controlRoomId.toString().toLowerCase() ==
                controlRoomData.controlRoomId.toString().toLowerCase())
            .toList();
        cngSearchList = searchList;
      }
    }
    cngData =  cngSearchList[listIndex];
    isFilterLoader = false;

    _eventComplete(emit);
  }

  _selectUnitName(ViewCvComplaintSelectUnitNameEvent event, emit) {
    unitNameData =  event.unitNameData;
    _eventComplete(emit);
  }

  _selectFile(ViewCvComplaintSelectFileEvent event, emit) async {
    if (event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        files.add(photo);
      }
    } else {
      var photo = await DashboardHelper.filePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        files.add(photo);
      }
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _deleteEstimatePhoto(
      ViewCvComplaintDeleteEstimatePhotoFileEvent event, emit) {
    isLoader = true;
    _eventComplete(emit);
    files.removeAt(event.index);
    isLoader = false;
    _eventComplete(emit);
  }

  _selectMeasurementPhoto(
      ViewCvComplaintMeasurementSelectFileEvent event, emit) async {
    if (event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        measurementFileList.add(photo);
      }
    } else {
      var photo = await DashboardHelper.filePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        measurementFileList.add(photo);
      }
    }
    if (measurementType == MeasurementType.sheet) {
      Navigator.pop(event.context.mounted ? event.context : event.context);
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _deleteMeasurementFilePhoto(
      ViewCvComplaintMeasurementDeleteFileEvent event, emit) {
    isLoader = true;
    _eventComplete(emit);
    measurementFileList.removeAt(event.index);

    isLoader = false;
    _eventComplete(emit);
  }

  _selectMeasurementSheet(
      ViewCvComplaintMeasurementSheetSelectFileEvent event, emit) async {
    if (event.mediaType == 1) {
      var photo = await DashboardHelper.imagePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        measurementFileSheet = photo;
      }
    } else {
      var photo = await DashboardHelper.filePiker(context: event.context);
      if (photo != null) {
        isLoader = true;
        _eventComplete(emit);
        measurementFileSheet = photo;
      }
    }
    Navigator.pop(event.context.mounted ? event.context : event.context);
    isLoader = false;
    _eventComplete(emit);
  }

  _submit(ViewCvComplaintSubmitEvent event, emit) async {
    if (particularList.isEmpty) {
      SnackBarErrorWidget(event.context)
          .show(message: "Please add particular data");
      return;
    }

    isLoader = true;
    _eventComplete(emit);
    var res = await ViewCvComplaintHelper.addEstimateData(
        cngData: event.cngData,
        amount: amountController.text.toString(),
        context: event.context,
        measureTypeData: measureTypeData,
        particular:  particularController.text.toString(),
        measurementValue:  measureController.text.toString(),
        particularList: particularList,
        file: files);
    if (res != null) {
      particularList = [];
      isParticularWidgetShow = true;
      var resComplaint = await ViewCvComplaintHelper.addCivilVendorComplaintApi(
          fromDate: startDate.toString(), toDate: endDate.toString());
      if (resComplaint != null) {
        cngList = resComplaint;
        cngSearchList = resComplaint;
      }

      if (filterData.stationData != null &&
          filterData.stationData!.name != null) {
        stationData = filterData.stationData!;
        List<CngModel> searchList = cngSearchList
            .where((element) =>
        element.cngStation.toString().toLowerCase() ==
            stationData.name.toString().toLowerCase())
            .toList();
        cngSearchList = searchList;
      }

      if (filterData.controlRoomData != null &&
          filterData.controlRoomData!.controlRoomName != null) {
        controlRoomData = filterData.controlRoomData!;
        List<CngModel> searchList = cngSearchList
            .where((element) =>
        element.controlRoomId.toString().toLowerCase() ==
            controlRoomData.controlRoomId.toString().toLowerCase())
            .toList();
        cngSearchList = searchList;
      }
      cngData =  cngSearchList[listIndex];
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _selectList(ViewCvComplaintSelectListEvent event, emit) {
    listIndex = event.listIndex;
    cngData = cngList[listIndex];
    isLoader = false;
    measurementFileList = [];
    measurementFileSheet = File("");
    files = [];
    amountController.text = "";
    measurementType = MeasurementType.non;
    particularController.text = "";
    measureTypeData =  MeasureTypeModel();
    measureController.text = "";

/*    if (cngData.measurementPreImageList == null ||
        cngData.measurementPreImageList!.isEmpty) {
      measurementType = MeasurementType.pre;
    } else*/
      if (cngData.measurementPostImageList == null ||
        cngData.measurementPostImageList!.isEmpty &&
            cngData.measurementSheetStatus.toString() != "1") {
      measurementType = MeasurementType.post;
    } else if (cngData.measurementSheetStatus.toString() != "1") {
      measurementType = MeasurementType.sheet;
    }
    _eventComplete(emit);
  }

  _selectMeasureType(ViewCvComplaintSelectMeasureDataEvent event, emit) {
    isLoader =  true;
    _eventComplete(emit);
    measureTypeData =  event.measureTypeData;
    unitNameData =  UnitName();
    measureController.text = "";
    isLoader =  false;
    _eventComplete(emit);
  }

  _addParticular(ViewCvComplaintAddParticularEvent event, emit) {
    if(isParticularWidgetShow == false) {
      isParticularWidgetShow =  true;
      _eventComplete(emit);
      return;
    }
    if (particularController.text.toString().isEmpty) {
      SnackBarErrorWidget(event.context)
          .show(message: "Please enter particular");
      return;
    }
    else if (measureTypeData.id == null) {
      SnackBarErrorWidget(event.context)
          .show(message: "Please select measure");
      return;
    }
    else if (unitNameData.name == null) {
      SnackBarErrorWidget(event.context)
          .show(message: "Please select unit");
      return;
    }
    else if (measureController.text.toString().isEmpty) {
      SnackBarErrorWidget(event.context)
          .show(message: "Please enter ${unitNameData.name.toString()}");
      return;
    }
    else if(files.length < 2){
      SnackBarErrorWidget(event.context)
          .show(message: "Please select two estimate image and document");
      return;
    }
    measureTypeData.unitData =  unitNameData;
    particularList.add(
      ParticularModel(
        name: particularController.text.toString(),
        measureTypeData: measureTypeData,
        measurementValue: measureController.text.toString(),
        fileList: files,
      )
    );
    measureController.text = "";
    measureTypeData =  MeasureTypeModel();
    particularController.text = "";
    files =  [];
    isParticularWidgetShow =  false;
    _eventComplete(emit);
  }

  _removeParticular(ViewCvComplaintRemoveParticularEvent event, emit) {
    isLoader =  true;
    _eventComplete(emit);
    particularList.removeAt(event.index);
    isLoader =  false;
    if(particularList.isEmpty){
      isParticularWidgetShow =  true;
    }
    _eventComplete(emit);
  }

  _submitMeasurement(ViewCvComplaintSubmitMeasurementEvent event, emit) async {
    if (measurementType == MeasurementType.sheet &&
        measurementFileSheet.path.isEmpty) {
      SnackBarErrorWidget(event.context).show(message: "Please select sheet");
      return;
    } else if (measurementType == MeasurementType.pre &&
        measurementFileList.length < 2) {
      SnackBarErrorWidget(event.context)
          .show(message: "Please select minimum two before photo");
      return;
    } else if (measurementType == MeasurementType.post &&
        measurementFileList.length < 2) {
      SnackBarErrorWidget(event.context)
          .show(message: "Please select minimum two after photo");
      return;
    }
    isLoader = true;
    _eventComplete(emit);
    var res = await ViewCvComplaintHelper.addMeasurementData(
        cngData: event.cngData,
        amount: amountController.text.toString(),
        context: event.context,
        measurementFileList: measurementFileList,
        measurementSheetFile: measurementFileSheet,
        measurementType: measurementType);
    if (res != null) {
      measurementFileList = [];
      measurementFileSheet = File("");
      measurementType =  MeasurementType.sheet;
      var resComplaint = await ViewCvComplaintHelper.addCivilVendorComplaintApi(
          fromDate: startDate.toString(), toDate: endDate.toString());
      if (resComplaint != null) {
        cngList = resComplaint;
        cngSearchList = resComplaint;
      }

      if (filterData.stationData != null &&
          filterData.stationData!.name != null) {
        stationData = filterData.stationData!;
        List<CngModel> searchList = cngSearchList
            .where((element) =>
        element.cngStation.toString().toLowerCase() ==
            stationData.name.toString().toLowerCase())
            .toList();
        cngSearchList = searchList;
      }

      if (filterData.controlRoomData != null &&
          filterData.controlRoomData!.controlRoomName != null) {
        controlRoomData = filterData.controlRoomData!;
        List<CngModel> searchList = cngSearchList
            .where((element) =>
        element.controlRoomId.toString().toLowerCase() ==
            controlRoomData.controlRoomId.toString().toLowerCase())
            .toList();
        cngSearchList = searchList;
      }
      cngData =  cngSearchList[listIndex];
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewCvComplaintState> emit) {
    emit(FetchViewCvComplaintDataState(
      cngList: cngList,
      complaintStatusList: complaintStatusList,
      complaintStatusData: complaintStatusData,
      isLoader: isLoader,
      amountController: amountController,
      file: files,
      isFilterLoader: isFilterLoader,
      cngData: cngData,
      measurementFileList: measurementFileList,
      measurementFileSheet: measurementFileSheet,
      listIndex: listIndex,
      measurementType: measurementType,
      stationData: stationData,
      stationList: stationList,
      isStationLoader: isStationLoader,
      stationController: stationController,
      filterDateController: filterDateController,
      controlRoomData: controlRoomData,
      controlRoomList: controlRoomList,
      measureTypeData: measureTypeData,
      measureTypeList: measureTypeList,
      measureController: measureController,
      particularController: particularController,
      particularList: particularList,
      isParticularWidgetShow: isParticularWidgetShow,
      unitNameData: unitNameData,
    ));
  }
}
