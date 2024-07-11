
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/ci/domain/bloc/view_ci_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/widget/ci_assign_widget.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/widget/ci_final_approve_widget.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/widget/ci_update_status_widget.dart';
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
      incidentDateTime = DateFormat('dd-MMM-yyyy, h:mm:ss').format(
          DateTime.parse(cngData.incidentDateTime.toString()));
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
                TextWidget("Complaint Id : ", fontWeight: FontWeight.w700, fontSize: AppFont.font_13,),
                Expanded(child: TextWidget(cngData.complaintNumber, fontWeight: FontWeight.w700, fontSize: AppFont.font_13,)),
              ],
            ),
            Divider(color: AppColor.lightGrey,),
            Row(
              children: [
                TextWidget("DateTime : ", fontWeight: FontWeight.w500, fontSize: AppFont.font_13,),
                Expanded(child: TextWidget(incidentDateTime, fontWeight: FontWeight.w500, fontSize: AppFont.font_13,)),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Row(
              children: [
                TextWidget("Reported By : ", fontWeight: FontWeight.w500, fontSize: AppFont.font_13,),
                Expanded(child: TextWidget(cngData.reportBy.toString(), fontWeight: FontWeight.w500, fontSize: AppFont.font_13,)),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Row(
              children: [
                TextWidget("Status : ", fontWeight: FontWeight.w500, fontSize: AppFont.font_13,),
                Expanded(child: TextWidget(cngData.complaintStatus.toString() == "0" ? "Pending" :
                cngData.complaintStatus.toString() == "1" ?  "Approved" : "Reject" ,
                  fontWeight: FontWeight.w500, fontSize: AppFont.font_13,
                  color: cngData.complaintStatus.toString() == "0" ? AppColor.orange :
                  cngData.complaintStatus.toString() == "1" ?  AppColor.green : AppColor.red,
                )),
              ],
            ),

            cngData.assignTo.toString() == "0" &&
            cngData.complaintStatus.toString() == "0"
                ? Row(
              children: [
                TextWidget("Assign : ", fontWeight: FontWeight.w500, fontSize: AppFont.font_13,),
                Expanded(child: _assignButton(cngData: cngData, index: index, context: context)),
              ],
            ) : const SizedBox.shrink(),

            cngData.assignTo.toString() != "0"
                && cngData.estimateCost.toString() != "0" &&
                cngData.measurementSheetBy.toString() == "0"
                ? Row(
              children: [
                TextWidget("Estimate Approve : ", fontWeight: FontWeight.w500, fontSize: AppFont.font_13,),
                Expanded(child: _estimateApproveButton(cngData: cngData, index: index, context: context)),
              ],
            ) : const SizedBox.shrink(),

            cngData.assignTo.toString() != "0"
                && cngData.estimateCost.toString() != "0" &&
                cngData.measurementSheetBy.toString() != "0" &&
                cngData.complaintStatus.toString() == "0"
                ? Row(
              children: [
                TextWidget("Final Approve : ", fontWeight: FontWeight.w500, fontSize: AppFont.font_13,),
                Expanded(child: _finalApproveButton(cngData: cngData, index: index, context: context)),
              ],
            ) : const SizedBox.shrink(),

            Divider(color: AppColor.lightGrey,),
            Row(
              children: [
                TextWidget("Description : ", fontWeight: FontWeight.w500, fontSize: AppFont.font_13,),
                Expanded(child: TextWidget(cngData.complaintDescription.toString(), fontWeight: FontWeight.w500, fontSize: AppFont.font_13,)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _assignButton({required CngModel cngData, required int index, required BuildContext context})  {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.34,
        height: MediaQuery.of(context).size.height * 0.07,
        child: ButtonWidget(
            fontSize: AppFont.font_12,
            text:  "Assign",
            backgroundColor: AppColor.orange,
            onPressed: () async {
                BlocProvider.of<ViewCiComplaintBloc>(context).add(const ViewCiComplaintFetchVendorEvent());
                var res =  await showDialog(
                    context: context,
                    builder: (BuildContext mContext) => CiAssignWidget(cngData: cngData));
                if(res.toString() == "Complete"){
                  BlocProvider.of<ViewCiComplaintBloc>(!context.mounted ? context : context)
                      .add(ViewCiComplaintPageLoadEvent());
                }
            }),
      ),
    );
  }

  Widget _estimateApproveButton({required CngModel cngData, required int index, required BuildContext context})  {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.07,
        child: ButtonWidget(
            fontSize: AppFont.font_12,
            text: AppString.estimateApprove,
            backgroundColor: AppColor.themeColor,
            onPressed: () async {
              var res =  await showDialog(
                  context: !context.mounted ? context : context,
                  builder: (BuildContext mContext) => CiUpdateStatusWidget(cngData: cngData));
              if(res.toString() == "Complete"){
                BlocProvider.of<ViewCiComplaintBloc>(!context.mounted ? context : context)
                    .add(ViewCiComplaintPageLoadEvent());
              }

            }),
      ),
    );
  }


  Widget _finalApproveButton({required CngModel cngData, required int index, required BuildContext context})  {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.34,
        height: MediaQuery.of(context).size.height * 0.07,
        child: ButtonWidget(
            fontSize: AppFont.font_12,
            text: "Final Approve",
            backgroundColor:  AppColor.themeColor,
            onPressed: () async {
              var res =  await showDialog(
                  context: !context.mounted ? context : context,
                  builder: (BuildContext mContext) => CiFinalApproveWidget(cngData: cngData));
              if(res.toString() == "Complete"){
                BlocProvider.of<ViewCiComplaintBloc>(!context.mounted ? context : context)
                    .add(ViewCiComplaintPageLoadEvent());
              }

            }),
      ),
    );
  }
}
