import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class AddSparePartItemBoxWidget extends StatelessWidget {
  final PartModel partModel;
  final int index;

  const AddSparePartItemBoxWidget({super.key,
  required this.partModel,
  required this.index,
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
          onTap: () {
            BlocProvider.of<AddSparePartBloc>(context).add(AddSparePartDeletePartEvent(index: index));
          },
          child: Icon(Icons.delete_forever_outlined, color: AppColor.red,)),
    );
  }

  Widget _itemBuilder({required BuildContext context}) {
    return Column(
        children: [
          Row(
            children: [
              TextWidget("Spares : ", color: AppColor.black,),
              Expanded(child: TextWidget(partModel.sparesData!.spareName.toString(),
                color: AppColor.black, textAlign: TextAlign.end,)),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),
          Row(
            children: [
              TextWidget(partModel.sparesData!.spareUom.toString(), color: AppColor.black,),
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
          _removeButton(context: context),
        ]);
  }
}
