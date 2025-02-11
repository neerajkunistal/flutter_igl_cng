import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/complaintNumber/domain/bloc/complaint_number_bloc.dart';
import 'package:flutter_igl_cng/feature/complaintNumber/presentation/widget/add_complaint_number_widget.dart';

class AddComplaintNumberPage extends StatelessWidget {
  final String assignType;
  final String complaintId;
  final String vendorComplaintNumber;
  final ValueChanged<String?> onChanged;
  const AddComplaintNumberPage({super.key,
  required this.assignType,
  required this.complaintId,
  required this.vendorComplaintNumber,
  required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComplaintNumberBloc()
        ..add(ComplaintNumberPageLoadEvent(context: context,
            assignType: assignType, complaintId: complaintId,
            vendorComplaintNumber: vendorComplaintNumber)),
      child: BlocBuilder<ComplaintNumberBloc, ComplaintNumberState>(
        builder: (context, state) {
          if (state is FetchComplaintNumberDataState) {
            onChanged.call(state.complaintNumber.isNotEmpty ? state.complaintNumber : "");
            return AddComplaintNumberWidget(dataState: state);
          } else {
            return const Center(child: CenterLoaderWidget());
          }
        },
      ),
    );
  }
}
