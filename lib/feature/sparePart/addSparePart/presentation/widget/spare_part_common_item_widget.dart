import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class SparePartCommonItemWidget extends StatelessWidget {
  final PartModel partModel;
  final int index;
  final GestureTapCallback? onTap;

  const SparePartCommonItemWidget({super.key,
    required this.partModel,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: EnvironmentConfig.of(context)!.primaryTheme,
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

          partModel.sparesData != null
           ? Row(
            children: [
              TextWidget("Spares : ", color: AppColor.black,),
              Expanded(child: TextWidget(partModel.sparesData!.spareName.toString(),
                color: AppColor.black, textAlign: TextAlign.end,)),
            ],
          ) : const SizedBox.shrink(),

          partModel.name != null
              ? Row(
            children: [
              TextWidget("Spares : ", color: AppColor.black,),
              Expanded(child: TextWidget(partModel.name.toString(),
                color: AppColor.black, textAlign: TextAlign.end,)),
            ],
          ) : const SizedBox.shrink(),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),

          partModel.sparesData != null
           ? Row(
            children: [
              TextWidget(partModel.sparesData!.spareUom.toString(), color: AppColor.black,),
              Expanded(child: TextWidget(partModel.qty.toString(), color: AppColor.black,textAlign: TextAlign.end,)),
            ],
          ) : Row(
            children: [
              TextWidget("Qty", color: AppColor.black,),
              Expanded(child: TextWidget(partModel.qty.toString(), color: AppColor.black,textAlign: TextAlign.end,)),
            ],
          ),


          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),
          Row(
            children: [
              TextWidget("Material Code", color: AppColor.black,),
              Expanded(child: TextWidget(partModel.materialCode.toString(),
                  color: AppColor.black,textAlign: TextAlign.end)),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),
          Row(
            children: [
              TextWidget("Remark", color: AppColor.black,),
              Expanded(child: TextWidget(partModel.remarkCode.toString(),
                  color: AppColor.black, textAlign: TextAlign.end)),
            ],
          ),
          userData.roleType ==  RoleType.shiftEngineer
          ? _removeButton(context: context) : const SizedBox(),
        ]);
  }
}
