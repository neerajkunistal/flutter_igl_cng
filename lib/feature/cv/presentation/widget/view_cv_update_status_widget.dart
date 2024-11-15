import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/feature/cv/domain/bloc/view_cv_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/cv/domain/model/measure_type_model.dart';
import 'package:flutter_igl_cng/feature/cv/presentation/widget/view_particular_widget_item_box.dart';

class ViewCvUpdateStatusWidget extends StatelessWidget {
  final CngModel cngData;

  const ViewCvUpdateStatusWidget({super.key, required this.cngData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewCvComplaintBloc, ViewCvComplaintState>(
      builder: (context, state) {
        if (state is FetchViewCvComplaintDataState) {
          return state.cngData.estimateList!.length < 4 ?
          _widgetBuilder(dataState: state, context: context)
              : const SizedBox.shrink();
        } else {
          return _centerLoader();
        }
      },
    );
  }

  Widget _centerLoader() {
    return const Center(child: CenterLoaderWidget());
  }

  Widget _widgetBuilder({required FetchViewCvComplaintDataState dataState,
    required BuildContext context}) {
    return Column(
      children: [

        dataState.particularList.isNotEmpty ?
        ViewParticularWidgetItemBox(particularList: dataState.particularList)
            : const SizedBox.shrink(),

        dataState.isParticularWidgetShow == true
            ? _itemBuilder(dataState: dataState, context: context)
            : const SizedBox.shrink(),

        _addButton(dataState: dataState, context: context),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.04,
        ),
        _submitButton(dataState: dataState, context: context),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.04,
        ),
      ],
    );
  }


  Widget _itemBuilder(
      {required FetchViewCvComplaintDataState dataState,
      required BuildContext context}) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.08,
        ),
        // _amountController(dataState: dataState, context: context),
        _particularController(dataState: dataState),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.08,
        ),
        _measureTypDropDown(dataState: dataState, context: context),

        dataState.measureTypeData.name != null ?
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.08,
        ) : const SizedBox.shrink(),

        dataState.measureTypeData.name != null ?
        _measureController(dataState: dataState)
            : const SizedBox.shrink(),


        SizedBox(
          height: MediaQuery.of(context).size.width * 0.04,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: _photo(
              dataState: dataState,
              index: 0,
              file: File(""),
              context: context),
        ),
        _imageList(dataState: dataState),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.04,
        ),
      ],
    );
  }


  Widget _amountController(
      {required FetchViewCvComplaintDataState dataState,
      required BuildContext context}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.amountController,
      textInputType: TextInputType.number,
      labelText: "Approximate Estimated Amount",
    );
  }

  Widget _particularController(
      {required FetchViewCvComplaintDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.particularController,
      textInputType: TextInputType.text,
      labelText: AppString.enterParticular,
    );
  }

  Widget _measureTypDropDown(
      {required FetchViewCvComplaintDataState dataState,
        required BuildContext context}) {
    return  DropdownWidget(
      hint: AppString.selectMeasure,
      dropdownValue: dataState.measureTypeData.id != null
          ? dataState.measureTypeData
          : null,
      onChanged: (value) {
        BlocProvider.of<ViewCvComplaintBloc>(context)
            .add(ViewCvComplaintSelectMeasureDataEvent(measureTypeData: value));
      },
      items: dataState.measureTypeList
          .map<DropdownMenuItem<MeasureTypeModel>>(
              (MeasureTypeModel measureTypeData) {
            return DropdownMenuItem<MeasureTypeModel>(
              value: measureTypeData,
              child: TextWidget(measureTypeData.name.toString()),
            );
          }).toList(),
    );
  }

  Widget _measureController(
      {required FetchViewCvComplaintDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.measureController,
      textInputType: dataState.measureTypeData.dataType == DataType.number ? TextInputType.number : TextInputType.text,
      labelText: dataState.measureTypeData.unit.toString(),
    );
  }

  Widget _imageList({required FetchViewCvComplaintDataState dataState}) {
    return dataState.file.isNotEmpty
        ? SizedBox(
      child: GridView.builder(
        itemCount: dataState.file.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _photo(
            dataState: dataState,
            index: index,
            file: dataState.file[index],
            context: context),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
      ),
    ) : const SizedBox.shrink();
  }

  Widget _photo({required FetchViewCvComplaintDataState dataState,
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
                    color: AppColor.themeColor,
                    fontSize: AppFont.font_12,
                  ) : const SizedBox.shrink(),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<ViewCvComplaintBloc>(context).add(
                        ViewCvComplaintDeleteEstimatePhotoFileEvent(index: index));
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
                    BlocProvider.of<ViewCvComplaintBloc>(context)
                        .add(ViewCvComplaintSelectFileEvent(
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
                    BlocProvider.of<ViewCvComplaintBloc>(context)
                        .add(ViewCvComplaintSelectFileEvent(
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


  Widget _addButton(
      {required FetchViewCvComplaintDataState dataState,
        required BuildContext context}) {
    return dataState.isLoader == false
        ? Align(
         alignment: Alignment.centerRight,
          child: SizedBox(
                width: dataState.particularList.isEmpty ?
                MediaQuery.of(context).size.width * 0.27
                    : MediaQuery.of(context).size.width * 0.37,
                child: ButtonWidget(
            fontSize: AppFont.font_12,
            text: dataState.particularList.isEmpty
                ?  AppString.add
                : AppString.addMore,
            backgroundColor: AppColor.themeSecondary,
            onPressed: () {
              BlocProvider.of<ViewCvComplaintBloc>(context)
                  .add(ViewCvComplaintAddParticularEvent(context: context));
           }
          )),
        ): const DottedLoaderWidget();
  }


  Widget _submitButton(
      {required FetchViewCvComplaintDataState dataState,
      required BuildContext context}) {
    return dataState.isLoader == false
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: ButtonWidget(
                fontSize: AppFont.font_12,
                text: AppString.submit,
                onPressed: () {
                  BlocProvider.of<ViewCvComplaintBloc>(context).add(
                      ViewCvComplaintSubmitEvent(
                          context: context, cngData: cngData));
                }),
          )
        : const DottedLoaderWidget();
  }
}
