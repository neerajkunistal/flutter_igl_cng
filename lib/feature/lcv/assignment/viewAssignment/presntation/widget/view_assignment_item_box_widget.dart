import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/presntation/widget/change_statu_pop_widget.dart';
import 'package:flutter_igl_cng/feature/lcv/cngFillingForm/domain/bloc/cng_filling_form_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/cngFillingForm/presentation/page/cng_filling_station_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

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
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
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
                  vehicleNumber: assignmentData.vehicleNo.toString()),
              const Divider(),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              _fromStation(
                  fromStationName: assignmentData.motherStation.toString()),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              _toStation(toStationName: assignmentData.cngStation.toString()),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              _receivedScm(
                  receivedScm: assignmentData.receivedScmQuantity.toString()),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.01,
              ),
              _currentScm(
                  currentScm: assignmentData.currentScmQuantity.toString()),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              _cngStationAddress(
                  cngStationAddress:
                      "${assignmentData.cngStationAddress},${assignmentData.cngStationCity},${assignmentData.cngStationDistrict},${assignmentData.cngStationState}"),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  Expanded(
                    child: _status(
                        assignmentStatus: assignmentData.assignmentStatus!,
                        assignmentStatusColor:
                            assignmentData.assignmentStatusColor!),
                  ),
                  userData.roleType == RoleType.cngStation &&
                          assignmentData.assignmentStatus ==
                              AssignmentStatus.complete &&
                          assignmentData.receivedScmQuantity.toString().isEmpty
                      ? _changeStatus(
                          assignmentStatus: assignmentData.assignmentStatus!,
                          context: context)
                      : userData.roleType != RoleType.cngStation &&
                              assignmentData.assignmentStatus !=
                                  AssignmentStatus.complete &&
                              assignmentData.assignmentStatus !=
                                  AssignmentStatus.cancel
                          ? _changeStatus(
                              assignmentStatus:
                                  assignmentData.assignmentStatus!,
                              context: context)
                          : const SizedBox.shrink(),
                ],
              ),
              const Divider(),
              _deliveryDate(deliveryDate: assignmentData.createdAt.toString()),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              _startDateTime(
                  startDateTime: assignmentData.startDateTime.toString()),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              assignmentData.delay.toString().isNotEmpty
                  ? _delayTime(delay: "${assignmentData.delay} Mints")
                  : const SizedBox.shrink(),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _images(
                        pictureUrl: assignmentData.slipPhoto.toString(),
                        context: context),
                    _images(
                        pictureUrl: assignmentData.startSelfPhoto.toString(),
                        context: context),
                    _images(
                        pictureUrl: assignmentData.startTruckImage.toString(),
                        context: context),
                    _images(
                        pictureUrl: assignmentData.endSelfPhoto.toString(),
                        context: context),
                    _images(
                        pictureUrl: assignmentData.endTruckImage.toString(),
                        context: context),
                  ],
                ),
              )
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
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(driverName,
              color: AppColor.black,
              fontSize: AppFont.font_14,
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
            fontSize: AppFont.font_13,
            fontWeight: FontWeight.w500),
        Expanded(
          child: TextWidget(vehicleNumber,
              color: AppColor.grey,
              fontSize: AppFont.font_13,
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
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(fromStationName,
              color: AppColor.black,
              fontSize: AppFont.font_14,
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
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(toStationName,
              color: AppColor.black,
              fontSize: AppFont.font_14,
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
      required Color assignmentStatusColor}) {
    return Row(
      children: [
        TextWidget("Status : ",
            color: AppColor.themeColor,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w700),
        TextWidget(
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
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
      ],
    );
  }

  Widget _deliveryDate({required String deliveryDate}) {
    return Row(
      children: [
        TextWidget("Schedule Date Time : ",
            color: AppColor.themeColor,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(deliveryDate,
              color: AppColor.black,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _startDateTime({required String startDateTime}) {
    return Row(
      children: [
        TextWidget("Start Date Time : ",
            color: AppColor.themeColor,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(startDateTime,
              color: AppColor.black,
              fontSize: AppFont.font_14,
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
      required BuildContext context}) {
    return userData.roleType == RoleType.driver
        ? const SizedBox.shrink()
        : ButtonWidget(
            height: MediaQuery.of(context).size.height * 0.04,
            fontSize: AppFont.font_12,
            text: userData.roleType == RoleType.cngStation
                ? "Change Status"
                : "Cancel",
            onPressed: () {
              if (userData.roleType == RoleType.cngStation) {
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
                    builder: (BuildContext context) => Container(
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
