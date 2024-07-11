import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/ci/domain/bloc/view_ci_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/ci/domain/model/complaint_status.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';

class CiFinalApproveWidget extends StatelessWidget {
  final CngModel cngData;
  const CiFinalApproveWidget({super.key, required this.cngData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewCiComplaintBloc, ViewCiComplaintState>(
      builder: (context, state) {
        if (state is FetchViewCiComplaintDataState) {
          return _itemBuilder(dataState: state, context: context);
        } else {
          return _centerLoader();
        }
      },
    );
  }

  Widget _centerLoader() {
    return const Center(child: CenterLoaderWidget());
  }

  Widget _itemBuilder(
      {required FetchViewCiComplaintDataState dataState,
        required BuildContext context}) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width / 1.2,
        child: Card(
          color: AppColor.white,
          margin: const EdgeInsets.all(10.0),
          child: dataState.isVendorListLoader == false ?
          Column(children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.04,),
            TextWidget("Estimate Approve", fontSize: AppFont.font_14, fontWeight: FontWeight.w700,),
            SizedBox(height: MediaQuery.of(context).size.width * 0.04,),
            _complaintStatusDropDown(dataState: dataState, context: context),
            SizedBox(height: MediaQuery.of(context).size.width * 0.04,),
            _remarkController(dataState: dataState, context: context),
            SizedBox(height: MediaQuery.of(context).size.width * 0.04,),
            _submitButton(dataState: dataState, context: context),
            SizedBox(height: MediaQuery.of(context).size.width * 0.04,),
          ],) : _centerLoader(),
        ),
      ),
    );
  }

  Widget _complaintStatusDropDown({required FetchViewCiComplaintDataState dataState, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: DropdownWidget(
        hint: AppString.selectComplaint,
        dropdownValue:
        dataState.complaintStatusData.id != null ? dataState.complaintStatusData : null,
        onChanged: (value) {
          BlocProvider.of<ViewCiComplaintBloc>(context)
              .add(ViewCiComplaintStatusDataEvent(complaintStatusData: value));
        },
        items: dataState.complaintStatusList.map<DropdownMenuItem<ComplaintStatus>>(
                (ComplaintStatus complaintStatusData) {
              return DropdownMenuItem<ComplaintStatus>(
                value: complaintStatusData,
                child: TextWidget(complaintStatusData.status.toString()),
              );
            }).toList(),
      ),
    );
  }

  Widget _remarkController({required FetchViewCiComplaintDataState dataState,
    required BuildContext context}) {
    return TextFieldWidget(
        controller: dataState.remarkController,
        labelText: AppString.remark);
  }

  Widget _submitButton({required FetchViewCiComplaintDataState dataState,
    required BuildContext context}) {
    return dataState.isVendorAssignLoader == false  ?
    SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: ButtonWidget(
          fontSize: AppFont.font_12,
          text: AppString.changeStatus,
          onPressed: () {

          }),
    ):const DottedLoaderWidget();
  }
}
