import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/presentation/widget/add_spare_part_item_box_widget.dart';

class AddSparePartWidget extends StatelessWidget {
  const AddSparePartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSparePartBloc, AddSparePartState>(
      builder: (context, state) {
        if(state is FetchAddSparePartDataState){
          return _scrapList(dataState: state);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _scrapList({required FetchAddSparePartDataState dataState}) {
    print("Part List ==== ${dataState.partList.length}");
    return dataState.partList.isNotEmpty ?
    DottedBorder(
      color: AppColor.grey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget("Spare Part Details",
              fontWeight: FontWeight.w700,
              fontSize: AppFont.font_15,),
            ListView.builder(
                itemCount: dataState.partList.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return AddSparePartItemBoxWidget(
                     partModel: dataState.partList[index],
                      index: index,
                  );
                }),
          ],
        ),
      ),
    ) : const SizedBox.shrink();
  }
}
