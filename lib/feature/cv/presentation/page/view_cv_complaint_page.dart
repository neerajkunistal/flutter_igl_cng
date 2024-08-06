import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/commonWidget/search_bar_widget.dart';
import 'package:flutter_igl_cng/feature/cv/domain/bloc/view_cv_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/cv/presentation/page/view_cv_detail_page.dart';
import 'package:flutter_igl_cng/feature/cv/presentation/widget/cvStation_filter.dart';
import 'package:flutter_igl_cng/feature/cv/presentation/widget/view_cv_complaint_item_widget.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/date_range_pop_widget.dart';

class ViewCvComplaintPage extends StatefulWidget {
  const ViewCvComplaintPage({super.key});

  @override
  State<ViewCvComplaintPage> createState() => _ViewCvComplaintPageState();
}

class _ViewCvComplaintPageState extends State<ViewCvComplaintPage> {
  @override
  void initState() {
    BlocProvider.of<ViewCvComplaintBloc>(!context.mounted ? context : context)
        .add(ViewCvComplaintPageLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewCvComplaintBloc, ViewCvComplaintState>(
      builder: (context, state) {
        if (state is FetchViewCvComplaintDataState) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _searchWidget()),
                  _filterButtonWidget(),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Expanded(
                  child: state.isFilterLoader == false
                      ? RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: _listBuilder(dataState: state))
                      : const CenterLoaderWidget()),
            ],
          );
        }
        return const CenterLoaderWidget();
      },
    );
  }

  Widget _listBuilder({required FetchViewCvComplaintDataState dataState}) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Colors.white.withOpacity(.4),
      ),
      child: dataState.cngList.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: dataState.cngList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: GestureDetector(
                    onTap:  () async {
                      BlocProvider.of<ViewCvComplaintBloc>(context).add(
                          ViewCvComplaintSelectListEvent(listIndex: index));
                      BlocProvider.of<ViewCvComplaintBloc>(context).add(
                          ViewCvComplaintSelectCngDataEvent(cngData: dataState.cngList[index]));
                      var res =  await Navigator.push(
                        !context.mounted ? context : context,
                        FadeRoute(page: const ViewCvDetailPage()),
                      );
                      if (res.toString() == "Complete") {
                        DateTime startDate = BlocProvider.of<ViewCvComplaintBloc>(
                            !context.mounted ? context : context)
                            .startDate;
                        DateTime endDate = BlocProvider.of<ViewCvComplaintBloc>(
                            !context.mounted ? context : context)
                            .endDate;
                        BlocProvider.of<ViewCvComplaintBloc>(!context.mounted ? context : context)
                            .add(ViewCvComplaintSelectedDateRangeEvent(
                            fromDate: startDate,
                            toDate: endDate,
                            context: !context.mounted ? context : context));
                      }
                    },
                    child: ViewCvComplaintItemBoxWidget(
                      index: index,
                      cngData: dataState.cngList[index],
                    ),
                  ),
                );
              })
          : Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.10,
          child: GestureDetector(
              onTap: () async {
                BlocProvider.of<ViewCvComplaintBloc>(!context.mounted ? context : context)
                    .add(ViewCvComplaintPageLoadEvent());
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

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    DateTime startDate = BlocProvider.of<ViewCvComplaintBloc>(
            !context.mounted ? context : context)
        .startDate;
    DateTime endDate = BlocProvider.of<ViewCvComplaintBloc>(
            !context.mounted ? context : context)
        .endDate;
    BlocProvider.of<ViewCvComplaintBloc>(!context.mounted ? context : context)
        .add(ViewCvComplaintSelectedDateRangeEvent(
            fromDate: startDate,
            toDate: endDate,
            context: !context.mounted ? context : context));
  }

  Widget _searchWidget() {
    return SearchBarWidget(
      onPressed: () async {
        DateTime startDate = BlocProvider.of<ViewCvComplaintBloc>(
            !context.mounted ? context : context)
            .startDate;
        DateTime endDate = BlocProvider.of<ViewCvComplaintBloc>(
            !context.mounted ? context : context)
            .endDate;
        var selectedDate = await DateRangeWidget.showDateRange(
            startDate: startDate, endDate: endDate, context: context);
        if (selectedDate != null) {
          BlocProvider.of<ViewCvComplaintBloc>(
              !context.mounted ? context : context)
              .add(ViewCvComplaintSelectedDateRangeEvent(
              fromDate: selectedDate.start,
              toDate: selectedDate.end,
              context: !context.mounted ? context : context));
        }
      },
      onChanged: (keyword) {
        BlocProvider.of<ViewCvComplaintBloc>(context)
            .add(ViewCvComplaintSearchDataEvent(keyword: keyword));
      },
    );
  }

  Widget _filterButtonWidget() {
    return IconButton(
        onPressed: () {
          BlocProvider.of<ViewCvComplaintBloc>(context).add(
              ViewCvComplaintFetchStationEvent(context: context));
          cvModalBottomSheetMenu(context: context);
        }, icon:  Icon(Icons.filter_alt_outlined, color: AppColor.white,));
  }
}
