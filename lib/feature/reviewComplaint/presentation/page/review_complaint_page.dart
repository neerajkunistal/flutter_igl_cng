import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/commonWidget/header_widget.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/widget/review_complaint_item_box.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class ReviewComaplintPage extends StatefulWidget {
  const ReviewComaplintPage({super.key});

  @override
  State<ReviewComaplintPage> createState() => _ReviewComaplintPageState();
}

class _ReviewComaplintPageState extends State<ReviewComaplintPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appBackGround(
        context: context,
        child: Column(
          children: [
            const HeaderWidget(title: "Review Complaint"),
            const DottedDividerLine(color: Colors.white),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: BlocBuilder<ReviewComplaintBloc, ReviewComplaintState>(
                builder: (context, state) {
                  if (state is FetchReviewComplaintDataState) {
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
  Widget _itemBuilder({required FetchReviewComplaintDataState dataState}) {
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    return Container(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _complaintItemBuilder(dataState: dataState),
            _verticalSpace(),
            userData.roleType == RoleType.shiftEngineer &&
                dataState.reviewComplaintData.assignType.toString() != "1"
                ? _radioButton(dataState: dataState)
                : const SizedBox.shrink(),
            userData.roleType == RoleType.shiftEngineer
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
            _observationController(dataState: dataState),
            _verticalSpace(),
            _rectifiedByController(dataState: dataState),
            _verticalSpace(),
            _imageList(dataState: dataState),
            _verticalSpace(),
            _verticalSpace(),
            _button(dataState: dataState),
          ],
        ),
      ),
    );
  }

  Widget _complaintItemBuilder(
      {required FetchReviewComplaintDataState dataState}) {
    return dataState.reviewComplaintData.id != null
        ? ReviewComplaintItemBox(
            index: 0,
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
              value: "1",
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
              value: "0",
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

  Widget _dateController({required FetchReviewComplaintDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: AppString.date,
      controller: dataState.closeDateController,
      onTap: () {
        BlocProvider.of<ReviewComplaintBloc>(context)
            .add(ReviewComplaintSelectDateData(context: context));
      },
    );
  }

  Widget _timeController({required FetchReviewComplaintDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: AppString.time,
      controller: dataState.closeTimeController,
      onTap: () {
        BlocProvider.of<ReviewComplaintBloc>(context)
            .add(ReviewComplaintSelectTimeData(context: context));
      },
    );
  }

  Widget _observationController(
      {required FetchReviewComplaintDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.remark,
      controller: dataState.observationController,
    );
  }

  Widget _rectifiedByController(
      {required FetchReviewComplaintDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.rectifiedBy,
      controller: dataState.rectifiedByController,
    );
  }

  Widget _imageList({required FetchReviewComplaintDataState dataState}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      child: GridView.builder(
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
      ),
    );
  }

  Widget _photo(
      {required FetchReviewComplaintDataState dataState, required int index}) {
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
                    BlocProvider.of<ReviewComplaintBloc>(context).add(
                        ReviewComplaintAddImageEvent(
                            context: context, mediaType: 1, index: index));
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
