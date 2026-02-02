import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/helper/acknowledge_helper.dart';
import 'package:flutter_igl_cng/feature/acknowledge/presentation/widget/complaint_assign_widget.dart';
import 'package:flutter_igl_cng/feature/acknowledge/presentation/widget/video_player_view_widget.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

import 'full_image_view_widget.dart';

class AcknowledgeItemBoxWidget extends StatelessWidget {
  final int index;
  final AcknowledgeModel acknowledgeData;

  const AcknowledgeItemBoxWidget(
      {super.key, required this.acknowledgeData, required this.index});

  @override
  Widget build(BuildContext context) {
    LoginDataModel loginData = UserInfo.instanceInit()!.userData!;

    // --- Safely parse attachment_file JSON ---
    List<String> attachments = [];
    if (acknowledgeData.attachmentFile != null && acknowledgeData.attachmentFile!.isNotEmpty) {
      try {
        final parsed = jsonDecode(acknowledgeData.attachmentFile!);
        if (parsed is List) {
          attachments = parsed.map((e) => e.toString()).toList();
        }
      } catch (e) {
        attachments = []; // fallback
      }
    }

    // Build image URLs
    final List<String> imageUrls = attachments.map((a) => "${loginData.complainPhotoUrl}$a").toList();

    final String? videoFile = (acknowledgeData.videoFile != null && acknowledgeData.videoFile!.isNotEmpty)
        ? "${loginData.complainVideoUrl}${acknowledgeData.videoFile}"
        : null;


    print("videoFile-->${videoFile}");

    return Card(
      shape: acknowledgeData.assignType.toString() == "1"  // self
          ?  RoundedRectangleBorder(
          side: BorderSide(color: Colors.orange, width: 2.0),
          borderRadius: BorderRadius.circular(10.0))
        : acknowledgeData.assignType.toString() == "2" // MI
          ?  RoundedRectangleBorder(
          side: BorderSide(color: Colors.purple, width: 2.0),
          borderRadius: BorderRadius.circular(10.0))
       : acknowledgeData.assignType.toString() == "3" // Vendor
          ?  RoundedRectangleBorder(
          side: BorderSide(color: Colors.yellow, width: 2.0),
          borderRadius: BorderRadius.circular(10.0))
          : RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                _rowHeaderWidget(
                    name: "Complaint ID",
                    value: acknowledgeData.tokenNo.toString()),
                Container(
                    height: 1,
                    color: AppColor.lightGrey,
                    width: MediaQuery.of(context).size.width),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(
                  name: "Station Name",
                  value:
                  "${acknowledgeData.cngStationName ?? ""}"
                      "${acknowledgeData.cngStationType != null &&
                      acknowledgeData.cngStationType!.isNotEmpty
                      ? " (${acknowledgeData.cngStationType})"
                      : ""}",
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(
                  name: "Equipment Type",
                  value: acknowledgeData.equipmentTypeName ?? "",
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(
                  name: "Equipment vendor",
                  value: acknowledgeData.equipmentVendor ?? "",
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(
                  name: "Equipment vendor code",
                  value: acknowledgeData.equipmentVendorCode ?? "",
                ),
                _rowWidget(
                    name: acknowledgeData.equipmentCode.toString().isNotEmpty
                        ? "Equipment"
                        : "General",
                    value: acknowledgeData.equipmentCode.toString().isNotEmpty
                        ? acknowledgeData.descriptionKva.toString()
                        : acknowledgeData.generalComplaintName.toString()),

                acknowledgeData.equipmentCode.toString().isNotEmpty?
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ) : const SizedBox(),

                acknowledgeData.equipmentCode.toString().isNotEmpty
                    ? _rowWidget(
                        name: "vendor Code",
                        value: acknowledgeData.vendorCode.toString())
                    : const SizedBox.shrink(),
                acknowledgeData.equipmentCode.toString().isNotEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      )
                    : const SizedBox.shrink(),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(name: "Complaint Date Time", value: acknowledgeData.complaintDateTime.toString()),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(name: "Report Date Time", value: acknowledgeData.reportDateTime.toString()),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(
                    name: "Complaint Status",
                    value: acknowledgeData.complaintStatus.toString() == "0"
                        ? "New"
                        : acknowledgeData.complaintStatus.toString() == "1"
                            ? "Completed"
                            : acknowledgeData.complaintStatus.toString() == "2"
                                ? "Reject"
                              : acknowledgeData.complaintStatus.toString() == "3"
                              ? "${AppString.closure} ${AppString.pending}"
                                : "", color: acknowledgeData.complaintStatus.toString() == "3" ? AppColor.orange: null),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(
                    name: "Ack Status",
                    value: acknowledgeData.ackStatus.toString() == "1"
                        ? "Ack Done"
                        : ""),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _rowWidget(
                    name: "Assign Type",
                    value: acknowledgeData.assignType.toString() == "1"
                        ? "Self"
                        : acknowledgeData.assignType.toString() == "2"
                            ? "MI"
                            : acknowledgeData.assignType.toString() == "3"
                                ? "Vendor"
                                : ""),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                acknowledgeData.miAssignToUser.toString().isNotEmpty
                    ? _rowWidget(
                        name: "Assign To",
                        value: acknowledgeData.miAssignToUser.toString())
                    : const SizedBox.shrink(),
                acknowledgeData.miAssignToUser.toString().isNotEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      )
                    : const SizedBox.shrink(),

                acknowledgeData.notificationNo.toString().isNotEmpty
                    ? _rowWidget(
                    name: "Notification No",
                    value: acknowledgeData.notificationNo.toString())
                    : const SizedBox.shrink(),
                acknowledgeData.notificationNo.toString().isNotEmpty
                    ? SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ): const SizedBox.shrink(),

