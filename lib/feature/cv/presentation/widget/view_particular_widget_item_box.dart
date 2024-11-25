import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cv/domain/bloc/view_cv_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/cv/domain/model/particular_model.dart';

class ViewParticularWidgetItemBox extends StatelessWidget {
  final List<ParticularModel> particularList;
  const ViewParticularWidgetItemBox({super.key,
   required this.particularList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: particularList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _itemBuilder(
              context: context,
              particularData: particularList[index], index: index);
      }
    );
  }

  Widget _itemBuilder(
      {required BuildContext context, required ParticularModel particularData, required int index}) {
    return Container(
      padding: const EdgeInsets.all(10),
       child: Stack(
         children: [
           Card(
             elevation: 2,
             shadowColor: AppColor.themeColor,
             child: Padding(
               padding: const EdgeInsets.all(10),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     children: [
                       TextWidget(AppString.particular + " : ",
                         fontWeight: FontWeight.w700, fontSize: AppFont.font_12,),
                       TextWidget(particularData.name.toString(),
                         fontWeight: FontWeight.w400, fontSize: AppFont.font_12,),
                     ],
                   ),
                   Row(
                     children: [
                       TextWidget(AppString.measure + "${particularData.measureTypeData!.name.toString()} : ",
                         fontWeight: FontWeight.w700, fontSize: AppFont.font_12,),
                       TextWidget("${particularData.measurementValue}${particularData.measureTypeData!.unit.toString()}",
                         fontWeight: FontWeight.w400, fontSize: AppFont.font_12,),
                     ],
                   ),

                   particularData.fileList!.isNotEmpty
                       ? _fileList(fileList: particularData.fileList!, context: context)
                       : const SizedBox.shrink() ,

                 ],
               ),
             ),
           ),
           Positioned (
             right: 0.10,
             top: -10,
             child: IconButton(
                 onPressed: () {
                   BlocProvider.of<ViewCvComplaintBloc>(context)
                       .add(ViewCvComplaintRemoveParticularEvent(index: index));
             }, icon: const Icon(Icons.close, color: Colors.grey,)),
           ),
         ],
       ),
    );
  }

  Widget _fileList(
      {required List<File> fileList, required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.15,
      child: ListView.builder(
          itemCount: fileList.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(fileList[index],
              height: MediaQuery.of(context).size.width * 0.10,),
          );
        }
      ),
    );
  }

}
