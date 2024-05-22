import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/date_range_pop_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AcknowledgePage extends StatefulWidget {
  const AcknowledgePage({super.key});

  @override
  State<AcknowledgePage> createState() => _AcknowledgePageState();
}

class _AcknowledgePageState extends State<AcknowledgePage> {
  @override
  void initState() {
    BlocProvider.of<AcknowledgeBloc>(context)
        .add(AcknowledgePageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColor.white,
        title: Row(
          children: [
            Expanded(child: _searchController()),
            IconButton(onPressed: () {
              showDialog(
                  context: context,
                  builder: (mContext) {
                    return  DateRangePopWidget(
                      onSubmit: (value) {
                        Navigator.pop(context);
                        PickerDateRange? date = value as PickerDateRange?;
                        if(date != null){
                          BlocProvider.of<AcknowledgeBloc>(context)
                              .add(AcknowledgeSelectDateRangeEvent(
                              fromDate: date.startDate!,
                              toDate: date.endDate!,
                              context: context));
                        }
                      },
                    );
                  });
            }, icon:  Icon(Icons.filter_alt_outlined, color: AppColor.white,))
          ],
        ),
      ),
      body: BlocBuilder<AcknowledgeBloc, AcknowledgeState>(
        builder: (context, state) {
          if (state is FetchAcknowledgeDataState) {
            return RefreshIndicator(
              onRefresh: _handleRefresh,
              child: Column(
                children: [
                  _tabWidget(dataState: state),
                  Expanded (child: _itemBuilder(dataState: state)),
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
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    DateTime startDate = BlocProvider.of<AcknowledgeBloc>(!context.mounted ? context : context).startDate;
    DateTime endDate = BlocProvider.of<AcknowledgeBloc>(!context.mounted ? context : context).endDate;
    BlocProvider.of<AcknowledgeBloc>(!context.mounted ? context : context)
        .add(AcknowledgeSelectDateRangeEvent(
        fromDate: startDate,
        toDate: endDate,
        context: !context.mounted ? context : context));
  }
  
  Widget _searchController() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.13,
      child: TextField(
        onChanged: (keyword) {
          BlocProvider.of<AcknowledgeBloc>(context)
               .add(AcknowledgeComplaintSearchEvent(keyword: keyword));
        },
        style: TextStyle(
          color: const Color(0xff020202),
          fontSize:  AppFont.font_12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xfff1f1f1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          hintText: "Search...",
          hintStyle: TextStyle(
              color: const Color(0xffb2b2b2),
              fontSize: AppFont.font_12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              decorationThickness: 6),
          prefixIcon: const Icon(Icons.search, ),
          prefixIconColor: AppColor.themeColor,
        ),
      ),
    );
  }

  Widget _tabWidget({required FetchAcknowledgeDataState dataState}) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.10,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.themeNormalLightColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextButton(
                style: dataState.selectTabIndex == 0 ?
                ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColor.themeColor ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side:  BorderSide(color: AppColor.themeColor )
                        )
                    )
                ) : null,
                onPressed: () {
                  BlocProvider.of<AcknowledgeBloc>(context)
                      .add(const AcknowledgeComplaintSelectedTabIndexEvent(selectedTabIndex: 0));
                }, child:  TextWidget(
              "New-${dataState.complaintCount[0]}",
              color: dataState.selectTabIndex == 0 ? AppColor.white : AppColor.black,
              fontWeight: dataState.selectTabIndex == 0
                  ? FontWeight.w700
                  : FontWeight.w400,
              fontSize: AppFont.font_11,)),
          ),

          Expanded(
            child: TextButton(
                style: dataState.selectTabIndex == 1 ?
                ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                       AppColor.themeColor ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side:  BorderSide(color: AppColor.themeColor )
                        )
                    )
                ) : null,
                onPressed: () {
                  BlocProvider.of<AcknowledgeBloc>(context)
                      .add(const AcknowledgeComplaintSelectedTabIndexEvent(selectedTabIndex: 1));
                }, child:  TextWidget(
              "Ack-${dataState.complaintCount[1]}",
              color: dataState.selectTabIndex == 1 ? AppColor.white : AppColor.black,
              fontWeight: dataState.selectTabIndex == 1
                  ? FontWeight.w700
                  : FontWeight.w400,
              fontSize: AppFont.font_11,)),
          ),

          Expanded(
            child: TextButton(
                style: dataState.selectTabIndex == 2 ?
                ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColor.themeColor ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side:  BorderSide(color: AppColor.themeColor )
                        )
                    )
                ) : null,
                onPressed: () {
                  BlocProvider.of<AcknowledgeBloc>(context)
                      .add(const AcknowledgeComplaintSelectedTabIndexEvent(selectedTabIndex: 2));
                }, child:  TextWidget(
              "Assign-${dataState.complaintCount[2]}",
              color: dataState.selectTabIndex == 2
                  ? AppColor.white
                  : AppColor.black,
              fontWeight: dataState.selectTabIndex == 2
                  ? FontWeight.w700
                  : FontWeight.w400,
              fontSize: AppFont.font_11,)),
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder({required FetchAcknowledgeDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: dataState.acknowledgeList.isNotEmpty
          ? ListView.builder(
              itemCount: dataState.acknowledgeList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    if (dataState.acknowledgeList[index].complaintStatus
                            .toString() !=
                        "2") {
                      BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
                          AddAcknowledgeComplaintPageLoadEvent(
                              context: context,
                              acknowledgeData:
                                  dataState.acknowledgeList[index]));
                      final result = await Navigator.push(
                        context,
                        FadeRoute(page: const AddAcknowledgePage()),
                      );
                      if (!context.mounted) return;
                      if (result.toString() == "Completed") {
                        BlocProvider.of<AcknowledgeBloc>(context)
                            .add(AcknowledgePageLoadEvent(context: context));
                      }
                    }
                  },
                  child: AcknowledgeItemBoxWidget(
                    index: index,
                    acknowledgeData: dataState.acknowledgeList[index],
                  ),
                );
              })
          : Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.10,
          child: GestureDetector(
              onTap: () async {
                BlocProvider.of<AcknowledgeBloc>(!context.mounted ? context : context)
                    .add(AcknowledgeSelectDateRangeEvent(
                    fromDate: dataState.startDate,
                    toDate:  dataState.endDate,
                    context: !context.mounted ? context : context));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, color: AppColor.grey,),
                  const TextWidget("No Data\nTab to refresh",
                    textAlign: TextAlign.center,),
                ],
              )),
        ),
      ),
    );
  }
}
