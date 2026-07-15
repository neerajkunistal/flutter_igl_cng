import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/presentation/page/view_cng_page.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/presntation/page/view_assignment_page.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvDashboard/presentation/page/lcv_dashboard_page.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/page/view_equipment_complaint_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:vibration/vibration.dart';

class ComplaintTypeWidget extends StatefulWidget {
  const ComplaintTypeWidget({super.key});

  @override
  State<ComplaintTypeWidget> createState() => _ComplaintTypeWidgetState();
}

class _ComplaintTypeWidgetState extends State<ComplaintTypeWidget> {
  LoginDataModel userData = UserInfo.instance!.userData!;

  void _navigate(BuildContext context, Widget page) async {
    if (await Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 100);
    }
    if (context.mounted) {
      Navigator.push(context, FadeRoute(page: page));
    }
  }

  Widget _buildCard({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      shadowColor: AppColor.themeColor,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                height: MediaQuery.of(context).size.width * 0.20,
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              TextWidget(
                label,
                textAlign: TextAlign.center,
                color: AppColor.themeColor,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          // Header
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                TextWidget(
                  "IGL CNG Automation",
                  fontSize: AppFont.font_18,
                  color: AppColor.white,
                  fontWeight: FontWeight.w700,
                ),
                TextWidget(
                  "Complaint App",
                  fontSize: AppFont.font_16,
                  color: AppColor.white,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Civil + CNG O&M Row
          Row(
            children: [
              userData.showCivil.toString() == "1"
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildCard(
                          icon: AppIcon.maintenanceIcon,
                          label: "Civil Complaint",
                          onTap: () => _navigate(context, const ViewCngPage()),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildCard(
                    icon: AppIcon.equipmentIcon,
                    label: "CNG O&M Complaints",
                    onTap: () => _navigate(
                      context,
                      const ViewEquipmentComplaintPage(
                        title: "CNG O&M Complaints",
                        equipmentComplaintType: EquipmentComplaintType.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // LCV Card
          userData.mDbStatus.toString() != "0" &&
                  userData.mDbStatus.toString().isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildCard(
                    icon: AppIcon.lcvTruckIcon,
                    label: "LCV",
                    onTap: () => _navigate(
                      context,
                      userData.mDbStatus.toString() == "1"
                          ? const LcvDashboardPage()
                          : const ViewAssignmentPage(),
                    ),
                  ),
                )
              : const SizedBox.shrink(),

          // IT Card
          userData.showIt.toString() == "1"
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildCard(
                    icon: AppIcon.equipmentIcon,
                    label: "IT",
                    onTap: () => _navigate(
                        context,
                        const ViewEquipmentComplaintPage(
                          title: "IT",
                          equipmentComplaintType: EquipmentComplaintType.it,
                        )),
                  ),
                )
              : const SizedBox.shrink(),

          Row(
            children: [
              // Fire & Safety complaints Card
              userData.showFS.toString() == "1"
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildCard(
                          icon: AppIcon.fireSafeyIcon,
                          label: "Fire & Safety complaints",
                          onTap: () {},
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),

              // Marketing Card
              userData.showMKT.toString() == "1"
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildCard(
                          icon: AppIcon.marketingIcon,
                          label: "Marketing",
                          onTap: () {},
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),

          const SizedBox(height: 30),

          // Footer
          TextWidget(
            "Unistal Systems Pvt Ltd. Version - ${AppConfig.instanceInit()!.appVersion}",
            fontSize: AppFont.font_12,
            color: AppColor.white,
            fontWeight: FontWeight.w700,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
