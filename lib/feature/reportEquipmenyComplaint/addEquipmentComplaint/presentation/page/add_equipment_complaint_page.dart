import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

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
      extendBodyBehindAppBar: true,
      body: appBackGround(
        context: context,
        child: Column(
          children: [
            _appBar(),
            const DottedDividerLine(color: Colors.white),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: BlocBuilder<AddEquipmentComplaintBloc,
                  AddEquipmentComplaintState>(
                builder: (context, state) {
                  if (state is FetchAddEquipmentComplaintState) {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white.withOpacity(0.9),
                        ),
                        child: _itemWWidget(dataState: state));
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
          "Add Complaint",
          color: AppColor.white,
          fontSize: AppFont.font_15,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Image.asset(
          AppConfig.instanceInit()!.client == Client.iglcng
              ? AppIcon.appLogoIgl
              : AppIcon.appLogoIgl,
          height: MediaQuery.of(context).size.width * 0.13,
          width: MediaQuery.of(context).size.width * 0.13,
        )
      ],
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

            dataState.complaintTypeData.id.toString() == "1"
                ? _generalDropDown(dataState: dataState)
                : const SizedBox.shrink(),
            dataState.complaintTypeData.id.toString() == "1"
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
            _imageList(dataState: dataState),
            _verticalSpace(),
            _video(dataState: dataState, index: 0),
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
          child: TextWidget(complaintTypeData.alias.toString()),
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
    return DropDownSearchWidget(
      selectedItem: dataState.equipmentTypeData.equipmentCode != null
          ? dataState.equipmentTypeData
          : null,
      hint: AppString.selectEquipment,
      items: dataState.equipmentTypeList,
      itemAsString: (equipmentTypeData) =>
          "${equipmentTypeData.descriptionKva.toString()} (${equipmentTypeData.equipmentCode.toString()})",
      onChanged: (value) {
        BlocProvider.of<AddEquipmentComplaintBloc>(context).add(
            AddEquipmentComplaintSelectEquipmentDataEvent(
                equipmentTypeData: value));
      },
    );
  }

  Widget _dateController({required FetchAddEquipmentComplaintState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: AppString.date,
      controller: dataState.dateController,
      onTap: () {
    /*    BlocProvider.of<AddEquipmentComplaintBloc>(context)
            .add(AddEquipmentComplaintSelectDateData(context: context));*/
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


  Widget _descriptionRemark(
      {required FetchAddEquipmentComplaintState dataState}) {
    return TextFieldWidget(
      labelText: AppString.description,
      controller: dataState.descriptionController,
    );
  }

  Widget _nameRemark({required FetchAddEquipmentComplaintState dataState}) {
    return TextFieldWidget(
      labelText: AppString.reportedByName,
      controller: dataState.reportByController,
    );
  }

  Widget _imageList({required FetchAddEquipmentComplaintState dataState}) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: dataState.files.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) =>
          _photo(dataState: dataState, index: index),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
    );
  }

  Widget _photo(
      {required FetchAddEquipmentComplaintState dataState,
      required int index}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: InkWell(
        onTap: () async {
          mediaType(context: context, index: index);
        },
        child: DottedBorder(
          color: AppColor.grey,
          strokeWidth: 1,
          child: dataState.files[index].path.isEmpty
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
                        "${AppString.photo} ${1 + index}",
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
                        dataState.files[index].path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".jpg") ||
                                dataState.files[index].path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".png") ||
                                dataState.files[index].path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".jpeg")
                            ? Image.file(
                                dataState.files[index],
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.width / 4.5,
                              )
                            : dataState.files[index].path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".pdf")
                                ? const Icon(Icons.picture_as_pdf_outlined)
                                : const Icon(Icons.document_scanner_outlined),
                        dataState.files[index].path
                                .toString()
                                .toLowerCase()
                                .contains(".pdf")
                            ? TextWidget(
                                dataState.files[index].path
                                    .split('/')
                                    .last
                                    .toString(),
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
                    BlocProvider.of<AddEquipmentComplaintBloc>(context).add(
                        AddEquipmentComplaintAddImageEvent(
                            context: context, mediaType: 1, index: index));
                    Navigator.pop(context);
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
                            context: context, mediaType: 2, index: index));
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

  Widget _video(
      {required FetchAddEquipmentComplaintState dataState,
      required int index}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: dataState.isFileLoader == false
          ? InkWell(
              onTap: () async {
                BlocProvider.of<AddEquipmentComplaintBloc>(context).add(
                    AddEquipmentComplaintAddVideoEvent(
                        context: context, mediaType: 1, index: index));
              },
              child: DottedBorder(
                color: AppColor.grey,
                strokeWidth: 1,
                child: dataState.videoFiles[index].path.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: Icon(Icons.video_collection_outlined),
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
                            child: TextWidget(
                              AppString.video,
                              fontSize: AppFont.font_12,
                              color: AppColor.grey,
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.video_collection_outlined,
                                  color: AppColor.themeColor,
                                  size:
                                      MediaQuery.of(context).size.width * 0.20,
                                ),
                                TextWidget(
                                  "video.${dataState.videoFiles[index].path.toString().split(".").last}",
                                  maxLines: 1,
                                  fontSize: AppFont.font_11,
                                ),
                              ],
                            ),
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
            )
          : const DottedLoaderWidget(),
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
