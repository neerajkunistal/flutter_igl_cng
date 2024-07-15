import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
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
    return Scaffold(
      body: appBackGround(
        context: context,
        child: BlocBuilder<ViewAmoComplaintBloc, ViewAmoComplaintState>(
          builder: (context, state) {
            if (state is FetchViewAmoComplaintDataState) {
              return Column(
                children: [
                  _searchWidget(dataState: state),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: Container(
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
        ),
      ),
    );
  }

  Widget _listBuilder({required FetchViewAmoComplaintDataState dataState}) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
      child: dataState.cngList.isNotEmpty
          ? ListView.builder(
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

  Widget _searchWidget({required FetchViewAmoComplaintDataState dataState}) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.08,
        ),
        Expanded(child: _searchController()),
        IconButton(
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
            icon: Icon(
              Icons.calendar_month_outlined,
              color: AppColor.white,
            ))
      ],
    );
  }

  Widget _searchController() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextField(
        onChanged: (keyword) {
          BlocProvider.of<ViewAmoComplaintBloc>(context)
              .add(ViewAmoComplaintSearchDataEvent(keyword: keyword));
        },
        style: TextStyle(
          color: const Color(0xff020202),
          fontSize: AppFont.font_12,
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
          prefixIcon: const Icon(
            Icons.search,
          ),
          prefixIconColor: AppColor.themeColor,
        ),
      ),
    );
  }
}
