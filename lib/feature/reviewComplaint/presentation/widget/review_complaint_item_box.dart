import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/page/view_equipment_complaint_detail_page.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/message_box_two_button_pop.dart';

class ReviewComplaintItemBox extends StatelessWidget {
  final ReviewComplaintModel reviewComplaintData;
  final int index;
  final bool? isDetailPage;

  const ReviewComplaintItemBox({super.key,
    required this.reviewComplaintData,
    required this.index,
    this.isDetailPage
  });

  @override
  Widget build(BuildContext context) {
    LoginDataModel userData = UserInfo.instance!.userData!;
    int tabIndex =  BlocProvider.of<ViewEquipmentComplaintBloc>(context).selectTabIndex;

    String complaintDate = "";
    if (reviewComplaintData.complaintDateTime != null &&
        reviewComplaintData.complaintDateTime.toString().isNotEmpty) {
      complaintDate = DateFormat('dd-MMM-yyyy, h:mm:ss').format(
          DateTime.parse(reviewComplaintData.complaintDateTime.toString()));
    }
    String reportDate = "";
    if (reviewComplaintData.reportDateTime != null &&
        reviewComplaintData.reportDateTime.toString().isNotEmpty) {
      reportDate = DateFormat('dd-MMM-yyyy, h:mm:ss').format(
          DateTime.parse(reviewComplaintData.reportDateTime.toString()));
    }

    String maintinaceStartDate = "";
    if (reviewComplaintData.maintenanceStartDate != null &&
        reviewComplaintData.maintenanceStartDate.toString().isNotEmpty) {
      String date = DateFormat('dd-MMM-yyyy').format(
          DateTime.parse(reviewComplaintData.maintenanceStartDate.toString()));

      DateTime initialDate =
          reviewComplaintData.maintenanceStartDate.toString().isNotEmpty
              ? DateFormat('yyyy-dd-MM h:mm:ss')
                  .parse(reviewComplaintData.maintenanceStartDate.toString())
              : DateTime.now();
      TimeOfDay initialTime = TimeOfDay.fromDateTime(initialDate);
      var timeFormat =
          TimeOfDay(hour: initialTime.hour, minute: initialTime.minute)
              .format(context);

      maintinaceStartDate = "$date $timeFormat";
    }

    String maintinaceEndDate = "";
    if (reviewComplaintData.maintenanceEndDate != null &&
        reviewComplaintData.maintenanceEndDate.toString().isNotEmpty) {
      String date = DateFormat('dd-MMM-yyyy').format(
          DateTime.parse(reviewComplaintData.maintenanceEndDate.toString()));

      DateTime initialDate =
          reviewComplaintData.maintenanceEndDate.toString().isNotEmpty
              ? DateFormat('yyyy-dd-MM h:mm:ss')
                  .parse(reviewComplaintData.maintenanceEndDate.toString())
              : DateTime.now();
      TimeOfDay initialTime = TimeOfDay.fromDateTime(initialDate);
      var timeFormat =
          TimeOfDay(hour: initialTime.hour, minute: initialTime.minute)
              .format(context);

      maintinaceEndDate = "$date $timeFormat";
    }

    String maintenanceStatus = "";
    String status = "";


    maintenanceStatus = reviewComplaintData.action.toString() == "1"
        ? "Start"
        : reviewComplaintData.action.toString() == "2"
            ? "Hold"
            : reviewComplaintData.action.toString() == "3"
                ? "Closed"
                : "";

    status =
       reviewComplaintData.rejectStatus.toString() == "1"
      ? "Reopen"
       : reviewComplaintData.complaintStatus.toString() == "0"
        ? "New"
           : reviewComplaintData.complaintStatus.toString() == "1"
              && reviewComplaintData.ackStatus.toString() == "2"
            ? "Reject - Not Acknowledge"
           : reviewComplaintData.complaintStatus.toString() == "1"
             ? "Completed"
            : reviewComplaintData.complaintStatus.toString() == "2"
                ? "Reject"
                : "";

    return Card(
      shape: userData.roleType == RoleType.stationUser && tabIndex == 4 && reviewComplaintData.ackStatus.toString() == "1"
          && reviewComplaintData.complaintStatus.toString() == "3"
          ?  RoundedRectangleBorder(
          side: BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(10.0))
        : userData.roleType == RoleType.stationUser &&  tabIndex == 4 && reviewComplaintData.ackStatus.toString() == "1"
          && reviewComplaintData.complaintStatus.toString() == "0"
          ?  RoundedRectangleBorder(
          side: BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(10.0))
          : RoundedRectangleBorder(
          side: BorderSide(color: userData.roleType == RoleType.shiftEngineer && tabIndex == 6 // self
              ? Colors.orange
              :userData.roleType == RoleType.shiftEngineer && tabIndex == 1 // Mi
              ? Colors.purple
              :userData.roleType == RoleType.shiftEngineer && tabIndex == 2 // Vendor
              ? Colors.yellow
              :userData.roleType == RoleType.shiftEngineer && tabIndex == 5 // close
              ? Colors.white
              :userData.roleType == RoleType.shiftEngineer && tabIndex == 3 // close
              ? Colors.green
              :AppColor.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0)),
      shadowColor: AppColor.themeColor,
      elevation: 2,
      color: AppColor.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _rowHeaderWidget(
                    name: "Complaint Id",
                    value: reviewComplaintData.tokenNo.toString()),
                Divider(
                  color: AppColor.lightGrey,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(
                    name: "Station Name",
                    value: reviewComplaintData.cngStationName.toString()),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(
                    name:
                        reviewComplaintData.equipmentCode.toString().isNotEmpty
                            ? "Equipment"
                            : "General",
                    value: reviewComplaintData.equipmentCode
                            .toString()
                            .isNotEmpty
                        ? reviewComplaintData.descriptionKva.toString()
                        : reviewComplaintData.generalComplaintName.toString()),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                reviewComplaintData.equipmentCode.toString().isNotEmpty &&
                        userData.roleType != RoleType.stationUser
                    ? _rowWidget(
                        name: "vendor Code",
                        value: reviewComplaintData.vendorCode.toString())
                    : const SizedBox.shrink(),
                reviewComplaintData.equipmentCode.toString().isNotEmpty &&
                        userData.roleType != RoleType.stationUser
                    ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      )
                    : const SizedBox.shrink(),
                _rowWidget(name: "Complaint Status",
                    value: status, color: reviewComplaintData.rejectStatus.toString() == "1"
                        ? AppColor.orange : null),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(name: "Complaint Date", value: complaintDate),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(name: "Report Date Time", value: reportDate),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                reviewComplaintData.miAssignToUser.toString().isNotEmpty
                    ? _rowWidget(
                        name: "Assign To",
                        value: reviewComplaintData.miAssignToUser.toString())
                    : const SizedBox.shrink(),
                reviewComplaintData.miAssignToUser.toString().isNotEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      )
                    : const SizedBox.shrink(),
                _rowWidget(name: "MI Status", value: maintenanceStatus),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
    /*            _rowWidget(name: "Start Date Time", value: maintinaceStartDate),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),*/
                _rowWidget(name: "Closed Date Time", value: maintinaceEndDate),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),

