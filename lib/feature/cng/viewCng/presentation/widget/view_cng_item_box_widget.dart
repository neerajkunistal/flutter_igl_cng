import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/bloc/view_cng_bloc.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/presentation/page/view_cng_detail_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';

class ViewCngItemBoxWidget extends StatelessWidget {
  final CngModel cngData;
  final int index;

  const ViewCngItemBoxWidget(
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
      elevation: 7,
      shadowColor: AppColor.themeColor,
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<ViewCngBloc>(context).add(ViewCngSelectIndexEvent(listIndex: index));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(page: const ViewCngDetailPage()),
          );
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
                        "Complaint ID : ",
                        fontWeight: FontWeight.w700,
                        fontSize: AppFont.font_13,
                        color: AppColor.themeColor,
                      ),
                      Expanded(
                          child: TextWidget(
                        cngData.complaintNumber,
                        textAlign: TextAlign.right,
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
                        "DateTime : ",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      ),
                      Expanded(
                          child: TextWidget(
                        incidentDateTime,
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
                        textAlign: TextAlign.right,
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
                        "Reported Phone: ",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      ),
                      Expanded(
                          child: TextWidget(
                            cngData.reportByPhone.toString(),
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.right,
                            fontSize: AppFont.font_13,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.02,
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
