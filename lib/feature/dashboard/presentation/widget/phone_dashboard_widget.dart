import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/presentation/page/add_equipment_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/page/view_equipment_complaint_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class PhoneDashboardWidget extends StatefulWidget {
  const PhoneDashboardWidget({
    super.key,
  });

  @override
  State<PhoneDashboardWidget> createState() => _PhoneDashboardWidgetState();
}

class _PhoneDashboardWidgetState extends State<PhoneDashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is FetchHomeDataState) {
        return _listBuilder(dataState: state);
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _listBuilder({required FetchHomeDataState dataState}) {
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;

    return userData.roleType == RoleType.mi
        ? const ViewEquipmentComplaintPage()
        : Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
/*         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,*/
              children: [
                Image.asset(
                  AppIcon.complaintBackground,
                  height: MediaQuery.of(context).size.height / 4.3,
                  opacity: const AlwaysStoppedAnimation(.6),
                ),
                userData.roleType == RoleType.stationUser
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shadowColor: AppColor.themeColor,
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddEquipmentComplaintPage()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(AppIcon.reportIcon,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.20),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  TextWidget(
                                    "Add Complaint",
                                    color: AppColor.themeColor,
                                    fontWeight: FontWeight.w700,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ))
                    : const SizedBox.shrink(),
                userData.roleType == RoleType.stationUser
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shadowColor: AppColor.themeColor,
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ViewEquipmentComplaintPage()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(AppIcon.reviewIcon,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.20),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  TextWidget(
                                    "View Complaint",
                                    color: AppColor.themeColor,
                                    fontWeight: FontWeight.w700,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ))
                    : const SizedBox.shrink(),
                userData.roleType == RoleType.shiftEngineer
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shadowColor: AppColor.themeColor,
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(page: const AcknowledgePage()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(AppIcon.equipmentIcon,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.20),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  TextWidget(
                                    "Ack Complaint",
                                    color: AppColor.themeColor,
                                    fontWeight: FontWeight.w700,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ))
                    : const SizedBox.shrink(),
                userData.roleType == RoleType.shiftEngineer
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shadowColor: AppColor.themeColor,
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                    page: const ViewEquipmentComplaintPage()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(AppIcon.reviewIcon,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.20),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  TextWidget(
                                    "Review Complaint",
                                    color: AppColor.themeColor,
                                    fontWeight: FontWeight.w700,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ))
                    : const SizedBox.shrink(),
                userData.roleType == RoleType.mi
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shadowColor: AppColor.themeColor,
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                    page: const ViewEquipmentComplaintPage()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(AppIcon.maintenanceIcon,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.20),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  TextWidget(
                                    "MI Complaint",
                                    color: AppColor.themeColor,
                                    fontWeight: FontWeight.w700,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ))
                    : const SizedBox.shrink(),
              ],
            ),
          );
  }
}
