import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
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
      incidentDateTime = DateFormat('dd-MMM-yyyy')
          .format(DateTime.parse(cngData.incidentDateTime.toString()));
    }

    String assignDateTime = "";
    if (cngData.assignDataTime != null &&
        cngData.assignDataTime.toString().isNotEmpty) {
      assignDateTime = DateFormat('dd-MMM-yyyy')
          .format(DateTime.parse(cngData.assignDataTime.toString()));
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
                      ? "Open"
                      : cngData.complaintStatus.toString() == "1"
                          ? "Closed"
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
          ],
        ),
      ),
    );
  }
}
