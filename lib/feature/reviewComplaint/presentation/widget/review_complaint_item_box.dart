import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/review_complaint_model.dart';

class ReviewComplaintItemBox extends StatelessWidget {
  final ReviewComplaintModel reviewComplaintData;
  ReviewComplaintItemBox({super.key, required this.reviewComplaintData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _rowWidget(name: "Complaint Id", value: reviewComplaintData.complaintTypeId.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(name: "Date Of Time Complaint ", value: reviewComplaintData.startDateTime.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(name: "Description", value: reviewComplaintData.complaintDescription.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(name: "Closed Date Time", value: reviewComplaintData.closeDateTime.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _rowWidget({required String name, required String value}) {
    return Row(
      children: [
       TextWidget(name),
       Expanded(child: TextWidget(value, textAlign: TextAlign.end,)), 
      ],
    );
  }
}
