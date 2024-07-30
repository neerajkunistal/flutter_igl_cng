import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/widget/scrap_item_box_widget.dart';

class ScrapItemWidget extends StatelessWidget {
  const ScrapItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScrapBloc, AddScrapState>(
      builder: (context, state) {
        if(state is FetchAddScrapDataState){
          return _scrapList(dataState: state);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _scrapList({required FetchAddScrapDataState dataState}) {
    return dataState.scrapList.isNotEmpty ?
    DottedBorder(
      color: AppColor.grey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget("Scrap Details",
              fontWeight: FontWeight.w700,
              fontSize: AppFont.font_15,),
            ListView.builder(
                itemCount: dataState.scrapList.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ScrapItemBoxWidget(
                      index: index, scrapData: dataState.scrapList[index]);
                }),
          ],
        ),
      ),
    ) : const SizedBox.shrink();
  }
}
