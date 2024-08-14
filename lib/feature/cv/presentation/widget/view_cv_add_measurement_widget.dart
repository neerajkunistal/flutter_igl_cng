import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cv/domain/bloc/view_cv_complaint_bloc.dart';

class ViewCvAddMeasurementWidget extends StatelessWidget {
  const ViewCvAddMeasurementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        BlocBuilder<ViewCvComplaintBloc, ViewCvComplaintState>(
          builder: (context, state) {
            if(state is FetchViewCvComplaintDataState){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _verticalSpace(context: context),
                  Row(
                    children: [
                      state.measurementType == MeasurementType.sheet  &&
                          state.cngData.measurementSheetStatus.toString() != "1"?
                      _measurementSheet(
                          dataState: state,
                          index: 0,
                          file: state.measurementFileSheet,
                          context: context
                      ) : const SizedBox.shrink(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,),

                      state.measurementType == MeasurementType.pre
                      || state.measurementType == MeasurementType.post ?
                      _photo(
                          dataState: state,
                          index: 0,
                          file: File(""),
                          context: context) : const SizedBox.shrink(),
                    ],
                  ),
                  _verticalSpace(context: context),
                  _imageList(dataState: state),
                  _verticalSpace(context: context),
                  _submitButton(dataState: state, context: context),
                  _verticalSpace(context: context),
                ],);
            } else {
              return const CenterLoaderWidget();
            }
          },
        ),
      ],
    );
  }

  Widget _imageList({required FetchViewCvComplaintDataState dataState}) {
    return dataState.measurementFileList.isNotEmpty
        ? SizedBox(
      child: GridView.builder(
        itemCount: dataState.measurementFileList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _photo(
            dataState: dataState,
            index: index,
            file: dataState.measurementFileList[index],
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
          if(dataState.measurementType == MeasurementType.sheet) {
            mediaType(context: context, index: index, isMeasurement: false);
          } else {
            BlocProvider.of<ViewCvComplaintBloc>(context)
                .add(ViewCvComplaintMeasurementSelectFileEvent(
              context: context,
              mediaType: 1,
            ));
          }

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
                  dataState.measurementType == MeasurementType.pre ? "Before"
                      : dataState.measurementType == MeasurementType.post ? "After"
                      : "Sheet",
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
                       ViewCvComplaintMeasurementDeleteFileEvent(index: index));
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

  Widget _measurementSheet(
      {required FetchViewCvComplaintDataState dataState,
        required int index,
        required File file, required BuildContext context}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      height: MediaQuery.of(context).size.width / 4,
      child: InkWell(
        onTap: () async {
          mediaType(context: context, index: index, isMeasurement: true);
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
              Padding(
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.02),
                child: TextWidget(
                  "Add Sheet",
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
                    maxLines: 2,
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

  void mediaType({required BuildContext context, required int index, required bool isMeasurement}) {
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
                    if(isMeasurement == false){
                      BlocProvider.of<ViewCvComplaintBloc>(context)
                          .add(ViewCvComplaintMeasurementSelectFileEvent(
                        context: context,
                        mediaType: 1,
                      ));
                    } else {
                      BlocProvider.of<ViewCvComplaintBloc>(context)
                          .add(ViewCvComplaintMeasurementSheetSelectFileEvent(
                        context: context,
                        mediaType: 1,
                      ));
                    }

                  },
                  child: TextWidget(
                    "Camera",
                    fontSize: AppFont.font_16,
                  )),
              const Divider(),
              TextButton(
                  onPressed: () {
                    if(isMeasurement == false){
                      BlocProvider.of<ViewCvComplaintBloc>(context)
                          .add(ViewCvComplaintMeasurementSelectFileEvent(
                        context: context,
                        mediaType: 2,
                      ));
                    } else {
                      BlocProvider.of<ViewCvComplaintBloc>(context)
                          .add(ViewCvComplaintMeasurementSheetSelectFileEvent(
                        context: context,
                        mediaType: 2,
                      ));
                    }
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

  Widget _submitButton({required FetchViewCvComplaintDataState dataState,
      required BuildContext context, }){
    return dataState.isLoader == false
    ? ButtonWidget(
        text: AppString.submit,
        onPressed: () {
           BlocProvider.of<ViewCvComplaintBloc>(context).add(
               ViewCvComplaintSubmitMeasurementEvent(context: context,
                   cngData: dataState.cngData));
          }
        ) : const DottedLoaderWidget();
  }

  Widget _verticalSpace({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
