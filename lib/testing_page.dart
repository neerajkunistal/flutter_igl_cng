import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/data_table_widget.dart';
import 'package:video_player/video_player.dart';


class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  final _fixedRowCells = [
    "Plant",
    "Plant Name",
    "Storage Location",
    "Storage Location Name",
    "Unrestricted Stock"
    "Base Unit of Measure"
  ];


  final _rowsCells = [
    ["3010", "IGL  Greater Noida", "0045", "Avinash Em Proje", "5.000", "NO"],
  ];

  final _fixedColCells = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: DataTableWidget(
            fixedCornerCell: '',
            borderColor: Colors.grey.shade300,
            rowsCells: _rowsCells,
            fixedColCells: _fixedColCells,
            fixedRowCells: _fixedRowCells,
          ),
        ),
      ),
    );
  }
}