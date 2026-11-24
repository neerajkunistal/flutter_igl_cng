import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class CiAssignmentListWidget extends StatelessWidget {
  final List<String> assignmentList;
  const CiAssignmentListWidget({super.key,
   required this.assignmentList,
  });

  @override
  Widget build(BuildContext context) {
    return _listBuilder();
  }

  Widget _listBuilder() {
    return ListView.builder(
         shrinkWrap: true,
         itemCount: assignmentList.length,
         physics: const NeverScrollableScrollPhysics(),
         itemBuilder: (context, index) {
         return Row(
           children: [
             Container(
                 width: 10,
                 height: 10,
                 decoration: const BoxDecoration(
                   color: Colors.black,
                   shape: BoxShape.circle,
                 )
             ),
             SizedBox(
               width: MediaQuery.of(context).size.width * 0.03,
             ),
             Expanded(
               child: TextWidget(assignmentList[index].toString(),
                 fontSize: AppFont.font_13,),
             ),
           ],
         );
    });
  }

}
