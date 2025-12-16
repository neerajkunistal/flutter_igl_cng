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

  LoginDataModel userData =  UserInfo.instance!.userData!;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  TextWidget(
                    "PBGPL CNG Automation",
                    fontSize: AppFont.font_18,
                    color: AppColor.white,
                    fontWeight: FontWeight.w700,
                  ),
                  TextWidget(
                    "Complaint App",
                    fontSize: AppFont.font_16,
                    color: AppColor.white,
                    fontWeight: FontWeight.w700,
                  )
                ],
              ),
            ),

            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shadowColor: AppColor.themeColor,
                            elevation: 2,
                            child: InkWell(
                              onTap: () async {
                                if (await Vibration.hasAmplitudeControl() != null) {
                                  Vibration.vibrate(duration: 100);
                                }
                                Navigator.push(
                                  !context.mounted ? context : context,
                                  FadeRoute(page: const ViewCngPage()),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(AppIcon.maintenanceIcon,
                                        height: MediaQuery.of(context).size.width * 0.20),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width * 0.02,
                                    ),
                                    TextWidget(
                                      "Civil Complaint",
                                      color: AppColor.themeColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ),

                   Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shadowColor: AppColor.themeColor,
                            elevation: 2,
                            child: InkWell(
                              onTap: () async {
                                if (await Vibration.hasAmplitudeControl() != null) {
                                  Vibration.vibrate(duration: 100);
                                }
                                Navigator.push(
                                  !context.mounted ? context : context,
                                  FadeRoute(
                                      page: const ViewEquipmentComplaintPage(
                                        title: "CNG O&M Complaints",
                                      )),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(AppIcon.equipmentIcon,
                                        height: MediaQuery.of(context).size.width * 0.20),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width * 0.02,
                                    ),
                                    TextWidget(
                                      "CNG O&M Complaints",
                                      textAlign: TextAlign.center,
                                      color: AppColor.themeColor,
                                      fontWeight: FontWeight.w700,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),

                userData.mDbStatus.toString() != "0" && userData.mDbStatus.toString().isNotEmpty ?
                 Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shadowColor: AppColor.themeColor,
                      elevation: 2,
                      child: InkWell(
                        onTap: () async {
                          if (await Vibration.hasAmplitudeControl() != null) {
                            Vibration.vibrate(duration: 100);
                          }
                          Navigator.push(
                            !context.mounted ? context : context,
                            FadeRoute(page: userData.mDbStatus.toString() == "1"
                                  ? const LcvDashboardPage()
                                  : const ViewAssignmentPage() ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppIcon.lcvTruckIcon,
                                  height: MediaQuery.of(context).size.width * 0.20),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.02,
                              ),
                              TextWidget(
                                "LCV",
                                color: AppColor.themeColor,
                                fontWeight: FontWeight.w700,
                              )
                            ],
                          ),
                        ),
                      ),
                    )) : const SizedBox.shrink(),
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: TextWidget(
                "Unistal Systems Pvt Ltd. Version - ${AppConfig.instanceInit()!.appVersion}",
                fontSize: AppFont.font_12,
                color: AppColor.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
          ],
        ),
      ),
    );
  }
}
