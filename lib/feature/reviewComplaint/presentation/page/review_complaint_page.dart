import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/sap_code_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/code_group_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/widget/review_complaint_item_box.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/page/add_scrap_page.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/widget/scrap_common_item_widget.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/widget/scrap_item_box_widget.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/widget/scrap_item_widget.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/presentation/page/add_spare_part_page.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/presentation/widget/add_spare_part_widget.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/presentation/widget/spare_part_common_item_widget.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
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

  Widget _appBar() {
    return  AppBar(
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          "Review Complaint",
          color: AppColor.white,
          fontSize: AppFont.font_15,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Image.asset(
          AppConfig.instanceInit()!.client == Client.iglcng
              ? AppIcon.appLogoIgl
              : AppConfig.instanceInit()!.client == Client.pbgplCNG
              ? AppIcon.appLogoPurvaBharti
              : AppConfig.instanceInit()!.client == Client.mahanagar
              ? AppIcon.appLogoMGL
              : AppIcon.appLogoIgl,
          height: MediaQuery.of(context).size.width * 0.13,
          width: MediaQuery.of(context).size.width * 0.13,
        )
      ],
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

            _scrapList(dataState: dataState),
            _sparePartList(dataState: dataState),

            userData.roleType == RoleType.shiftEngineer ?
            _codeGroupDropDown(dataState: dataState, context: context)
                : const SizedBox.shrink(),
            userData.roleType == RoleType.shiftEngineer
                ? _verticalSpace()
                : const SizedBox.shrink(),

            userData.roleType == RoleType.shiftEngineer ?
            _sapCodeDropDown(dataState: dataState, context: context)
                : const SizedBox.shrink(),
            userData.roleType == RoleType.shiftEngineer
                ? _verticalSpace()
                : const SizedBox.shrink(),

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

            AddSparePartWidget(),
            _addPartButton( context: context),

            ScrapItemWidget(),
            _addScarpButton(dataState: dataState),

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
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    return dataState.reviewComplaintData.id != null
        ? Column(
          children: [
            ReviewComplaintItemBox(
                index: 0,
                reviewComplaintData: dataState.reviewComplaintData,
              ),
            userData.roleType == RoleType.shiftEngineer
            ? Container(
              margin: EdgeInsets.all(0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: TextWidget("SU Details : ", fontWeight:  FontWeight.w700)),
                      ),
                    Row(
                        children: [
                          TextWidget("Remark : "),
                          TextWidget("${dataState.reviewComplaintData.stationRemark}"),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Row(
                        children: [
                          TextWidget("${AppString.rectifiedBy} : "),
                          TextWidget("${dataState.reviewComplaintData.rectifyBy}"),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Row(
                        children: [
                          TextWidget("${AppString.date} : "),
                          TextWidget("${dataState.reviewComplaintData.stationPersonDateTime}"),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),

                      dataState.reviewComplaintData.stationAttachmentFile != null &&
                          dataState.reviewComplaintData.stationAttachmentFile!.isNotEmpty?
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.15,
                        child: ListView.builder(
                            itemCount: dataState.reviewComplaintData.stationAttachmentFile!.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                             return Image.network(
                             dataState.reviewComplaintData.stationAttachmentFile![index].toString(),
                             height: MediaQuery.of(context).size.width * 0.13,
                             width: MediaQuery.of(context).size.width * 0.13,
                             );
                        }),
                      ) : const SizedBox.shrink(),
                    ],
                  ),
                ),

              ),
            ) : const SizedBox.shrink()
          ],
        )
        : const SizedBox.shrink();
  }

  Widget _scrapList({required FetchReviewComplaintDataState dataState}) {
    return  dataState.reviewComplaintData.scrapList != null &&
        dataState.reviewComplaintData.scrapList!.isNotEmpty
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DottedDividerLine(),
            TextWidget("Scarp", fontWeight: FontWeight.w700,),
            ListView.builder(
            itemCount: dataState.reviewComplaintData.scrapList!.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ScrapCommonItemWidget(
                index: index,
                scrapData: dataState.reviewComplaintData.scrapList![index],
                onTap: () {
                  BlocProvider.of<ReviewComplaintBloc>(context)
                  .add(ReviewComplaintDeleteScarpEvent(index: index));
                },
              );
            }),
            _verticalSpace(),
            const DottedDividerLine(),
            _verticalSpace(),
          ],
        ) : const SizedBox.shrink();
  }

  Widget _sparePartList({required FetchReviewComplaintDataState dataState}) {
    return  dataState.reviewComplaintData.partList != null &&
        dataState.reviewComplaintData.partList!.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DottedDividerLine(),
        TextWidget("Spare Part", fontWeight: FontWeight.w700,),
        ListView.builder(
            itemCount: dataState.reviewComplaintData.partList!.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return SparePartCommonItemWidget(
                index: index,
                partModel: dataState.reviewComplaintData.partList![index],
                onTap: () {
                  BlocProvider.of<ReviewComplaintBloc>(context)
                      .add(ReviewComplaintDeletePartEvent(index: index));
                },
              );
            }),
        _verticalSpace(),
        const DottedDividerLine(),
        _verticalSpace(),
      ],
    ) : const SizedBox.shrink();
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
      isRequired: true,
      enabled: false,
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
      isRequired: true,
      enabled: false,
      labelText: AppString.time,
      controller: dataState.closeTimeController,
      onTap: () {
        BlocProvider.of<ReviewComplaintBloc>(context)
            .add(ReviewComplaintSelectTimeData(context: context));
      },
    );
  }

  Widget _sapCodeDropDown(
      {required FetchReviewComplaintDataState dataState,
        required BuildContext context}) {
    return dataState.sapCodeLoader == false ?
    DropdownWidget(
      hint: AppString.sapCode,
      dropdownValue:
      dataState.sapCodeData.id != null ? dataState.sapCodeData : null,
      onChanged: (value) {
        BlocProvider.of<ReviewComplaintBloc>(context)
            .add(ReviewComplaintSelectSapCodeEvent(sapCodeData: value));
      },
      items: dataState.sapCodeList
          .map<DropdownMenuItem<SapCodeModel>>((SapCodeModel sapCodeData) {
        return DropdownMenuItem<SapCodeModel>(
          value: sapCodeData,
          child: TextWidget(sapCodeData.name.toString()),
        );
      }).toList(),
    ) : const DottedLoaderWidget();
  }

  Widget _codeGroupDropDown(
      {required FetchReviewComplaintDataState dataState,
        required BuildContext context}) {
    return DropdownWidget(
      hint: AppString.codeGroup,
      dropdownValue:
      dataState.codeGroupData.name != null ? dataState.codeGroupData : null,
      onChanged: (value) {
        BlocProvider.of<ReviewComplaintBloc>(context)
            .add(ReviewComplaintSelectCodeGroupEvent(codeGroupData: value));
      },
      items: dataState.codeGroupList
          .map<DropdownMenuItem<CodeGroupModel>>((CodeGroupModel codeGroupData) {
        return DropdownMenuItem<CodeGroupModel>(
          value: codeGroupData,
          child: TextWidget("${codeGroupData.name.toString()}-${codeGroupData.code.toString()}"),
        );
      }).toList(),
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
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          BlocProvider.of<ReviewComplaintBloc>(context)
                          .add(ReviewComplaintRemoveImageEvent(index: index));
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
                    BlocProvider.of<ReviewComplaintBloc>(context).add(
                        ReviewComplaintAddImageEvent(
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
                    BlocProvider.of<ReviewComplaintBloc>(context).add(
                        ReviewComplaintAddImageEvent(
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

  Widget _scrapCheckBoxWidget({required FetchReviewComplaintDataState dataState}) {
    return Row(
      children: [
        Checkbox(
          value: dataState.isNoScrap,
          onChanged: (bool? value) async {
            BlocProvider.of<ReviewComplaintBloc>(context).add(
                ReviewComplaintSelectScrapData(isNoScrap: value!)
            );
            if(value == false){
              var result = await Navigator.push(context,
                  FadeRoute(page: const AddScrapPage()));
              if (!context.mounted) result;
              if (result.toString() == "Completed") {

              }
            }
          },
          activeColor: Colors.green,
          checkColor: Colors.white,
        ),
        const TextWidget("No Scrap"),
      ],
    );
  }


  Widget _addScarpButton({required FetchReviewComplaintDataState dataState}) {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.5,
        child: ButtonWidget(
            text: AppString.addScrap,
            height:
            AppConfig.getDeviceType(context: context) == DeviceType.tablet
                ? MediaQuery.of(context).size.height * 0.13
                : null,
            onPressed: () async {
              var result = await Navigator.push(context,
                  FadeRoute(page: const AddScrapPage()));
              if (!context.mounted) result;
              if (result.toString() == "Completed") {

              }
            }),
      ),
    );
  }

  Widget _addPartButton(
      {required BuildContext context}) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width/2.6,
        child: ButtonWidget(
            text: AppString.addPart,
            onPressed: () {
              BlocProvider.of<AddSparePartBloc>(context)
                  .add(AddSparePartPageLoadEvent(context: context));
              Navigator.push(
                context,
                FadeRoute(page: const AddSparePartPage()),
              );
            }),
      ),
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
