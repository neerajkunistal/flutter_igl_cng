import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class AddCngScmPage extends StatefulWidget {
  const AddCngScmPage({super.key});

  @override
  State<AddCngScmPage> createState() => _AddCngScmPageState();
}

class _AddCngScmPageState extends State<AddCngScmPage> {
  @override
  void initState() {
    BlocProvider.of<AddCngScmBloc>(context)
        .add(AddCngScmPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: TextWidget(
          AppString.addScmInfo,
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
      ),
      body: BlocBuilder<AddCngScmBloc, AddCngScmState>(
        builder: (context, state) {
          if (state is FetchAddCngScmDataState) {
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

  Widget _itemBuilder({required FetchAddCngScmDataState dataState}) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: Column(
        children: [
          _verticalSpace(),
          _currentScmTextField(dataState: dataState),
          _verticalSpace(),
          _sellScmTextField(dataState: dataState),
          _verticalSpace(),
          _remainScmTextField(dataState: dataState),
          _verticalSpace(),
          _requiredScmTextField(dataState: dataState),
          _verticalSpace(),
          _verticalSpace(),
          _submitButton(dataState: dataState),
        ],
      ),
    );
  }

  Widget _currentScmTextField({required FetchAddCngScmDataState dataState}) {
    return TextFieldWidget(
        isRequired: true,
        textInputType: TextInputType.number,
        labelText: AppString.currentScmQuantity,
        controller: dataState.currentScmController);
  }

  Widget _sellScmTextField({required FetchAddCngScmDataState dataState}) {
    return TextFieldWidget(
        isRequired: true,
        textInputType: TextInputType.number,
        labelText: AppString.sellScmQuantity,
        controller: dataState.sellScmController);
  }

  Widget _remainScmTextField({required FetchAddCngScmDataState dataState}) {
    return TextFieldWidget(
        isRequired: true,
        textInputType: TextInputType.number,
        labelText: AppString.remainScmQuantity,
        controller: dataState.remainScnController);
  }

  Widget _requiredScmTextField({required FetchAddCngScmDataState dataState}) {
    return TextFieldWidget(
        isRequired: true,
        textInputType: TextInputType.number,
        labelText: AppString.requiredScmQuantity,
        controller: dataState.requiredScmController);
  }

  Widget _submitButton({required FetchAddCngScmDataState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            onPressed: () {
              BlocProvider.of<AddCngScmBloc>(context)
                  .add(AddCngScmSubmitEvent(context: context));
            })
        : const DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.03,
    );
  }
}
