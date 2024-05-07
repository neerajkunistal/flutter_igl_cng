import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/review_complaint_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:intl/intl.dart';

class ReviewComplaintItemBox extends StatelessWidget {
  final ReviewComplaintModel reviewComplaintData;
  const ReviewComplaintItemBox({super.key, required this.reviewComplaintData});

  @override
  Widget build(BuildContext context) {

    LoginDataModel userData =  UserInfo.instanceInit()!.userData!;

    String complaintDate = "";
    if(reviewComplaintData.complaintDateTime != null && reviewComplaintData.complaintDateTime.toString().isNotEmpty) {
      complaintDate = DateFormat('dd-MMM-yyyy, h:mm:ss').format(DateTime.parse(reviewComplaintData.complaintDateTime.toString()));
    }
    String reportDate = "";
    if(reviewComplaintData.reportDateTime != null && reviewComplaintData.reportDateTime.toString().isNotEmpty) {
      reportDate = DateFormat('dd-MMM-yyyy, h:mm:ss').format(DateTime.parse(reviewComplaintData.reportDateTime.toString()));
    }

    String startDate = "";
    if(reviewComplaintData.startDateTime != null && reviewComplaintData.startDateTime.toString().isNotEmpty) {
      startDate = DateFormat('dd-MMM-yyyy, h:mm:ss').format(DateTime.parse(reviewComplaintData.startDateTime.toString()));
    }

    String closedDate = "";
    if(reviewComplaintData.closeDateTime != null && reviewComplaintData.closeDateTime.toString().isNotEmpty) {
      closedDate = DateFormat('dd-MMM-yyyy, h:mm:ss').format(DateTime.parse(reviewComplaintData.closeDateTime.toString()));
    }

    String maintinaceEndDate = "";
    if(reviewComplaintData.maintenanceEndDate != null && reviewComplaintData.maintenanceEndDate.toString().isNotEmpty) {
      maintinaceEndDate = DateFormat('dd-MMM-yyyy, h:mm:ss').format(DateTime.parse(reviewComplaintData.maintenanceEndDate.toString()));
    }

    String maintinaceStartDate = "";
    if(reviewComplaintData.maintenanceStartDate != null && reviewComplaintData.maintenanceStartDate.toString().isNotEmpty) {
      maintinaceStartDate = DateFormat('dd-MMM-yyyy, h:mm:ss').format(DateTime.parse(reviewComplaintData.maintenanceStartDate.toString()));
    }

    String maintenanceStatus = "";
    String status = "";

    maintenanceStatus = reviewComplaintData.action.toString() == "1" ? "Start"
        : reviewComplaintData.action.toString() == "2" ? "Hold"
        : reviewComplaintData.action.toString() == "3" ? "Closed"
        : "";

    status = reviewComplaintData.complaintStatus.toString() ==  "0" ? "New"
        : reviewComplaintData.complaintStatus.toString() ==  "1" ?  "Completed"
        : reviewComplaintData.complaintStatus.toString() ==  "2" ? "Reject" : "";


    return Card(
      shadowColor: AppColor.themeColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _rowHeaderWidget(name: "Complaint Id", value: reviewComplaintData.tokenNo.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(name: "Equipment", value: reviewComplaintData.equipmentCode.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(name: "Complaint Status", value: status),
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
            _rowWidget(name: "MI Status", value: maintenanceStatus),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(name: "Start Date Time", value: userData.roleType == RoleType.mi
                || userData.roleType == RoleType.shiftEngineer ? maintinaceStartDate : startDate),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _rowWidget(name: "Closed Date Time", value: userData.roleType == RoleType.mi
                || userData.roleType == RoleType.shiftEngineer ? maintinaceEndDate : closedDate),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
             Container(
               height: 1,
               color: AppColor.lightGrey,
               width: MediaQuery.of(context).size.width),
            _rowBottomWidget(name: "Description", value: reviewComplaintData.complaintDescription.toString()),
          ],
        ),
      ),
    );
  }

  Widget _rowHeaderWidget({required String name, required String value}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0)),
        color: AppColor.lightGrey,
        border: Border(
          left: BorderSide(
            color: reviewComplaintData.complaintStatus.toString() == "1" ? AppColor.green
                : reviewComplaintData.complaintStatus.toString() == "2" ? AppColor.red
                : reviewComplaintData.action.toString() == "3" ? AppColor.orange
                :  AppColor.themeColor,
            width: 3,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            TextWidget("$name ", fontWeight: FontWeight.w700,fontSize: AppFont.font_13),
            Expanded(child: TextWidget(value, textAlign: TextAlign.end,
                color: AppColor.themeColor,
                fontWeight: FontWeight.w700,fontSize: AppFont.font_13)),
          ],
        ),
      ),
    );
  }
  
  Widget _rowWidget({required String name, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        children: [
         TextWidget("$name : ", fontSize: AppFont.font_13),
         Expanded(child: TextWidget(value, textAlign: TextAlign.end,fontSize: AppFont.font_13)),
        ],
      ),
    );
  }

  Widget _rowBottomWidget({required String name, required String value}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
        color: AppColor.white,
        border: Border(
          right: BorderSide(
            color: reviewComplaintData.complaintStatus.toString() == "1" ? AppColor.green
                : reviewComplaintData.complaintStatus.toString() == "2" ? AppColor.red
                : reviewComplaintData.action.toString() == "3" ? AppColor.orange
                : AppColor.themeColor,
            width: 3,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget("$name : ", fontSize: AppFont.font_13),
            Expanded(child: TextWidget(value, textAlign: TextAlign.end,fontSize: AppFont.font_13)),
          ],
        ),
      ),
    );
  }
}
