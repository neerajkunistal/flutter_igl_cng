import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scrap_model.dart';

class ScrapItemBoxWidget extends StatelessWidget {
  final ScrapModel scrapData;
  final int index;
  const ScrapItemBoxWidget({super.key,
    required this.index,
    required this.scrapData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: AppColor.themeColor,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _itemBuilder(context: context),
          ),
        ],
      ),
    );
  }

  Widget _removeButton({required BuildContext context}) {
    return Align(
      alignment: Alignment.bottomRight,
      child: InkWell(
          onTap: () {
            BlocProvider.of<AddScrapBloc>(context).add(AddScrapDeleteEvent(index: index));
          },
          child: Icon(Icons.delete_forever_outlined, color: AppColor.red,)),
    );
  }

  Widget _itemBuilder({required BuildContext context}) {
    return Column(
      children: [
         Row(
           children: [
             TextWidget("Sr. Number : ", color: AppColor.black,),
             Expanded(child: TextWidget(scrapData.srNumber.toString(), color: AppColor.black, textAlign: TextAlign.end,)),
           ],
         ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.02,
        ),
        Row(
          children: [
            TextWidget("Description", color: AppColor.black,),
            Expanded(child: TextWidget(scrapData.description.toString(), color: AppColor.black,textAlign: TextAlign.end,)),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.02,
        ),
        Row(
          children: [
            TextWidget("Unity Type", color: AppColor.black,),
            Expanded(child: TextWidget(scrapData.scrapUnitTypeData!.name.toString(),
                color: AppColor.black,textAlign: TextAlign.end)),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.02,
        ),
        Row(
          children: [
            TextWidget("Unity", color: AppColor.black,),
            Expanded(child: TextWidget(scrapData.scrapUnitTypeData!.unit.toString(), 
                color: AppColor.black, textAlign: TextAlign.end)),
          ],
        ),
       _removeButton(context: context),
   ]);
  }
}
