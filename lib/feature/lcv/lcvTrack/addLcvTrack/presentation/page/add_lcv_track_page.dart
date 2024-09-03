import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/addLcvTrack/domain/bloc/add_lcv_track_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/addLcvTrack/domain/model/fuel_type_model.dart';

class AddLcvTrackPage extends StatefulWidget {
  const AddLcvTrackPage({super.key});

  @override
  State<AddLcvTrackPage> createState() => _AddLcvTrackPageState();
}

class _AddLcvTrackPageState extends State<AddLcvTrackPage> {
  @override
  void initState() {
    BlocProvider.of<AddLcvTrackBloc>(context)
        .add(AddLcvTruckPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        elevation: 0.0,
        title: TextWidget(
          AppString.addLcvTruck,
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
      ),
      body: BlocBuilder<AddLcvTrackBloc, AddLcvTrackState>(
        builder: (context, state) {
          if (state is FetchAddLcvTrackDataState) {
            return _itemBuilder(dataState: state);
          } else {
            return const Center(
              child: CenterLoaderWidget(),
            );
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchAddLcvTrackDataState dataState}) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: ListView(
        children: [
          _verticalSpace(),
          _vehicleCompanyTextField(dataState: dataState),
          _verticalSpace(),
          _vehicleNameTextField(dataState: dataState),
          _verticalSpace(),
          _vehicleNumberTextField(dataState: dataState),
          _verticalSpace(),
          _engineNumberTextField(dataState: dataState),
          _verticalSpace(),
          _chassisNumberTextField(dataState: dataState),
          _verticalSpace(),
          _average(dataState: dataState),
          _verticalSpace(),
          _fuelTypeDropDown(dataState: dataState),
          _verticalSpace(),
          _verticalSpace(),
          _submitButton(dataState: dataState),
          _verticalSpace(),
          _verticalSpace(),
        ],
      ),
    );
  }

  Widget _vehicleCompanyTextField(
      {required FetchAddLcvTrackDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      labelText: AppString.vehicleCompany,
      controller: dataState.vehicleCompanyController,
    );
  }

  Widget _vehicleNameTextField({required FetchAddLcvTrackDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      labelText: AppString.vehicleName,
      controller: dataState.vehicleNameController,
    );
  }

  Widget _vehicleNumberTextField(
      {required FetchAddLcvTrackDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      labelText: AppString.vehicleNumber,
      controller: dataState.vehicleNumberController,
    );
  }

  Widget _engineNumberTextField(
      {required FetchAddLcvTrackDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      labelText: AppString.engineNumber,
      controller: dataState.engineNumberController,
    );
  }

  Widget _chassisNumberTextField(
      {required FetchAddLcvTrackDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      labelText: AppString.chassisNumber,
      controller: dataState.chassisNumberController,
    );
  }

  Widget _average({required FetchAddLcvTrackDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      labelText: AppString.average,
      controller: dataState.averageController,
    );
  }

  Widget _fuelTypeDropDown({required FetchAddLcvTrackDataState dataState}) {
    return DropdownWidget(
      hint: AppString.selectLCVTruck,
      dropdownValue:
          dataState.fuelTypeData.type != null ? dataState.fuelTypeData : null,
      onChanged: (value) {
        BlocProvider.of<AddLcvTrackBloc>(context)
            .add(AddLcvTruckSelectFuelTypeEvent(
          fuelTypeData: value,
        ));
      },
      items: dataState.fuelTypeList
          .map<DropdownMenuItem<FuelTypeModel>>((FuelTypeModel fuelTypeData) {
        return DropdownMenuItem<FuelTypeModel>(
          value: fuelTypeData,
          child: Text(fuelTypeData.type.toString()),
        );
      }).toList(),
    );
  }

  Widget _submitButton({required FetchAddLcvTrackDataState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            onPressed: () {
              BlocProvider.of<AddLcvTrackBloc>(context)
                  .add(AddLcvTruckSubmitEvent(context: context));
            })
        : const DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
