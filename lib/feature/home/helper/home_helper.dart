import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/page/dashboard_page.dart';
import 'package:flutter_igl_cng/feature/home/domain/model/drawer_model.dart';
import 'package:flutter_igl_cng/feature/home/domain/model/firebase_device_model.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/presentation/page/add_equipment_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/page/view_equipment_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/page/review_complaint_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

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

  static Future<dynamic> fetchAppBottomBarItems({required BuildContext context}) async {
    List<BottomNavigationBarItem> bottomNavigationBarItemList = [];
    try {

      LoginDataModel userData = UserInfo.instanceInit()!.userData!;
      if (userData.roleType == RoleType.shiftEngineer) {
        bottomNavigationBarItemList.add(BottomNavigationBarItem(
          icon: Image.asset(
            AppIcon.equipmentIcon,
            height: 20.0,
          ),
          label: AppString.acknowledge,
        ));
        bottomNavigationBarItemList.add(BottomNavigationBarItem(
          icon: Image.asset(
            AppIcon.reviewIcon,
            height: 20.0,
          ),
          label: AppString.review,
        ));
      }
    } catch (_) {}

    return bottomNavigationBarItemList;
  }

  static Future<dynamic> fetchPageList() async {

    List<Widget> pageList = [];
    try{
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;
      if (userData.roleType == RoleType.shiftEngineer) {
        pageList.add(const AcknowledgePage());
        pageList.add(const ViewEquipmentComplaintPage());
      }
      else if (userData.roleType == RoleType.stationUser) {
        pageList.add(const AddEquipmentComplaintPage());
        pageList.add(const ReviewComaplintPage());
      }
      else if (userData.roleType == RoleType.mi) {
        pageList.add(const ReviewComaplintPage());
      }

    }catch(_){}
    return pageList;
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
      String url = APIs.getFirebaseDeviceApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['data'] != null) {
        return firebaseDeviceListResponse(res['data']);
      }
    } catch (_) {}
    return null;
  }
}
