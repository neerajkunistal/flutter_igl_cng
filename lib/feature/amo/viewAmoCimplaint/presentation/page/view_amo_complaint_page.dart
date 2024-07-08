import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/domain/bloc/view_amo_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/presentation/widget/view_amo_complaint_item_box_widget.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/presentation/pages/add_cng_page.dart';

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
      body: BlocBuilder<ViewAmoComplaintBloc, ViewAmoComplaintState>(
        builder: (context, state) {
          if (state is FetchViewAmoComplaintDataState) {
            return _listBuilder(dataState: state);
          }
          return const CenterLoaderWidget();
        },
      ),
    );
  }

  Widget _listBuilder({required FetchViewAmoComplaintDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(08.0),
      child: dataState.cngList.isNotEmpty
          ? ListView.builder(
          itemCount: dataState.cngList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ViewAmoComplaintItemBoxWidget(
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
