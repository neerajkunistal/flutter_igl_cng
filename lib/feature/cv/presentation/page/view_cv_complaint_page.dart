import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cv/domain/bloc/view_cv_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/cv/presentation/widget/view_cv_complaint_item_widget.dart';

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
      body: BlocBuilder<ViewCvComplaintBloc, ViewCvComplaintState>(
        builder: (context, state) {
          if (state is FetchViewCvComplaintDataState) {
            return _listBuilder(dataState: state);
          }
          return const CenterLoaderWidget();
        },
      ),
    );
  }

  Widget _listBuilder({required FetchViewCvComplaintDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(08.0),
      child: dataState.cngList.isNotEmpty
          ? ListView.builder(
          itemCount: dataState.cngList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ViewCvComplaintItemBoxWidget(
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
