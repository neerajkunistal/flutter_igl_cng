import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/bloc/add_cng_bloc.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/presentation/pages/add_cng_page.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/bloc/view_cng_bloc.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/presentation/widget/view_cng_item_box_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/date_range_pop_widget.dart';

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
      appBar: AppBar(
        title: TextWidget(
          "View Civil Complaint",
          color: AppColor.white,
          fontSize: AppFont.font_15,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: BlocBuilder<ViewCngBloc, ViewCngState>(
        builder: (context, state) {
          if (state is FetchViewCngDataState) {
            return _listBuilder(dataState: state);
          }
          return const CenterLoaderWidget();
        },
      ),
    );
  }

  Widget _listBuilder({required FetchViewCngDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(08.0),
      child: dataState.cngList.isNotEmpty
          ? ListView.builder(
              itemCount: dataState.cngList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ViewCngItemBoxWidget(
                  index: index,
                  cngData: dataState.cngList[index],
                );
              })
          : const Center(
              child: TextWidget("No Data"),
            ),
    );
  }
}
