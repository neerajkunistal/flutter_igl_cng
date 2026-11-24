import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/viewEquipmentComplaint/domain/bloc/view_equipment_complaint_market_bloc.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/viewEquipmentComplaint/presentaion/widget/closer_widget_market.dart';
import 'package:flutter_igl_cng/feature/marketing/reviewComplaintMarket/presentation/widget/review_complaint_item_box_market.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/page/add_scrap_page.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/widget/scrap_common_item_widget.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/widget/scrap_item_widget.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/presentation/page/add_spare_part_page.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/presentation/widget/add_spare_part_widget.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/presentation/widget/spare_part_common_item_widget.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class ViewEquipmentComplaintMarketDetailPage extends StatefulWidget {
  final EquipmentComplaintType equipmentComplaintType;
  const ViewEquipmentComplaintMarketDetailPage({super.key, required this.equipmentComplaintType});

  @override
  State<ViewEquipmentComplaintMarketDetailPage> createState() =>
      _ViewEquipmentComplaintMarketDetailPageState();
}

class _ViewEquipmentComplaintMarketDetailPageState
    extends State<ViewEquipmentComplaintMarketDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: appBackGround(
        context: context,
        child: BlocBuilder<ViewEquipmentComplaintMarketBloc, ViewEquipmentComplaintMarketState>(
          builder: (context, state) {
            if (state is FetchViewEquipmentComplaintMarketDataState) {
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
                            // Guard the top item box against an out-of-range index.
                            if (_isValidIndex(state.index, state.listOfComplaintData.length))
                              ReviewComplaintMarketItemBox(
                                index: state.index,
                                isDetailPage: true,
                                reviewComplaintData:
                                state.listOfComplaintData[state.index],
                                equipmentComplaintType:
                                widget.equipmentComplaintType,
                              ),
                            _scrapList(dataState: state),
                            _sparePartList(dataState: state),

                            _verticalSpace(),
                            ScrapItemWidget(),
                            _verticalSpace(),


                            CloserWidgetMarket(dataState: state),
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

  /// True when [index] can safely be used on a list of [length] items.
  bool _isValidIndex(int index, int length) => index >= 0 && index < length;

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

  Widget _scrapList({required FetchViewEquipmentComplaintMarketDataState dataState}) {
    // reviewComplaintList can be empty when this page is opened from the
    // market flow (that flow populates listOfComplaintData, not this list),
    // so bounds-check before indexing to avoid a RangeError.
    if (!_isValidIndex(dataState.index, dataState.reviewComplaintList.length)) {
      return const SizedBox.shrink();
    }

    final scrapList =
        dataState.reviewComplaintList[dataState.index].scrapList;
    if (scrapList == null || scrapList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DottedDividerLine(),
        TextWidget("Scarp", fontWeight: FontWeight.w700),
        ListView.builder(
          itemCount: scrapList.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ScrapCommonItemWidget(
              index: index,
              scrapData: scrapList[index],
            );
          },
        ),
        _verticalSpace(),
        const DottedDividerLine(),
        _verticalSpace(),
      ],
    );
  }

  Widget _sparePartList({required FetchViewEquipmentComplaintMarketDataState dataState}) {
    if (!_isValidIndex(dataState.index, dataState.reviewComplaintList.length)) {
      return const SizedBox.shrink();
    }

    final partList =
        dataState.reviewComplaintList[dataState.index].partList;
    if (partList == null || partList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DottedDividerLine(),
        TextWidget("Spare Part", fontWeight: FontWeight.w700),
        ListView.builder(
          itemCount: partList.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SparePartCommonItemWidget(
              index: index,
              partModel: partList[index],
            );
          },
        ),
        _verticalSpace(),
        const DottedDividerLine(),
        _verticalSpace(),
      ],
    );
  }

  Widget _addScarpButton() {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.5,
        child: ButtonWidget(
          text: AppString.addScrap,
          height: AppConfig.getDeviceType(context: context) == DeviceType.tablet
              ? MediaQuery.of(context).size.height * 0.13
              : null,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              FadeRoute(page: const AddScrapPage()),
            );
            if (!context.mounted) return;
            if (result?.toString() == "Completed") {
              // TODO: refresh scrap list if needed
            }
          },
        ),
      ),
    );
  }

  Widget _addPartButton({required BuildContext context}) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.6,
        child: ButtonWidget(
          text: AppString.addPart,
          onPressed: () {
            BlocProvider.of<AddSparePartBloc>(context)
                .add(AddSparePartPageLoadEvent(context: context));
            Navigator.push(
              context,
              FadeRoute(page: const AddSparePartPage()),
            );
          },
        ),
      ),
    );
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
