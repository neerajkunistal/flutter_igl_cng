import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/feature/cv/domain/bloc/view_cv_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/cv/presentation/widget/view_cv_add_measurement_widget.dart';
import 'package:flutter_igl_cng/feature/cv/presentation/widget/view_cv_update_status_widget.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:vibration/vibration.dart';

class ViewCvComplaintItemBoxWidget extends StatelessWidget {
  final CngModel cngData;
  final int index;

  const ViewCvComplaintItemBoxWidget(
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
      elevation: 4,
      shadowColor: AppColor.themeColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                TextWidget(
                  "Complaint ID : ",
                  fontWeight: FontWeight.w700,
                  fontSize: AppFont.font_13,
                  color: AppColor.themeColor,
                ),
                Expanded(
                    child: TextWidget(
                  cngData.complaintNumber,
                  fontSize: AppFont.font_13,
                  textAlign: TextAlign.end,
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
                  fontWeight: FontWeight.w500,
                  fontSize: AppFont.font_13,
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
                  "Reported By : ",
                  fontWeight: FontWeight.w500,
                  fontSize: AppFont.font_13,
                ),
                Expanded(
                    child: TextWidget(
                  cngData.reportByName.toString(),
                  fontWeight: FontWeight.w500,
                  fontSize: AppFont.font_13,
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
                  "Complaint Status : ",
                  fontWeight: FontWeight.w500,
                  fontSize: AppFont.font_13,
                ),
                Expanded(
                    child: TextWidget(
                  cngData.approveStatus.toString() == "0"
                      ? "Pending"
                      : cngData.approveStatus.toString() == "1"
                          ? "Approved"
                          : "Reject",
                  fontWeight: FontWeight.w500,
                  fontSize: AppFont.font_13,
                  color: cngData.approveStatus.toString() == "0"
                      ? AppColor.orange
                      : cngData.approveStatus.toString() == "1"
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
            cngData.estimateCost.toString() == "0"
                || cngData.estimateStatus.toString() == "2"
                ? Row(
                    children: [
                      TextWidget(
                        "",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      ),
                      Expanded(
                          child: _updateStatusButton(
                        cngData: cngData,
                        index: index,
                        context: context,
                      )),
                    ],
                  ) : const SizedBox.shrink(),

            cngData.measurementSheetDataTime.toString().isEmpty &&
            cngData.estimateCostDataTime.toString().isNotEmpty &&
                cngData.estimateStatus.toString() == "1"
                ? Row(
              children: [
                TextWidget(
                  "",
                  fontWeight: FontWeight.w500,
                  fontSize: AppFont.font_13,
                ),
                Expanded(
                    child: _addMeasurementButton(
                      cngData: cngData,
                      index: index,
                      context: context,
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
          ],
        ),
      ),
    );
  }

  Widget _updateStatusButton(
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
            text: AppString.updateStatus,
            onPressed: () async {
              BlocProvider.of<ViewCvComplaintBloc>(
                  !context.mounted ? context : context).amountController.text = "";
              var res = await showDialog(
                  context: !context.mounted ? context : context,
                  builder: (BuildContext mContext) =>
                      ViewCvUpdateStatusWidget(cngData: cngData));
              if (res.toString() == "Complete") {
                DateTime startDate = BlocProvider.of<ViewCvComplaintBloc>(
                    !context.mounted ? context : context)
                    .startDate;
                DateTime endDate = BlocProvider.of<ViewCvComplaintBloc>(
                    !context.mounted ? context : context)
                    .endDate;
                BlocProvider.of<ViewCvComplaintBloc>(!context.mounted ? context : context)
                    .add(ViewCvComplaintSelectedDateRangeEvent(
                    fromDate: startDate,
                    toDate: endDate,
                    context: !context.mounted ? context : context));
              }
            }),
      ),
    );
  }

  Widget _addMeasurementButton(
      {required CngModel cngData,
        required int index,
        required BuildContext context}) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.07,
        child: ButtonWidget(
            fontSize: AppFont.font_12,
            text: AppString.addMeasurement,
            onPressed: () async {
              BlocProvider.of<ViewCvComplaintBloc>(context).add(
                  ViewCvComplaintSelectCngDataEvent(cngData: cngData));
              if (await Vibration.hasAmplitudeControl() != null) {
                Vibration.vibrate(duration: 100);
              }
             var res =  await Navigator.push(
                !context.mounted ? context : context,
                FadeRoute(page: const ViewCvAddMeasurementWidget()),
              );
              if(res.toString() == "Complete"){
                DateTime startDate = BlocProvider.of<ViewCvComplaintBloc>(
                    !context.mounted ? context : context)
                    .startDate;
                DateTime endDate = BlocProvider.of<ViewCvComplaintBloc>(
                    !context.mounted ? context : context)
                    .endDate;
                BlocProvider.of<ViewCvComplaintBloc>(!context.mounted ? context : context)
                    .add(ViewCvComplaintSelectedDateRangeEvent(
                    fromDate: startDate,
                    toDate: endDate,
                    context: !context.mounted ? context : context));
              }

            }),
      ),
    );
  }
}
