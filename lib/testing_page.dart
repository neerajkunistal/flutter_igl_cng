import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/data_table_widget.dart';


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
        child: Center(
          child: Table(border: TableBorder.all(), children: [
            const TableRow(children: [
              Text('Column 1'),
              Text('Column 2'),
            ]),
            TableRow(children: [
              const Text('Entry 1'),
              Table(border: TableBorder.all(), children: const [
                TableRow(children: [
                  Text('Nested Entry 1'),
                  Text('Nested Entry 2'),
                ]),
                TableRow(children: [
                  Text('Nested Entry 3'),
                  Text('Nested Entry 4'),
                ]),
              ]),
            ]),
          ]),
        ),
      ),
    );
  }
}