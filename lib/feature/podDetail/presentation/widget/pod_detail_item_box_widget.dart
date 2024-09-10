import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/podDetail/domain/model/pod_detail_model.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class PodDetailItemBoxWidget extends StatelessWidget {
  final PodDetailModel podDetailData;

  const PodDetailItemBoxWidget({
    super.key, required this.podDetailData});

  @override
  Widget build(BuildContext context) {

    String percentage =  podDetailData.consumedPercentage.toString().replaceAll(" ", "");
    double consumedPercentage =  0.0;
    if(percentage.isNotEmpty){
      consumedPercentage =  double.parse(percentage);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              TextWidget("Line Item : ", color: AppColor.black, fontSize: AppFont.font_13,),
              Expanded(child: TextWidget("${podDetailData.lineItem}",
                textAlign: TextAlign.end,
                color: AppColor.black, fontSize: AppFont.font_13,)),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          Row(
            children: [
              TextWidget("Line Item Net Value : ", color: AppColor.black, fontSize: AppFont.font_13,),
              Expanded(child: TextWidget("${podDetailData.lineItemNetValue}",
                textAlign: TextAlign.end,
                color: AppColor.black, fontSize: AppFont.font_13,)),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          Row(
            children: [
              TextWidget("Consumed Value : ", color: AppColor.black, fontSize: AppFont.font_13,),
              Expanded(child: TextWidget("${podDetailData.consumedValue}",
                textAlign: TextAlign.end,
                color: AppColor.black, fontSize: AppFont.font_13,)),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          Row(
            children: [
              TextWidget("Consumed Percentage : ", color: AppColor.black, fontSize: AppFont.font_13,),
              Expanded(child: TextWidget("${consumedPercentage.toStringAsFixed(2)}%",
                textAlign: TextAlign.end,
                color: AppColor.black, fontSize: AppFont.font_13,)),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          const Divider(),
          Row(
            children: [
              TextWidget("Short Description : ", color: AppColor.black, fontSize: AppFont.font_13,),
              Expanded(child: TextWidget("${podDetailData.shortTextDescription}",
                textAlign: TextAlign.end,
                color: AppColor.black, fontSize: AppFont.font_13,)),
            ],
          ),
          const DottedDividerLine(color: Colors.black,),
        ],
      ),
    );
  }
}
