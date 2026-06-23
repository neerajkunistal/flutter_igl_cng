import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/background_widget.dart';

class AddSparePartPage extends StatefulWidget {
  const AddSparePartPage({super.key});

  @override
  State<AddSparePartPage> createState() => _AddSparePartPageState();
}

class _AddSparePartPageState extends State<AddSparePartPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackgroundWidget(
        child: Column(
          children: [
            _appBar(),
            const DottedDividerLine(color: Colors.white),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: BlocBuilder<AddSparePartBloc, AddSparePartState>(
                builder: (context, state) {
                  if (state is FetchAddSparePartDataState) {
                    return Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: _itemBuilder(dataState: state));
                  } else {
                    return const Center(
                      child: CenterLoaderWidget(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          "Add Spare Part",
          color: AppColor.white,
          fontSize: AppFont.font_15,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Image.asset(
          AppConfig.instanceInit()!.client == Client.igl
              ? AppIcon.appLogoIgl
              : AppConfig.instanceInit()!.client == Client.pbgpl
              ? AppIcon.appLogoPurvaBharti
              : AppConfig.instanceInit()!.client == Client.mahanagar
              ? AppIcon.appLogoMGL
              : AppConfig.instanceInit()!.client == Client.hpcl
              ? AppIcon.appLogoHPCL
              : AppIcon.appLogoIgl,
          height: MediaQuery.of(context).size.width * 0.13,
          width: MediaQuery.of(context).size.width * 0.13,
        )
      ],
    );
  }

  Widget _itemBuilder({required FetchAddSparePartDataState dataState}) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            _verticalSpace(),
            _sparesDropDown(dataState: dataState),
            _verticalSpace(),
           // _sparesController(dataState: dataState),
            _qtyController(dataState: dataState),
            _verticalSpace(),
            _materialCodeController(dataState: dataState),
            _verticalSpace(),
            _remarkController(dataState: dataState),
            _verticalSpace(),
            _submit(dataState: dataState),
            _verticalSpace(),
          ],
        ),
      ),
    );
  }

  Widget _sparesDropDown({required FetchAddSparePartDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.sparesData.id != null ? dataState.sparesData : null,
      hint: AppString.selectSpares,
      items: dataState.sparePartList,
      itemAsString: (sparesData) => sparesData.spareName.toString(),
      onChanged: (value) {
        BlocProvider.of<AddSparePartBloc>(context)
            .add(AddSparePartSelectPartEvent(sparesData: value));
      },
    );
  }

  Widget _sparesController({required FetchAddSparePartDataState dataState}) {
    return dataState.sparesData.spareName.toString() == "Others" ? Column(
      children: [
        TextFieldWidget(
          textInputType: TextInputType.text,
          labelText: AppString.otherDescription,
          controller: dataState.sparesController,
        ),
        _verticalSpace(),
      ],
    ) : SizedBox.shrink();
  }

  Widget _qtyController({required FetchAddSparePartDataState dataState}) {
    return TextFieldWidget(
      textInputType: TextInputType.number,
      isRequired: true,
      labelText: dataState.sparesData.id != null
          ? dataState.sparesData.spareUom.toString()
          : AppString.qty,
      controller: dataState.qtyController,
    );
  }

  Widget _materialCodeController({required FetchAddSparePartDataState dataState,}) {
    return TextFieldWidget(
      textInputType: TextInputType.text,
      isRequired: true,
      labelText: AppString.materialCode,
      controller: dataState.materialCodeController,
    );
  }

  Widget _remarkController({required FetchAddSparePartDataState dataState,}) {
    return TextFieldWidget(
      labelText: AppString.remark,
      controller: dataState.remarkCodeController,
    );
  }

  Widget _submit({required FetchAddSparePartDataState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
        text: AppString.submit,
        onPressed: () {
          BlocProvider.of<AddSparePartBloc>(context)
          .add(AddSparePartSubmitEvent(context: context));
       }
    ) : const DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.02,
    );
  }
}
