import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/bloc/add_cng_bloc.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class AddCngPage extends StatefulWidget {
  const AddCngPage({super.key});

  @override
  State<AddCngPage> createState() => _AddCngPageState();
}

class _AddCngPageState extends State<AddCngPage> {
  @override
  void initState() {
    BlocProvider.of<AddCngBloc>(context).add(AddCngPageLoadEvent());
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
              child: BlocBuilder<AddCngBloc, AddCngState>(
                builder: (context, state) {
                  if (state is FetchAddCngDataState) {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white.withOpacity(0.9),
                        ),
                        child: _itemBuilder(dataState: state));
                  } else {
                    return const CenterLoaderWidget();
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
          "Add Civil Complaint",
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

  Widget _itemBuilder({required FetchAddCngDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _verticalSpace(),
            _controlRoomController(dataState: dataState),
            _verticalSpace(),
            _cngStationController(dataState: dataState),
            _verticalSpace(),
            _categoryDropDown(dataState: dataState),
            _verticalSpace(),
            Row(
              children: [
                Expanded(child: _dateController(dataState: dataState)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                //Expanded(child: _timeController(dataState: dataState)),
              ],
            ),
            _verticalSpace(),
            _descriptionController(dataState: dataState),
            _verticalSpace(),
            _reportedByController(dataState: dataState),
            _verticalSpace(),
           _reportedPhoneController(dataState: dataState),
           _verticalSpace(),
/*            _photo(dataState: dataState, index: 0, file: File("")),
            _verticalSpace(),*/
            _imageList(dataState: dataState),
            _verticalSpace(),
            _submit(dataState: dataState),
            _verticalSpace(),
            _verticalSpace(),
          ],
        ),
      ),
    );
  }

  Widget _controlRoomController({required FetchAddCngDataState dataState}) {
    TextEditingController controller = TextEditingController(
        text: dataState.crStationData.controlRoomName ?? "");
    return TextFieldWidget(
        controller: controller,
        isRequired: true,
        enabled: false,
        labelText: AppString.controlRoom);
  }

  Widget _cngStationController({required FetchAddCngDataState dataState}) {
    TextEditingController controller = TextEditingController(
        text: dataState.crStationData.cngStationName ?? "");
    return TextFieldWidget(
        controller: controller,
        isRequired: true,
        enabled: false,
        labelText: AppString.cngStation);
  }

  Widget _categoryDropDown({required FetchAddCngDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem:
          dataState.categoryData.name != null ? dataState.categoryData : null,
      hint: AppString.category,
      items: dataState.categoryList,
      itemAsString: (categoryData) => categoryData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<AddCngBloc>(context)
            .add(AddCngSelectCategoryDataEvent(categoryData: value));
      },
    );
  }

  Widget _dateController({required FetchAddCngDataState dataState}) {
    return TextFieldWidget(
      controller: dataState.dateController,
      isRequired: true,
      enabled: false,
      labelText: AppString.date,
      onTap: () {
        BlocProvider.of<AddCngBloc>(context)
            .add(AddCngSelectDateEvent(context: context));
      },
    );
  }

  Widget _descriptionController({required FetchAddCngDataState dataState}) {
    return TextFieldWidget(
      controller: dataState.descriptionController,
      isRequired: true,
      labelText: AppString.description,
    );
  }

  Widget _reportedByController({required FetchAddCngDataState dataState}) {
    return TextFieldWidget(
      controller: dataState.reportedByController,
      isRequired: true,
      labelText: AppString.reportedBy,
    );
  }

  Widget _reportedPhoneController({required FetchAddCngDataState dataState}) {
    return TextFieldWidget(
      controller: dataState.reportedByPhoneController,
      isRequired: true,
      textInputType: TextInputType.number,
      labelText: AppString.reportedPhone,
    );
  }

  Widget _submit({required FetchAddCngDataState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            onPressed: () {
              BlocProvider.of<AddCngBloc>(context)
                  .add(AddCngSubmitEvent(context: context));
            })
        : const DottedLoaderWidget();
  }

  Widget _imageList({required FetchAddCngDataState dataState}) {
    return dataState.fileList.isNotEmpty
        ? SizedBox(
            // height: MediaQuery.of(context).size.height / 6,
            child: GridView.builder(
              itemCount: dataState.fileList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => _photo(
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

  Widget _photo(
      {required FetchAddCngDataState dataState,
      required int index,
      required File file}) {
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
              ?  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Icon(Icons.photo_camera_back_outlined),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          index == 0 ?
                          TextWidget(
                            "* ",
                            fontSize: AppFont.font_12,
                            color: AppColor.red,
                          ): const SizedBox.shrink(),
                          TextWidget(
                            "${AppString.photo} ${1 + index}",
                            fontSize: AppFont.font_12,
                            color: AppColor.grey,
                          ),
                        ],
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
                                file.path.split('/').last.toString(),
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
                    BlocProvider.of<AddCngBloc>(context)
                        .add(AddCngSelectFileEvent(
                      context: context,
                      mediaType: 1,
                      index: index
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
                    BlocProvider.of<AddCngBloc>(context)
                        .add(AddCngSelectFileEvent(
                      context: context,
                      mediaType: 2,
                      index: index
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

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
