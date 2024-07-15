import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cv/domain/bloc/view_cv_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/cv/presentation/widget/view_cv_complaint_item_widget.dart';
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<ViewCvComplaintBloc, ViewCvComplaintState>(
        builder: (context, state) {
          if (state is FetchViewCvComplaintDataState) {
            return Column(
              children: [
                _searchWidget(dataState: state),
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

  Widget _listBuilder({required FetchViewCvComplaintDataState dataState}) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Colors.white.withOpacity(.4),
      ),
      child: dataState.cngList.isNotEmpty
          ? ListView.builder(
              itemCount: dataState.cngList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ViewCvComplaintItemBoxWidget(
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

  Widget _searchWidget({required FetchViewCvComplaintDataState dataState}) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.08,
        ),
        Expanded(child: _searchController()),
        IconButton(
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
          BlocProvider.of<ViewCvComplaintBloc>(context)
              .add(ViewCvComplaintSearchDataEvent(keyword: keyword));
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
