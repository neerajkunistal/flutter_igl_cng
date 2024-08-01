import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/commonWidget/search_bar_widget.dart';
import 'package:flutter_igl_cng/feature/ci/domain/bloc/view_ci_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/widget/view_ci_complaint_item_box_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/date_range_pop_widget.dart';

class ViewCiComplaintPage extends StatefulWidget {
  const ViewCiComplaintPage({super.key});

  @override
  State<ViewCiComplaintPage> createState() => _ViewCiComplaintPageState();
}

class _ViewCiComplaintPageState extends State<ViewCiComplaintPage> {
  @override
  void initState() {
    BlocProvider.of<ViewCiComplaintBloc>(!context.mounted ? context : context)
        .add(ViewCiComplaintPageLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<ViewCiComplaintBloc, ViewCiComplaintState>(
        builder: (context, state) {
          if (state is FetchViewCiComplaintDataState) {
            return Column(
              children: [
                _searchWidget(),
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
      ),
    );
  }

  Widget _listBuilder({required FetchViewCiComplaintDataState dataState}) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
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
                  child: ViewCiComplaintItemBoxWidget(
                    index: index,
                    cngData: dataState.cngList[index],
                  ),
                );
              }) : Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.10,
          child: GestureDetector(
              onTap: () async {
                BlocProvider.of<ViewCiComplaintBloc>(!context.mounted ? context : context)
                    .add(ViewCiComplaintPageLoadEvent());
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
    DateTime startDate = BlocProvider.of<ViewCiComplaintBloc>(
            !context.mounted ? context : context)
        .startDate;
    DateTime endDate = BlocProvider.of<ViewCiComplaintBloc>(
            !context.mounted ? context : context)
        .endDate;
    BlocProvider.of<ViewCiComplaintBloc>(!context.mounted ? context : context)
        .add(ViewCiComplaintSelectedDateRangeEvent(
            fromDate: startDate,
            toDate: endDate,
            context: !context.mounted ? context : context));
  }

  Widget _searchWidget() {
    return SearchBarWidget(
      onPressed: () async {
        DateTime startDate = BlocProvider.of<ViewCiComplaintBloc>(
            !context.mounted ? context : context)
            .startDate;
        DateTime endDate = BlocProvider.of<ViewCiComplaintBloc>(
            !context.mounted ? context : context)
            .endDate;
        var selectedDate = await DateRangeWidget.showDateRange(
            startDate: startDate, endDate: endDate, context: context);
        if (selectedDate != null) {
          BlocProvider.of<ViewCiComplaintBloc>(
              !context.mounted ? context : context)
              .add(ViewCiComplaintSelectedDateRangeEvent(
              fromDate: selectedDate.start,
              toDate: selectedDate.end,
              context: !context.mounted ? context : context));
        }
      },
      onChanged: (keyword) {
        BlocProvider.of<ViewCiComplaintBloc>(context)
            .add(ViewCiComplaintSearchDataEvent(keyword: keyword));
      },
    );
  }
}
