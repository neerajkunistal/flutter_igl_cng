import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class ComplaintTypeWidget extends StatefulWidget {
  const ComplaintTypeWidget({super.key});

  @override
  State<ComplaintTypeWidget> createState() => _ComplaintTypeWidgetState();
}

class _ComplaintTypeWidgetState extends State<ComplaintTypeWidget> {
  final LoginDataModel userData = UserInfo.instance!.userData!;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// MAIN SCROLLABLE CONTENT
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 70), // space for footer
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              /// HEADER
              Column(
                children: [
                  TextWidget(
                    AppConfig.instanceInit()!.client == Client.igl
                        ? "IGL CNG Automation"
                        : AppConfig.instanceInit()!.client == Client.pbgpl
                        ? "PBGPL CNG Automation"
                        : AppConfig.instanceInit()!.client == Client.mahanagar
                        ? "MGL CNG Automation"
                        : AppConfig.instanceInit()!.client == Client.hpcl
                        ? "HPCL CNG Automation"
                        : "IGL CNG Automation",
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

              const SizedBox(height: 30),

              /// CIVIL & EQUIPMENT ROW
              Row(
                children: [
                  Expanded(child: _civilComplaintCard()),
                  Expanded(child: _equipmentComplaintCard()),
                ],
              ),

              /// LCV CARD (Conditional)
              if (userData.mDbStatus.toString().isNotEmpty &&
                  userData.mDbStatus.toString() != "0")
                _lcvCard(),

              const SizedBox(height: 40),
            ],
          ),
        ),

        /// ✅ FIXED FOOTER
        Positioned(
          left: 0,
          right: 0,
          bottom: 8,
          child: _unistalFooter(),
        ),
      ],
    );
  }

  // -------------------- CARDS --------------------

  Widget _civilComplaintCard() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 2,
        shadowColor: EnvironmentConfig.of(context)!.primaryTheme,
        child: InkWell(
          onTap: () async {
            if (await Vibration.hasAmplitudeControl() != null) {
              Vibration.vibrate(duration: 100);
            }
            Navigator.push(
              context,
              FadeRoute(page: const ViewCngPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset(
                  AppIcon.maintenanceIcon,
                  height: MediaQuery.of(context).size.width * 0.20,
                ),
                const SizedBox(height: 10),
                TextWidget(
                  "Civil Complaint",
                  color: EnvironmentConfig.of(context)!.primaryTheme,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _equipmentComplaintCard() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 2,
        shadowColor: EnvironmentConfig.of(context)!.primaryTheme,
        child: InkWell(
          onTap: () async {
            if (await Vibration.hasAmplitudeControl() != null) {
              Vibration.vibrate(duration: 100);
            }
            Navigator.push(
              context,
              FadeRoute(
                page: const ViewEquipmentComplaintPage(
                  title: "CNG O&M Complaints",
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset(
                  AppIcon.equipmentIcon,
                  height: MediaQuery.of(context).size.width * 0.20,
                ),
                const SizedBox(height: 10),
                TextWidget(
                  "CNG O&M Complaints",
                  textAlign: TextAlign.center,
                  color: EnvironmentConfig.of(context)!.primaryTheme,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _lcvCard() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 2,
        shadowColor: EnvironmentConfig.of(context)!.primaryTheme,
        child: InkWell(
          onTap: () async {
            if (await Vibration.hasAmplitudeControl() != null) {
              Vibration.vibrate(duration: 100);
            }
            Navigator.push(
              context,
              FadeRoute(
                page: userData.mDbStatus.toString() == "1"
                    ? const LcvDashboardPage()
                    : const ViewAssignmentPage(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset(
                  AppIcon.lcvTruckIcon,
                  height: MediaQuery.of(context).size.width * 0.20,
                ),
                const SizedBox(height: 10),
                TextWidget(
                  "LCV",
                  color: EnvironmentConfig.of(context)!.primaryTheme,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- FOOTER --------------------

  Widget _unistalFooter() {
    return SafeArea(
      top: false,
      child: Center(
        child: TextWidget(
          "Unistal Systems Pvt Ltd. | Version ${AppConfig.instanceInit()!.appVersion}",
          fontSize: AppFont.font_12,
          color: AppColor.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
