import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class AddEquipmentComplaintPage extends StatefulWidget {
  const AddEquipmentComplaintPage({super.key});

  @override
  State<AddEquipmentComplaintPage> createState() =>
      _AddEquipmentComplaintPageState();
}

class _AddEquipmentComplaintPageState extends State<AddEquipmentComplaintPage> {
  @override
  void initState() {
    BlocProvider.of<AddEquipmentComplaintBloc>(context)
        .add(AddEquipmentComplaintPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          "Add Complaint",
          color: AppColor.white,
        ),
      ),
      body: BlocBuilder<AddEquipmentComplaintBloc, AddEquipmentComplaintState>(
        builder: (context, state) {
          if (state is FetchAddEquipmentComplaintState) {
            return _itemWWidget(dataState: state);
          } else {
            return const Center(
              child: CenterLoaderWidget(),
            );
          }
        },
      ),
    );
  }

  Widget _itemWWidget({required FetchAddEquipmentComplaintState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _verticalSpace(),
            _complaintDropDown(dataState: dataState),
            _verticalSpace(),
            dataState.complaintTypeData.id.toString() == "2"
                ? _equipmentDropDown(dataState: dataState)
                : const SizedBox.shrink(),
            dataState.complaintTypeData.id.toString() == "2"
                ? _verticalSpace()
                : const SizedBox.shrink(),
            _generalDropDown(dataState: dataState),
            _verticalSpace(),
            dataState.generalComplaintData.name != null &&
                    dataState.generalComplaintData.name
                            .toString()
                            .toLowerCase() ==
                        "others"
                ? _generalDescriptionController(dataState: dataState)
                : const SizedBox.shrink(),
            dataState.generalComplaintData.name != null &&
                    dataState.generalComplaintData.name
                            .toString()
                            .toLowerCase() ==
                        "others"
                ? _verticalSpace()
                : const SizedBox.shrink(),
            Row(
              children: [
                Expanded(child: _dateController(dataState: dataState)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Expanded(child: _timeController(dataState: dataState)),
              ],
            ),
            _verticalSpace(),
            _descriptionRemark(dataState: dataState),
            _verticalSpace(),
            _nameRemark(dataState: dataState),
            _verticalSpace(),
            _photo(dataState: dataState),
            _verticalSpace(),
            _verticalSpace(),
            _button(dataState: dataState),
          ],
        ),
      ),
    );
  }

  Widget _complaintDropDown(
      {required FetchAddEquipmentComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.selectComplaintType,
      dropdownValue: dataState.complaintTypeData.id != null
          ? dataState.complaintTypeData
          : null,
      onChanged: (value) {
        BlocProvider.of<AddEquipmentComplaintBloc>(context).add(
            AddEquipmentComplaintSelectComplaintDataEvent(
                complaintTypeData: value));
      },
      items: dataState.complaintTypeList
          .map<DropdownMenuItem<ComplaintTypeModel>>(
              (ComplaintTypeModel complaintTypeData) {
        return DropdownMenuItem<ComplaintTypeModel>(
          value: complaintTypeData,
          child: Text(complaintTypeData.name.toString()),
        );
      }).toList(),
    );
  }

  Widget _generalDropDown(
      {required FetchAddEquipmentComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.selectGeneral,
      dropdownValue: dataState.generalComplaintData.name != null
          ? dataState.generalComplaintData
          : null,
      onChanged: (value) {
        BlocProvider.of<AddEquipmentComplaintBloc>(context).add(
            AddEquipmentComplaintSelectGeneralDataEvent(
                generalComplaintData: value));
      },
      items: dataState.generalComplaintList
          .map<DropdownMenuItem<GeneralComplaintModel>>(
              (GeneralComplaintModel generalComplaintData) {
        return DropdownMenuItem<GeneralComplaintModel>(
          value: generalComplaintData,
          child: Text(generalComplaintData.name.toString()),
        );
      }).toList(),
    );
  }

  Widget _equipmentDropDown(
      {required FetchAddEquipmentComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.selectEquipment,
      dropdownValue: dataState.equipmentTypeData.description != null
          ? dataState.equipmentTypeData
          : null,
      onChanged: (value) {
        BlocProvider.of<AddEquipmentComplaintBloc>(context).add(
            AddEquipmentComplaintSelectEquipmentDataEvent(
                equipmentTypeData: value));
      },
      items: dataState.equipmentTypeList
          .map<DropdownMenuItem<EquipmentTypeModel>>(
              (EquipmentTypeModel equipmentTypeData) {
        return DropdownMenuItem<EquipmentTypeModel>(
          value: equipmentTypeData,
          child: Text(equipmentTypeData.description.toString()),
        );
      }).toList(),
    );
  }

  Widget _dateController({required FetchAddEquipmentComplaintState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: AppString.date,
      controller: dataState.dateController,
      onTap: () {
        BlocProvider.of<AddEquipmentComplaintBloc>(context)
            .add(AddEquipmentComplaintSelectDateData(context: context));
      },
    );
  }

  Widget _timeController({required FetchAddEquipmentComplaintState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: AppString.time,
      controller: dataState.timeController,
      onTap: () {
        BlocProvider.of<AddEquipmentComplaintBloc>(context)
            .add(AddEquipmentComplaintSelectTimeData(context: context));
      },
    );
  }

  Widget _generalDescriptionController(
      {required FetchAddEquipmentComplaintState dataState}) {
    return TextFieldWidget(
      labelText: AppString.otherDescription,
      controller: dataState.generalDescriptionController,
    );
  }

  Widget _descriptionRemark(
      {required FetchAddEquipmentComplaintState dataState}) {
    return TextFieldWidget(
      labelText: AppString.description,
      controller: dataState.descriptionController,
    );
  }

  Widget _nameRemark({required FetchAddEquipmentComplaintState dataState}) {
    return TextFieldWidget(
      labelText: AppString.name,
      controller: dataState.reportByController,
    );
  }

  Widget _photo({required FetchAddEquipmentComplaintState dataState}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: InkWell(
        onTap: () {
          mediaType(context: context);
        },
        child: DottedBorder(
          color: AppColor.grey,
          strokeWidth: 1,
          child: dataState.file.path.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Icon(Icons.photo_camera_back_outlined),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: TextWidget(
                        "Photo",
                        fontSize: AppFont.font_12,
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dataState.file.path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".jpg") ||
                                dataState.file.path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".png") ||
                                dataState.file.path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".jpeg")
                            ? Image.file(
                                dataState.file,
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.width / 4.5,
                              )
                            : dataState.file.path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".pdf")
                                ? const Icon(Icons.picture_as_pdf_outlined)
                                : const Icon(Icons.document_scanner_outlined),
                        dataState.file.path
                                .toString()
                                .toLowerCase()
                                .contains(".pdf")
                            ? TextWidget(
                                dataState.file.path.split('/').last.toString(),
                                color: AppColor.themeColor,
                                fontSize: AppFont.font_12,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        color: Colors.white.withOpacity(0.6),
                        child: Center(
                            child: Icon(
                          Icons.refresh,
                          color: AppColor.themeColor,
                        ))),
                  ],
                ),
        ),
      ),
    );
  }

  void mediaType({required BuildContext context}) {
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
                    BlocProvider.of<AddEquipmentComplaintBloc>(context).add(
                        AddEquipmentComplaintAddImageEvent(
                            context: context, mediaType: 1));
                  },
                  child: TextWidget(
                    "Camera",
                    fontSize: AppFont.font_16,
                  )),
              const Divider(),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<AddEquipmentComplaintBloc>(context).add(
                        AddEquipmentComplaintAddImageEvent(
                            context: context, mediaType: 2));
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

  Widget _button({required FetchAddEquipmentComplaintState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            height:
                AppConfig.getDeviceType(context: context) == DeviceType.tablet
                    ? MediaQuery.of(context).size.height * 0.13
                    : null,
            onPressed: () {
              BlocProvider.of<AddEquipmentComplaintBloc>(context)
                  .add(AddEquipmentComplaintSubmitEvent(context: context));
            })
        : const DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
