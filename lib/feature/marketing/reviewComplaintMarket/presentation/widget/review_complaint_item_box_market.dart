import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/marketing/acknowledgeMarketing/domain/model/complaint_market_list_model.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/viewEquipmentComplaint/domain/bloc/view_equipment_complaint_market_bloc.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/viewEquipmentComplaint/presentaion/page/view_equipment_complaint_detail_page_market.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class ReviewComplaintMarketItemBox extends StatelessWidget {
  final ComplaintMarketModel reviewComplaintData;
  final int index;
  final bool? isDetailPage;
  final EquipmentComplaintType equipmentComplaintType;

  const ReviewComplaintMarketItemBox({
    super.key,
    required this.reviewComplaintData,
    required this.index,
    required this.equipmentComplaintType,
    this.isDetailPage,
  });

  @override
  Widget build(BuildContext context) {
    final LoginDataModel userData = UserInfo.instance!.userData!;
    final int tabIndex = BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context).selectTabIndex;

    return Card(
      shape: userData.roleType == RoleType.stationUser && tabIndex == 4 && reviewComplaintData.ackStatus.toString() == "1"
          && reviewComplaintData.complaintStatus.toString() == "3"
          ? RoundedRectangleBorder(
          side: BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(10.0))
          : userData.roleType == RoleType.stationUser && tabIndex == 4 && reviewComplaintData.ackStatus.toString() == "1"
          && reviewComplaintData.complaintStatus.toString() == "0"
          ? RoundedRectangleBorder(
          side: BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(10.0))
          : RoundedRectangleBorder(
          side: BorderSide(
              color: userData.roleType == RoleType.shiftEngineer && tabIndex == 6 // self
                  ? Colors.orange
                  : userData.roleType == RoleType.shiftEngineer && tabIndex == 1 // MI
                  ? Colors.purple
                  : userData.roleType == RoleType.shiftEngineer && tabIndex == 2 // Vendor
                  ? Colors.yellow
                  : userData.roleType == RoleType.shiftEngineer && tabIndex == 5 // close
                  ? Colors.white
                  : userData.roleType == RoleType.shiftEngineer && tabIndex == 3 // close
                  ? Colors.green
                  : AppColor.white,
              width: 2.0),
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
                  value: reviewComplaintData.tokenNo.toString(),
                ),
                Divider(color: AppColor.lightGrey),
                _gap(context),
                _rowWidget(
                  name: "Station Name",
                  value: reviewComplaintData.cngStationName.toString(),
                ),
                _gap(context),

                _rowWidget(
                  name: "vendor Code",
                  value: reviewComplaintData.vendorId.toString(),
                ),
                _gap(context),

                _rowWidget(
                  name: "Complaint Status",
                  value: _statusLabel(),
                  color: reviewComplaintData.rejectStatus.toString() == "1"
                      ? AppColor.orange
                      : null,
                ),
                _gap(context),

                _rowWidget(
                  name: "Complaint Date",
                  value: reviewComplaintData.complainDateTime.toString(),
                ),
                _gap(context),

                _rowWidget(
                  name: "Report Date Time",
                  value: reviewComplaintData.reportDateTime.toString(),
                ),
                _gap(context),

                _rowWidget(
                  name: "Assign To",
                  value: reviewComplaintData.assignedVendorName.toString(),
                ),

                _rowWidget(
                  name: "Closed Date Time",
                  value: reviewComplaintData.closeDateTime.toString(),
                ),
                _gap(context),

                if (reviewComplaintData.complaintStatus.toString() == "3") ...[
                  _rowWidget(
                    name: "Closure Status",
                    value: "Pending",
                    color: AppColor.red,
                  ),
                  _gap(context),
                ],


                Container(
                  height: 1,
                  color: AppColor.lightGrey,
                  width: MediaQuery.of(context).size.width,
                ),

                _rowBottomWidget(
                  name: "Description",
                  value: reviewComplaintData.complaintDescription
                      .toString()
                      .isNotEmpty
                      ? reviewComplaintData.complaintDescription.toString()
                      : reviewComplaintData.complaintDescription.toString(),
                ),
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
          ),
        ],
      ),
    );
  }

  /// Consistent vertical spacing used between rows.
  Widget _gap(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.width * 0.02);

  /// Human-readable complaint status label.
  String _statusLabel() {
    final String rejectStatus = reviewComplaintData.rejectStatus.toString();
    final String complaintStatus =
    reviewComplaintData.complaintStatus.toString();
    final String ackStatus = reviewComplaintData.ackStatus.toString();

    if (rejectStatus == "1") return "Reopen";
    if (complaintStatus == "0") return "New";
    if (complaintStatus == "1" && ackStatus == "2") {
      return "Reject - Not Acknowledge";
    }
    if (complaintStatus == "1") return "Completed";
    if (complaintStatus == "2") return "Reject";
    return "";
  }

  Widget _rowHeaderWidget({required String name, required String value}) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
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
              child: TextWidget(
                value,
                textAlign: TextAlign.end,
                fontSize: AppFont.font_13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowWidget({
    required String name,
    required String value,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        children: [
          TextWidget("$name : ", fontSize: AppFont.font_13),
          Expanded(
            child: TextWidget(
              value,
              textAlign: TextAlign.end,
              fontSize: AppFont.font_13,
              color: color ?? AppColor.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowBottomWidget({required String name, required String value}) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget("$name : ", fontSize: AppFont.font_13),
            Expanded(
              child: TextWidget(
                value,
                textAlign: TextAlign.end,
                fontSize: AppFont.font_13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _closureButton({
    required BuildContext context,
    required ComplaintMarketModel reviewComplaintData,
  }) {
    final LoginDataModel userData = UserInfo.instance!.userData!;
    final bool isStationUser = userData.roleType == RoleType.stationUser;

    final String rejectStatus = reviewComplaintData.rejectStatus.toString();
    final String ackStatus = reviewComplaintData.ackStatus.toString();
    final String amoAssignStatus =
    reviewComplaintData.amoAssignStatus.toString();
    final String complaintStatus =
    reviewComplaintData.complaintStatus.toString();
    final String assignType = reviewComplaintData.assignType.toString();

    final bool isReopenedByStationUser = rejectStatus == "1" && isStationUser;

    final bool isAssignable = (amoAssignStatus == "0" && ackStatus == "0") ||
        ackStatus == "1";

    final bool isNewStationComplaint =
        complaintStatus == "0" && assignType != "3" && isStationUser;

    final bool showClosureButton =
        isReopenedByStationUser || (isAssignable && isNewStationComplaint);

    if (!showClosureButton) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: ButtonWidget(
          backgroundColor: AppColor.red,
          text: "Closure",
          fontSize: AppFont.font_12,
          onPressed: () async {
            BlocProvider.of<AddSparePartBloc>(context)
                .add(AddSparePartClearSparePartEvent());
            BlocProvider.of<AddScrapBloc>(context)
                .add(AddScrapClearScrapDataEvent(context: context));
            BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context).add(
              ViewEquipmentComplaintMarketSelectedComplaintEvent(index: index),
            );

            final result = await Navigator.push(
              context,
              FadeRoute(
                page: ViewEquipmentComplaintMarketDetailPage(
                  equipmentComplaintType: equipmentComplaintType,
                ),
              ),
            );

            if (!context.mounted) return;

            if (result?.toString() == "Completed") {
              BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context).add(
                ViewEquipmentComplaintMarketPageLoadEvent(
                  context: context,
                  equipmentComplaintType: equipmentComplaintType,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}