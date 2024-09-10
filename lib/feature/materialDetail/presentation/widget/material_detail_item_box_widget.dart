import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/materialDetail/domain/model/material_detail_model.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class MaterialDetailItemBoxWidget extends StatelessWidget {
  final MaterialDetailModel materialDetailData;

  const MaterialDetailItemBoxWidget({
    super.key,
    required this.materialDetailData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              TextWidget("Plant : ", color: AppColor.black, fontSize: AppFont.font_13,),
              Expanded(child: TextWidget("${materialDetailData.plant}",
                textAlign: TextAlign.end,
                color: AppColor.black, fontSize: AppFont.font_13,)),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          Row(
            children: [
              TextWidget("Plant Name : ", color: AppColor.black, fontSize: AppFont.font_13,),
              Expanded(child: TextWidget("${materialDetailData.plantName}",
                textAlign: TextAlign.end,
                color: AppColor.black, fontSize: AppFont.font_13,)),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          Row(
            children: [
              TextWidget("Storage Location : ", color: AppColor.black, fontSize: AppFont.font_13,),
              Expanded(child: TextWidget("${materialDetailData.storageLocation}",
                textAlign: TextAlign.end,
                color: AppColor.black, fontSize: AppFont.font_13,)),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          Row(
            children: [
              TextWidget("Storage Location Name : ", color: AppColor.black, fontSize: AppFont.font_13,),
              Expanded(child: TextWidget("${materialDetailData.storageLocationName}",
                textAlign: TextAlign.end,
                color: AppColor.black, fontSize: AppFont.font_13,)),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          Row(
            children: [
              TextWidget("Unrestricted Stock : ", color: AppColor.black,fontSize: AppFont.font_13,),
              Expanded(child: TextWidget("${materialDetailData.unrestrictedStock}",
                textAlign: TextAlign.end,
                color: AppColor.black, fontSize: AppFont.font_13,)),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          Row(
            children: [
              TextWidget("Base Unit of Measure : ", color: AppColor.black, fontSize: AppFont.font_13,),
              Expanded(child: TextWidget("${materialDetailData.baseUnitofMeasure}",
                textAlign: TextAlign.end,
                color: AppColor.black, fontSize: AppFont.font_13,)),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          const DottedDividerLine(color: Colors.black,),
        ],
      ),
    );
  }
}
