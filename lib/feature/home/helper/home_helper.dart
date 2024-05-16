import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/page/dashboard_page.dart';
import 'package:flutter_igl_cng/feature/home/domain/model/drawer_model.dart';
import 'package:flutter_igl_cng/feature/home/domain/model/firebase_device_model.dart';

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

  static Future<dynamic> fetchAppBottomBarItems() async {
    try {
      List<BottomNavigationBarItem> bottomNavigationBarItemList = [];

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
              label: AppString.date,
            ));

      return bottomNavigationBarItemList;
    } catch (_) {}
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

  static Future<dynamic> fetchFirebaseDeviceData() async {
    try {
      String url =  APIs.getFirebaseDeviceApi;
      var res =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['status'] != null
           && res['status'] == true && res['data'] != null){
         return firebaseDeviceListResponse(res['data']);
      }
    } catch (_) {}
    return null;
  }
}
