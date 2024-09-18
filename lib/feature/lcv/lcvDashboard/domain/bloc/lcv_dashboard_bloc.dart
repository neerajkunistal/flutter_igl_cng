import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvDashboard/helper/lcv_dashboard_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/overSpeedAlert/domain/model/over_speed_alert_model.dart';
import 'package:flutter_igl_cng/services/firebase/notification_service.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:vibration/vibration.dart';

part 'lcv_dashboard_event.dart';
part 'lcv_dashboard_state.dart';

class LcvDashboardBloc extends Bloc<LcvDashboardEvent, LcvDashboardState> {
  List<BottomNavigationBarItem> _bottomNavigationBarItemList = [];

  List<BottomNavigationBarItem> get bottomNavigationBarItemList =>
      _bottomNavigationBarItemList;

  int _bottomTabIndex = 0;

  int get bottomTabIndex => _bottomTabIndex;

  final bool _isLoader = false;

  bool get isLoader => _isLoader;

  RoleType _roleType = RoleType.stationUser;

  RoleType get roleType => _roleType;

  List<Widget> _pageWidgetList = [];

  List<Widget> get pageWidgetList => _pageWidgetList;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;


  Widget _childWidget = Container();

  Widget get childWidget => _childWidget;

  String _title = "";

  String get title => _title;

  Widget _actionButtonWidget = const SizedBox.shrink();

  Widget get actionButtonWidget => _actionButtonWidget;

  bool isNotificationSilent =  false;

  List<OverSpeedAlertModel> overSpeedAlertList = [];

  LcvDashboardBloc() : super(LcvDashboardInitial()) {
    on<LcvDashboardPageLoadEvent>(_pageLoad);
    on<LcvDashboardChangeBottomNavigationItemEvent>(_changeBottomNavigationBarIndex);
    on<LcvDashboardPageNotificationSilentEvent>(_notificationSilent);
  }

  _pageLoad(LcvDashboardPageLoadEvent event, emit) async {
    emit(LcvDashboardPageLoadState());
    _bottomTabIndex = 0;
    _userData = UserInfo.instance!.userData!;
    _roleType = userData.roleType!;
    _bottomNavigationBarItemList = [];
    _pageWidgetList = [];
    FirebaseService.instance.setupInteractedMessage();
    _title = "LCV ( ${userData.roleName} )";
    _childWidget =  Container();
    _actionButtonWidget = const SizedBox.shrink();

    String notificationSilent = await SharedPreferencesUtils.getString(key: PreferencesName.notificationSilent);
    if(notificationSilent == "1"){
      isNotificationSilent =  true;
    } else {
      isNotificationSilent =  false;
    }

    _bottomNavigationBarItemList = await LcvDashboardHelper.fetchAppBottomBarItems(
        context: !event.context.mounted ? event.context : event.context);
    List<Widget> pageList = await LcvDashboardHelper.fetchPageList();
    if (pageList.isNotEmpty) {
      _childWidget = pageList[bottomTabIndex];
    }
    _eventCompleted(emit);
  }

  _changeBottomNavigationBarIndex(
      LcvDashboardChangeBottomNavigationItemEvent event, emit) async {
    if (await Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 100);
    }
    _bottomTabIndex = event.index;
    List<Widget> pageList = await LcvDashboardHelper.fetchPageList();
    _childWidget = pageList[bottomTabIndex];
    _eventCompleted(emit);
  }

  _notificationSilent(LcvDashboardPageNotificationSilentEvent event, emit) async {
    String notificationSilent = await SharedPreferencesUtils.getString(key: PreferencesName.notificationSilent);
    if(notificationSilent == "1"){
      isNotificationSilent =  false;
      SharedPreferencesUtils.setString(key: PreferencesName.notificationSilent, value: "0");
    } else {
      isNotificationSilent =  true;
      SharedPreferencesUtils.setString(key: PreferencesName.notificationSilent, value: "1");
    }
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<LcvDashboardState> emit) {
    emit(FetchLcvDashboardDataState(
      isLoader: isLoader,
      bottomNavigationBarItemList: bottomNavigationBarItemList,
      bottomTabIndex: bottomTabIndex,
      roleType: roleType,
      pageWidgetList: pageWidgetList,
      childWidget: childWidget,
      title: title,
      actionButtonWidget: actionButtonWidget,
      isNotificationSilent: isNotificationSilent,
      overSpeedAlertList: overSpeedAlertList,
    ));
  }
}