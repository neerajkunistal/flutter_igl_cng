import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _verticalSpace(),
            _driverName(dataState: dataState),
            _verticalSpace(),
            _lcvTruckNumber(dataState: dataState),
            _verticalSpace(),
            _arrivalTimeController(dataState: dataState),
            _verticalSpace(),
            _lcvPointTimeController(dataState: dataState),
            _verticalSpace(),
            _flowMeterReadingOpenController(dataState: dataState),
            _verticalSpace(),
            _inPressureController(dataState: dataState),
            _verticalSpace(),
            _flowMeterReadingClosedController(dataState: dataState),
            _verticalSpace(),
            _outPressureController(dataState: dataState),
            _verticalSpace(),
            _fillEndTimeController(dataState: dataState),
            _verticalSpace(),
            TextWidget(AppString.checklist, fontWeight: FontWeight.w700,),
            _verticalSpace(),
            _lcvCondition(dataState: dataState),
            _verticalSpace(),
            _driverNotWearingUniform(dataState: dataState),
            _verticalSpace(),
            Align(
                alignment: Alignment.centerLeft,
                child: _photo(dataState: dataState, index: 0, file: File(""), context: context)),
            _verticalSpace(),
            _imageList(dataState: dataState),
            _verticalSpace(),
            _verticalSpace(),
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

  Widget _lcvTruckNumber({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
        enabled: false,
        isRequired: true,
        labelText: AppString.vehicleNumber,
        controller: dataState.lcvTruckNumberController);
  }

  Widget _arrivalTimeController({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
         onTap: () {
           BlocProvider.of<CngFillingFormBloc>(context)
               .add(CngFillingArrivalTimeEvent(
             context: context,
           ));
         },
        isRequired: true,
        enabled: false,
        labelText: AppString.arrivalTime,
        controller: dataState.arrivalTimeController);
  }

  Widget _lcvPointTimeController({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
        onTap: () {
          BlocProvider.of<CngFillingFormBloc>(context)
              .add(CngFillingLcvPointTimeEvent(
            context: context,
          ));
        },
        isRequired: true,
        enabled: false,
        labelText: AppString.lcvPointTime,
        controller: dataState.lcvPointTimeController);
  }

  Widget _flowMeterReadingOpenController({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
        isRequired: true,
        textInputType: TextInputType.number,
        labelText: AppString.flowMeterReadingOpen,
        controller: dataState.flowMeterReadingOpenController);
  }

  Widget _inPressureController({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
        isRequired: true,
        labelText: AppString.inPressure,
        textInputType: TextInputType.number,
        controller: dataState.inPressureController);
  }

  Widget _flowMeterReadingClosedController({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
        isRequired: true,
        labelText: AppString.flowMeterReadingClosed,
        textInputType: TextInputType.number,
        controller: dataState.flowMeterReadingClosedController);
  }

  Widget _outPressureController({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
        isRequired: true,
        labelText: AppString.outPressure,
        textInputType: TextInputType.number,
        controller: dataState.outPressureController);
  }

  Widget _fillEndTimeController({required FetchCngFillingDataState dataState}) {
    return TextFieldWidget(
        onTap: () {
          BlocProvider.of<CngFillingFormBloc>(context)
              .add(CngFillingFillEndTimeEvent(
            context: context,
          ));
        },
        isRequired: true,
        enabled: false,
        labelText: AppString.fillEndTime,
        controller: dataState.fillEndTimeController);
  }

  Widget _lcvCondition( {required FetchCngFillingDataState dataState}) {
    return Column(
      children: [
        _radioButton(
            selectedValue: dataState.isLcvCondition,
            title: AppString.lcvCondition,
            label1: "Ok",
            label2: "Not Ok",
            onChanged: (value) {
              BlocProvider.of<CngFillingFormBloc>(context).add(CngFillingCheckListEvent(
                  checklist: 1, isSelected: value == "0" ? false : true
              ));
            }
        ),
        dataState.isLcvCondition == false ?
        TextFieldWidget(
          labelText: AppString.remark,
          controller: dataState.remarkController,
        ) : const SizedBox.shrink(),
      ],
    );
  }

  Widget _driverNotWearingUniform( {required FetchCngFillingDataState dataState}) {
    return _radioButton(
        selectedValue: dataState.isDriverNotWearingUniform,
        title: AppString.driverNotWearingUniform,
        onChanged: (value) {
          BlocProvider.of<CngFillingFormBloc>(context).add(CngFillingCheckListEvent(
              checklist: 2, isSelected: value == "0" ? false : true
          ));
        }
    );
  }

  Widget _imageList({required FetchCngFillingDataState dataState}) {
    return dataState.fileList.isNotEmpty
        ? SizedBox(
      // height: MediaQuery.of(context).size.height / 6,
      child: GridView.builder(
        itemCount: dataState.fileList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _photo(
            context: context,
            dataState: dataState,
            index: index,
            file: dataState.fileList[index]),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
      ),
    )
        : const SizedBox.shrink();
  }

  Widget _photo({required FetchCngFillingDataState dataState,
    required int index,
    required File file, required BuildContext context}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      height: MediaQuery.of(context).size.width / 4,
      child: InkWell(
        onTap: () async {
          mediaType(context: context, index: index);
        },
        child: DottedBorder(
          color: AppColor.grey,
          strokeWidth: 1,
          child: file.path.isEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Icon(Icons.photo_camera_back_outlined),
              ),
              Padding (
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.02),
                child: TextWidget(
                  "Add Photo",
                  fontSize: AppFont.font_12,
                  color: AppColor.grey,
                ),
              ),
            ],
          ) : Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  file.path.toString().toLowerCase().contains(".jpg") ||
                      file.path
                          .toString()
                          .toLowerCase()
                          .contains(".png") ||
                      file.path
                          .toString()
                          .toLowerCase()
                          .contains(".jpeg")
                      ? Image.file(
                    file,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 4.5,
                  )
                      : file.path
                      .toString()
                      .toLowerCase()
                      .contains(".pdf")
                      ? const Icon(Icons.picture_as_pdf_outlined)
                      : const Icon(Icons.document_scanner_outlined),
                  file.path.toString().toLowerCase().contains(".pdf")
                      ? TextWidget(
                    file.path.split('.').last.toString(),
                    maxLines: 1,
                    color: EnvironmentConfig.of(context)!.primaryTheme,
                    fontSize: AppFont.font_12,
                  ) : const SizedBox.shrink(),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<CngFillingFormBloc>(context).add(
                        CngFillingDeletePhotoEvent(index: index));
                  },
                  child: Icon(
                    Icons.close,
                    color: AppColor.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void mediaType({required BuildContext context, required int index}) {
    showModalBottomSheet(
      context: context, // Also default
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.18,
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    BlocProvider.of<CngFillingFormBloc>(context)
                        .add(CngFillingSelectPhotoEvent(
                      context: context,
                      mediaType: 1,
                    ));
                    Navigator.pop(context);
                  },
                  child: TextWidget(
                    "Camera",
                    fontSize: AppFont.font_16,
                  )),
              const Divider(),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<CngFillingFormBloc>(context)
                        .add(CngFillingSelectPhotoEvent(
                      context: context,
                      mediaType: 2,
                    ));
                    Navigator.pop(context);
                  },
                  child: TextWidget(
                    "Gallery",
                    fontSize: AppFont.font_16,
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _radioButton({required bool selectedValue,
    required String title,
    String? label1,
    String? label2,
    required ValueChanged<dynamic> onChanged
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextWidget(title, fontWeight: FontWeight.w700, fontSize: AppFont.font_11,),
              TextWidget("*", fontWeight: FontWeight.w700, fontSize: AppFont.font_11, color: AppColor.red,),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                RadioListTile<String>(
                  title: TextWidget(label1 ?? AppString.yes),
                  value: '1',
                  groupValue: selectedValue == true ? "1" : "0",
                  onChanged: onChanged,
                ),
                RadioListTile<String>(
                  title: TextWidget(label2 ?? AppString.no),
                  value: '0',
                  groupValue: selectedValue == true ? "1" : "0",
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
