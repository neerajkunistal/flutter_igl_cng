import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/presentation/widget/complaint_assign_widget.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';

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
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                _rowHeaderWidget(
                    name: "Complaint ID",
                    value: acknowledgeData.tokenNo.toString()),
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
                _rowWidget(
                    name: acknowledgeData.equipmentCode.toString().isNotEmpty
                        ? "Equipment"
                        : "General",
                    value: acknowledgeData.equipmentCode.toString().isNotEmpty
                        ? acknowledgeData.descriptionKva.toString()
                        : acknowledgeData.generalComplaintName.toString()),

                acknowledgeData.equipmentCode.toString().isNotEmpty?
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ) : const SizedBox(),

                acknowledgeData.equipmentCode.toString().isNotEmpty
                    ? _rowWidget(
                        name: "vendor Code",
                        value: acknowledgeData.vendorCode.toString())
                    : const SizedBox.shrink(),
                acknowledgeData.equipmentCode.toString().isNotEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      )
                    : const SizedBox.shrink(),
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
                    name: "Assign Type",
                    value: acknowledgeData.assignType.toString() == "1"
                        ? "Self"
                        : acknowledgeData.assignType.toString() == "2"
                            ? "MI"
                            : acknowledgeData.assignType.toString() == "3"
                                ? "Vendor"
                                : ""),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                acknowledgeData.miAssignToUser.toString().isNotEmpty
                    ? _rowWidget(
                        name: "Assign By",
                        value: acknowledgeData.miAssignToUser.toString())
                    : const SizedBox.shrink(),
                acknowledgeData.miAssignToUser.toString().isNotEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      )
                    : const SizedBox.shrink(),

                acknowledgeData.notificationNo.toString().isNotEmpty
                    ? _rowWidget(
                    name: "Notification No",
                    value: acknowledgeData.notificationNo.toString())
                    : const SizedBox.shrink(),
                acknowledgeData.notificationNo.toString().isNotEmpty
                    ? SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ): const SizedBox.shrink(),

                acknowledgeData.complaintStatus.toString() != "2" &&
                        acknowledgeData.complaintStatus.toString() != "1" &&
                        acknowledgeData.ackStatus.toString() == "1"
                    ? _assignButton(context: context)
                    : const SizedBox.shrink(),
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

  Widget _assignButton({required BuildContext context}) {
    return Align(
      alignment: Alignment.bottomRight,
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.13,
        width: MediaQuery.of(context).size.width * 0.35,
        child: ButtonWidget(
            backgroundColor: acknowledgeData.assignTo.toString() != "0"
                    ? AppColor.orange
                    : AppColor.themeColor,
            fontSize: AppFont.font_11,
            text:(acknowledgeData.assignTo.toString().isEmpty ||
                        acknowledgeData.assignTo.toString() == "0")
                    ? AppString.assign
                    : AppString.reAssign,
            onPressed: () async {
                BlocProvider.of<AcknowledgeBloc>(context)
                    .add(AcknowledgeUserListLoadEvent(context: context));
                BlocProvider.of<AddSparePartBloc>(context).add(AddSparePartClearSparePartEvent());
                BlocProvider.of<AddSparePartBloc>(context)
                    .add(AddSparePartPageLoadEvent(context: context));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ComplaintAssignWidget(
                            acknowledgeData: acknowledgeData)));
            }),
      ),
    );
  }
}
