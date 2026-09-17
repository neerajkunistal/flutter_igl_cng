import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/commonWidget/search_bar_widget.dart';
import 'package:flutter_igl_cng/feature/marketing/acknowledgeMarketing/domain/bloc/acknowledge_market_bloc.dart';
import 'package:flutter_igl_cng/feature/marketing/acknowledgeMarketing/presentation/widget/acknowledge_market_item_box_widget.dart';
import 'package:flutter_igl_cng/feature/marketing/addAcknowledgeMarket/addAcknowledgeMarketComplaint/domain/bloc/add_acknowledge_market_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/marketing/addAcknowledgeMarket/addAcknowledgeMarketComplaint/presentation/page/add_acknowledge_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/date_range_pop_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/tab_bar_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/tab_item_widget.dart';

class AcknowledgeMarketPage extends StatefulWidget {
  final EquipmentComplaintType equipmentComplaintType;
  const AcknowledgeMarketPage({super.key, required this.equipmentComplaintType});

  @override
  State<AcknowledgeMarketPage> createState() => _AcknowledgeMarketPageState();
}

class _AcknowledgeMarketPageState extends State<AcknowledgeMarketPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  // true only for AMO users -> shows 4 tabs, everyone else keeps 3.
  late final bool _isAmo;

  @override
  void initState() {
    _isAmo = UserInfo.instanceInit()!.userData!.roleType == RoleType.amo;

    // AMO: New, Ack/Assign, Close, Complete (4). Others: New, Ack, Assign (3).
    _tabController = TabController(length: _isAmo ? 4 : 3, vsync: this);

    BlocProvider.of<AcknowledgeMarketBloc>(context)
        .add(AcknowledgeMarketPageLoadEvent(context: context, selectTabIndex:  0,
        equipmentComplaintType: widget.equipmentComplaintType));
    fetchData();
    super.initState();
  }

  void fetchData () async {
    bool flag = true;
    var futureWithTheLoop = () async {
      while (flag){
        await Future.delayed(Duration(minutes: 15));
        _pageRefresh(isTimerCondition: true);
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _searchWidget(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
              color: Colors.white.withOpacity(.4),
            ),
            child: BlocBuilder<AcknowledgeMarketBloc, AcknowledgeMarketState>(
              builder: (context, state) {
                if (state is FetchAcknowledgeMarketDataState) {
                  return RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        _tabWidget(dataState: state),
                        Expanded(child: _itemBuilder(dataState: state)),
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

  Widget _searchWidget() {
    DateTime startDate =  BlocProvider.of<AcknowledgeMarketBloc>(context).startDate;
    DateTime endDate =  BlocProvider.of<AcknowledgeMarketBloc>(context).endDate;
    return SearchBarWidget(
      onPressed: () async {
        var selectedDate = await DateRangeWidget.showDateRange(
            startDate:startDate,
            endDate: endDate,
            context: context);
        if (selectedDate != null) {
          BlocProvider.of<AcknowledgeMarketBloc>(
              !context.mounted ? context : context)
              .add(AcknowledgeMarketSelectDateRangeEvent(
              fromDate: selectedDate.start,
              toDate: selectedDate.end,
              context: !context.mounted ? context : context,
              isTimerCondition: false
          ));
        }
      },
      onChanged: (keyword) {
        BlocProvider.of<AcknowledgeMarketBloc>(context)
            .add(AcknowledgeMarketComplaintSearchEvent(keyword: keyword));
      },
    );
  }

  Future<void> _handleRefresh() async {
    _pageRefresh(isTimerCondition: false);
  }

  Future<void> _pageRefresh({required bool isTimerCondition}) async {
    await Future.delayed(const Duration(seconds: 1));
    DateTime startDate =
        BlocProvider.of<AcknowledgeMarketBloc>(!context.mounted ? context : context)
            .startDate;
    DateTime endDate =
        BlocProvider.of<AcknowledgeMarketBloc>(!context.mounted ? context : context)
            .endDate;
    BlocProvider.of<AcknowledgeMarketBloc>(!context.mounted ? context : context).add(
        AcknowledgeMarketSelectDateRangeEvent(
          fromDate: startDate,
          toDate: endDate,
          context: !context.mounted ? context : context,
          isTimerCondition: isTimerCondition,
        ));
  }

  Widget _tabWidget({required FetchAcknowledgeMarketDataState dataState}) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TabBarWidget(
        controller: _tabController,
        onTap: (index) {
          print("=== TAB CLICKED: index = $index ==="); // <-- YAHAN
            BlocProvider.of<AcknowledgeMarketBloc>(context).add(AcknowledgeMarketComplaintSelectedMarketTabIndexEvent(
                selectedTabMarketIndex: index));
            },
        tabs: [
          TabItemWidget(title: "New", count: dataState.complaintCount[0]),
          TabItemWidget(title: "Ack/Assign", count: dataState.complaintCount[1]),
          TabItemWidget(title: "Close", count: dataState.complaintCount[2]),
          TabItemWidget(title: "Complete", count: dataState.complaintCount[3]),
        ],
      ),
    );
  }

  Widget _itemBuilder({required FetchAcknowledgeMarketDataState dataState}) {
    final list = dataState.listOfComplaintData;
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: list.isNotEmpty
          ? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: list.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                print("----complaintStatus  ${dataState.listOfComplaintData[index].complaintStatus}");
                if (dataState.listOfComplaintData[index].complaintStatus.toString() != "2") {
                  BlocProvider.of<AddAcknowledgeMarketComplaintBloc>(context).add(
                      AddAcknowledgeMarketComplaintPageLoadEvent(
                          context: context,
                          acknowledgeData:
                          dataState.listOfComplaintData[index],
                          equipmentComplaintType: widget.equipmentComplaintType,
                        selectedTabIndex: dataState.selectTabIndex,
                      ));

                  final result = await Navigator.push(
                    context,
                    FadeRoute(page:  AddAcknowledgeMarketPage(
                      equipmentComplaintType: widget.equipmentComplaintType,
                      selectTabIndex: dataState.selectTabIndex,
                    )),
                  );
                  if (!context.mounted) return;
                  if (result.toString() == "Completed") {
                    BlocProvider.of<AcknowledgeBloc>(context)
                        .add(AcknowledgePageLoadEvent(context: context,
                        selectTabIndex : dataState.selectTabIndex,
                        equipmentComplaintType: widget.equipmentComplaintType));
                  }
                }
              },
              child: AcknowledgeMarketItemBoxWidget(
                index: index,
                acknowledgeData: list[index],
                equipmentComplaintType: widget.equipmentComplaintType,
              ),
            );
          })
          : Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.10,
          child: GestureDetector(
              onTap: () async {
                BlocProvider.of<AcknowledgeMarketBloc>(
                    !context.mounted ? context : context)
                    .add(AcknowledgeMarketSelectDateRangeEvent(
                    fromDate: dataState.startDate,
                    toDate: dataState.endDate,
                    context: !context.mounted ? context : context,
                    isTimerCondition: false));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh,
                    color: AppColor.white,
                  ),
                  TextWidget(
                    "No Data\nTab to refresh",
                    color: AppColor.white,
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}