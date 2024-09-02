import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';

class ViewCvComplaintItemBoxWidget extends StatelessWidget {
  final CngModel cngData;
  final int index;

  const ViewCvComplaintItemBoxWidget(
      {super.key, required this.index, required this.cngData});

  @override
  Widget build(BuildContext context) {
    String assignDateTime = "";
    if (cngData.assignDataTime != null &&
        cngData.assignDataTime.toString().isNotEmpty) {
      assignDateTime = DateFormat('dd-MMM-yyyy')
          .format(DateTime.parse(cngData.assignDataTime.toString()));
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
                          : "Rejected",
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
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Row(
              children: [
                TextWidget(
                  "Assign Phone : ",
                  fontWeight: FontWeight.w500,
                  fontSize: AppFont.font_13,
                ),
                Expanded(
                    child: TextWidget(
                      cngData.reportByPhone.toString(),
                      fontWeight: FontWeight.w500,
                      fontSize: AppFont.font_13,
                      textAlign: TextAlign.end,
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
                      "Changes request",
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

          ],
        ),
      ),
    );
  }

}
