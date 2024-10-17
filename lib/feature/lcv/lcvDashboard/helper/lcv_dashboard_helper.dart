import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/presentation/page/add_assignment_page.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/presntation/page/view_assignment_page.dart';
import 'package:flutter_igl_cng/feature/lcv/runningTruck/presentation/page/running_truck_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class LcvDashboardHelper {
  static Future<dynamic> fetchAppBottomBarItems(
      {required BuildContext context}) async {
    List<BottomNavigationBarItem> bottomNavigationBarItemList = [];
    try {
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;
       if (userData.roleType == RoleType.stationUser) {
        bottomNavigationBarItemList.add(BottomNavigationBarItem(
          icon: const Icon(
            Icons.fire_truck_outlined,
          ),
          label: AppString.running,
        ));
        bottomNavigationBarItemList.add(BottomNavigationBarItem(
          icon: const Icon(
            Icons.add,
          ),
          label: AppString.addAssign,
        ));
        bottomNavigationBarItemList.add(BottomNavigationBarItem(
          icon: const Icon(
            Icons.assignment_outlined,
          ),
          label: AppString.assign,
        ));
      }
    } catch (_) {}

    return bottomNavigationBarItemList;
  }

  static Future<dynamic> fetchPageList() async {
    List<Widget> pageList = [];
    try {
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;
      if (userData.mDbStatus == "1") {
        pageList.add(const RunningTruckPage());
        pageList.add(const AddAssignmentPage());
        pageList.add(const ViewAssignmentPage());
      }
    } catch (_) {}
    return pageList;
  }

}
