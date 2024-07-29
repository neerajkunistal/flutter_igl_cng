import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/commonWidget/search_bar_widget.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/domain/bloc/view_amo_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/presentation/widget/view_amo_complaint_item_box_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/date_range_pop_widget.dart';

class ViewAmoComplaintPage extends StatefulWidget {
  const ViewAmoComplaintPage({super.key});

  @override
  State<ViewAmoComplaintPage> createState() => _ViewAmoComplaintPageState();
}

class _ViewAmoComplaintPageState extends State<ViewAmoComplaintPage> {
  @override
  void initState() {
    BlocProvider.of<ViewAmoComplaintBloc>(!context.mounted ? context : context)
        .add(ViewAmoComplaintPageLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewAmoComplaintBloc, ViewAmoComplaintState>(
      builder: (context, state) {
        if (state is FetchViewAmoComplaintDataState) {
          return Column(
            children: [
              _searchWidget(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white.withOpacity(.4),
                      ),
                      child: state.isFilterLoader == false
                          ? _listBuilder(dataState: state)
                          : const CenterLoaderWidget()),
                ),
              ),
            ],
          );
        }
        return const CenterLoaderWidget();
      },
    );
  }

  Widget _listBuilder({required FetchViewAmoComplaintDataState dataState}) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: dataState.cngList.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: dataState.cngList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ViewAmoComplaintItemBoxWidget(
                    index: index,
                    cngData: dataState.cngList[index],
                  ),
                );
              })
          : const Center(
              child: TextWidget("No Data"),
            ),
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    DateTime startDate = BlocProvider.of<ViewAmoComplaintBloc>(
            !context.mounted ? context : context)
        .startDate;
    DateTime endDate = BlocProvider.of<ViewAmoComplaintBloc>(
            !context.mounted ? context : context)
        .endDate;
    BlocProvider.of<ViewAmoComplaintBloc>(!context.mounted ? context : context)
        .add(ViewAmoComplaintSelectedDateRangeEvent(
            fromDate: startDate,
            toDate: endDate,
            context: !context.mounted ? context : context));
  }

  Widget _searchWidget() {
    return SearchBarWidget(
      onPressed: () async {
        DateTime startDate = BlocProvider.of<ViewAmoComplaintBloc>(
            !context.mounted ? context : context)
            .startDate;
        DateTime endDate = BlocProvider.of<ViewAmoComplaintBloc>(
            !context.mounted ? context : context)
            .endDate;
        var selectedDate = await DateRangeWidget.showDateRange(
            startDate: startDate, endDate: endDate, context: context);
        if (selectedDate != null) {
          BlocProvider.of<ViewAmoComplaintBloc>(
              !context.mounted ? context : context)
              .add(ViewAmoComplaintSelectedDateRangeEvent(
              fromDate: selectedDate.start,
              toDate: selectedDate.end,
              context: !context.mounted ? context : context));
        }
      },
      onChanged: (keyword) {
        BlocProvider.of<ViewAmoComplaintBloc>(context)
            .add(ViewAmoComplaintSearchDataEvent(keyword: keyword));
      },
    );
  }
}
