import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/domain/bloc/view_amo_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/presentation/widget/amo_update_status_widget.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';

class ViewAmoComplaintItemBoxWidget extends StatelessWidget {
  final CngModel cngData;
  final int index;

  const ViewAmoComplaintItemBoxWidget(
      {super.key, required this.index, required this.cngData});

  @override
  Widget build(BuildContext context) {
    String incidentDateTime = "";
    if (cngData.incidentDateTime != null &&
        cngData.incidentDateTime.toString().isNotEmpty) {
      incidentDateTime = DateFormat('dd-MMM-yyyy, h:mm:ss')
          .format(DateTime.parse(cngData.incidentDateTime.toString()));
    }

    return Card(
      elevation: 2,
      shadowColor: AppColor.themeColor,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    TextWidget(
                      "Complaint Id : ",
                      fontWeight: FontWeight.w700,
                      fontSize: AppFont.font_13,
                      color: AppColor.themeColor,
                    ),
                    Expanded(
                        child: TextWidget(
                      cngData.complaintNumber,
                      textAlign: TextAlign.right,
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
                      textAlign: TextAlign.right,
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
                      cngData.reportBy.toString(),
                      textAlign: TextAlign.right,
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
                      cngData.approveStatus.toString() == "0"
                          ? "Pending"
                          : cngData.approveStatus.toString() == "1"
                              ? "Approved"
                              : "Rejected",
                      fontWeight: FontWeight.w500,
                      fontSize: AppFont.font_13,
                      textAlign: TextAlign.right,
                      color: cngData.approveStatus.toString() == "0"
                          ? AppColor.orange
                          : cngData.approveStatus.toString() == "1"
                              ? AppColor.green
                              : AppColor.red,
                    )),
                  ],
                ),
                cngData.approveStatus.toString() == "0"
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
                                  context: context)),
                        ],
                      )
                    : const SizedBox.shrink(),
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
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.w500,
                      fontSize: AppFont.font_13,
                    )),
                  ],
                ),
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

  Widget _updateStatusButton(
      {required CngModel cngData,
      required int index,
      required BuildContext context}) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.43,
        height: MediaQuery.of(context).size.height * 0.07,
        child: ButtonWidget(
            fontSize: AppFont.font_11,
            text: AppString.updateStatus,
            onPressed: () async {
              var res = await showDialog(
                  context: !context.mounted ? context : context,
                  builder: (BuildContext mContext) =>
                      AmoUpdateStatusWidget(cngData: cngData));
              if (res.toString() == "Complete") {
                DateTime startDate = BlocProvider.of<ViewAmoComplaintBloc>(
                    !context.mounted ? context : context)
                    .startDate;
                DateTime endDate = BlocProvider.of<ViewAmoComplaintBloc>(
                    !context.mounted ? context : context)
                    .endDate;
                BlocProvider.of<ViewAmoComplaintBloc>(!context.mounted ? context : context)
                    .add(ViewAmoComplaintSelectedDateRangeEvent(
                    fromDate: startDate,
                    toDate: endDate,
                    context: !context.mounted ? context : context));
              }
            }),
      ),
    );
  }
}
