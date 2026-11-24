import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/widget/closer_widget.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/widget/review_complaint_item_box.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/page/add_scrap_page.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/widget/scrap_common_item_widget.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/widget/scrap_item_widget.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/presentation/page/add_spare_part_page.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/presentation/widget/add_spare_part_widget.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/presentation/widget/spare_part_common_item_widget.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class ViewEquipmentComplaintDetailPage extends StatefulWidget {
  final EquipmentComplaintType equipmentComplaintType;
  const ViewEquipmentComplaintDetailPage({super.key, required this.equipmentComplaintType});

  @override
  State<ViewEquipmentComplaintDetailPage> createState() =>
      _ViewEquipmentComplaintDetailPageState();
}

class _ViewEquipmentComplaintDetailPageState
    extends State<ViewEquipmentComplaintDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: appBackGround(
        context: context,
        child: BlocBuilder<ViewEquipmentComplaintBloc, ViewEquipmentComplaintState>(
          builder: (context, state) {
            if(state is FetchViewEquipmentComplaintDataState){
              return Column(
                children: [
                  _appBar(),
                  const DottedDividerLine(color: Colors.white),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Expanded(
                    child: Container(
                      color: AppColor.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ReviewComplaintItemBox(
                              index: state.index,
                              isDetailPage: true,
                              reviewComplaintData: state.reviewComplaintList[state.index],
                              equipmentComplaintType: widget.equipmentComplaintType,
                            ),
                            _scrapList(dataState: state),
                            _sparePartList(dataState: state),

                            _verticalSpace(),
                            ScrapItemWidget(),
                            _verticalSpace(),

                           widget.equipmentComplaintType == EquipmentComplaintType.normal
                               ? _addScarpButton() : const SizedBox.shrink(),
                            widget.equipmentComplaintType == EquipmentComplaintType.normal
                                ?  _verticalSpace() : const SizedBox.shrink(),
                            AddSparePartWidget(),
                            widget.equipmentComplaintType == EquipmentComplaintType.normal
                                ? _addPartButton( context: context) : const SizedBox.shrink(),
                            CloserWidget(dataState: state),
                            _verticalSpace(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CenterLoaderWidget());
            }
          },
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          "Complaint Details",
          color: AppColor.white,
          fontSize: AppFont.font_15,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Image.asset(
          AppConfig.instanceInit()!.client == Client.iglcng
              ? AppIcon.appLogoIgl
              : AppIcon.appLogoIgl,
          height: MediaQuery.of(context).size.width * 0.13,
          width: MediaQuery.of(context).size.width * 0.13,
        )
      ],
    );
  }

  Widget _scrapList({required FetchViewEquipmentComplaintDataState dataState}) {
    return  dataState.reviewComplaintList[dataState.index].scrapList!.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DottedDividerLine(),
        TextWidget("Scarp", fontWeight: FontWeight.w700,),
        ListView.builder(
            itemCount: dataState.reviewComplaintList[dataState.index].scrapList!.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ScrapCommonItemWidget(
                index: index,
                scrapData: dataState.reviewComplaintList[dataState.index].scrapList![index],
              );
            }),
        _verticalSpace(),
        const DottedDividerLine(),
        _verticalSpace(),
      ],
    ) : const SizedBox.shrink();
  }

  Widget _sparePartList({required FetchViewEquipmentComplaintDataState dataState}) {
    return  dataState.reviewComplaintList[dataState.index].partList!.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DottedDividerLine(),
        TextWidget("Spare Part", fontWeight: FontWeight.w700,),
        ListView.builder(
            itemCount:  dataState.reviewComplaintList[dataState.index].partList!.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return SparePartCommonItemWidget(
                index: index,
                partModel:  dataState.reviewComplaintList[dataState.index].partList![index],
              );
            }),
        _verticalSpace(),
        const DottedDividerLine(),
        _verticalSpace(),
      ],
    ) : const SizedBox.shrink();
  }

  Widget _addScarpButton() {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.5,
        child: ButtonWidget(
            text: AppString.addScrap,
            height:
            AppConfig.getDeviceType(context: context) == DeviceType.tablet
                ? MediaQuery.of(context).size.height * 0.13
                : null,
            onPressed: () async {
              var result = await Navigator.push(context,
                  FadeRoute(page: const AddScrapPage()));
              if (!context.mounted) result;
              if (result.toString() == "Completed") {

              }
            }),
      ),
    );
  }

  Widget _addPartButton(
      {required BuildContext context}) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width/2.6,
        child: ButtonWidget(
            text: AppString.addPart,
            onPressed: () {
              BlocProvider.of<AddSparePartBloc>(context)
                  .add(AddSparePartPageLoadEvent(context: context));
              Navigator.push(
                context,
                FadeRoute(page: const AddSparePartPage()),
              );
            }),
      ),
    );
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
