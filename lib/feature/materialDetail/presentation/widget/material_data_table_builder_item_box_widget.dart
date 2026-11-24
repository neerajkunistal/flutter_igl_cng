import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/materialDetail/domain/bloc/material_detail_bloc.dart';
import 'package:flutter_igl_cng/feature/materialDetail/presentation/widget/material_list_header_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/data_table_widget.dart';

class MaterialDataTableBuilderItemBox extends StatelessWidget {
  final FetchMaterialDetailDataState dataState;
  const MaterialDataTableBuilderItemBox({super.key, required this.dataState});

  @override
  Widget build(BuildContext context) {
    List<List<Object>> rowsCells = [];
    final fixedRowCells = [
      "Plant",
      "Plant Name",
      "Storage Location",
      "Storage Location Name",
      "Unrestricted Stock",
      "Base Unit of Measure"
    ];

    final fixedColCells = [];
    for(var materialDetailData in dataState.materialDetailList) {
      List<Object> row = [];
      row.add(materialDetailData.plant.toString());
      row.add(materialDetailData.plantName.toString());
      row.add(materialDetailData.storageLocation.toString());
      row.add(materialDetailData.storageLocationName.toString());
      row.add(materialDetailData.unrestrictedStock.toString());
      row.add(materialDetailData.baseUnitofMeasure.toString());
      rowsCells.add(row);
    }
    return dataState.materialDetailList.isNotEmpty ?
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
          MaterialListHeaderWidget(materialDetailData: dataState.materialDetailList[0],
              total: dataState.materialDetailList.length),
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
}
