import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/page/view_equipment_complaint_detail_page.dart';


class ReviewComplaintItemBox extends StatelessWidget {
  final ReviewComplaintModel reviewComplaintData;
  final int index;
  final bool? isDetailPage;

  const ReviewComplaintItemBox({
    super.key,
    required this.reviewComplaintData,
    required this.index,
    this.isDetailPage,
  });

  // ---------------- HELPERS ----------------

  List<String> _parseJsonList(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final parsed = jsonDecode(raw);
      return parsed is List ? parsed.map((e) => e.toString()).toList() : [];
    } catch (_) {
      return [];
    }
  }

  DateTime? _parseDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      return DateFormat("yyyy-MM-dd HH:mm:ss").parse(raw);
    } catch (_) {
      try {
        return DateTime.parse(raw.replaceAll(" ", "T"));
      } catch (_) {
        return null;
      }
    }
  }

  bool _isStationUser(LoginDataModel user) =>
      user.roleType == RoleType.stationUser ||
      user.roleType == RoleType.stationUserManager;

  String _getMaintenanceStatus(String? action) {
    switch (action) {
      case "1":
        return "Start";
      case "2":
        return "Hold";
      case "3":
        return "Closed";
      default:
        return "";
    }
  }

  String _getComplaintStatus(ReviewComplaintModel data) {
    if (data.rejectStatus == "1") return "Reopen";
    if (data.complaintStatus == "0") return "New";
    if (data.complaintStatus == "1" && data.ackStatus == "2") {
      return "Reject - Not Acknowledge";
    }
    if (data.complaintStatus == "1") return "Completed";
    if (data.complaintStatus == "2") return "Reject";
    return "";
  }

  Color _getBorderColor(BuildContext context, LoginDataModel userData) {
    final tabIndex =
        BlocProvider.of<ViewEquipmentComplaintBloc>(context).selectTabIndex;

    if (userData.roleType == RoleType.shiftEngineer) {
      switch (tabIndex) {
        case 6:
          return Colors.orange;
        case 1:
          return Colors.purple;
        case 2:
          return Colors.yellow;
        case 3:
          return Colors.green;
      }
    }
    return AppColor.white;
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    final userData = UserInfo.instanceInit()!.userData!;
    final size = MediaQuery.of(context).size;
    final spacing = size.width * 0.02;

    final dt = _parseDate(reviewComplaintData.closeDateTime);

    final formattedDate = dt != null ? DateFormat('yyyy-MM-dd').format(dt) : "";
    final formattedTime = dt != null ? DateFormat('HH:mm:ss').format(dt) : "";

    final attachments = _parseJsonList(reviewComplaintData.attachmentFile);
    final reviewAttach = _parseJsonList(reviewComplaintData.reviewAttachFile);

    final imageUrls =
        attachments.map((e) => "${userData.complainPhotoUrl}$e").toList();

    final reviewAttachUrls =
        reviewAttach.map((e) => "${userData.complainPhotoUrl}$e").toList();

    final videoUrl = (reviewComplaintData.videoFile?.isNotEmpty ?? false)
        ? "${userData.complainVideoUrl}${reviewComplaintData.videoFile}"
        : null;

    final isStationUser = _isStationUser(userData);

    final complaintName =
        reviewComplaintData.generalComplaintName?.toLowerCase().trim();

    final showSpecialClosure = complaintName == "dry out" ||
                     complaintName == "power supply not available";
    final isEquipment = (reviewComplaintData.equipmentCode ?? "").isNotEmpty;
    final maintenanceStatus = _getMaintenanceStatus(reviewComplaintData.action);

    final status = _getComplaintStatus(reviewComplaintData);

    final borderColor = _getBorderColor(context, userData);
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _row("Complaint Id", reviewComplaintData.tokenNo.toString()),
            _divider(),
            _row("Station Name",
                "${reviewComplaintData.cngStationName ?? ""} ${reviewComplaintData.cngStationType ?? ""}"),
            _row(
              (reviewComplaintData.equipmentCode ?? "").isNotEmpty
                  ? "Equipment"
                  : "General",
              (reviewComplaintData.equipmentCode ?? "").isNotEmpty
                  ? reviewComplaintData.descriptionKva ?? ""
                  : reviewComplaintData.generalComplaintName ?? "",
            ),
            if ((reviewComplaintData.equipmentTypeName ?? "").isNotEmpty)
              _row("Equipment Type",
                  reviewComplaintData.equipmentTypeName ?? ""),
            if ((reviewComplaintData.equipmentVendor ?? "").isNotEmpty)
              _row("Equipment Vendor",
                  reviewComplaintData.equipmentVendor ?? ""),
            if ((reviewComplaintData.equipmentCode ?? "").isNotEmpty &&
                !isStationUser)
              _row("Vendor Code", reviewComplaintData.equipmentCode ?? ""),
            _row("Complaint Status", status,
                color: reviewComplaintData.rejectStatus == "1"
                    ? AppColor.orange
                    : null),
            _row("Complaint Date", reviewComplaintData.complaintDateTime ?? ""),
            _row("Report Date Time", reviewComplaintData.reportDateTime ?? ""),
            formattedDate.isNotEmpty
                ? _row("Close Date", formattedDate)
                : SizedBox.shrink(),
            formattedTime.isNotEmpty
                ? _row("Close Time", formattedTime)
                : SizedBox.shrink(),
            reviewComplaintData.actionTaken!.isNotEmpty
                ? _row("Action Taken", reviewComplaintData.actionTaken ?? "")
                : SizedBox.shrink(),
            reviewComplaintData.personName!.isNotEmpty
                ? _row("Person Name", reviewComplaintData.personName ?? "")
                : SizedBox.shrink(),
            maintenanceStatus.isNotEmpty
                ? _row("MI Status", maintenanceStatus)
                : SizedBox.shrink(),
            if (showSpecialClosure) ...[
              reviewComplaintData.maintenanceEndDate!.isNotEmpty
                  ? _row("Closed Date Time",
                      reviewComplaintData.maintenanceEndDate ?? "")
                  : SizedBox.shrink(),
              if (reviewComplaintData.complaintStatus == "3")
                _row("Closure Status", "Pending", color: AppColor.red),
              if (isDetailPage != true)
                _closureButton(context, reviewComplaintData),
            ],
            if (!showSpecialClosure && isEquipment && isDetailPage != true)
              _closureButton(context, reviewComplaintData,),
            reviewComplaintData.serialNumber!.isNotEmpty
                ? _row("Serial Number", reviewComplaintData.serialNumber ?? "")
                : SizedBox.shrink(),
            if (!isStationUser) ...[
              reviewComplaintData.notificationNo!.isNotEmpty
                  ? _row("Notification No",
                      reviewComplaintData.notificationNo ?? "")
                  : SizedBox.shrink(),
            ],
            if ((reviewComplaintData.vendorComplaintNumber ?? "")
                .isNotEmpty) ...[
              _row("Vendor Complaint No",
                  reviewComplaintData.vendorComplaintNumber ?? ""),
            ],
            _divider(),
            _row(
                "Description",
                reviewComplaintData.crComplaintDescription?.isNotEmpty == true
                    ? reviewComplaintData.crComplaintDescription!
                    : reviewComplaintData.complaintDescription ?? ""),
            _imageList(imageUrls, context),
            _imageList(reviewAttachUrls, context),
            _videoWidget(context, videoUrl),
          ],
        ),
      ),
    );
  }

  // ---------------- UI WIDGETS ----------------

  Widget _row(String name, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          TextWidget("$name : "),
          Expanded(
            child: TextWidget(
              value,
              textAlign: TextAlign.end,
              color: color ?? AppColor.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: AppColor.lightGrey);

  Widget _imageList(List<String> urls, BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => FullImageViewWidget(imageUrl: urls[i])),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Image.network(urls[i], width: 80, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _videoWidget(BuildContext context, String? url) {
    if (url == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideoPlayerViewWidget(videoUrl: url)),
      ),
      child: Container(
        height: 80,
        width: 120,
        color: Colors.black,
        child: const Icon(Icons.play_arrow, color: Colors.white),
      ),
    );
  }

  Widget _closureButton(BuildContext context, ReviewComplaintModel data) {
    final user = UserInfo.instance!.userData!;
    final isStationUser = _isStationUser(user);

    final canShow = (data.rejectStatus == "1" && isStationUser)
        || ((data.seAssignStatus == "0" && data.ackStatus == "0") ||
            (data.seAssignStatus == "1" && data.ackStatus == "1")) &&
            (data.complaintStatus == "0" &&
                data.assignType != "3" &&
                isStationUser);

    if (!canShow) return const SizedBox.shrink();
    print("CLOSURE token=${data.tokenNo} role=${user.roleType} "
        "isStation=$isStationUser isEquip= "
        "reject=${data.rejectStatus} seAssign=${data.seAssignStatus} "
        "ack=${data.ackStatus} cStatus=${data.complaintStatus} "
        "assignType=${data.assignType} isSelected=${data.isSelected} "
        "canShow=$canShow");
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: data.isSelected == false
            ? ButtonWidget(
                backgroundColor: AppColor.red,
                text: "Closure",
                onPressed: () async {
                  BlocProvider.of<AddSparePartBloc>(context)
                      .add(AddSparePartClearSparePartEvent());

                  BlocProvider.of<AddScrapBloc>(context)
                      .add(AddScrapClearScrapDataEvent(context: context));

                  BlocProvider.of<ViewEquipmentComplaintBloc>(context).add(
                      ViewEquipmentComplaintSelectedComplaintEvent(
                          index: index));

                  final result = await Navigator.push(
                      context,
                      FadeRoute(
                          page: const ViewEquipmentComplaintDetailPage()));

                  if (result == "Completed") {
                    BlocProvider.of<ViewEquipmentComplaintBloc>(context).add(
                        ViewEquipmentComplaintPageLoadEvent(context: context));
                  }
                },
              )
            : const DottedLoaderWidget(),
      ),
    );
  }
}
