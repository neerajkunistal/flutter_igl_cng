import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/bloc/view_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/text_widget.dart';
import 'package:flutter_igl_cng/utils/res/app_color.dart';

class ViewAssignmentDetailPage extends StatefulWidget {
  const ViewAssignmentDetailPage({super.key});

  @override
  State<ViewAssignmentDetailPage> createState() => _ViewAssignmentDetailPageState();
}

class _ViewAssignmentDetailPageState extends State<ViewAssignmentDetailPage> {

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          "Assignment Details",
          color: AppColor.white,
          fontSize: AppFont.font_15,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Image.asset(
          AppConfig.instanceInit()!.client == Client.iglcng
              ? AppIcon.appLogoIgl
              : AppIcon.appLogoIgl,
          height: MediaQuery.of(context).size.width * 0.13,
          width: MediaQuery.of(context).size.width * 0.13,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: appBackGround(
         context: context,
         child: Column(
           children: [
             _appBar(),
             const DottedDividerLine(color: Colors.white),
             SizedBox(
               height: MediaQuery.of(context).size.height * 0.02,
             ),
             Expanded(
                 child:  BlocBuilder<ViewAssignmentBloc,  ViewAssignmentState>(
                   builder: (context, state) {
                     if (state is FetchViewAssignmentDataState) {
                       return Container(
                           decoration: const BoxDecoration(
                             borderRadius: BorderRadius.only(
                                 topLeft: Radius.circular(20),
                                 topRight: Radius.circular(20)),
                             color: Colors.white,
                           ),
                           child: SingleChildScrollView(
                               child: _itemBuilder(dataState: state)));
                     } else {
                       return const Center(
                         child: CenterLoaderWidget(),
                       );
                     }
                   },
                 ),
             ),
           ],
         )
       ),
    );
  }

  Widget _itemBuilder({required FetchViewAssignmentDataState dataState}) {
    AssignmentModel assignmentData =  dataState.assignmentData;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _driverName(driverName: assignmentData.driverName.toString()),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.01,
          ),
          _vehicleNumber(
              vehicleNumber: assignmentData.lcvNumber.toString()),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.01,
          ),
          DottedDividerLine(color: AppColor.grey,),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          _fromStation(
              fromStationName: assignmentData.mbStationName.toString()),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          _toStation(toStationName: assignmentData.dbStationName.toString()),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          _status(
              assignmentStatus: assignmentData.assignmentStatus!,
              assignmentStatusColor:
              assignmentData.assignmentStatusColor!,
              assignmentData: assignmentData,
              context: context
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.01,
          ),
          DottedDividerLine(color: AppColor.grey,),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          _createDateTime(deliveryDate: assignmentData.createdAt.toString()),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          _lastUpdate(
              startDateTime: assignmentData.updatedAt.toString()),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          DottedDividerLine(color: AppColor.grey,),
          _verticalSpace(),
          _rowWidget(label: "Lcv Entry Time", value: assignmentData.lcvEntryTime.toString()),
          _verticalSpace(),
          _rowWidget(label: "Fill Start Time", value: assignmentData.fillStartTime.toString()),
          _verticalSpace(),
          _rowWidget(label: AppString.flowMeterReadingOpen, value: assignmentData.flowMeterReadingOpening.toString()),
          _verticalSpace(),
          _rowWidget(label: AppString.flowMeterReadingClosed, value: assignmentData.flowMeterReadingClosing.toString()),
          _verticalSpace(),
          _rowWidget(label: AppString.fillEndTime, value: assignmentData.fillEndTime.toString()),
          _verticalSpace(),
          _rowWidget(label: AppString.outPressure, value: assignmentData.outPressure.toString()),
          _verticalSpace(),
          _rowWidget(label: AppString.unscheduledMaintenancePenaltyHours, value: assignmentData.unscheduledMaintenancePenaltyHours.toString()),
          _verticalSpace(),
          _rowWidget(label: AppString.scheduledMaintenancePenaltyHours, value: assignmentData.scheduledMaintenancePenaltyHours.toString()),
          _verticalSpace(),
          DottedDividerLine(color: AppColor.grey,),
          _verticalSpace(),
          assignmentData.motherStationAttachments!.isNotEmpty ?
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.15,
            child: ListView.builder(
                itemCount: assignmentData.motherStationAttachments!.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return  _images(pictureUrl: assignmentData.motherStationAttachments![index].toString(),
                      context: context);
                }),
          ) : const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _rowWidget({required String label,required String value}) {
    return Row(
      children: [
        TextWidget("$label : ",
            color: AppColor.black,
            fontSize: AppFont.font_13,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(value,
              color: AppColor.black,
              textAlign: TextAlign.start,
              fontSize: AppFont.font_13,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _driverName({required String driverName}) {
    return Row(
      children: [
        TextWidget("Driver Name : ",
            color: AppColor.themeColor,
            fontSize: AppFont.font_13,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(driverName,
              color: AppColor.black,
              fontSize: AppFont.font_13,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _vehicleNumber({required String vehicleNumber}) {
    return Row(
      children: [
        TextWidget("Vehicle No. : ",
            color: AppColor.grey,
            fontSize: AppFont.font_12,
            fontWeight: FontWeight.w500),
        Expanded(
          child: TextWidget(vehicleNumber,
              color: AppColor.grey,
              fontSize: AppFont.font_12,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _fromStation({required String fromStationName}) {
    return Row(
      children: [
        TextWidget("From : ",
            color: AppColor.themeColor,
            fontSize: AppFont.font_12,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(fromStationName,
              color: AppColor.black,
              fontSize: AppFont.font_12,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _toStation({required String toStationName}) {
    return Row(
      children: [
        TextWidget("To : ",
            color: AppColor.themeColor,
            fontSize: AppFont.font_12,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(toStationName,
              color: AppColor.black,
              fontSize: AppFont.font_12,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _receivedScm({required String receivedScm}) {
    return Row(
      children: [
        TextWidget("Received Scm: ",
            color: AppColor.themeColor,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(receivedScm,
              color: AppColor.black,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _currentScm({required String currentScm}) {
    return Row(
      children: [
        TextWidget("Current Scm : ",
            color: AppColor.themeColor,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(currentScm,
              color: AppColor.black,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _cngStationAddress({required String cngStationAddress}) {
    return Row(
      children: [
        TextWidget("Address : ",
            color: AppColor.grey,
            fontSize: AppFont.font_12,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(cngStationAddress,
              color: AppColor.grey,
              fontSize: AppFont.font_12,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _status(
      {required AssignmentStatus assignmentStatus,
        required Color assignmentStatusColor,
        required AssignmentModel assignmentData,
        required BuildContext context}) {
    return Row(
      children: [
        TextWidget("Status : ",
            color: AppColor.themeColor,
            fontSize: AppFont.font_12,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(
              assignmentStatus == AssignmentStatus.pending
                  ? "Pending"
                  : assignmentStatus == AssignmentStatus.confirm
                  ? "Confirm"
                  : assignmentStatus == AssignmentStatus.startRoute
                  ? "Start Route"
                  : assignmentStatus == AssignmentStatus.complete
                  ? "Complete"
                  : assignmentStatus == AssignmentStatus.cancel
                  ? "Cancel"
                  : "Pending",
              color: assignmentStatusColor,
              fontSize: AppFont.font_12,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _createDateTime({required String deliveryDate}) {
    String dateTime = "";
    if (deliveryDate.isNotEmpty) {
      dateTime = DateFormat('dd-MMM-yyyy HH:MM')
          .format(DateTime.parse(deliveryDate.toString()));
    }
    return Row(
      children: [
        TextWidget("Created DateTime : ",
            color: AppColor.themeColor,
            fontSize: AppFont.font_12,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(dateTime,
              color: AppColor.black,
              fontSize: AppFont.font_12,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _lastUpdate({required String startDateTime}) {
    String dateTime = "";
    if (startDateTime.isNotEmpty) {
      dateTime = DateFormat('dd-MMM-yyyy HH:MM')
          .format(DateTime.parse(startDateTime.toString()));
    }
    return Row(
      children: [
        TextWidget("Last Update : ",
            color: AppColor.themeColor,
            fontSize: AppFont.font_12,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(dateTime,
              color: AppColor.black,
              fontSize: AppFont.font_12,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _delayTime({required String delay}) {
    return Row(
      children: [
        TextWidget("Delay : ",
            color: AppColor.black,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(delay,
              color: AppColor.red,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _images({required String pictureUrl, required BuildContext context}) {
    return pictureUrl.isNotEmpty
        ? SizedBox.fromSize(
      size: Size.fromRadius(MediaQuery.of(context).size.width * 0.08),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width / 0.6,
                child: Image.network(
                  pictureUrl,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes !=
                            null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, exception, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ));
        },
        child: CircleAvatar(
          backgroundColor: AppColor.white,
          radius: MediaQuery.of(context).size.width * 0.15,
          child: Image.network(
            pictureUrl,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, exception, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    )
        : const SizedBox.shrink();
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.02,
    );
  }

}
