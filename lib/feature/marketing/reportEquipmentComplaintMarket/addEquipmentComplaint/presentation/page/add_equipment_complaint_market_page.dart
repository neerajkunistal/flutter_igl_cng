import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/addEquipmentComplaint/domain/bloc/add_equipment_complaint_market_bloc.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class AddEquipmentComplaintMarketPage extends StatefulWidget {
  final EquipmentComplaintType equipmentComplaintType;

  const AddEquipmentComplaintMarketPage(
      {super.key, required this.equipmentComplaintType});

  @override
  State<AddEquipmentComplaintMarketPage> createState() =>
      _AddEquipmentComplaintMarketPageState();
}

class _AddEquipmentComplaintMarketPageState extends State<AddEquipmentComplaintMarketPage> {
  @override
  void initState() {
    BlocProvider.of<AddEquipmentComplaintMarketBloc>(context).add(
        AddEquipmentComplaintMarketPageLoadEvent(
            context: context,
            equipmentComplaintType: widget.equipmentComplaintType));
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
              child: BlocBuilder<AddEquipmentComplaintMarketBloc,
                  AddEquipmentComplaintMarketState>(
                builder: (context, state) {
                  if (state is FetchAddEquipmentComplaintMarketState) {
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

  Widget _itemWWidget({required FetchAddEquipmentComplaintMarketState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: _marketingForm(dataState: dataState)
      ),
    );
  }
  Widget _marketingForm({required FetchAddEquipmentComplaintMarketState dataState}) {
    final isOther = dataState.facilityData.name?.toString().toLowerCase() == "others";
    return Column(
      children: [
        _verticalSpace(),
        _facilityDropDown(dataState: dataState),
        _verticalSpace(),
        if (isOther) ...[
          _facilityOtherField(dataState: dataState),
          _verticalSpace(),
        ],
        if (dataState.facilityData.id != null) ...[
          _categoryDropDown(dataState: dataState),
          _verticalSpace(),
        ],
        if (dataState.categoryData.id != null) ...[
          _subCategoryDropDown(dataState: dataState),
          _verticalSpace(),
        ],
        Row(children: [
          Expanded(child: _dateController(dataState: dataState)),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Expanded(child: _timeController(dataState: dataState)),
        ]),
        _verticalSpace(),
        _userNameField(dataState: dataState),
        _verticalSpace(),
        _mobileNumberField(dataState: dataState),
        _verticalSpace(),
        _marketingDescription(dataState: dataState),
        _verticalSpace(),
        _imageList(dataState: dataState),
        _verticalSpace(),
        _video(dataState: dataState, index: 0),
        _verticalSpace(),
        _verticalSpace(),
        _button(dataState: dataState),
      ],
    );
  }


  Widget _dateController({required FetchAddEquipmentComplaintMarketState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: AppString.date,
      controller: dataState.dateController,
      onTap: () {
        /*    BlocProvider.of<AddEquipmentComplaintMarketBloc>(context)
            .add(AddEquipmentComplaintMarketSelectDateData(context: context));*/
      },
    );
  }

  Widget _timeController({required FetchAddEquipmentComplaintMarketState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: AppString.time,
      controller: dataState.timeController,
      onTap: () {
        BlocProvider.of<AddEquipmentComplaintMarketBloc>(context)
            .add(AddEquipmentComplaintMarketSelectTimeData(context: context));
      },
    );
  }




  Widget _imageList({required FetchAddEquipmentComplaintMarketState dataState}) {
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

  Widget _photo({required FetchAddEquipmentComplaintMarketState dataState, required int index}) {
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
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<AddEquipmentComplaintMarketBloc>(context)
                        .add(AddEquipmentComplaintMarketRemoveImageEvent(
                        index: index));
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
                    BlocProvider.of<AddEquipmentComplaintMarketBloc>(context).add(
                        AddEquipmentComplaintMarketAddImageEvent(
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
                    BlocProvider.of<AddEquipmentComplaintMarketBloc>(context).add(
                        AddEquipmentComplaintMarketAddImageEvent(
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
      {required FetchAddEquipmentComplaintMarketState dataState,
        required int index}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: dataState.isFileLoader == false
          ? InkWell(
        onTap: () async {
          BlocProvider.of<AddEquipmentComplaintMarketBloc>(context).add(
              AddEquipmentComplaintMarketAddVideoEvent(
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
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<AddEquipmentComplaintMarketBloc>(
                        context)
                        .add(AddEquipmentComplaintMarketRemoveVideoEvent(
                        index: index));
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
      )
          : const DottedLoaderWidget(),
    );
  }

  Widget _button({required FetchAddEquipmentComplaintMarketState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
        text: AppString.submit,
        height:
        AppConfig.getDeviceType(context: context) == DeviceType.tablet
            ? MediaQuery.of(context).size.height * 0.13
            : null,
        onPressed: () {
          BlocProvider.of<AddEquipmentComplaintMarketBloc>(context)
              .add(AddEquipmentComplaintMarketSubmitEvent(context: context));
        })
        : const DottedLoaderWidget();
  }

  Widget _facilityDropDown({required FetchAddEquipmentComplaintMarketState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      hint: "Select Facility",
      selectedItem: dataState.facilityData.id != null ? dataState.facilityData : null,
      items: dataState.facilityList,
      itemAsString: (f) => f.name.toString(),
      onChanged: (value) => BlocProvider.of<AddEquipmentComplaintMarketBloc>(context)
          .add(AddEquipmentComplaintMarketSelectFacilityDataEvent(facilityData: value)),
    );
  }

  Widget _facilityOtherField({required FetchAddEquipmentComplaintMarketState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      labelText: "Facility (Others)",
      controller: dataState.facilityOtherController,
    );
  }

  Widget _categoryDropDown({required FetchAddEquipmentComplaintMarketState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      hint: "Select Category",
      selectedItem: dataState.categoryData.id != null ? dataState.categoryData : null,
      items: dataState.categoryList,
      itemAsString: (c) => c.name.toString(),
      onChanged: (value) => BlocProvider.of<AddEquipmentComplaintMarketBloc>(context)
          .add(AddEquipmentComplaintMarketSelectCategoryDataEvent(categoryData: value)),
    );
  }

  Widget _subCategoryDropDown({required FetchAddEquipmentComplaintMarketState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      hint: "Select Sub Category",
      selectedItem: dataState.subCategoryData.id != null ? dataState.subCategoryData : null,
      items: dataState.subCategoryList,
      itemAsString: (c) => c.name.toString(),
      onChanged: (value) => BlocProvider.of<AddEquipmentComplaintMarketBloc>(context)
          .add(AddEquipmentComplaintMarketSelectSubCategoryDataEvent(subCategoryData: value)),
    );
  }

  Widget _marketingDescription({required FetchAddEquipmentComplaintMarketState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      labelText: AppString.description,
      controller: dataState.marketingDescriptionController,
    );
  }

  Widget _userNameField({required FetchAddEquipmentComplaintMarketState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      labelText: "User Name",
      controller: dataState.userNameController,
      // keyboardType: TextInputType.phone, maxLength: 10 — if TextFieldWidget exposes them
    );
  }

  Widget _mobileNumberField({required FetchAddEquipmentComplaintMarketState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      labelText: "Mobile Number",
      controller: dataState.mobileController,
        textInputType: TextInputType.phone, maxLength: 10
    );
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
