import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/podDetail/domain/model/pod_detail_model.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class PodListHeaderWidget extends StatelessWidget {
  final PodDetailModel podDetailModel;
  final int total;
  const PodListHeaderWidget({super.key,
    required this.podDetailModel,
    required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextWidget("PO Number : ", color: AppColor.black, fontSize: AppFont.font_13, fontWeight: FontWeight.w700,),
            Expanded(child: TextWidget("${podDetailModel.pONo}",
              color: AppColor.black, textAlign: TextAlign.center, fontSize: AppFont.font_13,)),

          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.02,
        ),
        const DottedDividerLine(color: Colors.black,),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.02,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget("Total : ", color: AppColor.black,fontSize: AppFont.font_13, fontWeight: FontWeight.w700,),
            TextWidget("$total",
              color: AppColor.black, textAlign: TextAlign.center, fontSize: AppFont.font_13,),

          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.02,
        ),
        const DottedDividerLine(color: Colors.black,),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.02,
        ),
      ],
    );
  }
}
