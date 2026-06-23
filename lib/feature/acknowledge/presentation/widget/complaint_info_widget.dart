import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart'; // FullImageViewWidget, VideoPlayerViewWidget
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/review_complaint_model.dart';
import 'package:flutter_igl_cng/utils/res/app_color.dart';
import 'package:flutter_igl_cng/utils/res/app_icon.dart';
import 'package:flutter_igl_cng/utils/res/app_string.dart';

class ComplaintInfoWidget extends StatelessWidget {
  final ReviewComplaintModel acknowledgeData;
  final List<String> imageUrls;
  final List<String> reviewAttachUrls;
  final String? videoUrl;

  const ComplaintInfoWidget({
    super.key,
    required this.acknowledgeData,
    this.imageUrls = const [],
    this.reviewAttachUrls = const [],
    this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: acknowledgeData.assignType.toString() == "1" // self
          ? RoundedRectangleBorder(
          side: const BorderSide(color: Colors.orange, width: 2.0),
          borderRadius: BorderRadius.circular(10.0))
          : acknowledgeData.assignType.toString() == "2" // MI
          ? RoundedRectangleBorder(
          side: const BorderSide(color: Colors.purple, width: 2.0),
          borderRadius: BorderRadius.circular(10.0))
          : acknowledgeData.assignType.toString() == "3" // Vendor
          ? RoundedRectangleBorder(
          side: const BorderSide(color: Colors.yellow, width: 2.0),
          borderRadius: BorderRadius.circular(10.0))
          : RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                _rowHeaderWidget(
                  name: "Complaint ID",
                  value: acknowledgeData.tokenNo.toString(),
                  context: context,
                ),
                Container(
                    height: 1,
                    color: AppColor.lightGrey,
                    width: MediaQuery.of(context).size.width),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                _rowWidget(
                  name: "Station Name",
                  value: "${acknowledgeData.cngStationName ?? ""}"
                      "${acknowledgeData.cngStationType != null && acknowledgeData.cngStationType!.isNotEmpty ? " (${acknowledgeData.cngStationType})" : ""}",
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                _rowWidget(
                  name: "Equipment Type",
                  value: acknowledgeData.equipmentTypeName!.isEmpty
                      ? "NA"
                      : acknowledgeData.equipmentTypeName.toString(),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                _rowWidget(
                  name: "Equipment vendor",
                  value: acknowledgeData.equipmentVendor!.isEmpty
                      ? "NA"
                      : acknowledgeData.equipmentVendor.toString(),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                _rowWidget(
                  name: "Equipment vendor code",
                  value: acknowledgeData.equipmentVendorCode!.isEmpty
                      ? "NA"
                      : acknowledgeData.equipmentVendorCode.toString(),
                ),
                _rowWidget(
                    name: acknowledgeData.equipmentCode.toString().isNotEmpty
                        ? "Equipment"
                        : "General",
                    value: acknowledgeData.equipmentCode.toString().isNotEmpty
                        ? acknowledgeData.descriptionKva.toString()
                        : acknowledgeData.generalComplaintName.toString()),
                acknowledgeData.equipmentCode.toString().isNotEmpty
                    ? SizedBox(height: MediaQuery.of(context).size.width * 0.02)
                    : const SizedBox(),
                acknowledgeData.equipmentCode.toString().isNotEmpty
                    ? _rowWidget(
                    name: "vendor Code",
                    value: acknowledgeData.vendorCode.toString())
                    : const SizedBox.shrink(),
                acknowledgeData.equipmentCode.toString().isNotEmpty
                    ? SizedBox(height: MediaQuery.of(context).size.width * 0.02)
                    : const SizedBox.shrink(),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                _rowWidget(
                    name: "Complaint Date Time",
                    value: acknowledgeData.complaintDateTime.toString()),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                _rowWidget(
                    name: "Report Date Time",
                    value: acknowledgeData.reportDateTime.toString()),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                _rowWidget(
                    name: "Complaint Status",
                    value: acknowledgeData.complaintStatus.toString() == "0"
                        ? "New"
                        : acknowledgeData.complaintStatus.toString() == "1"
                        ? "Completed"
                        : acknowledgeData.complaintStatus.toString() == "2"
                        ? "Reject"
                        : acknowledgeData.complaintStatus.toString() ==
                        "3"
                        ? "${AppString.closure} ${AppString.pending}"
                        : "",
                    color: acknowledgeData.complaintStatus.toString() == "3"
                        ? AppColor.orange
                        : null),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                _rowWidget(
                    name: "Ack Status",
                    value: acknowledgeData.ackStatus.toString() == "1"
                        ? "Ack Done"
                        : ""),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                _rowWidget(
                    name: "Assign Type",
                    value: acknowledgeData.assignType.toString() == "1"
                        ? "Self"
                        : acknowledgeData.assignType.toString() == "2"
                        ? "MI"
                        : acknowledgeData.assignType.toString() == "3"
                        ? "Vendor"
                        : ""),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                acknowledgeData.miAssignToUser.toString().isNotEmpty
                    ? _rowWidget(
                    name: "Assign To",
                    value: acknowledgeData.miAssignToUser.toString())
                    : const SizedBox.shrink(),
                acknowledgeData.miAssignToUser.toString().isNotEmpty
                    ? SizedBox(height: MediaQuery.of(context).size.width * 0.02)
                    : const SizedBox.shrink(),
                acknowledgeData.notificationNo.toString().isNotEmpty
                    ? _rowWidget(
                    name: "Notification No",
                    value: acknowledgeData.notificationNo.toString())
                    : const SizedBox.shrink(),
                acknowledgeData.notificationNo.toString().isNotEmpty
                    ? SizedBox(height: MediaQuery.of(context).size.width * 0.02)
                    : const SizedBox.shrink(),
                acknowledgeData.vendorComplaintNumber.toString().isNotEmpty
                    ? _rowWidget(
                    name: "Vendor Complaint No",
                    value: acknowledgeData.vendorComplaintNumber.toString())
                    : const SizedBox.shrink(),
                acknowledgeData.vendorComplaintNumber.toString().isNotEmpty
                    ? SizedBox(height: MediaQuery.of(context).size.width * 0.02)
                    : const SizedBox.shrink(),
                acknowledgeData.sapRejectError.toString().isNotEmpty
                    ? _rowWidget(
                    name: "Sap Reject Error",
                    value: acknowledgeData.sapRejectError.toString(),
                    color: AppColor.red)
                    : const SizedBox.shrink(),
                acknowledgeData.sapRejectError.toString().isNotEmpty
                    ? SizedBox(height: MediaQuery.of(context).size.width * 0.02)
                    : const SizedBox.shrink(),
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
                    value: acknowledgeData.crComplaintDescription
                        .toString()
                        .isNotEmpty
                        ? acknowledgeData.crComplaintDescription.toString()
                        : acknowledgeData.complaintDescription.toString()),
                const SizedBox(height: 8),
                _imageList(imageUrls, context),
                const SizedBox(height: 8),
                _imageList(reviewAttachUrls, context),
                const SizedBox(height: 8),
                _videoWidget(context: context, url: videoUrl),
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

  // Single video widget — removed the duplicate stub.
  Widget _videoWidget({required BuildContext context, String? url}) {
    if (url == null || url.isEmpty) return const SizedBox.shrink();
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

  // ---- Paste your real implementations below ----

  Widget _rowHeaderWidget(
      {required String name,
        required String value,
        required BuildContext context}) {
    return const SizedBox.shrink(); // TODO
  }

  Widget _rowWidget(
      {required String name, required String value, Color? color}) {
    return const SizedBox.shrink(); // TODO
  }

  Widget _rowBottomWidget({required String name, required String value}) {
    return const SizedBox.shrink(); // TODO
  }

  Widget _assignButton({required BuildContext context}) {
    return const SizedBox.shrink(); // TODO
  }
}