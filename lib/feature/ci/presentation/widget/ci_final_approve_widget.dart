import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

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
    return dataState.isVendorListLoader == false
        ? Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.04,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextWidget(
            "Approve Task",
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.04,
        ),
        _radioButton(
            dataState: dataState, context: context),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.04,
        ),
        dataState.complaintStatusData.id.toString() == "1" ?
        _dateController(dataState: dataState, context: context)
            : const SizedBox.shrink(),

        dataState.complaintStatusData.id.toString() == "1" ?
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.04,
        ) : const SizedBox.shrink(),

        _remarkController(dataState: dataState, context: context),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.04,
        ),
        _submitButton(dataState: dataState, context: context),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.04,
        ),
      ],
    )
        : _centerLoader();
  }

  Widget _radioButton({required FetchViewCiComplaintDataState dataState,
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
              BlocProvider.of<ViewCiComplaintBloc>(context)
                  .add(ViewCiComplaintStatusDataEvent(complaintStatusData: dataState.complaintStatusList[0]));
            },
          ),
          RadioListTile<String>(
            title:const TextWidget('Change'),
            value: '2',
            groupValue: dataState.complaintStatusData.id,
            onChanged: (value) {
              BlocProvider.of<ViewCiComplaintBloc>(context)
                  .add(ViewCiComplaintStatusDataEvent(complaintStatusData: dataState.complaintStatusList[1]));
            },
          ),
        ],
      ),
    );
  }

  Widget _dateController(
      {required FetchViewCiComplaintDataState dataState,
        required BuildContext context}) {
        DateTime estimateDateTime = DateTime.now();
        if (cngData.estimateCostDataTime != null &&
            cngData.estimateCostDataTime.toString().isNotEmpty) {
          String dateTime = DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(cngData.estimateCostDataTime.toString()));
          estimateDateTime =  DateTime.parse(dateTime);
        }
    DateTime date = DateTime(estimateDateTime.year, estimateDateTime.month, estimateDateTime.day);

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextFieldWidget(
         enabled: false,
          controller: dataState.toDateController,
          labelText: AppString.date,
          onTap: () => showCupertinoDatePickerWidgetDialog(
           context: context,
           child : CupertinoDatePickerWidget(
             minimumDate: date,
             initialDateTime: dataState.finalDate,
             onDateTimeChanged: (DateTime newDate) async {
               BlocProvider.of<ViewCiComplaintBloc>(context).add(
                   ViewCiComplaintFinalApproveDateEvent(date: newDate));
             },
           ),
         ),
      ),
    );
  }

  Widget _remarkController(
      {required FetchViewCiComplaintDataState dataState,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextFieldWidget(
          controller: dataState.remarkController, labelText: AppString.remark),
    );
  }

  Widget _submitButton(
      {required FetchViewCiComplaintDataState dataState,
      required BuildContext context}) {
    return dataState.isVendorAssignLoader == false
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: ButtonWidget(
                fontSize: AppFont.font_12,
                text: "Submit",
                onPressed: () {
                  BlocProvider.of<ViewCiComplaintBloc>(context).add(
                      ViewCiComplaintFinalApproveEvent(cngData: cngData, context: context));
                }),
          ) : const DottedLoaderWidget();
  }
}
