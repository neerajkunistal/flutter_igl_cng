import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/bloc/add_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/presntation/widget/change_statu_pop_widget.dart';
import 'package:flutter_igl_cng/feature/lcv/cngFillingForm/domain/bloc/cng_filling_form_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/cngFillingForm/presentation/page/cng_filling_station_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';
import 'package:flutter_igl_cng/utils/res/app_color.dart';

class ViewAssignmentItemBoxWidget extends StatelessWidget {
  final int index;
  final AssignmentModel assignmentData;

  ViewAssignmentItemBoxWidget(
      {super.key, required this.index, required this.assignmentData});

  final LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      child: Card(
        shadowColor: AppColor.themeLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
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
        ),
      ),
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
        _changeStatus(assignmentStatus: assignmentStatus, assignmentData: assignmentData,
            context: context)
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

  Widget _changeStatus(
      {required AssignmentStatus assignmentStatus,
        required AssignmentModel assignmentData,
      required BuildContext context}) {
    return userData.roleType == RoleType.driver
        ? const SizedBox.shrink()
        : ButtonWidget(
            height: MediaQuery.of(context).size.height * 0.04,
            fontSize: AppFont.font_12,
            backgroundColor: assignmentData.fillEndTime.toString().isEmpty
                && userData.roleType == RoleType.lcvManager
                ? AppColor.orange
                : assignmentData.fillEndTime.toString().isEmpty
                && userData.roleType == RoleType.lcvManager
                ? AppColor.themeSecondary
                : AppColor.red,
            text: assignmentData.fillEndTime.toString().isEmpty
                && userData.roleType == RoleType.lcvManager
                ? "Update"
                : assignmentData.fillEndTime.toString().isNotEmpty
                && userData.roleType == RoleType.cngStation ?
                "Update"
                : "Cancel",
            onPressed: () {
              if (assignmentData.fillEndTime.toString().isEmpty
                  && userData.roleType == RoleType.lcvManager) {
                BlocProvider.of<AddAssignmentBloc>(context)
                    .add(AddAssignmentSetAssignmentDataEvent(assignmentData: assignmentData));
                BlocProvider.of<HomeBloc>(context).add(
                    HomeChangeBottomNavigationItemEvent(
                        index: 1, context: context));
              }
              else  if (assignmentData.fillEndTime.toString().isNotEmpty
                  && userData.roleType == RoleType.cngStation) {
                BlocProvider.of<CngFillingFormBloc>(context).add(
                    CngFillingFormSetAssignmentDataEvent(
                        assignmentData: assignmentData));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CngFillingStationPage()),
                );
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        ChangeStatusPopWidget(index: index));
              }
            });
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
}
