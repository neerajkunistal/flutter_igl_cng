import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/cngFillingForm/helper/cng_filling_stattion_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/model/cng_stattion_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'cng_filling_form_event.dart';
part 'cng_filling_form_state.dart';

class CngFillingFormBloc
    extends Bloc<CngFillingFormEvent, CngFillingFormState> {
  TextEditingController driverController = TextEditingController();
  TextEditingController receivedScmQuantityController = TextEditingController();
  TextEditingController unitGasMeterController = TextEditingController();
  TextEditingController scmQuantityController = TextEditingController();
  TextEditingController drivingLicenceController = TextEditingController();
  TextEditingController truckNumberController = TextEditingController();
  TextEditingController driverLicenceIdController = TextEditingController();
  TextEditingController lcvTruckNumberController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  List<CngStationModel> _cngStationList = [];

  List<CngStationModel> get cngStationList => _cngStationList;

  CngStationModel _cngStationData = CngStationModel();

  CngStationModel get cngStationData => _cngStationData;

  bool _isLoader = false;

  bool get isLoader => _isLoader;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  AssignmentModel _assignmentData = AssignmentModel();

  AssignmentModel get assignmentData => _assignmentData;

  CngFillingFormBloc() : super(CngFillingFormInitial()) {
    on<CngFillingFormPageLoadEvent>(_pageLoad);
    on<CngFillingFormSetAssignmentDataEvent>(_setAssignment);
    on<CngFillingFormSetDriverNoDataEvent>(_setDrivingLicence);
    on<CngFillingFormSetTruckNoDataEvent>(_setTruckNumber);
    on<CngFillingFormSubmitEvent>(_submit);
  }

  _pageLoad(CngFillingFormPageLoadEvent event, emit) async {
    emit(CngFillingPageLoadState());
    _userData = UserInfo.instance!.userData!;
    _isLoader = false;
    _cngStationData = CngStationModel();
    _cngStationList = [];
    driverController.text = assignmentData.driverName.toString();
    scmQuantityController.text = assignmentData.quantity.toString();
    unitGasMeterController.text = "";
    receivedScmQuantityController.text = "";
    driverLicenceIdController.text = assignmentData.driverLicenseId.toString();
    lcvTruckNumberController.text = assignmentData.vehicleNo.toString();
    remarkController.text = "";
    _eventCompleted(emit);
  }

  _setAssignment(CngFillingFormSetAssignmentDataEvent event, emit) {
    _assignmentData = event.assignmentData;
  }

  _setDrivingLicence(CngFillingFormSetDriverNoDataEvent event, emit) {
    drivingLicenceController.text = event.drivingLicence;
    _eventCompleted(emit);
  }

  _setTruckNumber(CngFillingFormSetTruckNoDataEvent event, emit) {
    truckNumberController.text = event.truckNumber;
    _eventCompleted(emit);
  }

  _submit(CngFillingFormSubmitEvent event, emit) async {
    var textFiledValidation = await CngFillingStationHelper.textFieldValidation(
        context: event.context,
        recievedScmQuantity: scmQuantityController.text.toString(),
        currentScmQuantity: receivedScmQuantityController.text.toString(),
        drivingLicence: drivingLicenceController.text.toString(),
        truckNumber: truckNumberController.text.toString(),
        remark: remarkController.text.toString());
    if (textFiledValidation == false) {
      return;
    }

    _isLoader = true;
    _eventCompleted(emit);
    var res = await CngFillingStationHelper.fetchCngFillingStationList(
        userDat: userData,
        assignmentData: assignmentData,
        context: event.context,
        scmQuantity: scmQuantityController.text.toString(),
        receivedScmQuantity: receivedScmQuantityController.text.toString(),
        drivingLicence: drivingLicenceController.text.toString(),
        truckNumber: truckNumberController.text.toString(),
        remark: remarkController.text.toString(),
        isMismatch: event.isMismatch);
    _isLoader = false;
    _eventCompleted(emit);
    if (res != null) {
/*      BlocProvider.of<RunningTruckBloc>(event.context)
          .add(RunningTruckPageLoadEvent(context: event.context));
      Navigator.pop(event.context);*/
    }
  }

  _eventCompleted(Emitter<CngFillingFormState> emit) {
    emit(FetchCngFillingDataState(
      isLoader: isLoader,
      driverController: driverController,
      cngStationData: cngStationData,
      cngStationList: cngStationList,
      receivedScmQuantityController: receivedScmQuantityController,
      scmQuantityController: scmQuantityController,
      unitGasMeterController: unitGasMeterController,
      truckNumberController: truckNumberController,
      drivingLicenceController: drivingLicenceController,
      remarkController: remarkController,
      lcvTruckNumberController: lcvTruckNumberController,
      driverLicenceIdController: driverLicenceIdController,
    ));
  }
}
