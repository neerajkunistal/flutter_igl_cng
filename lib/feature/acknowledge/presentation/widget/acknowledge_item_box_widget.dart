import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class AcknowledgeItemBoxWidget extends StatelessWidget {
  final int index;
  final AcknowledgeModel acknowledgeData;

  const AcknowledgeItemBoxWidget(
      {super.key, required this.acknowledgeData, required this.index});

  @override
  Widget build(BuildContext context) {
    String complaintDate = "";
    if (acknowledgeData.complaintDateTime.toString().isNotEmpty) {
      complaintDate = DateFormat('dd-MMM-yyyy, h:mm:ss')
          .format(DateTime.parse(acknowledgeData.complaintDateTime.toString()));
    }
    String reportDate = "";
    if (acknowledgeData.reportDateTime.toString().isNotEmpty) {
      reportDate = DateFormat('dd-MMM-yyyy, h:mm:ss')
          .format(DateTime.parse(acknowledgeData.reportDateTime.toString()));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            _rowHeaderWidget(
                name: "Complaint ID",
                value: acknowledgeData.tokenNo.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(
                name: "Reported By",
                value: acknowledgeData.reportBy.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(
                name: "Equipment",
                value: acknowledgeData.equipmentCode.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(name: "Complaint Date Time", value: complaintDate),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(name: "Report Date Time", value: reportDate),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(
                name: "Complaint Status",
                value: acknowledgeData.complaintStatus.toString() == "0"
                    ? "New"
                    : acknowledgeData.complaintStatus.toString() == "1"
                        ? "Completed"
                        : acknowledgeData.complaintStatus.toString() == "2"
                            ? "Reject"
                            : ""),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(
                name: "Ack Status",
                value: acknowledgeData.ackStatus.toString() == "1"
                    ? "Ack Done"
                    : ""),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Container(
                height: 1,
                color: AppColor.lightGrey,
                width: MediaQuery.of(context).size.width),
            _rowBottomWidget(
                name: "Description",
                value: acknowledgeData.complaintDescription.toString()),
          ],
        ),
      ),
    );
  }

  Widget _rowHeaderWidget({required String name, required String value}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        color: AppColor.lightGrey,
        border: Border(
          left: BorderSide(
            color: acknowledgeData.complaintStatus.toString() == "1"
                ? AppColor.green
                : acknowledgeData.complaintStatus.toString() == "2"
                    ? AppColor.red
                    : acknowledgeData.ackStatus.toString() == "1"
                        ? AppColor.orange
                        : AppColor.themeColor,
            width: 3,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            TextWidget("$name ",
                fontWeight: FontWeight.w700, fontSize: AppFont.font_13),
            Expanded(
                child: TextWidget(value,
                    textAlign: TextAlign.end,
                    color: AppColor.themeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: AppFont.font_13)),
          ],
        ),
      ),
    );
  }

  Widget _rowWidget({required String name, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        children: [
          TextWidget("$name : ", fontSize: AppFont.font_13),
          Expanded(
              child: TextWidget(value,
                  textAlign: TextAlign.end, fontSize: AppFont.font_13)),
        ],
      ),
    );
  }

  Widget _rowBottomWidget({required String name, required String value}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
        color: AppColor.white,
        border: Border(
          right: BorderSide(
            color: acknowledgeData.complaintStatus.toString() == "1"
                ? AppColor.green
                : acknowledgeData.complaintStatus.toString() == "2"
                    ? AppColor.red
                    : acknowledgeData.ackStatus.toString() == "1"
                        ? AppColor.orange
                        : AppColor.themeColor,
            width: 3,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget("$name : ", fontSize: AppFont.font_13),
            Expanded(
                child: TextWidget(value,
                    textAlign: TextAlign.end, fontSize: AppFont.font_13)),
          ],
        ),
      ),
    );
  }
}
