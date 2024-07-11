
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/feature/cv/domain/bloc/view_cv_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/cv/presentation/widget/view_cv_update_status_widget.dart';

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
                Expanded(child: TextWidget(cngData.approveStatus.toString() == "0" ? "Pending" :
                cngData.approveStatus.toString() == "1" ?  "Approved" : "Reject" ,
                  fontWeight: FontWeight.w500, fontSize: AppFont.font_13,
                  color: cngData.approveStatus.toString() == "0" ? AppColor.orange :
                  cngData.approveStatus.toString() == "1" ?  AppColor.green : AppColor.red,
                )),
              ],
            ),

            cngData.estimateCost.toString() == "0" ?
            Row(
              children: [
                TextWidget("Update Status : ", fontWeight: FontWeight.w500, fontSize: AppFont.font_13,),
                Expanded(child: _updateStatusButton(cngData: cngData, index: index, context: context)),
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

  Widget _updateStatusButton({required CngModel cngData, required int index, required BuildContext context})  {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.34,
        height: MediaQuery.of(context).size.height * 0.07,
        child: ButtonWidget(
            fontSize: AppFont.font_12,
            text: AppString.update,
            onPressed: () async {
              var res =  await showDialog(
                  context: !context.mounted ? context : context,
                  builder: (BuildContext mContext) => ViewCvUpdateStatusWidget(cngData: cngData));
              if(res.toString() == "Complete"){
                BlocProvider.of<ViewCvComplaintBloc>(!context.mounted ? context : context)
                    .add(ViewCvComplaintPageLoadEvent());
              }
            }),
        ),
    );
  }
}
