import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/cngFillingForm/domain/bloc/cng_filling_form_bloc.dart';

class CngFillingStationPage extends StatefulWidget {
  const CngFillingStationPage({
    super.key,
  });

  @override
  State<CngFillingStationPage> createState() => _CngFillingStationPageState();
}

class _CngFillingStationPageState extends State<CngFillingStationPage> {
  @override
  void initState() {
    BlocProvider.of<CngFillingFormBloc>(context)
        .add(CngFillingFormPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          AppString.updateCngFilling,
          fontSize: AppFont.font_16,
          color: AppColor.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: BlocBuilder<CngFillingFormBloc, CngFillingFormState>(
        builder: (context, state) {
          if (state is FetchCngFillingDataState) {
            return _itemBuilder(dataState: state);
          } else {
            return const Center(child: CenterLoaderWidget());
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchCngFillingDataState dataState}) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            _driverName(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            _driverLicenceId(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            _scmQuantity(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            _lcvTruckNumber(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            _receivedTextFieldEdit(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            _driverLicenceNumber(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            _vehicleNumber(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            _remark(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            _saveButton(dataState: dataState),
          ],
        ),
      ),
    );
  }

  Widget _driverName({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
        enabled: false,
        isRequired: true,
        labelText: AppString.driverName,
        controller: dataState.driverController);
  }

  Widget _driverLicenceId({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
        isRequired: true,
        enabled: false,
        textInputType: TextInputType.number,
        labelText: AppString.drivingLicenceNumber,
        controller: dataState.driverLicenceIdController);
  }

  Widget _scmQuantity({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
        isRequired: true,
        enabled: false,
        textInputType: TextInputType.number,
        labelText: AppString.scmQuantity,
        controller: dataState.scmQuantityController);
  }

  Widget _lcvTruckNumber({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
        enabled: false,
        isRequired: true,
        labelText: AppString.vehicleNumber,
        controller: dataState.lcvTruckNumberController);
  }

  Widget _receivedTextFieldEdit({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
        isRequired: true,
        textInputType: TextInputType.number,
        labelText: AppString.receivedScmQuantity,
        controller: dataState.receivedScmQuantityController);
  }

  Widget _driverLicenceNumber({required FetchCngFillingDataState dataState}) {
    return Row(
      children: [
        Expanded(
          child: TextFieldWidget(
              isRequired: true,
              textInputType: TextInputType.text,
              labelText: AppString.enterDrivingLicenceNumber,
              controller: dataState.drivingLicenceController),
        ),
        IconButton(
            onPressed: () {
/*              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QrCodeScanPage(
                          onScan: (value) {
                            BlocProvider.of<CngFillingFormBloc>(context).add(
                                CngFillingFormSetDriverNoDataEvent(
                                    drivingLicence: value.toString()));
                          },
                        )),
              );*/
            },
            icon: Icon(
              Icons.qr_code_scanner,
              color: AppColor.themeColor,
            ))
      ],
    );
  }

  Widget _vehicleNumber({required FetchCngFillingDataState dataState}) {
    return Row(
      children: [
        Expanded(
          child: TextFieldWidget(
              isRequired: true,
              textInputType: TextInputType.text,
              labelText: AppString.enterVehicleNumber,
              controller: dataState.truckNumberController),
        ),
        IconButton(
            onPressed: () {
/*              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QrCodeScanPage(
                          onScan: (value) {
                            BlocProvider.of<CngFillingFormBloc>(context).add(
                                CngFillingFormSetTruckNoDataEvent(
                                    truckNumber: value.toString()));
                          },
                        )),
              );*/
            },
            icon: Icon(
              Icons.qr_code_scanner,
              color: AppColor.themeColor,
            ))
      ],
    );
  }

  Widget _remark({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
        maxLine: 3,
        isRequired: true,
        labelText: AppString.remark,
        controller: dataState.remarkController);
  }

  Widget _saveButton({required FetchCngFillingDataState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            onPressed: () {
              BlocProvider.of<CngFillingFormBloc>(context).add(
                  CngFillingFormSubmitEvent(
                      context: context, isMismatch: false));
            })
        : const DottedLoaderWidget();
  }
}