                acknowledgeData.vendorComplaintNumber.toString().isNotEmpty
                    ? _rowWidget(
                    name: "Vendor Complaint No",
                    value: acknowledgeData.vendorComplaintNumber.toString())
                    : const SizedBox.shrink(),
                acknowledgeData.vendorComplaintNumber.toString().isNotEmpty
                    ? SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ): const SizedBox.shrink(),

                acknowledgeData.sapRejectError.toString().isNotEmpty
                    ? _rowWidget(name: "Sap Reject Error", value: acknowledgeData.sapRejectError.toString(), color: AppColor.red)
                    : const SizedBox.shrink(),
                acknowledgeData.sapRejectError.toString().isNotEmpty
                    ? SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ): const SizedBox.shrink(),


                acknowledgeData.complaintStatus.toString() != "2" &&
                        acknowledgeData.complaintStatus.toString() != "1" &&
                        acknowledgeData.ackStatus.toString() == "1"
                    ? _assignButton(context: context)
                    : const SizedBox.shrink(),
                Container(
                    height: 1,
                    color: AppColor.lightGrey,
                    width: MediaQuery.of(context).size.width),
                _rowBottomWidget(
                    name: "Description",
                    value: acknowledgeData.crComplaintDescription.toString().isNotEmpty ? acknowledgeData.crComplaintDescription.toString() : acknowledgeData.complaintDescription.toString()),

                SizedBox(height: 8),
                _attachmentImages(imageUrls, context),
                SizedBox(height: 8),
                _videoWidget(videoUrl: videoFile,context: context),
              //  SizedBox(height: 10),


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
// --- Inside build() method, after parsing attachments ---

  Widget _attachmentImages(List<String> imageUrls, BuildContext context) {
    if (imageUrls.isEmpty) {
      return SizedBox.shrink();
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final imgUrl = imageUrls[i];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullImageViewWidget(imageUrl: imgUrl),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imgUrl,
                    height: MediaQuery.of(context).size.height * 0.07,
                    width:MediaQuery.of(context).size.width * 0.2,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width:MediaQuery.of(context).size.width * 0.2,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.zoom_out_map,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _videoWidget({
    required BuildContext context,
    required String? videoUrl,
  }) {
    if (videoUrl == null || videoUrl.isEmpty) {
      return const SizedBox.shrink(); // nothing to show
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerViewWidget(videoUrl: videoUrl),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.videocam,
              color: Colors.white54,
              size: 60,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }


  Widget _rowHeaderWidget({required String name, required String value}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        color: AppColor.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            TextWidget("$name ",
                color: AppColor.themeColor,
                fontWeight: FontWeight.w700,
                fontSize: AppFont.font_13),
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
                  textAlign: TextAlign.end, fontSize: AppFont.font_13, color: color,)),
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

  Widget _assignButton({required BuildContext context}) {
    return Align(
      alignment: Alignment.bottomRight,
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.13,
        width: MediaQuery.of(context).size.width * 0.35,
        child: ButtonWidget(
            backgroundColor: acknowledgeData.assignTo.toString() != "0"
                    ? AppColor.orange
                    : AppColor.themeColor,
            fontSize: AppFont.font_11,
            text:(acknowledgeData.assignTo.toString().isEmpty ||
                        acknowledgeData.assignTo.toString() == "0")
                    ? AppString.assign
                    : AppString.reAssign,
            onPressed: () async {
                BlocProvider.of<AcknowledgeBloc>(context)
                    .add(AcknowledgeUserListLoadEvent(context: context));
                BlocProvider.of<AddSparePartBloc>(context).add(AddSparePartClearSparePartEvent());
                BlocProvider.of<AddSparePartBloc>(context)
                    .add(AddSparePartPageLoadEvent(context: context));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ComplaintAssignWidget(
                            acknowledgeData: acknowledgeData)));
            }),
      ),
    );
  }
}
