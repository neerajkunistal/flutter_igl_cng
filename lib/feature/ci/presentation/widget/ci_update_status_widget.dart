import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class CiUpdateStatusWidget extends StatelessWidget {
  final CngModel cngData;

  const CiUpdateStatusWidget({super.key, required this.cngData});

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
    return dataState.isVendorListLoader == false
        ? Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextWidget(
                  "Estimate",
                  fontSize: AppFont.font_14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              _radioButton(dataState: dataState, context: context),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),

               dataState.complaintStatusData.id == "1"
                  ? _amountRemarkController(
                  dataState: dataState, context: context)
                  : const SizedBox.shrink(),

               dataState.complaintStatusData.id == "1"
                  ? SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ) : const SizedBox.shrink(),

              dataState.complaintStatusData.id == "2"
                  ||  dataState.complaintStatusData.id == "1"
                  ? _estimateRemarkController(
                      dataState: dataState, context: context)
                  : const SizedBox.shrink(),
              dataState.complaintStatusData.id == "2"
                  ||  dataState.complaintStatusData.id == "1"
                  ? SizedBox(
                      height: MediaQuery.of(context).size.width * 0.04,
                    )
                  : const SizedBox.shrink(),

              _submitButton(dataState: dataState, context: context),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
            ],
          )
        : _centerLoader();
  }

  Widget _radioButton(
      {required FetchViewCiComplaintDataState dataState,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          RadioListTile<String>(
            title: const TextWidget('Approve'),
            value: '1',
            groupValue: dataState.complaintStatusData.id,
            onChanged: (value) {
/*              BlocProvider.of<ViewCiComplaintBloc>(context).add(
                  ViewCiComplaintStatusDataEvent(
                      complaintStatusData: dataState.complaintStatusList[0]));*/
            },
          ),
          RadioListTile<String>(
            title: const TextWidget('Change'),
            value: '2',
            groupValue: dataState.complaintStatusData.id,
            onChanged: (value) {
/*              BlocProvider.of<ViewCiComplaintBloc>(context).add(
                  ViewCiComplaintStatusDataEvent(
                      complaintStatusData: dataState.complaintStatusList[1]));*/
            },
          ),
        ],
      ),
    );
  }

  Widget _amountRemarkController(
      {required FetchViewCiComplaintDataState dataState,
        required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: TextFieldWidget(
        controller: dataState.amountRemarkController,
        labelText: AppString.estimateAmount,
      ),
    );
  }

  Widget _estimateRemarkController(
      {required FetchViewCiComplaintDataState dataState,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: TextFieldWidget(
        controller: dataState.estimateRemarkController,
        labelText: AppString.remark,
      ),
    );
  }



  Widget _submitButton(
      {required FetchViewCiComplaintDataState dataState,
      required BuildContext context}) {
    return dataState.isVendorAssignLoader == false
        ? ButtonWidget(
        fontSize: AppFont.font_12,
        text: AppString.provisionallyApproved,
        onPressed: () {
          BlocProvider.of<ViewCiComplaintBloc>(context).add(
              ViewCiComplaintEstimateApproveEvent(
                  context: context, cngData: cngData));
        })
        : const DottedLoaderWidget();
  }
}
