import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/ci/domain/bloc/view_ci_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/widget/view_ci_complaint_item_box_widget.dart';

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
      body: BlocBuilder<ViewCiComplaintBloc, ViewCiComplaintState>(
        builder: (context, state) {
          if (state is FetchViewCiComplaintDataState) {
            return _listBuilder(dataState: state);
          }
          return const CenterLoaderWidget();
        },
      ),
    );
  }

  Widget _listBuilder({required FetchViewCiComplaintDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(08.0),
      child: dataState.cngList.isNotEmpty
          ? ListView.builder(
          itemCount: dataState.cngList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ViewCiComplaintItemBoxWidget(
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
