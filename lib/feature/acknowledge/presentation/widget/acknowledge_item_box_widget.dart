import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/acknowledge_model.dart';

class AcknowledgeItemBoxWidget extends StatelessWidget {
  final int index;
  final AcknowledgeModel acknowledgeData;
  const AcknowledgeItemBoxWidget({super.key, required this.acknowledgeData, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _rowWidget(index: index, name: "Complaint ID", value: acknowledgeData.complaintTypeId.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(index: index, name: "Date Of Complaint", value: acknowledgeData.reportDateTime.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(index: index, name: "Description", value: acknowledgeData.complaintDescription.toString()),
          ],
        ),
      ),
    );
  }

  Widget _rowWidget({required int index, required String name, required String value}) {
     return Row(
       children: [
        TextWidget(name),
        Expanded(child: TextWidget(value, textAlign: TextAlign.end,)),
       ],
     );
  }
}
