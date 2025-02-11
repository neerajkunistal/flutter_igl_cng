import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/bloc/acknowledge_bloc.dart';
import 'package:flutter_igl_cng/feature/complaintNumber/domain/bloc/complaint_number_bloc.dart';

class AddComplaintNumberWidget extends StatelessWidget {
  final FetchComplaintNumberDataState dataState;

  const AddComplaintNumberWidget({super.key, required this.dataState});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        children: [
          _complaintNumberController(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
           _submitButton(context: context)
        ],
      ),
    );
  }

  Widget _complaintNumberController() {
    return Expanded(
      child: TextFieldWidget(
        isRequired: true,
        labelText: "Complaint Number",
        controller: dataState.complaintNumberController,
      ),
    );
  }

  Widget _submitButton({required BuildContext context}) {
    return dataState.isLoader == false
        ? SizedBox(
          child: dataState.complaintNumberController.text.toString().isNotEmpty
           && dataState.complaintNumberController.text.toString() != dataState.vendorComplaintNumber.toString()
        ? ButtonWidget(
              text: AppString.add,
              onPressed: () {
                BlocProvider.of<ComplaintNumberBloc>(context)
                    .add(ComplaintNumberSubmitEvent(context: context));
              }) : const SizedBox.shrink(),
        ): const DottedLoaderWidget();
  }
}
