import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/ci/domain/bloc/view_ci_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/widget/ci_assign_widget.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/widget/ci_final_approve_widget.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/widget/ci_update_status_widget.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';

class ViewCiComplaintItemBoxWidget extends StatelessWidget {
  final CngModel cngData;
  final int index;

  const ViewCiComplaintItemBoxWidget(
      {super.key, required this.index, required this.cngData});

  @override
  Widget build(BuildContext context) {
    String incidentDateTime = "";
    if (cngData.incidentDateTime != null &&
        cngData.incidentDateTime.toString().isNotEmpty) {
      incidentDateTime = DateFormat('dd-MMM-yyyy, h:mm:ss')
          .format(DateTime.parse(cngData.incidentDateTime.toString()));
    }

    String assignDateTime = "";
    if (cngData.assignDataTime != null &&
        cngData.assignDataTime.toString().isNotEmpty) {
      assignDateTime = DateFormat('dd-MMM-yyyy, h:mm:ss')
          .format(DateTime.parse(cngData.assignDataTime.toString()));
    }

    String estimateDateTime = "";
    if (cngData.estimateCostDataTime != null &&
        cngData.estimateCostDataTime.toString().isNotEmpty) {
      estimateDateTime = DateFormat('dd-MMM-yyyy, h:mm:ss')
          .format(DateTime.parse(cngData.estimateCostDataTime.toString()));
    }

    return Card(
      elevation: 2,
      shadowColor: AppColor.themeColor,
      child: Padding(
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
                  "DateTime : ",
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
                  "Reported By : ",
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
                  "Complaint Status : ",
                  fontWeight: FontWeight.w500,
                  fontSize: AppFont.font_13,
                ),
                Expanded(
                    child: TextWidget(
                  cngData.complaintStatus.toString() == "0"
                      ? "Pending"
                      : cngData.complaintStatus.toString() == "1"
                          ? "Approved"
                          : "Reject",
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
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            cngData.assignTo.toString() == "0" &&
                    cngData.complaintStatus.toString() == "0"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        "",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      ),
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: _assignButton(
                                  cngData: cngData,
                                  index: index,
                                  context: context))),
                    ],
                  )
                : const SizedBox.shrink(),
            cngData.assignTo.toString() != "0" &&
                    cngData.estimateCost.toString() != "0" &&
                ( cngData.estimateStatus.toString() == "0"
                    || cngData.estimateStatus.toString().isEmpty)
                ? Row(
                    children: [
                      TextWidget(
                        "",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      ),
                      Expanded(
                          child: _estimateApproveButton(
                              cngData: cngData,
                              index: index,
                              context: context)),
                    ],
                  )
                : const SizedBox.shrink(),

            cngData.estimateCost.toString().isNotEmpty  &&
                cngData.estimateCostDataTime.toString().isNotEmpty &&
                cngData.measurementSheetDataTime.toString().isNotEmpty  &&
                cngData.complaintStatus.toString() != "1"
                ? Row(
                    children: [
                      TextWidget(
                        "",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      ),
                      Expanded(
                          child: _finalApproveButton(
                              cngData: cngData,
                              index: index,
                              context: context)),
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
          ],
        ),
      ),
    );
  }

  Widget _assignButton(
      {required CngModel cngData,
      required int index,
      required BuildContext context}) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.34,
        height: MediaQuery.of(context).size.height * 0.07,
        child: ButtonWidget(
            fontSize: AppFont.font_12,
            text: "Assign",
            backgroundColor: AppColor.orange,
            onPressed: () async {
              BlocProvider.of<ViewCiComplaintBloc>(context)
                  .add(const ViewCiComplaintFetchVendorEvent());
              var res = await showDialog(
                  context: context,
                  builder: (BuildContext mContext) =>
                      CiAssignWidget(cngData: cngData));
              if (res.toString() == "Complete") {
                DateTime startDate = BlocProvider.of<ViewCiComplaintBloc>(
                    !context.mounted ? context : context)
                    .startDate;
                DateTime endDate = BlocProvider.of<ViewCiComplaintBloc>(
                    !context.mounted ? context : context)
                    .endDate;
                BlocProvider.of<ViewCiComplaintBloc>(!context.mounted ? context : context)
                    .add(ViewCiComplaintSelectedDateRangeEvent(
                    fromDate: startDate,
                    toDate: endDate,
                    context: !context.mounted ? context : context));
              }
            }),
      ),
    );
  }

  Widget _estimateApproveButton(
      {required CngModel cngData,
      required int index,
      required BuildContext context}) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.48,
        height: MediaQuery.of(context).size.height * 0.07,
        child: ButtonWidget(
            fontSize: AppFont.font_12,
            text: AppString.estimateApprove,
            backgroundColor: AppColor.themeColor,
            onPressed: () async {
              var res = await showDialog(
                  context: !context.mounted ? context : context,
                  builder: (BuildContext mContext) =>
                      CiUpdateStatusWidget(cngData: cngData));
              if (res.toString() == "Complete") {
                DateTime startDate = BlocProvider.of<ViewCiComplaintBloc>(
                    !context.mounted ? context : context)
                    .startDate;
                DateTime endDate = BlocProvider.of<ViewCiComplaintBloc>(
                    !context.mounted ? context : context)
                    .endDate;
                BlocProvider.of<ViewCiComplaintBloc>(!context.mounted ? context : context)
                    .add(ViewCiComplaintSelectedDateRangeEvent(
                    fromDate: startDate,
                    toDate: endDate,
                    context: !context.mounted ? context : context));
              }
            }),
      ),
    );
  }

  Widget _finalApproveButton(
      {required CngModel cngData,
      required int index,
      required BuildContext context}) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.40,
        height: MediaQuery.of(context).size.height * 0.07,
        child: ButtonWidget(
            fontSize: AppFont.font_12,
            text: "Approve task",
            backgroundColor: AppColor.themeColor,
            onPressed: () async {
              var res = await showDialog(
                  context: !context.mounted ? context : context,
                  builder: (BuildContext mContext) =>
                      CiFinalApproveWidget(cngData: cngData));
              if (res.toString() == "Complete") {
                DateTime startDate = BlocProvider.of<ViewCiComplaintBloc>(
                    !context.mounted ? context : context)
                    .startDate;
                DateTime endDate = BlocProvider.of<ViewCiComplaintBloc>(
                    !context.mounted ? context : context)
                    .endDate;
                BlocProvider.of<ViewCiComplaintBloc>(!context.mounted ? context : context)
                    .add(ViewCiComplaintSelectedDateRangeEvent(
                    fromDate: startDate,
                    toDate: endDate,
                    context: !context.mounted ? context : context));
              }
            }),
      ),
    );
  }
}
