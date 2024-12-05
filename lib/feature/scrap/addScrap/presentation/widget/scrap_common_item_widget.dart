import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/model/scrap_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class ScrapCommonItemWidget extends StatelessWidget {
  final ScrapModel scrapData;
  final int index;
  final GestureTapCallback? onTap;
  const ScrapCommonItemWidget({super.key,
    required this.index,
    required this.scrapData,
    this.onTap,
  });

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
          onTap: onTap,
          child: Icon(Icons.delete_forever_outlined, color: AppColor.red,)),
    );
  }

  Widget _itemBuilder({required BuildContext context}) {
    LoginDataModel userData =  UserInfo.instance!.userData!;
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
          scrapData.scrapUnitTypeData != null ?
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ): const SizedBox.shrink(),

          scrapData.scrapUnitTypeData != null ?
          Row(
            children: [
              TextWidget("Unity Type", color: AppColor.black,),
              Expanded(child: TextWidget(scrapData.scrapUnitTypeData!.name.toString(),
                  color: AppColor.black,textAlign: TextAlign.end)),
            ],
          ) : const SizedBox.shrink(),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),

          scrapData.unit != null ?
          Row(
            children: [
              TextWidget("Unity", color: AppColor.black,),
              Expanded(child: TextWidget(scrapData.unit.toString(),
                  color: AppColor.black, textAlign: TextAlign.end)),
            ],
          ) : const SizedBox.shrink(),

          scrapData.scrapUnitTypeData != null ?
          Row(
            children: [
              TextWidget("Unity", color: AppColor.black,),
              Expanded(child: TextWidget(scrapData.scrapUnitTypeData!.unit.toString(),
                  color: AppColor.black, textAlign: TextAlign.end)),
            ],
          ) : const SizedBox.shrink(),
          Row(
            children: [
              TextWidget("Remark", color: AppColor.black,),
              Expanded(child: TextWidget(scrapData.remark.toString(),
                  color: AppColor.black, textAlign: TextAlign.end)),
            ],
          ),
          userData.roleType ==  RoleType.shiftEngineer
              ? _removeButton(context: context) : const SizedBox(),
        ]);
  }
}
