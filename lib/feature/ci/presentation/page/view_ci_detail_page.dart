import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/presentation/widget/complaint_images_widget.dart';
import 'package:flutter_igl_cng/feature/ci/domain/bloc/view_ci_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/widget/ci_assign_widget.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/widget/ci_assignment_list_widget.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/widget/ci_final_approve_widget.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/widget/ci_update_status_widget.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/feature/cv/presentation/widget/estimate_coast_history_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class ViewCiDetailPage extends StatefulWidget {
  const ViewCiDetailPage({super.key});

  @override
  State<ViewCiDetailPage> createState() => _ViewCiDetailPageState();
}

class _ViewCiDetailPageState extends State<ViewCiDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: BlocBuilder<ViewCiComplaintBloc, ViewCiComplaintState>(
                  builder: (context, state) {
                    if (state is FetchViewCiComplaintDataState) {
                      return state.isFilterLoader == false ?
                      Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
                              child: state.cngList.isNotEmpty
                                  ? _itemBuilder(dataState: state)
                                  : const SizedBox.shrink()))
                          : _centerLoader();
                    } else {
                      return _centerLoader();
                    }
                  },
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget _centerLoader() {
    return const Center(
      child: CenterLoaderWidget(),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          "Complaint Details",
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
        ),
      ],
    );
  }

  Widget _itemBuilder({required FetchViewCiComplaintDataState dataState}) {
    final CngModel cngData =  dataState.cngList[dataState.listIndex];
    String incidentDateTime = "";
    if (cngData.incidentDateTime != null &&
        cngData.incidentDateTime.toString().isNotEmpty) {
      incidentDateTime = DateFormat('dd-MMM-yyyy')
          .format(DateTime.parse(cngData.incidentDateTime.toString()));
    }

    String assignDateTime = "";
    if (cngData.assignDataTime != null &&
        cngData.assignDataTime.toString().isNotEmpty) {
      assignDateTime = DateFormat('dd-MMM-yyyy')
          .format(DateTime.parse(cngData.assignDataTime.toString()));
    }

    String estimateDateTime = "";
    if (cngData.estimateCostDataTime != null &&
        cngData.estimateCostDataTime.toString().isNotEmpty) {
      estimateDateTime = DateFormat('dd-MMM-yyyy')
          .format(DateTime.parse(cngData.estimateCostDataTime.toString()));
    }

    String complaintClosedDate = "";
    if (cngData.complaintClosedOn != null &&
        cngData.complaintClosedOn.toString().isNotEmpty) {
      complaintClosedDate = DateFormat('dd-MMM-yyyy')
          .format(DateTime.parse(cngData.complaintClosedOn.toString()));
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  TextWidget(
                    "Complaint ID : ",
                    color: AppColor.green,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.complaintNumber,
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.w700,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              Divider(
                color: AppColor.lightGrey,
              ),
              Row(
                children: [
                  TextWidget(
                    "Control Room : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.controlRoom.toString(),
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Station Name : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.cngStation.toString(),
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Date : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        incidentDateTime,
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Reported Name : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.reportByName.toString(),
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Reported Phone : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.reportByPhone.toString(),
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Complaint Status : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.complaintStatus.toString() == "0"
                            ? "Pending"
                            : cngData.complaintStatus.toString() == "1"
                            ? "Closed"
                            : "Rejected",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                        color: cngData.complaintStatus.toString() == "0"
                            ? AppColor.orange
                            : cngData.complaintStatus.toString() == "1"
                            ? AppColor.green
                            : AppColor.red,
                        textAlign: TextAlign.end,
                      )),
                ],
              ),

              complaintClosedDate .isNotEmpty ?
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ) : const SizedBox.shrink(),

              complaintClosedDate .isNotEmpty ?
              Row(
                children: [
                  TextWidget(
                    "Complaint Closed date : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        complaintClosedDate,
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                        color:  AppColor.green,
                        textAlign: TextAlign.end,
                      )),
                ],
              ) : const SizedBox.shrink(),


              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Assign vendor: ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.assignToVendor.toString(),
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Assign Date: ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        assignDateTime,
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Estimate Cost: ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.estimateCost.toString(),
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Estimate Cost Date: ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        estimateDateTime,
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),

              cngData.estimateStatus.toString() == "2" ?
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ) : const SizedBox.shrink(),

              cngData.estimateStatus.toString() == "2" ?
              Row(
                children: [
                  TextWidget(
                    "Estimate Status : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        "Change request",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                        color: AppColor.red,
                        textAlign: TextAlign.end,
                      )),
                ],
              ) : const SizedBox.shrink(),

              cngData.estimateStatus.toString() == "2" ?
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ) : const SizedBox.shrink(),

              cngData.estimateStatus.toString() == "2" ?
              Row(
                children: [
                  TextWidget(
                    "Estimate Remark : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.estimateRemark.toString(),
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                        color: AppColor.black,
                        textAlign: TextAlign.end,
                      )),
                ],
              ) : const SizedBox.shrink(),

              cngData.estimateList != null && cngData.estimateList!.isNotEmpty
                  &&  cngData.estimateList!.length > 1  ? Divider(
                color: AppColor.lightGrey,
              ) : const SizedBox.shrink(),

              cngData.estimateList != null && cngData.estimateList!.isNotEmpty
                  &&  cngData.estimateList!.length > 1  ?
              TextWidget("Estimate history",
                color: AppColor.black,
                fontWeight: FontWeight.w700,)
                  : const SizedBox.shrink(),

              EstimateCoastHistoryWidget(cngData: cngData),

              cngData.measurementSheetStatus.toString() == "2" &&
                  cngData.measurementSheet.toString().isNotEmpty
                  ? SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ) : const SizedBox.shrink(),

              cngData.measurementSheetStatus.toString() == "2" &&
                  cngData.measurementSheet.toString().isNotEmpty
                  ? Row(
                children: [
                  TextWidget(
                    "Measurement Sheet Status : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        "Change request",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                        color: AppColor.red,
                        textAlign: TextAlign.end,
                      )),
                ],
              ) : const SizedBox.shrink(),

              cngData.measurementSheetStatus.toString() == "2" &&
                  cngData.measurementSheet.toString().isNotEmpty
                  ?SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ) : const SizedBox.shrink(),

              cngData.measurementSheetStatus.toString() == "2" &&
                  cngData.measurementSheet.toString().isNotEmpty
                  ? Row(
                children: [
                  TextWidget(
                    "Measurement Remark : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.anyRemarks.toString(),
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                        color: AppColor.black,
                        textAlign: TextAlign.end,
                      )),
                ],
              ) : const SizedBox.shrink(),


              Divider(
                color: AppColor.lightGrey,
              ),
              Row(
                children: [
                  TextWidget(
                    "Description : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.complaintDescription.toString(),
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),

              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              TextWidget("Complaint Images : ",
                fontWeight: FontWeight.bold,
                color: AppColor.black, textAlign: TextAlign.start,),
              ComplaintImagesWidget(imageList: cngData.createdComplaintImagesList ?? []),

              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              TextWidget("Estimate & Before Images : ",
                fontWeight: FontWeight.bold,
                color: AppColor.black, textAlign: TextAlign.start,),
              ComplaintImagesWidget(imageList: cngData.estimateAttachment ?? []),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              TextWidget("After Images : ",
                fontWeight: FontWeight.bold,
                color: AppColor.black, textAlign: TextAlign.start,),
              ComplaintImagesWidget(imageList: cngData.measurementPostImageList ?? []),

              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              TextWidget("Measurement Sheet : ",
                fontWeight: FontWeight.bold,
                color: AppColor.black, textAlign: TextAlign.start,),
              ComplaintImagesWidget(imageList: cngData.measurementSheet.toString().isNotEmpty ?
              [cngData.measurementSheet] : []),

              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              cngData.assignmentList!.isNotEmpty
                  ? CiAssignmentListWidget(assignmentList: cngData.assignmentList!)
                  : const SizedBox.shrink(),

              (cngData.assignTo.toString() == "0" &&
                  cngData.complaintStatus.toString() == "0")
                  ? CiAssignWidget(cngData: cngData)
                  : const SizedBox.shrink(),

              cngData.assignTo.toString() != "0" &&
                  cngData.estimateCost.toString() != "0" &&
                  cngData.complaintStatus.toString() == "0" &&
                  ( cngData.estimateStatus.toString() == "0"
                      || cngData.estimateStatus.toString().isEmpty) &&
                  (cngData.estimateList!.length <= 4
                      && cngData.estimateStatus.toString() == "0")
                  ?  CiUpdateStatusWidget(cngData: cngData)
                  : const SizedBox.shrink(),

              cngData.estimateCost.toString().isNotEmpty  &&
                  cngData.estimateCostDataTime.toString().isNotEmpty &&
                  cngData.measurementSheetDataTime.toString().isNotEmpty  &&
                  cngData.complaintStatus.toString() != "1"
                  ? CiFinalApproveWidget(cngData: cngData)
                  : const SizedBox.shrink(),
            ],
          ),
        )
      ],
    );
  }
}
