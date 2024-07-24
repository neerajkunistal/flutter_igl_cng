import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/domain/bloc/view_amo_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/ci/domain/model/complaint_status.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';

class AmoUpdateStatusWidget extends StatelessWidget {
  final CngModel cngData;

  const AmoUpdateStatusWidget({super.key, required this.cngData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewAmoComplaintBloc, ViewAmoComplaintState>(
      builder: (context, state) {
        if (state is FetchViewAmoComplaintDataState) {
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
      {required FetchViewAmoComplaintDataState dataState,
      required BuildContext context}) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.40,
        width: MediaQuery.of(context).size.width / 1.2,
        child: Card(
          color: AppColor.white,
          margin: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              TextWidget(
                "Update Status",
                fontSize: AppFont.font_14,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              _radioButton(dataState: dataState, context: context),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              _submitButton(dataState: dataState, context: context),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _radioButton({required FetchViewAmoComplaintDataState dataState,
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
              BlocProvider.of<ViewAmoComplaintBloc>(context)
                  .add(ViewAmoComplaintSelectComplaintStatusEvent(complaintStatusData: dataState.complaintStatusList[0]));
            },
          ),
          RadioListTile<String>(
            title:const TextWidget('Reject'),
            value: '2',
            groupValue: dataState.complaintStatusData.id,
            onChanged: (value) {
              BlocProvider.of<ViewAmoComplaintBloc>(context)
                  .add(ViewAmoComplaintSelectComplaintStatusEvent(complaintStatusData: dataState.complaintStatusList[1]));
            },
          ),
        ],
      ),
    );
  }

  Widget _submitButton(
      {required FetchViewAmoComplaintDataState dataState,
      required BuildContext context}) {
    return dataState.isLoader == false
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: ButtonWidget(
                fontSize: AppFont.font_12,
                text: AppString.changeStatus,
                onPressed: () {
                  BlocProvider.of<ViewAmoComplaintBloc>(context).add(
                      ViewAmoComplaintSubmitEvent(
                          context: context, cngData: cngData));
                }),
          )
        : const DottedLoaderWidget();
  }
}
