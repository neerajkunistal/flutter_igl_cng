import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/commonWidget/search_bar_widget.dart';
import 'package:flutter_igl_cng/feature/marketing/acknowledgeMarketing/domain/model/complaint_market_list_model.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/viewEquipmentComplaint/domain/bloc/view_equipment_complaint_market_bloc.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/viewEquipmentComplaint/presentaion/page/view_equipment_complaint_detail_page_market.dart';
import 'package:flutter_igl_cng/feature/marketing/reviewComplaintMarket/domain/bloc/review_complaint_market_bloc.dart';
import 'package:flutter_igl_cng/feature/marketing/reviewComplaintMarket/presentation/page/review_complaint_page_market.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/date_range_pop_widget.dart';

class ViewEquipmentMarketWidget extends StatelessWidget {
  final EquipmentComplaintType equipmentComplaintType;

  const ViewEquipmentMarketWidget(
      {super.key, required this.equipmentComplaintType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _searchWidget(context: context),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.white.withOpacity(.4),
            ),
            child: BlocBuilder<ViewEquipmentComplaintMarketBloc,
                ViewEquipmentComplaintMarketState>(
              builder: (context, state) {
                if (state is FetchViewEquipmentComplaintMarketDataState) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      _handleRefresh(context: context);
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        _tabWidget(dataState: state, context: context),
                        Expanded(
                            child: _listBuilder(
                                dataState: state, context: context)),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CenterLoaderWidget(),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleRefresh({required BuildContext context}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;
    final bloc = BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context);
    final DateTime startDate = bloc.startDate;
    final DateTime endDate = bloc.endDate;
    bloc.add(ViewEquipmentComplaintMarketSelectedDateRangeEvent(
      fromDate: startDate,
      toDate: endDate,
      context: context,
    ));
  }

  Widget _searchWidget({required BuildContext context}) {
    return SearchBarWidget(
      onPressed: () async {
        final bloc = BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context);
        final DateTime startDate = bloc.startDate;
        final DateTime endDate = bloc.endDate;
        final selectedDate = await DateRangeWidget.showDateRange(
            startDate: startDate, endDate: endDate, context: context);
        if (selectedDate == null || !context.mounted) return;
        BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context).add(
          ViewEquipmentComplaintMarketSelectedDateRangeEvent(
            fromDate: selectedDate.start,
            toDate: selectedDate.end,
            context: context,
          ),
        );
      },
      onChanged: (keyword) {
        BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context)
            .add(ViewEquipmentComplaintMarketSearchEvent(keyword: keyword));
      },
    );
  }

  // Market index -> New:0, Ack:1, Close:2, Complete:3
  Widget _tabButton({
    required BuildContext context,
    required FetchViewEquipmentComplaintMarketDataState dataState,
    required int index,
    required String label,
    bool isMarket = false,
  }) {
    final bool selected = dataState.selectedTabIndex == index;
    return TextButton(
      style: selected
          ? ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(AppColor.themeColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: AppColor.themeColor))))
          : null,
      onPressed: () {
        BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context).add(
            ViewEquipmentComplaintMarketSelectedTabIndexMarketEvent(
                selectedTabIndex: index));
      },
      child: TextWidget(
        "$label-${index < dataState.complaintCount.length ? dataState.complaintCount[index] : 0}",
        color: selected ? AppColor.white : AppColor.black,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        fontSize: AppFont.font_11,
      ),
    );
  }

  Widget _tabWidget(
      {required FetchViewEquipmentComplaintMarketDataState dataState,
      required BuildContext context}) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.10,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.white,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          _tabButton(
              context: context,
              dataState: dataState,
              index: 0,
              label: "New",
              isMarket: true),
          _tabButton(
              context: context,
              dataState: dataState,
              index: 1,
              label: "Ack",
              isMarket: true),
          _tabButton(
              context: context,
              dataState: dataState,
              index: 2,
              label: "Close",
              isMarket: true),
          _tabButton(
              context: context,
              dataState: dataState,
              index: 3,
              label: "Complete",
              isMarket: true),
        ],
      ),
    );
  }

  Widget _listBuilder(
      {required FetchViewEquipmentComplaintMarketDataState dataState,
      required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: dataState.listOfComplaintData.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: dataState.listOfComplaintData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = dataState.listOfComplaintData[index];
                return GestureDetector(
                  onTap: () async {
                    if (dataState.selectedTabIndex == 0|| dataState.selectedTabIndex == 2) {
                      return;
                    } else {
                      BlocProvider.of<ReviewComplaintMarketBloc>(context).add(
                        ReviewComplaintMarketPageLoadEvent(
                          context: context,
                          equipmentComplaintType: equipmentComplaintType,
                          complaintMarketData: item,
                          complaintId: item.id.toString(),
                        ),
                      );
                      final result = await Navigator.push(
                          context,
                          FadeRoute(
                              page: ReviewComaplintMarketPage(
                                  equipmentComplaintType:
                                      equipmentComplaintType)));
                      if (!context.mounted) return;
                      if (result?.toString() == "Completed") {
                        BlocProvider.of<ViewEquipmentComplaintMarketBloc>(
                                context)
                            .add(
                          ViewEquipmentComplaintMarketPageLoadEvent(
                            context: context,
                            equipmentComplaintType: equipmentComplaintType,
                          ),
                        );
                      }
                    }
                  },
                  child: _MarketComplaintCard(
                    data: item,
                    index: index,
                    tabIndex: dataState.selectedTabIndex,
                    equipmentComplaintType: equipmentComplaintType,
                  ),
                );
              },
            )
          : _noDataRefresh(context: context, dataState: dataState),
    );
  }

  Widget _noDataRefresh({
    required BuildContext context,
    required FetchViewEquipmentComplaintMarketDataState dataState,
  }) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.10,
        child: GestureDetector(
          onTap: () async {
            BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context).add(
                ViewEquipmentComplaintMarketSelectedDateRangeEvent(
                    fromDate: dataState.startDate,
                    toDate: dataState.endDate,
                    context: context));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh, color: AppColor.white),
              TextWidget(
                "No Data\nTab to refresh",
                color: AppColor.white,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarketComplaintCard extends StatelessWidget {
  final ComplaintMarketModel data;
  final int index;
  final int tabIndex; // 0=New, 1=Ack, 2=Close, 3=Complete
  final EquipmentComplaintType equipmentComplaintType;

  const _MarketComplaintCard({
    required this.data,
    required this.index,
    required this.tabIndex,
    required this.equipmentComplaintType,
  });

  // New tab index.
  static const int _newTabIndex = 0;

  String _statusText(String s) {
    switch (s) {
      case "0":
        return "Pending";
      case "1":
        return "Closed";
      case "2":
        return "Rejected";
      default:
        return s.isEmpty ? "-" : s;
    }
  }

  Color _statusColor(String s) {
    switch (s) {
      case "1":
        return Colors.green;
      case "2":
        return Colors.red;
      default:
        return AppColor.orange; // pending / unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    final String station = (data.cngStationName ?? '').toString();
    final String statusCode = (data.complaintStatus ?? '').toString();
    final String categoryName = (data.categoryName ?? '').toString();
    final String complainantName = (data.complainantName ?? '').toString();
    final String facilityName = (data.facilityName ?? '').toString();
    final String reportDate = (data.complainDateTime ?? '').toString();
    final String description = (data.complaintDescription ?? '').toString();
    final String token = (data.tokenNo ?? '').toString();
    final String ticket = (data.ticketNo ?? '').toString();

    // ── Design: normal ReviewComplaintItemBox jaisa (Card + header + rows + ghungaru) ──
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColor.white, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      shadowColor: AppColor.themeColor,
      elevation: 2,
      color: AppColor.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _rowHeaderWidget(
                  name: "Complaint Id",
                  value: token.isNotEmpty ? token : ticket,
                ),
                Divider(color: AppColor.lightGrey),
                _gap(context),

                if (station.isNotEmpty) ...[
                  _rowWidget(name: "Station Name", value: station),
                  _gap(context),
                ],
                if (ticket.isNotEmpty && token.isNotEmpty) ...[
                  _rowWidget(name: "Ticket No", value: ticket),
                  _gap(context),
                ],
                if (facilityName.isNotEmpty) ...[
                  _rowWidget(name: "Facility Name", value: facilityName),
                  _gap(context),
                ],
                if (categoryName.isNotEmpty) ...[
                  _rowWidget(name: "Category Name", value: categoryName),
                  _gap(context),
                ],
                if (complainantName.isNotEmpty) ...[
                  _rowWidget(name: "Complainant Name", value: complainantName),
                  _gap(context),
                ],

                _rowWidget(
                  name: "Complaint Status",
                  value: _statusText(statusCode),
                  color: _statusColor(statusCode),
                ),
                _gap(context),

                if (reportDate.isNotEmpty) ...[
                  _rowWidget(name: "Report Date", value: reportDate),
                  _gap(context),
                ],

                // Closure button: Station user only, New tab only.
                _closureButton(context),

                Container(
                  height: 1,
                  color: AppColor.lightGrey,
                  width: MediaQuery.of(context).size.width,
                ),

                _rowBottomWidget(
                  name: "Description",
                  value: description.isNotEmpty ? description : "-",
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -8.0,
            left: 0.09,
            right: 0.09,
            child: Padding(
              padding: const EdgeInsets.only(left: 7.0, right: 7.0),
              child: Image.asset(
                AppIcon.ghungaruIcon,
                height: MediaQuery.of(context).size.width * 0.06,
                color: Colors.grey[200],
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gap(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.width * 0.02);

  Widget _closureButton(BuildContext context) {
    final LoginDataModel userData = UserInfo.instance!.userData!;
    final bool isStationUser = userData.roleType == RoleType.stationUser;

    // Rule: sirf Station user ko, sirf New tab par.
    final bool showClosureButton = isStationUser && tabIndex == _newTabIndex;

    if (!showClosureButton) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: ButtonWidget(
            backgroundColor: AppColor.red,
            text: "Closure",
            fontSize: AppFont.font_12,
            onPressed: () async {
              BlocProvider.of<AddSparePartBloc>(context)
                  .add(AddSparePartClearSparePartEvent());
              BlocProvider.of<AddScrapBloc>(context)
                  .add(AddScrapClearScrapDataEvent(context: context));
              BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context).add(
                ViewEquipmentComplaintMarketSelectedComplaintEvent(
                    index: index),
              );

              final result = await Navigator.push(
                context,
                FadeRoute(
                  page: ViewEquipmentComplaintMarketDetailPage(
                    equipmentComplaintType: equipmentComplaintType,
                  ),
                ),
              );

              if (!context.mounted) return;

              if (result?.toString() == "Completed") {
                BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context).add(
                  ViewEquipmentComplaintMarketPageLoadEvent(
                    context: context,
                    equipmentComplaintType: equipmentComplaintType,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _rowHeaderWidget({required String name, required String value}) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            TextWidget(
              "$name ",
              fontWeight: FontWeight.w700,
              fontSize: AppFont.font_13,
              color: AppColor.themeColor,
            ),
            Expanded(
                child: TextWidget(value,
                    textAlign: TextAlign.end, fontSize: AppFont.font_13)),
          ],
        ),
      ),
    );
  }

  Widget _rowWidget(
      {required String name, required String value, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        children: [
          TextWidget("$name : ", fontSize: AppFont.font_13),
          Expanded(
              child: TextWidget(value,
                  textAlign: TextAlign.end,
                  fontSize: AppFont.font_13,
                  color: color ?? AppColor.black)),
        ],
      ),
    );
  }

  Widget _rowBottomWidget({required String name, required String value}) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget("$name : ", fontSize: AppFont.font_13),
            Expanded(
                child: TextWidget(value,
                    textAlign: TextAlign.end, fontSize: AppFont.font_13)),
          ],
        ),
      ),
    );
  }
}
