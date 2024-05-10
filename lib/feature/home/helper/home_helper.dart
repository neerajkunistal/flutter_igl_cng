import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/page/dashboard_page.dart';
import 'package:flutter_igl_cng/feature/home/domain/model/drawer_model.dart';

class HomeHelper {
  static Future<dynamic> fetchDrawerList(
      {required BuildContext context}) async {
    try {
      List<DrawerModel> drawerList = [];
      drawerList.add(DrawerModel(
          widget: const DashboardPage(),
          icon: Icons.home_outlined,
          label: AppString.dashboard,
          sublist: [],
          isSelected: true));

      List<DrawerSubModel> systemAdminList = await fetchSystemAdminSubList();
      return drawerList;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchSystemAdminSubList() async {
    try {
      List<DrawerSubModel> drawerSubList = [];
      drawerSubList.add(DrawerSubModel(
        label: 'Add User',
        widget: Container(),
        isSelected: false,
      ));

      drawerSubList.add(DrawerSubModel(
        label: 'Update User',
        widget: Container(),
        isSelected: false,
      ));

      drawerSubList.add(DrawerSubModel(
        label: 'Update Company',
        widget: Container(),
        isSelected: false,
      ));
      return drawerSubList;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchAppBottomBarItems(
      {required BuildContext context, required RoleType appModule}) async {
    try {
      List<BottomNavigationBarItem> bottomNavigationBarItemList = [];

/*         if (appModule == RoleType.serviceCenter){
            bottomNavigationBarItemList.add(BottomNavigationBarItem(
              icon: const Icon(Icons.fire_truck_outlined,),
              label: AppString.running,
            ));
            bottomNavigationBarItemList.add(BottomNavigationBarItem(
              icon: const Icon(Icons.assignment_outlined,),
              label: AppString.assign,
            ));

            bottomNavigationBarItemList.add(BottomNavigationBarItem(
              icon: const Icon(Icons.person_pin,),
              label: AppString.profile,
            ));
          }*/

      return bottomNavigationBarItemList;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: "Bottom Bar Error");
      return null;
    }
  }

  static Future<dynamic> fetchPageWidgets(
      {required BuildContext context, required RoleType appModule}) async {
    try {
      List<Widget> pageWidgetList = [];
      return pageWidgetList;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: "Page Widget Error");
      return null;
    }
  }
}
