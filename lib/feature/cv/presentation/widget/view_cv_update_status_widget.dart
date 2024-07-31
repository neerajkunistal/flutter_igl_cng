import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/feature/cv/domain/bloc/view_cv_complaint_bloc.dart';

class ViewCvUpdateStatusWidget extends StatelessWidget {
  final CngModel cngData;

  const ViewCvUpdateStatusWidget({super.key, required this.cngData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewCvComplaintBloc, ViewCvComplaintState>(
      builder: (context, state) {
        if (state is FetchViewCvComplaintDataState) {
          return _itemBuilder(dataState: state, context: context);
        } else {
          return _centerLoader();
        }
      },
    );
  }

  Widget _centerLoader() {
    return const Center(child: CenterLoaderWidget());
  }

  Widget _itemBuilder(
      {required FetchViewCvComplaintDataState dataState,
      required BuildContext context}) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.60,
        width: MediaQuery.of(context).size.width / 1.2,
        child: Card(
          color: AppColor.white,
          margin: const EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.04,
                ),
                TextWidget(
                  "Update Status",
                  fontSize: AppFont.font_14,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.04,
                ),
                _amountController(dataState: dataState, context: context),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.04,
                ),
                _photo(dataState: dataState, context: context),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.04,
                ),
                _submitButton(dataState: dataState, context: context),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _amountController(
      {required FetchViewCvComplaintDataState dataState,
      required BuildContext context}) {
    return TextFieldWidget(
      controller: dataState.amountController,
      textInputType: TextInputType.number,
      labelText: AppString.amount,
    );
  }

  Widget _photo(
      {required FetchViewCvComplaintDataState dataState,
      required BuildContext context}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: InkWell(
        onTap: () async {
          mediaType(
            context: context,
          );
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
                        "${AppString.photo}",
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

  Widget _submitButton(
      {required FetchViewCvComplaintDataState dataState,
      required BuildContext context}) {
    return dataState.isLoader == false
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: ButtonWidget(
                fontSize: AppFont.font_12,
                text: AppString.changeStatus,
                onPressed: () {
                  BlocProvider.of<ViewCvComplaintBloc>(context).add(
                      ViewCvComplaintSubmitEvent(
                          context: context, cngData: cngData));
                }),
          )
        : const DottedLoaderWidget();
  }
}