                reviewComplaintData.complaintStatus.toString() == "3" ?
                _rowWidget(name: "Closure Status", value: "Pending", color: AppColor.red) : const SizedBox.shrink(),
                reviewComplaintData.complaintStatus.toString() == "3" ?
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ): const SizedBox.shrink(),

                isDetailPage == true ?
                const SizedBox.shrink()
                : _closureButton(context: context, reviewComplaintData: reviewComplaintData),

                userData.roleType != RoleType.stationUser
                    ? _rowWidget(name: "Notification No", value: reviewComplaintData.notificationNo.toString())
                    : const SizedBox.shrink(),

                userData.roleType != RoleType.stationUser && reviewComplaintData.sapRejectError.toString().isNotEmpty
                    ? _rowWidget(name: "Sap Reject Error", value: reviewComplaintData.sapRejectError.toString(), color: AppColor.red)
                    : const SizedBox.shrink(),

                Container(
                    height: 1,
                    color: AppColor.lightGrey,
                    width: MediaQuery.of(context).size.width),
                _rowBottomWidget(
                    name: "Description",
                    value: reviewComplaintData.crComplaintDescription.toString().isNotEmpty ? reviewComplaintData.crComplaintDescription.toString() : reviewComplaintData.complaintDescription.toString()),
              ],
            ),
          ),
          Positioned(
            bottom: -8.0,
            left: 0.09,
            right: 0.09,
            child: Padding(
              padding: const EdgeInsets.only(left: 7.0, right: 7.0),
              child: Image.asset(
                AppIcon.ghungaruIcon,
                height: MediaQuery.of(context).size.width * 0.06,
                color: Colors.grey[200],
                width: MediaQuery.of(context).size.width,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _rowHeaderWidget({required String name, required String value}) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            TextWidget(
              "$name ",
              fontWeight: FontWeight.w700,
              fontSize: AppFont.font_13,
              color: AppColor.themeColor,
            ),
            Expanded(
                child: TextWidget(value,
                    textAlign: TextAlign.end, fontSize: AppFont.font_13)),
          ],
        ),
      ),
    );
  }

  Widget _rowWidget({required String name, required String value, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        children: [
          TextWidget("$name : ", fontSize: AppFont.font_13),
          Expanded(
              child: TextWidget(value,
                  textAlign: TextAlign.end, fontSize: AppFont.font_13,
                color: color ?? AppColor.black,)),
        ],
      ),
    );
  }

  Widget _rowBottomWidget({required String name, required String value}) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget("$name : ", fontSize: AppFont.font_13),
            Expanded(
                child: TextWidget(value,
                    textAlign: TextAlign.end, fontSize: AppFont.font_13)),
          ],
        ),
      ),
    );
  }

  Widget _closureButton({required BuildContext context,
     required ReviewComplaintModel reviewComplaintData})  {
    LoginDataModel userData =  UserInfo.instance!.userData!;
    return
      (reviewComplaintData.rejectStatus.toString() == "1" &&userData.roleType == RoleType.stationUser)
          || ((reviewComplaintData.seAssignStatus.toString() == "0"
          && reviewComplaintData.ackStatus.toString() == "0")
          || (reviewComplaintData.seAssignStatus.toString() == "1"
              && reviewComplaintData.ackStatus.toString() == "1"))
            && (reviewComplaintData.complaintStatus.toString() == "0" &&
          reviewComplaintData.assignType.toString() != "3" &&
              userData.roleType == RoleType.stationUser)  ?
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: MediaQuery.of(context).size.width/3,
            child: reviewComplaintData.isSelected == false ?
            ButtonWidget(
              backgroundColor: AppColor.red,
              text: "Closure",
              fontSize: AppFont.font_12,
              onPressed: () async {
                BlocProvider.of<AddSparePartBloc>(context).add(AddSparePartClearSparePartEvent());
                BlocProvider.of<AddScrapBloc>(context).add(AddScrapClearScrapDataEvent(context: context));
                BlocProvider.of<ViewEquipmentComplaintBloc>(context).add(
                    ViewEquipmentComplaintSelectedComplaintEvent(index: index));
                var result = await Navigator.push(context,
                    FadeRoute(page: const ViewEquipmentComplaintDetailPage()));
                if (result.toString() == "Completed") {
                  BlocProvider.of<ViewEquipmentComplaintBloc>(
                      !context.mounted ? context : context)
                      .add(ViewEquipmentComplaintPageLoadEvent(
                      context:
                      !context.mounted ? context : context));
                }

/*                if(await _onClosureComplaintPop(context: context) == true){
                  BlocProvider.of<ViewEquipmentComplaintBloc>(!context.mounted ? context: context).add(
                      ViewEquipmentComplaintClosureEvent(context: context.mounted ? context: context,
                      reviewComplaintData: reviewComplaintData, index: index));
                }*/
              },
            ) : const DottedLoaderWidget(),
          ),
        ) : const SizedBox.shrink();
   }

  Future<bool> _onClosureComplaintPop({required BuildContext context}) async {
    return (await showDialog(
        context: context,
        builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
            message: "Do you want to closure complaint?",
            okButtonText: "Closure",
             okButtonColour: AppColor.red,
            onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }

}
