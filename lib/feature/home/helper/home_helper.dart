import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/presentation/page/view_amo_complaint_page.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/page/view_ci_complaint_page.dart';
import 'package:flutter_igl_cng/feature/cv/presentation/page/view_cv_complaint_page.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/page/dashboard_page.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/widget/web_page.dart';
import 'package:flutter_igl_cng/feature/home/domain/model/drawer_model.dart';
import 'package:flutter_igl_cng/feature/home/domain/model/firebase_device_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/presntation/page/view_assignment_page.dart';
import 'package:flutter_igl_cng/feature/lcv/runningTruck/presentation/page/running_truck_page.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/menu_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/page/view_equipment_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/widget/complaint_type_widget.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/message_box_pop_button_widget.dart';
import 'package:vibration/vibration.dart';

import '../../lcv/assignment/addAssignment/presentation/page/add_assignment_page.dart';

class HomeHelper {
   static Future<dynamic> fetchDrawerList(
      {required BuildContext context}) async {
    try {

      List<DrawerModel> drawerList = [];
      drawerList.add(DrawerModel(
          widget: const DashboardPage(),
          icon: Icons.home_outlined,
          label: AppString.home,
          sublist: [],
          isSelected: true));

      LoginDataModel loginData =  UserInfo.instance!.userData!;
      List<MenuModel> menuPageList =  loginData.menuPage!;
      for(var menuData in menuPageList){
        if(menuData.url.toString().isNotEmpty){
          drawerList.add(DrawerModel(
              widget: WebPage(url: "${menuData.url}?token=${loginData.token}", name: menuData.name.toString(),),
              icon: Icons.dashboard_outlined,
              label: menuData.name.toString(),
              isNewPage: true,
              sublist: [],
              isSelected: false)
          );
        }
      }
      return drawerList;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchAppBottomBarItems(
      {required BuildContext context}) async {
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
      else if (userData.roleType == RoleType.lcvManager) {
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
      if (userData.roleType == RoleType.shiftEngineer) {
        pageList.add(const AcknowledgePage());
        pageList.add(const ViewEquipmentComplaintPage());
      } else if (userData.roleType == RoleType.stationUser) {
        pageList.add(const ComplaintTypeWidget());
      } else if (userData.roleType == RoleType.mi) {
        pageList.add(const ViewEquipmentComplaintPage());
      } else if (userData.roleType == RoleType.amo) {
        pageList.add(const ViewAmoComplaintPage());
      } else if (userData.roleType == RoleType.ci) {
        pageList.add(const ViewCiComplaintPage());
      } else if (userData.roleType == RoleType.cv) {
        pageList.add(const ViewCvComplaintPage());
      } else if(userData.roleType == RoleType.lcvManager){
        pageList.add(const RunningTruckPage());
        pageList.add(const AddAssignmentPage());
        pageList.add(const ViewAssignmentPage());
      }
    } catch (_) {}
    return pageList;
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

  static Future <dynamic> fifteenMinuteNotification ({required BuildContext context}) async {

     if (await Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 10000);
    }
    final player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.loop);
    player.play(AssetSource('siren_alert.mp3'));
    var res =  await (showDialog(
        context: !context.mounted ? context : context,
        builder: (BuildContext mContext) => MessageBoxPopButtonWidget(
            title: "Alert",
            message: "Pending Task",
            onPressed: () => Navigator.of(!context.mounted ? context : context).pop(true))));
    player.stop();
  }
}
