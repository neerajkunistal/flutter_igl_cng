part of 'cng_filling_form_bloc.dart';

abstract class CngFillingFormState extends Equatable {
  const CngFillingFormState();
}

class CngFillingFormInitial extends CngFillingFormState {
  @override
  List<Object> get props => [];
}

class CngFillingPageLoadState extends CngFillingFormInitial {
  @override
  List<Object> get props => [];
}

class FetchCngFillingDataState extends CngFillingFormInitial {
  final bool isLoader;
  final List<CngStationModel> cngStationList;
  final CngStationModel cngStationData;
  final TextEditingController driverController;
  final TextEditingController receivedScmQuantityController;
  final TextEditingController scmQuantityController;
  final TextEditingController unitGasMeterController;
  final TextEditingController drivingLicenceController;
  final TextEditingController truckNumberController;
  final TextEditingController lcvTruckNumberController;
  final TextEditingController driverLicenceIdController;
  final TextEditingController remarkController;
  final TextEditingController arrivalTimeController;
  final TextEditingController lcvPointTimeController;
  final TextEditingController flowMeterReadingOpenController;
  final TextEditingController flowMeterReadingClosedController;
  final TextEditingController inPressureController;
  final TextEditingController fillEndTimeController;
  final TextEditingController outPressureController;
  final bool isLcvCondition;
  final bool isDriverNotWearingUniform;
  final List<File> fileList;

  FetchCngFillingDataState({
    required this.isLoader,
    required this.cngStationData,
    required this.cngStationList,
    required this.driverController,
    required this.receivedScmQuantityController,
    required this.scmQuantityController,
    required this.unitGasMeterController,
    required this.drivingLicenceController,
    required this.truckNumberController,
    required this.remarkController,
    required this.lcvTruckNumberController,
    required this.driverLicenceIdController,
    required this.arrivalTimeController,
    required this.lcvPointTimeController,
    required this.flowMeterReadingOpenController,
    required this.flowMeterReadingClosedController,
    required this.inPressureController,
    required this.fillEndTimeController,
    required this.isLcvCondition,
    required this.isDriverNotWearingUniform,
    required this.fileList,
    required this.outPressureController,
  });

  @override
  List<Object> get props => [
        isLoader,
        cngStationList,
        cngStationData,
        driverController,
        receivedScmQuantityController,
        scmQuantityController,
        unitGasMeterController,
        drivingLicenceController,
        truckNumberController,
        remarkController,
        lcvTruckNumberController,
        driverLicenceIdController,
        arrivalTimeController,
        lcvPointTimeController,
        flowMeterReadingOpenController,
        flowMeterReadingClosedController,
        inPressureController,
        fillEndTimeController,
        isLcvCondition,
        isDriverNotWearingUniform,
        fileList,
        outPressureController,
      ];
}
