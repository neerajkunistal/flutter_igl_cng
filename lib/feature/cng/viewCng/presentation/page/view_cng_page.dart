import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/commonWidget/header_widget.dart';
import 'package:flutter_igl_cng/commonWidget/search_bar_widget.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/presentation/pages/add_cng_page.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/bloc/view_cng_bloc.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/presentation/widget/view_cng_item_box_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/date_range_pop_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class ViewCngPage extends StatefulWidget {
  const ViewCngPage({super.key});

  @override
  State<ViewCngPage> createState() => _ViewCngPageState();
}

class _ViewCngPageState extends State<ViewCngPage> {
  @override
  void initState() {
    BlocProvider.of<ViewCngBloc>(!context.mounted ? context : context)
        .add(ViewCngPageLoadEvent());
    super.initState();
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      backgroundColor: AppColor.themeColor,
      onPressed: () async {
        var res = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddCngPage()),
        );
        if (res != null && res.toString() == "complete") {
          if (!context.mounted) return;
          BlocProvider.of<ViewCngBloc>(!context.mounted ? context : context)
              .add(ViewCngPageLoadEvent());
        }
      },
      child: Icon(
        Icons.add,
        color: AppColor.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _floatingActionButton(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Align(
          alignment: Alignment.centerLeft,
          child: TextWidget(
            "View Civil Complaint",
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
      ),
      body: appBackGround(
        context: context,
        child: BlocBuilder<ViewCngBloc, ViewCngState>(
          builder: (context, state) {
            if (state is FetchViewCngDataState) {
              return _listBuilder(dataState: state);
            }
            return const CenterLoaderWidget();
          },
        ),
      ),
    );
  }

  Widget _listBuilder({required FetchViewCngDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
          ),
          const DottedDividerLine(color: Colors.white),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _searchWidget(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Expanded(
            child: dataState.isFilterLoader == false
                ? dataState.cngList.isNotEmpty
                    ? RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: Container(
                          // height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Colors.white.withOpacity(.4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10),
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: dataState.cngList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 8.0,
                                    ),
                                    child: ViewCngItemBoxWidget(
                                      index: index,
                                      cngData: dataState.cngList[index],
                                    ),
                                  );
                                }),
                          ),
                        ),
                      )
                    : Center(
                        child: TextWidget(
                        "No Data",
                        color: AppColor.white,
                      ))
                : const CenterLoaderWidget(),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    DateTime startDate =
        BlocProvider.of<ViewCngBloc>(!context.mounted ? context : context)
            .startDate;
    DateTime endDate =
        BlocProvider.of<ViewCngBloc>(!context.mounted ? context : context)
            .endDate;
    BlocProvider.of<ViewCngBloc>(!context.mounted ? context : context).add(
        ViewCngSelectedDateRangeEvent(
            fromDate: startDate,
            toDate: endDate,
            context: !context.mounted ? context : context));
  }

  Widget _searchWidget() {
    return SearchBarWidget(
      onPressed: () async {
        DateTime startDate = BlocProvider.of<ViewCngBloc>(
            !context.mounted ? context : context)
            .startDate;
        DateTime endDate = BlocProvider.of<ViewCngBloc>(
            !context.mounted ? context : context)
            .endDate;
        var selectedDate = await DateRangeWidget.showDateRange(
            startDate: startDate, endDate: endDate, context: context);
        if (selectedDate != null) {
          BlocProvider.of<ViewCngBloc>(
              !context.mounted ? context : context)
              .add(ViewCngSelectedDateRangeEvent(
              fromDate: selectedDate.start,
              toDate: selectedDate.end,
              context: !context.mounted ? context : context));
        }
      },
      onChanged: (keyword) {
        BlocProvider.of<ViewCngBloc>(context)
            .add(ViewCngSearchEvent(keyword: keyword));
      },
    );
  }
}
