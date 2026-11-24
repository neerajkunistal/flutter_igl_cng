import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/model/cng_stattion_model.dart';
import 'package:flutter_igl_cng/feature/lcv/user/addUser/domain/bloc/add_user_bloc.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  @override
  void initState() {
    BlocProvider.of<AddUserBloc>(context)
        .add(AddUserPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          AppString.addCngUser,
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
      ),
      body: BlocBuilder<AddUserBloc, AddUserState>(
        builder: (context, state) {
          if (state is FetchAddUserDataState) {
            return _itemBuilder(dataState: state);
          } else if (state is AddUserPageLoadState) {
            return const Center(child: CenterLoaderWidget());
          } else {
            return const Center(child: CenterLoaderWidget());
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchAddUserDataState dataState}) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _verticalSpace(context: context),
            _cngStationDropdown(dataState: dataState),
            _verticalSpace(context: context),
            _fullName(dataState: dataState),
            _verticalSpace(context: context),
            _email(dataState: dataState),
            _verticalSpace(context: context),
            _phone(dataState: dataState),
            _verticalSpace(context: context),
            _address(dataState: dataState),
            _verticalSpace(context: context),
            _city(dataState: dataState),
            _verticalSpace(context: context),
            _district(dataState: dataState),
            _verticalSpace(context: context),
            _state(dataState: dataState),
            _verticalSpace(context: context),
            _verticalSpace(context: context),
            _button(dataState: dataState, context: context),
          ],
        ),
      ),
    );
  }

  Widget _cngStationDropdown({required FetchAddUserDataState dataState}) {
    return DropdownWidget(
      hint: AppString.selectCNGStation,
      dropdownValue: dataState.cngStationData.stationName != null
          ? dataState.cngStationData
          : null,
      onChanged: (value) {
        BlocProvider.of<AddUserBloc>(context).add(AddUserSetCngStationDataEvent(
          cngStationData: value,
        ));
      },
      items: dataState.cngStationList.map<DropdownMenuItem<CngStationModel>>(
          (CngStationModel cngStationData) {
        return DropdownMenuItem<CngStationModel>(
          value: cngStationData,
          child: Text(cngStationData.stationName.toString()),
        );
      }).toList(),
    );
  }

  Widget _fullName({required FetchAddUserDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.fullName,
      isRequired: true,
      controller: dataState.fullNameController,
    );
  }

  Widget _email({required FetchAddUserDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.email,
      controller: dataState.emailController,
    );
  }

  Widget _phone({required FetchAddUserDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.mobileNumber,
      isRequired: true,
      maxLength: 10,
      textInputType: TextInputType.number,
      controller: dataState.phoneNumberController,
    );
  }

  Widget _address({required FetchAddUserDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.address,
      isRequired: true,
      controller: dataState.addressController,
    );
  }

  Widget _city({required FetchAddUserDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.cityTown,
      isRequired: true,
      controller: dataState.cityController,
    );
  }

  Widget _district({required FetchAddUserDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.district,
      isRequired: true,
      controller: dataState.districtController,
    );
  }

  Widget _state({required FetchAddUserDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.state,
      isRequired: true,
      controller: dataState.stateController,
    );
  }

  Widget _button(
      {required FetchAddUserDataState dataState,
      required BuildContext context}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            onPressed: () {
              BlocProvider.of<AddUserBloc>(context)
                  .add(AddUserSubmitEvent(context: context));
            })
        : const DottedLoaderWidget();
  }

  Widget _verticalSpace({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.03,
    );
  }
}
