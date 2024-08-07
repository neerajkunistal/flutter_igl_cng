import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/domain/bloc/view_amo_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/presentation/page/view_amo_detail_page.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';

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
      incidentDateTime = DateFormat('dd-MMM-yyyy')
          .format(DateTime.parse(cngData.incidentDateTime.toString()));
    }

    return Card(
      elevation: 2,
      shadowColor: AppColor.themeColor,
      child: GestureDetector(
        onTap: () async {
          BlocProvider.of<ViewAmoComplaintBloc>(context).add(ViewAmoComplaintSelectIndexEvent(listIndex: index));
          var res =  await Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(page: const ViewAmoDetailPage()),
          );
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
        },
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
                        "Station Name : ",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      ),
                      Expanded(
                          child: TextWidget(
                            cngData.cngStation.toString(),
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.right,
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
                        "Category : ",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      ),
                      Expanded(
                          child: TextWidget(
                            cngData.categoryName.toString(),
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.right,
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
                        "Approval Status : ",
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
                                : "Rejected",
                            fontWeight: FontWeight.w500,
                            fontSize: AppFont.font_13,
                            textAlign: TextAlign.right,
                            color: cngData.complaintStatus.toString() == "0"
                                ? AppColor.orange
                                : cngData.complaintStatus.toString() == "1"
                                ? AppColor.green
                                : AppColor.red,
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
                        "Reported Phone : ",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      ),
                      Expanded(
                          child: TextWidget(
                            cngData.reportByPhone.toString(),
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
      ),
    );
  }


}
