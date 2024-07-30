import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scarp_unit_type_model.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class AddScrapPage extends StatefulWidget {
  const AddScrapPage({super.key});

  @override
  State<AddScrapPage> createState() => _AddScrapPageState();
}

class _AddScrapPageState extends State<AddScrapPage> {

  @override
  void initState() {
    BlocProvider.of<AddScrapBloc>(context).add(
        AddScrapPageLoadEvent());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Align(
          alignment: Alignment.centerLeft,
          child: TextWidget(
            "Add Scarp",
            color: AppColor.white,
            fontSize: AppFont.font_15,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Image.asset(
            AppIcon.appLogoIgl,
            height: MediaQuery.of(context).size.width * 0.13,
            width: MediaQuery.of(context).size.width * 0.13,
          )
        ],
      ),
      body:appBackGround(
        context: context,
        child: Column(
          children: [
            const SizedBox(
              height: 55,
            ),
            const DottedDividerLine(color: Colors.white),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: BlocBuilder<AddScrapBloc, AddScrapState>(
                builder: (context, state) {
                  if (state is FetchAddScrapDataState) {
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

  Widget _itemBuilder({required FetchAddScrapDataState dataState}) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            const DottedDividerLine(color: Colors.white),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _srNumberController(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _descriptionController(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _sapCodeDropDown(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _unitController(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _imageList(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _button(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget _srNumberController({required FetchAddScrapDataState dataState}) {
    return TextFieldWidget(
        labelText: AppString.srNumber,
        controller: dataState.srNumberController,
    );
  }

  Widget _descriptionController({required FetchAddScrapDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.description,
      controller: dataState.descriptionController,
    );
  }

  Widget _sapCodeDropDown(
      {required FetchAddScrapDataState dataState}) {
    return DropdownWidget(
      hint: AppString.unitType,
      dropdownValue:
      dataState.scrapUnitTypeData.id != null ? dataState.scrapUnitTypeData : null,
      onChanged: (value) {
        BlocProvider.of<AddScrapBloc>(context)
            .add(AddScrapSelectScrapUnitTypeEvent(scrapUnitTypeData: value));
      },
      items: dataState.scrapUnitTypeList
          .map<DropdownMenuItem<ScrapUnitTypeModel>>((ScrapUnitTypeModel scrapUnitTypeData) {
        return DropdownMenuItem<ScrapUnitTypeModel>(
          value: scrapUnitTypeData,
          child: TextWidget(scrapUnitTypeData.name.toString()),
        );
      }).toList(),
    );
  }

  Widget _unitController({required FetchAddScrapDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.unit,
      controller: dataState.unitController,
      textInputType: TextInputType.number,
    );
  }

  Widget _imageList({required FetchAddScrapDataState dataState}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: dataState.filesList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) =>
            _photo(dataState: dataState, index: index),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
      ),
    );
  }

  Widget _photo(
      {required FetchAddScrapDataState dataState, required int index}) {
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
          child: dataState.filesList[index].path.isEmpty
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
                  "Photo ${1 + index}",
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
                  dataState.filesList[index].path
                      .toString()
                      .toLowerCase()
                      .contains(".jpg") ||
                      dataState.filesList[index].path
                          .toString()
                          .toLowerCase()
                          .contains(".png") ||
                      dataState.filesList[index].path
                          .toString()
                          .toLowerCase()
                          .contains(".jpeg")
                      ? Image.file(
                    dataState.filesList[index],
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 4.5,
                  )
                      : dataState.filesList[index].path
                      .toString()
                      .toLowerCase()
                      .contains(".pdf")
                      ? const Icon(Icons.picture_as_pdf_outlined)
                      : const Icon(Icons.document_scanner_outlined),
                  dataState.filesList[index].path
                      .toString()
                      .toLowerCase()
                      .contains(".pdf")
                      ? TextWidget(
                    dataState.filesList[index].path
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
                    BlocProvider.of<AddScrapBloc>(context).add(
                        AddScrapSelectFileEvent(
                            context: context, mediaType: 1, index: index));
                  },
                  child: TextWidget(
                    "Camera",
                    fontSize: AppFont.font_16,
                  )),
              const Divider(),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<AddScrapBloc>(context).add(
                        AddScrapSelectFileEvent(
                            context: context, mediaType: 2, index: index));
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

  Widget _button({required FetchAddScrapDataState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
        text: AppString.submit,
        height:
        AppConfig.getDeviceType(context: context) == DeviceType.tablet
            ? MediaQuery.of(context).size.height * 0.13
            : null,
        onPressed: () {
          BlocProvider.of<AddScrapBloc>(context)
              .add(AddScrapSubmitEvent(context: context));
        })
        : const DottedLoaderWidget();
  }
}
