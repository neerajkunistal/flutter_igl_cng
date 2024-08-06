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
                  "Control Room : ",
                  fontWeight: FontWeight.w500,
                  fontSize: AppFont.font_13,
                ),
                Expanded(
                    child: TextWidget(
                      cngData.controlRoom.toString(),
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
                  "Station Name : ",
                  fontWeight: FontWeight.w500,
                  fontSize: AppFont.font_13,
                ),
                Expanded(
                    child: TextWidget(
                      cngData.cngStation.toString(),
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
                  "Category : ",
                  fontWeight: FontWeight.w500,
                  fontSize: AppFont.font_13,
                ),
                Expanded(
                    child: TextWidget(
                      cngData.categoryName.toString(),
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
                  "Assigned Status : ",
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
                  "Assign By : ",
                  fontWeight: FontWeight.w500,
                  fontSize: AppFont.font_13,
                ),
                Expanded(
                    child: TextWidget(
                  cngData.assignByUser.toString(),
                  fontWeight: FontWeight.w500,
                  fontSize: AppFont.font_13,
                  textAlign: TextAlign.end,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
