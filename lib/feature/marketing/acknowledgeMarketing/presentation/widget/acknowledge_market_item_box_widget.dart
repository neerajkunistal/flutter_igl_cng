import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/presentation/widget/complaint_assign_widget.dart';
import 'package:flutter_igl_cng/feature/marketing/acknowledgeMarketing/domain/model/complaint_market_list_model.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

import 'complaint_market_assign_widget.dart';

class AcknowledgeMarketItemBoxWidget extends StatelessWidget {
  final int index;
  final EquipmentComplaintType equipmentComplaintType;
  final ComplaintMarketModel acknowledgeData;

  const AcknowledgeMarketItemBoxWidget(
      {super.key, required this.acknowledgeData, required this.index, required this.equipmentComplaintType});

  @override
  Widget build(BuildContext context) {
    LoginDataModel userData = UserInfo.instance!.userData!;

    return Card(
      shape: acknowledgeData.assignType.toString() == "1"  // self
          ?  RoundedRectangleBorder(
          side: BorderSide(color: Colors.orange, width: 2.0),
          borderRadius: BorderRadius.circular(10.0))
        : acknowledgeData.assignType.toString() == "2" // MI
          ?  RoundedRectangleBorder(
          side: BorderSide(color: Colors.purple, width: 2.0),
          borderRadius: BorderRadius.circular(10.0))
       : acknowledgeData.assignType.toString() == "3" // Vendor
          ?  RoundedRectangleBorder(
          side: BorderSide(color: Colors.yellow, width: 2.0),
          borderRadius: BorderRadius.circular(10.0))
          : RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                _rowHeaderWidget(
                    name: "Complaint ID",
                    value: acknowledgeData.ticketNo.toString()),
                Container(
                    height: 1,
                    color: AppColor.lightGrey,
                    width: MediaQuery.of(context).size.width),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(
                    name: "Station Name",
                    value: acknowledgeData.cngStationName.toString()),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
         _rowWidget(name: "Complaint Date Time", value: acknowledgeData.incidentDateTime.toString()),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(name: "Report Date Time", value: acknowledgeData.complainDateTime.toString()),
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
                              : acknowledgeData.complaintStatus.toString() == "3"
                              ? "${AppString.closure} ${AppString.pending}"
                                : "", color: acknowledgeData.complaintStatus.toString() == "3" ? AppColor.orange: null),
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
                _rowWidget(
                    name: "Assign To",
                    value: acknowledgeData.assignedVendorName.toString()),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),

                Container(
                    height: 1,
                    color: AppColor.lightGrey,
                    width: MediaQuery.of(context).size.width),
                _rowBottomWidget(
                    name: "Description",
                    value: acknowledgeData.ackRemarks.toString().isNotEmpty ? acknowledgeData.ackRemarks.toString() : acknowledgeData.complaintDescription.toString()),
              ],
            ),
          ),
          Positioned(
            bottom: -8.0,
            left: 0.09,
            right: 0.09,
            child: Padding(
              padding: const EdgeInsets.only(left: 7.0, right: 7.0),
              child: Image.asset(
                AppIcon.ghungaruIcon,
                height: MediaQuery.of(context).size.width * 0.06,
                color: Colors.grey[200],
                width: MediaQuery.of(context).size.width,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _rowHeaderWidget({required String name, required String value}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        color: AppColor.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            TextWidget("$name ",
                color: AppColor.themeColor,
                fontWeight: FontWeight.w700,
                fontSize: AppFont.font_13),
            Expanded(
                child: TextWidget(value,
                    textAlign: TextAlign.end, fontSize: AppFont.font_13)),
          ],
        ),
      ),
    );
  }

  Widget _rowWidget({required String name, required String value, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        children: [
          TextWidget("$name : ", fontSize: AppFont.font_13),
          Expanded(
              child: TextWidget(value,
                  textAlign: TextAlign.end, fontSize: AppFont.font_13, color: color,)),
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
