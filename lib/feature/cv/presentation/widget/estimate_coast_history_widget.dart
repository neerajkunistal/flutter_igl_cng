import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class EstimateCoastHistoryWidget extends StatelessWidget {
  final CngModel cngData;
  const EstimateCoastHistoryWidget({
    super.key,
    required this.cngData,
  });

  @override
  Widget build(BuildContext context) {
    return cngData.estimateList != null && cngData.estimateList!.isNotEmpty
        &&  cngData.estimateList!.length > 1 ?
    ListView.builder(
        itemCount: cngData.estimateList!.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
      String estimateDateTime = "";
      if (cngData.estimateList![index].createdAt.toString().isNotEmpty) {
        estimateDateTime = DateFormat('dd-MMM-yyyy')
            .format(DateTime.parse(cngData.estimateList![index].createdAt.toString()));
      }
       return Column(
         children: [
           SizedBox(
             height: MediaQuery.of(context).size.width * 0.02,
           ),
           Row(
             children: [
               TextWidget(
                 "Estimate Cost: ",
                 fontWeight: FontWeight.w500,
                 fontSize: AppFont.font_13,
               ),
               Expanded(
                   child: TextWidget(
                     cngData.estimateList![index].estimateAmount.toString(),
                     textAlign: TextAlign.end,
                     fontWeight: FontWeight.w500,
                     fontSize: AppFont.font_13,
                   )),
             ],
           ),
           SizedBox(
             height: MediaQuery.of(context).size.width * 0.02,
           ),
           Row(
             children: [
               TextWidget(
                 "Estimate Cost Date: ",
                 fontWeight: FontWeight.w500,
                 fontSize: AppFont.font_13,
               ),
               Expanded(
                   child: TextWidget(
                     estimateDateTime,
                     textAlign: TextAlign.end,
                     fontWeight: FontWeight.w500,
                     fontSize: AppFont.font_13,
                   )),
             ],
           ),

         ],
       );
    }) : const SizedBox.shrink();
  }
}
