import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/addCNGStation/domain/bloc/add_cng_station_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/presentation/widgest/AddressTextFieldWidgest.dart';

class AddCngStationPage extends StatefulWidget {
  const AddCngStationPage({super.key});

  @override
  State<AddCngStationPage> createState() => _AddCngStationPageState();
}

class _AddCngStationPageState extends State<AddCngStationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          AppString.addCngStation,
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
      ),
      body: BlocBuilder<AddCngStationBloc, AddCngStationState>(
        builder: (context, state) {
          if (state is FetchAddCNGStationDataState) {
            return _itemBuilder(dataState: state);
          } else if (state is AddCNGStationPageLoadState) {
            return const Center(child: CenterLoaderWidget());
          } else {
            return const Center(child: CenterLoaderWidget());
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchAddCNGStationDataState dataState}) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _verticalSpace(),
            _stationCodeTextField(dataState: dataState),
            _verticalSpace(),
            _stationNameTextField(dataState: dataState),
            _verticalSpace(),
            _address(dataState: dataState),
            _verticalSpace(),
            _city(dataState: dataState),
            _verticalSpace(),
            _state(dataState: dataState),
            _verticalSpace(),
            _district(dataState: dataState),
            _verticalSpace(),
            _pincode(dataState: dataState),
            _verticalSpace(),
            _officerName(dataState: dataState),
            _verticalSpace(),
            _phoneNumber(dataState: dataState),
            _verticalSpace(),
            _emailId(dataState: dataState),
            _verticalSpace(),
            _verticalSpace(),
            _button(dataState: dataState),
            _verticalSpace(),
            _verticalSpace(),
          ],
        ),
      ),
    );
  }

  Widget _stationCodeTextField(
      {required FetchAddCNGStationDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.stationCodeController,
      labelText: AppString.enterStationCode,
    );
  }

  Widget _stationNameTextField(
      {required FetchAddCNGStationDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.stationNameController,
      labelText: AppString.enterStationName,
    );
  }

  Widget _address({required FetchAddCNGStationDataState dataState}) {
    return AddressTextFieldWidget(
      maxLines: 2,
      height: MediaQuery.of(context).size.height * 0.06,
      address: dataState.addressController.text.toString(),
      callback: (value) {
        if (value.toString().isNotEmpty) {
          BlocProvider.of<AddCngStationBloc>(context)
              .add(AddCngStationSetAddressEvent(address: value));
        }
      },
    );
  }

  Widget _city({required FetchAddCNGStationDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.cityController,
      labelText: AppString.cityTown,
    );
  }

  Widget _state({required FetchAddCNGStationDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.stateController,
      labelText: AppString.state,
    );
  }

  Widget _district({required FetchAddCNGStationDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.districtController,
      labelText: AppString.district,
    );
  }

  Widget _pincode({required FetchAddCNGStationDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      controller: dataState.pincodeController,
      labelText: AppString.pincode,
    );
  }

  Widget _officerName({required FetchAddCNGStationDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.officerNameController,
      labelText: AppString.enterOfficerName,
    );
  }

  Widget _phoneNumber({required FetchAddCNGStationDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.phoneNumberController,
      labelText: AppString.mobileNumber,
    );
  }

  Widget _emailId({required FetchAddCNGStationDataState dataState}) {
    return TextFieldWidget(
      controller: dataState.emailController,
      labelText: AppString.email,
    );
  }

  Widget _button({required FetchAddCNGStationDataState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            onPressed: () {
              BlocProvider.of<AddCngStationBloc>(context)
                  .add(AddCngStationSubmitEvent(context: context));
            })
        : const DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.03,
    );
  }
}
