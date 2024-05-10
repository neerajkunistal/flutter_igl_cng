import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/widget/review_complaint_item_box.dart';

class ReviewComaplintPage extends StatefulWidget {
  const ReviewComaplintPage({super.key});

  @override
  State<ReviewComaplintPage> createState() => _ReviewComaplintPageState();
}

class _ReviewComaplintPageState extends State<ReviewComaplintPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          "Review Complaint",
          color: AppColor.white,
        ),
      ),
      body: BlocBuilder<ReviewComplaintBloc, ReviewComplaintState>(
        builder: (context, state) {
          if (state is FetchReviewComplaintDataState) {
            return _itemBuilder(dataState: state);
          } else {
            return const Center(
              child: CenterLoaderWidget(),
            );
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchReviewComplaintDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _complaintItemBuilder(dataState: dataState),
            _verticalSpace(),
            _radioButton(dataState: dataState),
            _verticalSpace(),
            _observationController(dataState: dataState),
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

  Widget _complaintTypeDropDown(
      {required FetchReviewComplaintDataState dataState}) {
    return DropdownWidget(
      hint: AppString.selectComplaint,
      dropdownValue: dataState.reviewComplaintData.id != null
          ? dataState.reviewComplaintData
          : null,
      onChanged: (value) {
        BlocProvider.of<ReviewComplaintBloc>(context).add(
            ReviewComplaintSelectComplaintEvent(reviewComplaintData: value));
      },
      items: dataState.reviewComplaintList
          .map<DropdownMenuItem<ReviewComplaintModel>>(
              (ReviewComplaintModel reviewComplaintData) {
        return DropdownMenuItem<ReviewComplaintModel>(
          value: reviewComplaintData,
          child: Text(reviewComplaintData.complaintDescription.toString()),
        );
      }).toList(),
    );
  }

  Widget _complaintItemBuilder(
      {required FetchReviewComplaintDataState dataState}) {
    return dataState.reviewComplaintData.id != null
        ? ReviewComplaintItemBox(
            reviewComplaintData: dataState.reviewComplaintData,
          )
        : const SizedBox.shrink();
  }

  Widget _radioButton({required FetchReviewComplaintDataState dataState}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const TextWidget("Action*"),
        Row(
          children: [
            Radio(
              value: "Yes",
              groupValue: dataState.approvalValue,
              onChanged: (val) {
                BlocProvider.of<ReviewComplaintBloc>(context).add(
                    ReviewComplaintSelectApprovalEvent(
                        approvalValue: val.toString()));
              },
            ),
            const TextWidget("Accept"),
          ],
        ),
        Row(
          children: [
            Radio(
              value: "No",
              groupValue: dataState.approvalValue,
              onChanged: (val) {
                BlocProvider.of<ReviewComplaintBloc>(context).add(
                    ReviewComplaintSelectApprovalEvent(
                        approvalValue: val.toString()));
              },
            ),
            const TextWidget("Reject"),
          ],
        ),
      ],
    );
  }

  Widget _observationController(
      {required FetchReviewComplaintDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.observation,
      controller: dataState.observationController,
    );
  }

  Widget _photo({required FetchReviewComplaintDataState dataState}) {
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
                    BlocProvider.of<ReviewComplaintBloc>(context).add(
                        ReviewComplaintAddImageEvent(
                            context: context, mediaType: 1));
                  },
                  child: TextWidget(
                    "Camera",
                    fontSize: AppFont.font_16,
                  )),
              const Divider(),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<ReviewComplaintBloc>(context).add(
                        ReviewComplaintAddImageEvent(
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

  Widget _button({required FetchReviewComplaintDataState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            height:
                AppConfig.getDeviceType(context: context) == DeviceType.tablet
                    ? MediaQuery.of(context).size.height * 0.13
                    : null,
            onPressed: () {
              BlocProvider.of<ReviewComplaintBloc>(context)
                  .add(ReviewComplaintSubmitEvent(context: context));
            })
        : const DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
