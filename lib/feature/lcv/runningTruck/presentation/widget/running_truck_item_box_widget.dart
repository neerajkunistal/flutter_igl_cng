import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/cngFillingForm/domain/bloc/cng_filling_form_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/cngFillingForm/presentation/page/cng_filling_station_page.dart';

class RunningTruckItemBoxWidget extends StatelessWidget {
  final AssignmentModel assignmentData;
  final int index;

  const RunningTruckItemBoxWidget(
      {super.key, required this.index, required this.assignmentData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.05,
      child: Card(
        color: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextWidget(
                assignmentData.driverName.toString(),
                maxLines: 1,
                fontSize: AppFont.font_16,
                fontWeight: FontWeight.w600,
                color: AppColor.themeColor,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    AppString.vehicleNumber + " : ",
                    maxLines: 2,
                    fontSize: AppFont.font_14,
                    color: AppColor.black,
                  ),
                  TextWidget(
                    assignmentData.vehicleNo.toString(),
                    maxLines: 2,
                    fontSize: AppFont.font_14,
                    color: AppColor.black,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              TextWidget(
                assignmentData.createdAt.toString(),
                fontSize: AppFont.font_14,
                color: AppColor.grey,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              TextWidget(
                "Address : ${assignmentData.motherStationAddress}",
                fontSize: AppFont.font_12,
                color: AppColor.grey,
              ),
              _actionButton(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({required BuildContext context}) {
    return assignmentData.isSelected == false
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              assignmentData.assignmentStatus == AssignmentStatus.complete &&
                      assignmentData.receivedScmQuantity.toString().isEmpty
                  ? TextButton(
                      onPressed: () async {
                        BlocProvider.of<CngFillingFormBloc>(context).add(
                            CngFillingFormSetAssignmentDataEvent(
                                assignmentData: assignmentData));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CngFillingStationPage()),
                        );
                      },
                      child:
                          TextWidget(AppString.complete, color: AppColor.red))
                  : const SizedBox.shrink()
            ],
          )
        : const DottedLoaderWidget();
  }
}
