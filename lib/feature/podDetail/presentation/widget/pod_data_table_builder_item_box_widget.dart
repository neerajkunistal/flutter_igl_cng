import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/podDetail/domain/bloc/pod_detail_bloc.dart';
import 'package:flutter_igl_cng/feature/podDetail/presentation/widget/pod_list_header_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/data_table_widget.dart';

class PodDataTableBuilderItemBox extends StatelessWidget {
  final FetchPodDetailDataState dataState;
  const PodDataTableBuilderItemBox({super.key, required this.dataState});

  @override
  Widget build(BuildContext context) {
    List<List<Object>> rowsCells = [];
    final fixedRowCells = [
      "Line Item",
      "Short Description",
      "Line Item Net Value",
      "Consumed Value",
      "Consumed Percentage",
    ];

    final fixedColCells = [];
    for(var podDetailData in dataState.podDetailList) {
      List<Object> row = [];
      row.add(podDetailData.lineItem.toString());
      row.add(podDetailData.shortTextDescription.toString());
      row.add(podDetailData.lineItemNetValue.toString());

      // row.add(podDetailData.consumedValue.toString());

      String value =  podDetailData.consumedValue.toString().replaceAll(" ", "");
      dynamic consumedValue =  0.0;
      if(value.isNotEmpty && isNumeric(value) == true){
        double consumedPr =  double.parse(value)/1.18;
        consumedValue = consumedPr.toStringAsFixed(2);
      } else {
        consumedValue = value.toString();
      }
      row.add("$consumedValue");

      String percentage =  podDetailData.consumedPercentage.toString().replaceAll(" ", "");
      dynamic consumedPercentage =  0.0;
      if(percentage.isNotEmpty && isNumeric(percentage) == true){
        double consumedPr =  double.parse(percentage)/1.18;
        consumedPercentage = consumedPr.toStringAsFixed(2);
      } else {
        consumedPercentage = percentage.toString();
      }

      row.add("$consumedPercentage");
      rowsCells.add(row);
    }
    return dataState.podDetailList.isNotEmpty ?
    Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          PodListHeaderWidget(podDetailModel: dataState.podDetailList[0],
              total: dataState.podDetailList.length),
          Expanded(
            child: DataTableWidget(
              cellWidth : MediaQuery.of(context).size.width * 0.35,
              fixedCornerCell: '',
              borderColor: Colors.grey.shade300,
              rowsCells: rowsCells,
              fixedColCells: fixedColCells,
              fixedRowCells: fixedRowCells,
            ),
          ),
        ],
      ),
    ) : const Center(child: TextWidget("No Record Found", color: Colors.white,));
  }

  bool isNumeric(String str) {
    try{
      var value = double.parse(str);
      return true;
    } on FormatException {
      return false;
    }
  }
}
